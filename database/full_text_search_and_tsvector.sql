-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — POSTGRESQL FULL-TEXT SEARCH (FTS) & GIN INDEXES
-- PostgreSQL Relational Database Management System (RDBMS)
-- ================================================================================
-- Focus Areas:
-- 1. Full-Text Search (FTS) with to_tsvector, to_tsquery, and plainto_tsquery
-- 2. Generalized Inverted Indexes (GIN) for Sub-Millisecond Search
-- 3. Relevance Ranking with ts_rank & ts_rank_cd
-- 4. Search Result Snippet Highlighting with ts_headline
-- 5. Lexeme Normalization, Stemming & Stop-Word Filtering
-- ================================================================================

-- --------------------------------------------------------------------------------
-- SECTION 1: SEARCH VECTOR COLUMNS & GIN INVERTED INDEXES
-- --------------------------------------------------------------------------------

-- Add search vector to guest special requests if not existing
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'reservations' AND column_name = 'search_vector'
    ) THEN
        ALTER TABLE reservations ADD COLUMN search_vector tsvector;
    END IF;
END $$;

-- Populate search vectors using English dictionary stemming
UPDATE reservations
SET search_vector = to_tsvector('english', COALESCE(special_requests, '') || ' ' || COALESCE(status, ''));

-- Create high-speed Generalized Inverted Index (GIN)
DROP INDEX IF EXISTS idx_gin_reservations_fts;
CREATE INDEX idx_gin_reservations_fts 
    ON reservations USING GIN (search_vector);

-- 1.2 Automated Trigger: Keep tsvector synchronized on every write
CREATE OR REPLACE FUNCTION fn_trg_reservations_fts_sync()
RETURNS TRIGGER AS $$
BEGIN
    NEW.search_vector := to_tsvector('english', COALESCE(NEW.special_requests, '') || ' ' || COALESCE(NEW.status, ''));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_reservations_fts_sync ON reservations;
CREATE TRIGGER trg_reservations_fts_sync
    BEFORE INSERT OR UPDATE OF special_requests, status ON reservations
    FOR EACH ROW EXECUTE FUNCTION fn_trg_reservations_fts_sync();


-- --------------------------------------------------------------------------------
-- SECTION 2: GUEST REVIEWS & FEEDBACK CATALOG (FULL-TEXT SEARCH ENGINE)
-- --------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS guest_reviews (
    review_id SERIAL PRIMARY KEY,
    reservation_id INT REFERENCES reservations(reservation_id) ON DELETE CASCADE,
    customer_id INT REFERENCES customers(customer_id) ON DELETE CASCADE,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    headline VARCHAR(200) NOT NULL,
    review_body TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tsv_review tsvector
);

-- Generalized Inverted Index on Review Content
CREATE INDEX IF NOT EXISTS idx_gin_guest_reviews_tsv 
    ON guest_reviews USING GIN (tsv_review);

-- Trigger to maintain review tsvector
CREATE OR REPLACE FUNCTION fn_trg_reviews_fts_sync()
RETURNS TRIGGER AS $$
BEGIN
    NEW.tsv_review := setweight(to_tsvector('english', COALESCE(NEW.headline, '')), 'A') ||
                      setweight(to_tsvector('english', COALESCE(NEW.review_body, '')), 'B');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_reviews_fts_sync ON guest_reviews;
CREATE TRIGGER trg_reviews_fts_sync
    BEFORE INSERT OR UPDATE OF headline, review_body ON guest_reviews
    FOR EACH ROW EXECUTE FUNCTION fn_trg_reviews_fts_sync();

-- Seed sample reviews if empty
INSERT INTO guest_reviews (reservation_id, customer_id, rating, headline, review_body)
SELECT 
    r.reservation_id,
    r.customer_id,
    5,
    'Exceptional presidential suite hospitality and breathtaking view!',
    'The room was impeccably clean, peaceful ambiance, delicious breakfast buffet, and the front desk staff provided outstanding concierge service throughout our vacation.'
FROM reservations r
WHERE r.status = 'Checked-out'
LIMIT 5
ON CONFLICT DO NOTHING;


-- --------------------------------------------------------------------------------
-- SECTION 3: RELEVANCE RANKING & SEARCH HEADLINE HIGHLIGHTING
-- --------------------------------------------------------------------------------

-- 3.1 Search Function with Highlight Snippets
CREATE OR REPLACE FUNCTION fn_search_guest_reviews(p_search_query TEXT)
RETURNS TABLE (
    review_id INT,
    rating INT,
    search_rank REAL,
    highlighted_headline TEXT,
    highlighted_snippet TEXT
) AS $$
DECLARE
    v_query tsquery;
BEGIN
    -- Parse natural language input into safe boolean tsquery
    v_query := plainto_tsquery('english', p_search_query);

    RETURN QUERY
    SELECT 
        gr.review_id,
        gr.rating,
        ts_rank(gr.tsv_review, v_query) AS search_rank,
        ts_headline('english', gr.headline, v_query, 'StartSel=<mark>, StopSel=</mark>') AS highlighted_headline,
        ts_headline('english', gr.review_body, v_query, 'StartSel=<mark>, StopSel=</mark>, MaxWords=35, MinWords=15') AS highlighted_snippet
    FROM guest_reviews gr
    WHERE gr.tsv_review @@ v_query
    ORDER BY search_rank DESC;
END;
$$ LANGUAGE plpgsql;
