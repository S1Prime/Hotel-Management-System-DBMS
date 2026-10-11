-- Food menu items share the existing services and service_requests billing flow.
UPDATE services SET service_category = 'Food'
WHERE service_name = 'Gourmet Breakfast in Bed' AND service_category = 'Other';

INSERT INTO services (service_name, price, description, is_available, service_category, image_url, is_vegetarian)
SELECT m.service_name, m.price, m.description, TRUE, m.cuisine,
       CASE m.cuisine
         WHEN 'South Indian' THEN 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=640&q=75'
         WHEN 'North Indian' THEN 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=640&q=75'
         WHEN 'Chinese' THEN 'https://images.unsplash.com/photo-1525755662778-989d0524087e?auto=format&fit=crop&w=640&q=75'
         WHEN 'Thai' THEN 'https://images.unsplash.com/photo-1559847844-5315695dadae?auto=format&fit=crop&w=640&q=75'
         ELSE 'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?auto=format&fit=crop&w=640&q=75'
       END,
       m.is_vegetarian
FROM (VALUES
 ('South Indian','Idli',100,'Soft steamed rice cakes served with sambar and chutneys',TRUE),
 ('South Indian','Medu Vada',130,'Crisp lentil doughnuts with coconut chutney',TRUE),
 ('South Indian','Masala Dosa',220,'Golden rice crepe filled with spiced potato',TRUE),
 ('South Indian','Plain Dosa',160,'Thin crisp rice and lentil crepe with sambar',TRUE),
 ('South Indian','Ghee Roast Dosa',240,'Crisp dosa roasted with aromatic ghee',TRUE),
 ('South Indian','Pongal',180,'Peppery rice and lentil pongal with cashews',TRUE),
 ('South Indian','Poori Masala',190,'Puffed wheat bread with potato masala',TRUE),
 ('South Indian','Vegetable Upma',150,'Semolina breakfast with vegetables and curry leaves',TRUE),
 ('South Indian','Onion Uttapam',190,'Soft rice pancake topped with onion and tomato',TRUE),
 ('South Indian','Appam with Vegetable Stew',240,'Lacy rice hoppers with coconut vegetable stew',TRUE),
 ('South Indian','Puttu & Kadala Curry',230,'Steamed rice flour cylinders with black chickpea curry',TRUE),
 ('South Indian','Kerala Parotta',210,'Layered flaky flatbread served with kurma',TRUE),
 ('South Indian','Chicken Chettinad',420,'Peppery chicken curry with roasted Chettinad spices',FALSE),
 ('South Indian','Kerala Fish Curry',450,'Fish simmered in coconut and kokum curry',FALSE),
 ('South Indian','Chicken 65',350,'Crisp chilli-marinated chicken bites',FALSE),
 ('North Indian','Butter Naan',90,'Soft leavened bread brushed with butter',TRUE),
 ('North Indian','Garlic Naan',120,'Tandoor-baked naan topped with garlic and herbs',TRUE),
 ('North Indian','Tandoori Roti',70,'Whole-wheat roti baked in a clay oven',TRUE),
 ('North Indian','Paneer Butter Masala',340,'Cottage cheese in a rich tomato and butter gravy',TRUE),
 ('North Indian','Shahi Paneer',360,'Paneer in a creamy cashew and saffron sauce',TRUE),
 ('North Indian','Dal Makhani',290,'Slow-cooked black lentils finished with cream',TRUE),
 ('North Indian','Chole Bhature',280,'Punjabi chickpea curry with fried bread',TRUE),
 ('North Indian','Rajma Masala',260,'Red kidney beans in a home-style onion gravy',TRUE),
 ('North Indian','Aloo Paratha',180,'Whole-wheat flatbread stuffed with spiced potato',TRUE),
 ('North Indian','Palak Paneer',320,'Paneer cubes in a smooth spinach gravy',TRUE),
 ('North Indian','Malai Kofta',340,'Vegetable and paneer dumplings in cream sauce',TRUE),
 ('North Indian','Chicken Tikka',390,'Tandoor-charred yoghurt-marinated chicken',FALSE),
 ('North Indian','Butter Chicken',440,'Tandoori chicken in a buttery tomato gravy',FALSE),
 ('North Indian','Chicken Tandoori',420,'Classic bone-in chicken roasted in the tandoor',FALSE),
 ('North Indian','Mutton Rogan Josh',520,'Kashmiri-style slow-braised lamb curry',FALSE),
 ('North Indian','Fish Tikka',460,'Tandoori-marinated fish grilled with spices',FALSE),
 ('Chinese','Vegetable Fried Rice',240,'Wok-tossed rice with seasonal vegetables',TRUE),
 ('Chinese','Chicken Fried Rice',310,'Wok-fried rice with tender chicken and egg',FALSE),
 ('Chinese','Vegetable Hakka Noodles',250,'Wok-tossed noodles with crisp vegetables',TRUE),
 ('Chinese','Chicken Hakka Noodles',320,'Hakka noodles with chicken and spring onion',FALSE),
 ('Chinese','Vegetable Manchurian',280,'Vegetable dumplings in tangy Indo-Chinese sauce',TRUE),
 ('Chinese','Chicken Manchurian',350,'Crisp chicken in ginger-soy Manchurian sauce',FALSE),
 ('Chinese','Chilli Paneer',320,'Paneer tossed with peppers in chilli-soy glaze',TRUE),
 ('Chinese','Chilli Chicken',360,'Chicken tossed with green chilli and peppers',FALSE),
 ('Chinese','Vegetable Spring Rolls',220,'Crisp pastry rolls filled with vegetables',TRUE),
 ('Chinese','Hot & Sour Soup',180,'Peppery soup with mushrooms and vegetables',TRUE),
 ('Thai','Pad Thai',360,'Rice noodles with tamarind, peanuts and vegetables',TRUE),
 ('Thai','Thai Green Curry',390,'Fragrant coconut curry with Thai herbs and vegetables',TRUE),
 ('Thai','Thai Red Curry',390,'Red curry paste and coconut milk with vegetables',TRUE),
 ('Thai','Thai Basil Chicken',420,'Chicken stir-fried with Thai basil and chilli',FALSE),
 ('Thai','Thai Fried Rice',320,'Jasmine rice wok-fried with vegetables and basil',TRUE),
 ('Thai','Tom Yum Soup',260,'Hot and sour lemongrass soup with mushrooms',TRUE),
 ('Thai','Tom Kha Soup',280,'Coconut galangal soup with mushrooms',TRUE),
 ('Thai','Vegetable Spring Rolls',230,'Thai-style crisp rolls with sweet chilli dip',TRUE),
 ('Thai','Thai Cashew Chicken',430,'Chicken stir-fried with roasted cashews',FALSE),
 ('Thai','Mango Sticky Rice',260,'Sweet coconut sticky rice with ripe mango',TRUE),
 ('Continental','Grilled Chicken',440,'Herb-marinated chicken breast with vegetables',FALSE),
 ('Continental','Chicken Steak',520,'Grilled chicken steak with pepper sauce',FALSE),
 ('Continental','Fish & Chips',480,'Battered fish with fries and tartar sauce',FALSE),
 ('Continental','Chicken Alfredo Pasta',390,'Creamy parmesan pasta with grilled chicken',FALSE),
 ('Continental','Arrabbiata Pasta',320,'Penne in a spicy tomato and garlic sauce',TRUE),
 ('Continental','Vegetable Pasta',330,'Pasta tossed with seasonal vegetables and herbs',TRUE),
 ('Continental','Margherita Pizza',350,'Stone-baked pizza with tomato, mozzarella and basil',TRUE),
 ('Continental','Chicken Pizza',430,'Stone-baked pizza with chicken and mozzarella',FALSE),
 ('Continental','Caesar Salad',310,'Romaine, parmesan and classic Caesar dressing',TRUE),
 ('Continental','Grilled Vegetable Sandwich',260,'Grilled sourdough with vegetables and cheese',TRUE)
) AS m(cuisine,service_name,price,description,is_vegetarian)
WHERE NOT EXISTS (SELECT 1 FROM services s WHERE s.service_name = m.service_name AND s.service_category = m.cuisine);

UPDATE bills b SET food_charge = COALESCE((
    SELECT SUM(sr.quantity * sr.unit_price) FROM service_requests sr JOIN services s ON s.service_id = sr.service_id
    WHERE sr.reservation_id = b.reservation_id AND sr.status = 'Completed'
      AND s.service_category IN ('Food','South Indian','North Indian','Chinese','Thai','Continental')
), 0.00) WHERE b.food_charge = 0;


