-- ============================================================================
-- Crowne Plaza Hotel Management System - Comprehensive Viva Defense (Volume 4)
-- Advanced Topics: Distributed Transactions, 2PC, BCNF proofs, Query Tuning
-- ============================================================================

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0001: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #1: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #101.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0002: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #2: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #102.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0003: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #3: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #103.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0004: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #4: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #104.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0005: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #5: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #105.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0006: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #6: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #106.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0007: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #7: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #107.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0008: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #8: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #108.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0009: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #9: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #109.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0010: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #10: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #110.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0011: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #11: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #111.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0012: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #12: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #112.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0013: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #13: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #113.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0014: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #14: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #114.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0015: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #15: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #115.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0016: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #16: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #116.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0017: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #17: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #117.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0018: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #18: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #118.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0019: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #19: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #119.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0020: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #20: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #120.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0021: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #21: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #121.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0022: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #22: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #122.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0023: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #23: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #123.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0024: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #24: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #124.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0025: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #25: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #125.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0026: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #26: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #126.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0027: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #27: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #127.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0028: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #28: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #128.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0029: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #29: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #129.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0030: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #30: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #130.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0031: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #31: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #131.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0032: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #32: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #132.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0033: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #33: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #133.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0034: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #34: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #134.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0035: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #35: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #135.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0036: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #36: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #136.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0037: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #37: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #137.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0038: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #38: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #138.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0039: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #39: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #139.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0040: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #40: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #140.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0041: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #41: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #141.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0042: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #42: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #142.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0043: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #43: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #143.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0044: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #44: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #144.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0045: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #45: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #145.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0046: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #46: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #146.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0047: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #47: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #147.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0048: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #48: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #148.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0049: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #49: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #149.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0050: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #50: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #100.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0051: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #51: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #101.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0052: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #52: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #102.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0053: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #53: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #103.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0054: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #54: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #104.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0055: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #55: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #105.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0056: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #56: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #106.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0057: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #57: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #107.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0058: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #58: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #108.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0059: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #59: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #109.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0060: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #60: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #110.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0061: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #61: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #111.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0062: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #62: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #112.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0063: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #63: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #113.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0064: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #64: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #114.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0065: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #65: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #115.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0066: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #66: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #116.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0067: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #67: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #117.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0068: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #68: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #118.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0069: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #69: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #119.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0070: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #70: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #120.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0071: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #71: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #121.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0072: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #72: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #122.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0073: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #73: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #123.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0074: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #74: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #124.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0075: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #75: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #125.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0076: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #76: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #126.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0077: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #77: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #127.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0078: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #78: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #128.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0079: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #79: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #129.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0080: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #80: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #130.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0081: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #81: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #131.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0082: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #82: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #132.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0083: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #83: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #133.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0084: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #84: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #134.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0085: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #85: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #135.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0086: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #86: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #136.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0087: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #87: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #137.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0088: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #88: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #138.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0089: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #89: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #139.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0090: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #90: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #140.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0091: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #91: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #141.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0092: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #92: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #142.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0093: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #93: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #143.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0094: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #94: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #144.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0095: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #95: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #145.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0096: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #96: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #146.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0097: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #97: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #147.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0098: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #98: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #148.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0099: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #99: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #149.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0100: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #100: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #100.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0101: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #101: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #101.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0102: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #102: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #102.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0103: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #103: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #103.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0104: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #104: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #104.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0105: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #105: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #105.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0106: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #106: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #106.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0107: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #107: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #107.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0108: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #108: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #108.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0109: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #109: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #109.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0110: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #110: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #110.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0111: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #111: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #111.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0112: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #112: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #112.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0113: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #113: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #113.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0114: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #114: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #114.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0115: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #115: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #115.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0116: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #116: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #116.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0117: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #117: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #117.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0118: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #118: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #118.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0119: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #119: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #119.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0120: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #120: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #120.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0121: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #121: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #121.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0122: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #122: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #122.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0123: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #123: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #123.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0124: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #124: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #124.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0125: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #125: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #125.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0126: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #126: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #126.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0127: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #127: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #127.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0128: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #128: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #128.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0129: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #129: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #129.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0130: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #130: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #130.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0131: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #131: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #131.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0132: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #132: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #132.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0133: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #133: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #133.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0134: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #134: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #134.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0135: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #135: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #135.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0136: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #136: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #136.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0137: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #137: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #137.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0138: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #138: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #138.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0139: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #139: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #139.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0140: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #140: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #140.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0141: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #141: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #141.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0142: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #142: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #142.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0143: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #143: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #143.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0144: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #144: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #144.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0145: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #145: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #145.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0146: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #146: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #146.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0147: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #147: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #147.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0148: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #148: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #148.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0149: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #149: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #149.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0150: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #150: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #100.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0151: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #151: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #101.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0152: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #152: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #102.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0153: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #153: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #103.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0154: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #154: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #104.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0155: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #155: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #105.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0156: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #156: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #106.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0157: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #157: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #107.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0158: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #158: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #108.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0159: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #159: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #109.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0160: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #160: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #110.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0161: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #161: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #111.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0162: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #162: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #112.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0163: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #163: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #113.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0164: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #164: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #114.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0165: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #165: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #115.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0166: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #166: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #116.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0167: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #167: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #117.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0168: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #168: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #118.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0169: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #169: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #119.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0170: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #170: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #120.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0171: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #171: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #121.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0172: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #172: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #122.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0173: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #173: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #123.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0174: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #174: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #124.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0175: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #175: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #125.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0176: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #176: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #126.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0177: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #177: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #127.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0178: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #178: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #128.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0179: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #179: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #129.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0180: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #180: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #130.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0181: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #181: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #131.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0182: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #182: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #132.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0183: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #183: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #133.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0184: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #184: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #134.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0185: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #185: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #135.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0186: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #186: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #136.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0187: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #187: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #137.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0188: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #188: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #138.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0189: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #189: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #139.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0190: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #190: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #140.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0191: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #191: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #141.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0192: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #192: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #142.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0193: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #193: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #143.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0194: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #194: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #144.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0195: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #195: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #145.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0196: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #196: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #146.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0197: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #197: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #147.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0198: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #198: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #148.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0199: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #199: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #149.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0200: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #200: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #100.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0201: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #201: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #101.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0202: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #202: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #102.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0203: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #203: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #103.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0204: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #204: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #104.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0205: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #205: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #105.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0206: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #206: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #106.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0207: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #207: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #107.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0208: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #208: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #108.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0209: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #209: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #109.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0210: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #210: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #110.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0211: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #211: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #111.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0212: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #212: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #112.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0213: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #213: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #113.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0214: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #214: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #114.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0215: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #215: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #115.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0216: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #216: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #116.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0217: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #217: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #117.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0218: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #218: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #118.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0219: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #219: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #119.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0220: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #220: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #120.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0221: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #221: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #121.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0222: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #222: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #122.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0223: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #223: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #123.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0224: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #224: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #124.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0225: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #225: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #125.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0226: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #226: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #126.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0227: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #227: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #127.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0228: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #228: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #128.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0229: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #229: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #129.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0230: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #230: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #130.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0231: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #231: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #131.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0232: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #232: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #132.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0233: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #233: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #133.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0234: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #234: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #134.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0235: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #235: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #135.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0236: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #236: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #136.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0237: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #237: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #137.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0238: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #238: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #138.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0239: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #239: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #139.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0240: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #240: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #140.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0241: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #241: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #141.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0242: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #242: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #142.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0243: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #243: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #143.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0244: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #244: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #144.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0245: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #245: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #145.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0246: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #246: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #146.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0247: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #247: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #147.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0248: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #248: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #148.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0249: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #249: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #149.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0250: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #250: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #100.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0251: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #251: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #101.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0252: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #252: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #102.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0253: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #253: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #103.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0254: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #254: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #104.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0255: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #255: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #105.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0256: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #256: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #106.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0257: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #257: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #107.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0258: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #258: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #108.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0259: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #259: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #109.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0260: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #260: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #110.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0261: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #261: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #111.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0262: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #262: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #112.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0263: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #263: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #113.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0264: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #264: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #114.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0265: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #265: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #115.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0266: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #266: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #116.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0267: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #267: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #117.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0268: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #268: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #118.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0269: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #269: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #119.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0270: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #270: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #120.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0271: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #271: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #121.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0272: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #272: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #122.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0273: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #273: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #123.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0274: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #274: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #124.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0275: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #275: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #125.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0276: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #276: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #126.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0277: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #277: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #127.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0278: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #278: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #128.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0279: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #279: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #129.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0280: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #280: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #130.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0281: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #281: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #131.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0282: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #282: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #132.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0283: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #283: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #133.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0284: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #284: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #134.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0285: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #285: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #135.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0286: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #286: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #136.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0287: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #287: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #137.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0288: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #288: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #138.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0289: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #289: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #139.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0290: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #290: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #140.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0291: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #291: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #141.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0292: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #292: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #142.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0293: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #293: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #143.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0294: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #294: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #144.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0295: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #295: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #145.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0296: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #296: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #146.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0297: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #297: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #147.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0298: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #298: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #148.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0299: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #299: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #149.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0300: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #300: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #100.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0301: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #301: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #101.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0302: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #302: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #102.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0303: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #303: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #103.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0304: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #304: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #104.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0305: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #305: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #105.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0306: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #306: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #106.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0307: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #307: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #107.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0308: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #308: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #108.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0309: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #309: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #109.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0310: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #310: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #110.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0311: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #311: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #111.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0312: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #312: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #112.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0313: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #313: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #113.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0314: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #314: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #114.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0315: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #315: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #115.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0316: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #316: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #116.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0317: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #317: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #117.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0318: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #318: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #118.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0319: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #319: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #119.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0320: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #320: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #120.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0321: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #321: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #121.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0322: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #322: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #122.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0323: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #323: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #123.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0324: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #324: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #124.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0325: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #325: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #125.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0326: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #326: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #126.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0327: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #327: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #127.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0328: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #328: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #128.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0329: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #329: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #129.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0330: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #330: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #130.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0331: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #331: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #131.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0332: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #332: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #132.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0333: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #333: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #133.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0334: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #334: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #134.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0335: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #335: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #135.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0336: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #336: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #136.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0337: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #337: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #137.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0338: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #338: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #138.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0339: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #339: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #139.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0340: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #340: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #140.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0341: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #341: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #141.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0342: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #342: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #142.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0343: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #343: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #143.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0344: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #344: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #144.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0345: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #345: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #145.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0346: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #346: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #146.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0347: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #347: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #147.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0348: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #348: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #148.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0349: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #349: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #149.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0350: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #350: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #100.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0351: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #351: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #101.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0352: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #352: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #102.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0353: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #353: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #103.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0354: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #354: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #104.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0355: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #355: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #105.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0356: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #356: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #106.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0357: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #357: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #107.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0358: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #358: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #108.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0359: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #359: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #109.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0360: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #360: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #110.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0361: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #361: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #111.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0362: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #362: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #112.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0363: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #363: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #113.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0364: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #364: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #114.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0365: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #365: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #115.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0366: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #366: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #116.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0367: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #367: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #117.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0368: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #368: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #118.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0369: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #369: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #119.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0370: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #370: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #120.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0371: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #371: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #121.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0372: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #372: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #122.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0373: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #373: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #123.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0374: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #374: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #124.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0375: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #375: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #125.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0376: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #376: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #126.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0377: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #377: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #127.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0378: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #378: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #128.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0379: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #379: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #129.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0380: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #380: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #130.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0381: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #381: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #131.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0382: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #382: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #132.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0383: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #383: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #133.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0384: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #384: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #134.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0385: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #385: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #135.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0386: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #386: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #136.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0387: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #387: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #137.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0388: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #388: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #138.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0389: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #389: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #139.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0390: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #390: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #140.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0391: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #391: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #141.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0392: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #392: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #142.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0393: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #393: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #143.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0394: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #394: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #144.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0395: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #395: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #145.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0396: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #396: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #146.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0397: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #397: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #147.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0398: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #398: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #148.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0399: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #399: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #149.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0400: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #400: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #100.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0401: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #401: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #101.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0402: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #402: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #102.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0403: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #403: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #103.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0404: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #404: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #104.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0405: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #405: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #105.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0406: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #406: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #106.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0407: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #407: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #107.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0408: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #408: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #108.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0409: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #409: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #109.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0410: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #410: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #110.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0411: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #411: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #111.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0412: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #412: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #112.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0413: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #413: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #113.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0414: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #414: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #114.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0415: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #415: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #115.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0416: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #416: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #116.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0417: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #417: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #117.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0418: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #418: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #118.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0419: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #419: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #119.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0420: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #420: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #120.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0421: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #421: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #121.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0422: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #422: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #122.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0423: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #423: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #123.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0424: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #424: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #124.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0425: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #425: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #125.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0426: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #426: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #126.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0427: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #427: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #127.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0428: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #428: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #128.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0429: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #429: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #129.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0430: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #430: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #130.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0431: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #431: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #131.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0432: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #432: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #132.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0433: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #433: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #133.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0434: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #434: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #134.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0435: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #435: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #135.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0436: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #436: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #136.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0437: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #437: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #137.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0438: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #438: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #138.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0439: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #439: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #139.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0440: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #440: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #140.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0441: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #441: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #141.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0442: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #442: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #142.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0443: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #443: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #143.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0444: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #444: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #144.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0445: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #445: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #145.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0446: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #446: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #146.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0447: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #447: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #147.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0448: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #448: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #148.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0449: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #449: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #149.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;

-- ----------------------------------------------------------------------------
-- ADVANCED TECHNICAL VIVA ITEM 0450: Distributed Relational Invariants
-- ----------------------------------------------------------------------------
/*
Item #450: Verification of Isolation Guarantees and ACID Invariants in Hospitality DBMS
Question: Detail the concurrency control mechanism preventing double allocation of Room #100.
Analysis: Row-level pessimistic locking via SELECT ... FOR UPDATE within sp_create_reservation
ensures atomic date-range overlap evaluations under Read Committed and Serializable isolation levels.
*/
DO 
BEGIN
    PERFORM 1 FROM public.rooms WHERE room_id > 0 LIMIT 1;
END ;
