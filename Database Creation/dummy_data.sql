USE SmartPlate;

-- ── Allergens ────────────────────────────────────────────────────────────────
INSERT IGNORE INTO Allergens (name, description) VALUES
('None',    'No allergen'),
('Gluten',  'Wheat, barley, rye'),
('Dairy',   'Milk and milk products'),
('Eggs',    'Egg and egg products'),
('Nuts',    'Tree nuts and peanuts'),
('Soy',     'Soybean products'),
('Seafood', 'Fish and shellfish');

-- ── Roles ────────────────────────────────────────────────────────────────────
INSERT IGNORE INTO Roles (name, description) VALUES
('manager',  'Full system access'),
('chef',     'Kitchen staff'),
('employee', 'General staff'),
('supplier', 'Ingredient supplier'),
('customer', 'Restaurant customer');

-- ── Users (password = "Password123" for all) ─────────────────────────────────

INSERT IGNORE INTO Users (username, email, password_hash, last_login, role_id) VALUES
('admin',        'admin@smartplate.com',    'Password123', NOW(), (SELECT role_id FROM Roles WHERE name='manager')),
('chef_ali',     'ali@smartplate.com',      'Password123', NOW(), (SELECT role_id FROM Roles WHERE name='chef')),
('chef_priya',   'priya@smartplate.com',    'Password123', NOW(), (SELECT role_id FROM Roles WHERE name='chef')),
('emp_raj',      'raj@smartplate.com',      'Password123', NOW(), (SELECT role_id FROM Roles WHERE name='employee')),
('sup_freshco',  'fresh@freshco.com',       'Password123', NOW(), (SELECT role_id FROM Roles WHERE name='supplier')),
('sup_quicksup', 'quick@quicksupply.com',   'Password123', NOW(), (SELECT role_id FROM Roles WHERE name='supplier')),
('customer_sara','sara@email.com',          'Password123', NOW(), (SELECT role_id FROM Roles WHERE name='customer')),
('customer_john','john@email.com',          'Password123', NOW(), (SELECT role_id FROM Roles WHERE name='customer'));

-- ── Employees ────────────────────────────────────────────────────────────────
INSERT IGNORE INTO Employees (hire_date, salary, user_id) VALUES
(NOW(), 0,        (SELECT user_id FROM Users WHERE username='admin')),
(NOW(), 55000.00, (SELECT user_id FROM Users WHERE username='chef_ali')),
(NOW(), 52000.00, (SELECT user_id FROM Users WHERE username='chef_priya')),
(NOW(), 38000.00, (SELECT user_id FROM Users WHERE username='emp_raj'));

-- ── Customers ─────────────────────────────────────────────────────────────────
INSERT IGNORE INTO Customers (name, visit_frequency, user_id) VALUES
('Sara Ahmed', 5, (SELECT user_id FROM Users WHERE username='customer_sara')),
('John Smith', 2, (SELECT user_id FROM Users WHERE username='customer_john'));

-- ── Suppliers ────────────────────────────────────────────────────────────────
INSERT IGNORE INTO Suppliers (name, contact, delivery_time, is_active, user_id) VALUES
('FreshCo Produce',  'fresh@freshco.com',     2, 1, (SELECT user_id FROM Users WHERE username='sup_freshco')),
('QuickSupply Ltd.', 'quick@quicksupply.com', 1, 1, (SELECT user_id FROM Users WHERE username='sup_quicksup'));

-- ── Ingredients ──────────────────────────────────────────────────────────────
INSERT IGNORE INTO Ingredients (name, unit, min_stock, quantity, allergen_id) VALUES
('Tomato',        'kg',    5.00, 20.00, (SELECT allergen_id FROM Allergens WHERE name='None')),
('Flour',         'kg',   10.00, 40.00, (SELECT allergen_id FROM Allergens WHERE name='Gluten')),
('Mozzarella',    'kg',    3.00, 12.00, (SELECT allergen_id FROM Allergens WHERE name='Dairy')),
('Olive Oil',     'litre', 2.00,  8.00, (SELECT allergen_id FROM Allergens WHERE name='None')),
('Chicken',       'kg',    4.00, 15.00, (SELECT allergen_id FROM Allergens WHERE name='None')),
('Rice',          'kg',    5.00, 25.00, (SELECT allergen_id FROM Allergens WHERE name='None')),
('Eggs',          'units', 24.0, 60.00, (SELECT allergen_id FROM Allergens WHERE name='Eggs')),
('Butter',        'kg',    1.00,  5.00, (SELECT allergen_id FROM Allergens WHERE name='Dairy')),
('Garlic',        'kg',    0.50,  3.00, (SELECT allergen_id FROM Allergens WHERE name='None')),
('Pasta',         'kg',    3.00, 12.00, (SELECT allergen_id FROM Allergens WHERE name='Gluten'));

-- ── Supplies (supplier -> ingredient + pricing) ───────────────────────────────
INSERT IGNORE INTO Supplies (supplier_id, ingredient_id, price_per_unit, unit) VALUES
(1, 1, 1.20, 'kg'),   -- FreshCo -> Tomato
(1, 3, 8.50, 'kg'),   -- FreshCo -> Mozzarella
(1, 4, 6.00, 'litre'),-- FreshCo -> Olive Oil
(1, 5, 5.50, 'kg'),   -- FreshCo -> Chicken
(1, 6, 0.80, 'kg'),   -- FreshCo -> Rice
(1, 9, 2.00, 'kg'),   -- FreshCo -> Garlic
(2, 2, 0.60, 'kg'),   -- QuickSupply -> Flour
(2, 7, 0.25, 'units'),-- QuickSupply -> Eggs
(2, 8, 7.00, 'kg'),   -- QuickSupply -> Butter
(2, 10,1.20, 'kg');   -- QuickSupply -> Pasta

-- ── Inventory Batches (delivered stock) ──────────────────────────────────────
INSERT IGNORE INTO Inventory_Batches (purchase_date, expiry_date, quantity, unit, cost, status, supplier_id, ingredient_id) VALUES
(DATE_SUB(NOW(),INTERVAL 3 DAY), DATE_ADD(NOW(),INTERVAL 14 DAY), 20.00,'kg',   24.00, 2, 1, 1),
(DATE_SUB(NOW(),INTERVAL 2 DAY), DATE_ADD(NOW(),INTERVAL 30 DAY), 40.00,'kg',   24.00, 2, 2, 2),
(DATE_SUB(NOW(),INTERVAL 4 DAY), DATE_ADD(NOW(),INTERVAL 7  DAY), 12.00,'kg',  102.00, 2, 1, 3),
(DATE_SUB(NOW(),INTERVAL 1 DAY), DATE_ADD(NOW(),INTERVAL 60 DAY),  8.00,'litre',48.00, 2, 1, 4),
(DATE_SUB(NOW(),INTERVAL 2 DAY), DATE_ADD(NOW(),INTERVAL 5  DAY), 15.00,'kg',   82.50, 2, 1, 5),
(DATE_SUB(NOW(),INTERVAL 5 DAY), DATE_ADD(NOW(),INTERVAL 90 DAY), 25.00,'kg',   20.00, 2, 1, 6),
(DATE_SUB(NOW(),INTERVAL 1 DAY), DATE_ADD(NOW(),INTERVAL 10 DAY), 60.00,'units',15.00, 2, 2, 7),
(DATE_SUB(NOW(),INTERVAL 3 DAY), DATE_ADD(NOW(),INTERVAL 20 DAY),  5.00,'kg',   35.00, 2, 2, 8),
(DATE_SUB(NOW(),INTERVAL 2 DAY), DATE_ADD(NOW(),INTERVAL 21 DAY),  3.00,'kg',    6.00, 2, 1, 9),
(DATE_SUB(NOW(),INTERVAL 1 DAY), DATE_ADD(NOW(),INTERVAL 30 DAY), 12.00,'kg',   14.40, 2, 2, 10);

-- ── Categories & Menu Items ───────────────────────────────────────────────────
INSERT IGNORE INTO Category (name) VALUES ('Pizza'), ('Pasta'), ('Mains'), ('Sides'), ('Desserts');

CALL sp_AddMenuItem('Margherita Pizza',    'Classic tomato and mozzarella',      12.99, 15, 'Pizza');
CALL sp_AddMenuItem('Chicken Tikka Pizza', 'Spicy chicken with tomato base',     14.99, 18, 'Pizza');
CALL sp_AddMenuItem('Spaghetti Bolognese', 'Pasta with rich meat sauce',         13.99, 20, 'Pasta');
CALL sp_AddMenuItem('Grilled Chicken',     'Herb marinated grilled chicken',     15.99, 25, 'Mains');
CALL sp_AddMenuItem('Fried Rice',          'Wok fried rice with vegetables',     10.99, 15, 'Mains');
CALL sp_AddMenuItem('Garlic Bread',        'Toasted bread with garlic butter',    4.99, 8,  'Sides');

-- ── Recipes ───────────────────────────────────────────────────────────────────
-- Margherita Pizza (item 1): Tomato, Mozzarella, Flour, Olive Oil
CALL sp_AddRecipeLine(1, 1, 0.20, 'kg');
CALL sp_AddRecipeLine(1, 3, 0.15, 'kg');
CALL sp_AddRecipeLine(1, 2, 0.30, 'kg');
CALL sp_AddRecipeLine(1, 4, 0.05, 'litre');
-- Chicken Tikka Pizza (item 2): Tomato, Mozzarella, Flour, Chicken
CALL sp_AddRecipeLine(2, 1, 0.15, 'kg');
CALL sp_AddRecipeLine(2, 3, 0.15, 'kg');
CALL sp_AddRecipeLine(2, 2, 0.30, 'kg');
CALL sp_AddRecipeLine(2, 5, 0.20, 'kg');
-- Spaghetti Bolognese (item 3): Pasta, Tomato, Garlic, Olive Oil
CALL sp_AddRecipeLine(3, 10, 0.20, 'kg');
CALL sp_AddRecipeLine(3, 1,  0.10, 'kg');
CALL sp_AddRecipeLine(3, 9,  0.02, 'kg');
CALL sp_AddRecipeLine(3, 4,  0.03, 'litre');
-- Grilled Chicken (item 4): Chicken, Garlic, Olive Oil
CALL sp_AddRecipeLine(4, 5, 0.30, 'kg');
CALL sp_AddRecipeLine(4, 9, 0.01, 'kg');
CALL sp_AddRecipeLine(4, 4, 0.02, 'litre');
-- Fried Rice (item 5): Rice, Eggs, Garlic
CALL sp_AddRecipeLine(5, 6, 0.25, 'kg');
CALL sp_AddRecipeLine(5, 7, 2.00, 'units');
CALL sp_AddRecipeLine(5, 9, 0.01, 'kg');
-- Garlic Bread (item 6): Flour, Butter, Garlic
CALL sp_AddRecipeLine(6, 2, 0.10, 'kg');
CALL sp_AddRecipeLine(6, 8, 0.05, 'kg');
CALL sp_AddRecipeLine(6, 9, 0.01, 'kg');

-- ── Occasions ─────────────────────────────────────────────────────────────────
INSERT IGNORE INTO Occasions (name) VALUES ('Regular');

-- ── Compliance Records (0=waiting, 1=passed, 2=failed) ──────────────────────
CALL sp_LogCompliance(1, 'Monthly kitchen hygiene inspection - passed');
CALL sp_LogCompliance(1, 'Food safety audit - passed');
CALL sp_LogCompliance(0, 'Equipment check - awaiting inspection');

-- ── Weather Data ──────────────────────────────────────────────────────────────
CALL sp_RecordWeather(DATE_SUB(NOW(),INTERVAL 2 DAY), 28.50, 65.00);
CALL sp_RecordWeather(DATE_SUB(NOW(),INTERVAL 1 DAY), 26.00, 70.00);
CALL sp_RecordWeather(NOW(), 24.50, 68.00);

SELECT 'Dummy data loaded successfully' AS status;

-- ── Permissions_Granted ───────────────────────────────────────
-- manager (role 1) gets everything
INSERT IGNORE INTO Permissions_Granted (permission_id, role_id)
SELECT p.permission_id, r.role_id
FROM Permissions p, Roles r
WHERE r.name = 'manager';

-- chef (role 2)
INSERT IGNORE INTO Permissions_Granted (permission_id, role_id)
SELECT p.permission_id, r.role_id
FROM Permissions p JOIN Roles r ON r.name = 'chef'
WHERE p.name IN ('view_menu','view_orders','update_order_status','manage_inventory');

-- employee (role 3)
INSERT IGNORE INTO Permissions_Granted (permission_id, role_id)
SELECT p.permission_id, r.role_id
FROM Permissions p JOIN Roles r ON r.name = 'employee'
WHERE p.name IN ('view_menu','view_orders','update_order_status','place_order');

-- supplier (role 4)
INSERT IGNORE INTO Permissions_Granted (permission_id, role_id)
SELECT p.permission_id, r.role_id
FROM Permissions p JOIN Roles r ON r.name = 'supplier'
WHERE p.name IN ('view_menu','manage_inventory');

-- customer (role 5)
INSERT IGNORE INTO Permissions_Granted (permission_id, role_id)
SELECT p.permission_id, r.role_id
FROM Permissions p JOIN Roles r ON r.name = 'customer'
WHERE p.name IN ('view_menu','place_order');

-- ── Gift Codes ────────────────────────────────────────────────
-- type 0 = percentage discount, type 1 = flat amount
INSERT IGNORE INTO Gift_Code (code, amount, type, min_order, valid_from, valid_to) VALUES
('WELCOME10',  10.00, 0,  0.00, DATE_SUB(NOW(),INTERVAL 30 DAY), DATE_ADD(NOW(),INTERVAL 60 DAY)),
('SAVE5NOW',    5.00, 1, 20.00, DATE_SUB(NOW(),INTERVAL 10 DAY), DATE_ADD(NOW(),INTERVAL 20 DAY)),
('SUMMER20',   20.00, 0, 30.00, DATE_SUB(NOW(),INTERVAL 5  DAY), DATE_ADD(NOW(),INTERVAL 25 DAY)),
('FLAT15OFF',  15.00, 1, 50.00, DATE_SUB(NOW(),INTERVAL 15 DAY), DATE_ADD(NOW(),INTERVAL 15 DAY)),
('EXPIRED5',    5.00, 0,  0.00, DATE_SUB(NOW(),INTERVAL 60 DAY), DATE_SUB(NOW(),INTERVAL 1  DAY));

-- ── Nutritional Info ──────────────────────────────────────────
-- item_id 1-6 match sp_AddMenuItem insertion order
INSERT IGNORE INTO Nutritional_Info (item_id, calories, protein, carbs, fat, fiber) VALUES
(1, 850,  32, 98, 28, 5),   -- Margherita Pizza
(2, 920,  45, 95, 32, 4),   -- Chicken Tikka Pizza
(3, 780,  35, 90, 22, 6),   -- Spaghetti Bolognese
(4, 520,  48, 10, 28, 1),   -- Grilled Chicken
(5, 620,  18, 88, 14, 3),   -- Fried Rice
(6, 310,   7, 42, 13, 2);   -- Garlic Bread

-- ── Menu Orders (30 orders spread over last 14 days) ─────────
-- sara  = customer user_id 7, john = customer user_id 8
INSERT INTO Menu_Orders (order_time, price, gift_code_id, user_id) VALUES
(DATE_SUB(NOW(),INTERVAL 13 DAY), 27.98, NULL, 7),
(DATE_SUB(NOW(),INTERVAL 13 DAY), 14.99, NULL, 8),
(DATE_SUB(NOW(),INTERVAL 12 DAY), 28.98, 1,    7),
(DATE_SUB(NOW(),INTERVAL 12 DAY), 25.98, NULL, 8),
(DATE_SUB(NOW(),INTERVAL 11 DAY), 15.99, NULL, 7),
(DATE_SUB(NOW(),INTERVAL 10 DAY), 30.97, NULL, 8),
(DATE_SUB(NOW(),INTERVAL 10 DAY), 10.99, NULL, 7),
(DATE_SUB(NOW(),INTERVAL 9  DAY), 43.97, 2,    8),
(DATE_SUB(NOW(),INTERVAL 9  DAY), 12.99, NULL, 7),
(DATE_SUB(NOW(),INTERVAL 8  DAY), 26.98, NULL, 8),
(DATE_SUB(NOW(),INTERVAL 7  DAY), 15.99, NULL, 7),
(DATE_SUB(NOW(),INTERVAL 7  DAY), 13.99, NULL, 8),
(DATE_SUB(NOW(),INTERVAL 6  DAY), 29.97, 3,    7),
(DATE_SUB(NOW(),INTERVAL 6  DAY), 15.99, NULL, 8),
(DATE_SUB(NOW(),INTERVAL 5  DAY), 27.98, NULL, 7),
(DATE_SUB(NOW(),INTERVAL 5  DAY), 24.98, NULL, 8),
(DATE_SUB(NOW(),INTERVAL 4  DAY), 10.99, NULL, 7),
(DATE_SUB(NOW(),INTERVAL 4  DAY), 30.98, NULL, 8),
(DATE_SUB(NOW(),INTERVAL 3  DAY), 13.99, NULL, 7),
(DATE_SUB(NOW(),INTERVAL 3  DAY), 12.99, NULL, 8),
(DATE_SUB(NOW(),INTERVAL 2  DAY), 44.97, 4,    7),
(DATE_SUB(NOW(),INTERVAL 2  DAY), 15.99, NULL, 8),
(DATE_SUB(NOW(),INTERVAL 1  DAY), 27.98, NULL, 7),
(DATE_SUB(NOW(),INTERVAL 1  DAY), 10.99, NULL, 8),
(DATE_SUB(NOW(),INTERVAL 1  DAY), 13.99, NULL, 7),
(NOW(),                           28.98, NULL, 8),
(NOW(),                           15.99, NULL, 7),
(NOW(),                           25.98, 1,    8),
(NOW(),                           10.99, NULL, 7),
(NOW(),                           12.99, NULL, 8);

-- ── Menu_Orders_Items ─────────────────────────────────────────
-- status: 0=being prepared, 1=out for delivery, 2=delivered
-- Older orders fully delivered; recent ones in progress
INSERT INTO Menu_Orders_Items (menu_order_id, item_id, quantity, status, prepared_at, dispatched_at, delivered_at) VALUES
-- order 1
(1, 1, 1, 2, DATE_SUB(NOW(),INTERVAL 13 DAY)+INTERVAL 15 MINUTE, DATE_SUB(NOW(),INTERVAL 13 DAY)+INTERVAL 25 MINUTE, DATE_SUB(NOW(),INTERVAL 13 DAY)+INTERVAL 45 MINUTE),
(1, 4, 1, 2, DATE_SUB(NOW(),INTERVAL 13 DAY)+INTERVAL 25 MINUTE, DATE_SUB(NOW(),INTERVAL 13 DAY)+INTERVAL 35 MINUTE, DATE_SUB(NOW(),INTERVAL 13 DAY)+INTERVAL 50 MINUTE),
-- order 2
(2, 2, 1, 2, DATE_SUB(NOW(),INTERVAL 13 DAY)+INTERVAL 18 MINUTE, DATE_SUB(NOW(),INTERVAL 13 DAY)+INTERVAL 30 MINUTE, DATE_SUB(NOW(),INTERVAL 13 DAY)+INTERVAL 48 MINUTE),
-- order 3
(3, 3, 1, 2, DATE_SUB(NOW(),INTERVAL 12 DAY)+INTERVAL 20 MINUTE, DATE_SUB(NOW(),INTERVAL 12 DAY)+INTERVAL 32 MINUTE, DATE_SUB(NOW(),INTERVAL 12 DAY)+INTERVAL 52 MINUTE),
(3, 6, 2, 2, DATE_SUB(NOW(),INTERVAL 12 DAY)+INTERVAL 8  MINUTE, DATE_SUB(NOW(),INTERVAL 12 DAY)+INTERVAL 32 MINUTE, DATE_SUB(NOW(),INTERVAL 12 DAY)+INTERVAL 52 MINUTE),
-- order 4
(4, 1, 1, 2, DATE_SUB(NOW(),INTERVAL 12 DAY)+INTERVAL 15 MINUTE, DATE_SUB(NOW(),INTERVAL 12 DAY)+INTERVAL 28 MINUTE, DATE_SUB(NOW(),INTERVAL 12 DAY)+INTERVAL 46 MINUTE),
(4, 5, 1, 2, DATE_SUB(NOW(),INTERVAL 12 DAY)+INTERVAL 15 MINUTE, DATE_SUB(NOW(),INTERVAL 12 DAY)+INTERVAL 28 MINUTE, DATE_SUB(NOW(),INTERVAL 12 DAY)+INTERVAL 46 MINUTE),
-- order 5
(5, 4, 1, 2, DATE_SUB(NOW(),INTERVAL 11 DAY)+INTERVAL 25 MINUTE, DATE_SUB(NOW(),INTERVAL 11 DAY)+INTERVAL 37 MINUTE, DATE_SUB(NOW(),INTERVAL 11 DAY)+INTERVAL 55 MINUTE),
-- order 6
(6, 2, 1, 2, DATE_SUB(NOW(),INTERVAL 10 DAY)+INTERVAL 18 MINUTE, DATE_SUB(NOW(),INTERVAL 10 DAY)+INTERVAL 30 MINUTE, DATE_SUB(NOW(),INTERVAL 10 DAY)+INTERVAL 50 MINUTE),
(6, 3, 1, 2, DATE_SUB(NOW(),INTERVAL 10 DAY)+INTERVAL 20 MINUTE, DATE_SUB(NOW(),INTERVAL 10 DAY)+INTERVAL 30 MINUTE, DATE_SUB(NOW(),INTERVAL 10 DAY)+INTERVAL 50 MINUTE),
(6, 6, 1, 2, DATE_SUB(NOW(),INTERVAL 10 DAY)+INTERVAL 8  MINUTE, DATE_SUB(NOW(),INTERVAL 10 DAY)+INTERVAL 30 MINUTE, DATE_SUB(NOW(),INTERVAL 10 DAY)+INTERVAL 50 MINUTE),
-- order 7
(7, 5, 1, 2, DATE_SUB(NOW(),INTERVAL 10 DAY)+INTERVAL 15 MINUTE, DATE_SUB(NOW(),INTERVAL 10 DAY)+INTERVAL 25 MINUTE, DATE_SUB(NOW(),INTERVAL 10 DAY)+INTERVAL 42 MINUTE),
-- order 8
(8, 1, 1, 2, DATE_SUB(NOW(),INTERVAL 9 DAY)+INTERVAL 15 MINUTE, DATE_SUB(NOW(),INTERVAL 9 DAY)+INTERVAL 27 MINUTE, DATE_SUB(NOW(),INTERVAL 9 DAY)+INTERVAL 48 MINUTE),
(8, 4, 2, 2, DATE_SUB(NOW(),INTERVAL 9 DAY)+INTERVAL 25 MINUTE, DATE_SUB(NOW(),INTERVAL 9 DAY)+INTERVAL 37 MINUTE, DATE_SUB(NOW(),INTERVAL 9 DAY)+INTERVAL 58 MINUTE),
(8, 6, 1, 2, DATE_SUB(NOW(),INTERVAL 9 DAY)+INTERVAL 8  MINUTE, DATE_SUB(NOW(),INTERVAL 9 DAY)+INTERVAL 37 MINUTE, DATE_SUB(NOW(),INTERVAL 9 DAY)+INTERVAL 58 MINUTE),
-- order 9
(9, 1, 1, 2, DATE_SUB(NOW(),INTERVAL 9 DAY)+INTERVAL 15 MINUTE, DATE_SUB(NOW(),INTERVAL 9 DAY)+INTERVAL 27 MINUTE, DATE_SUB(NOW(),INTERVAL 9 DAY)+INTERVAL 46 MINUTE),
-- order 10
(10,3, 1, 2, DATE_SUB(NOW(),INTERVAL 8 DAY)+INTERVAL 20 MINUTE, DATE_SUB(NOW(),INTERVAL 8 DAY)+INTERVAL 32 MINUTE, DATE_SUB(NOW(),INTERVAL 8 DAY)+INTERVAL 50 MINUTE),
(10,6, 1, 2, DATE_SUB(NOW(),INTERVAL 8 DAY)+INTERVAL 8  MINUTE, DATE_SUB(NOW(),INTERVAL 8 DAY)+INTERVAL 32 MINUTE, DATE_SUB(NOW(),INTERVAL 8 DAY)+INTERVAL 50 MINUTE),
-- order 11
(11,4, 1, 2, DATE_SUB(NOW(),INTERVAL 7 DAY)+INTERVAL 25 MINUTE, DATE_SUB(NOW(),INTERVAL 7 DAY)+INTERVAL 37 MINUTE, DATE_SUB(NOW(),INTERVAL 7 DAY)+INTERVAL 55 MINUTE),
-- order 12
(12,3, 1, 2, DATE_SUB(NOW(),INTERVAL 7 DAY)+INTERVAL 20 MINUTE, DATE_SUB(NOW(),INTERVAL 7 DAY)+INTERVAL 32 MINUTE, DATE_SUB(NOW(),INTERVAL 7 DAY)+INTERVAL 50 MINUTE),
-- order 13
(13,2, 1, 2, DATE_SUB(NOW(),INTERVAL 6 DAY)+INTERVAL 18 MINUTE, DATE_SUB(NOW(),INTERVAL 6 DAY)+INTERVAL 30 MINUTE, DATE_SUB(NOW(),INTERVAL 6 DAY)+INTERVAL 50 MINUTE),
(13,5, 1, 2, DATE_SUB(NOW(),INTERVAL 6 DAY)+INTERVAL 15 MINUTE, DATE_SUB(NOW(),INTERVAL 6 DAY)+INTERVAL 25 MINUTE, DATE_SUB(NOW(),INTERVAL 6 DAY)+INTERVAL 50 MINUTE),
(13,6, 1, 2, DATE_SUB(NOW(),INTERVAL 6 DAY)+INTERVAL 8  MINUTE, DATE_SUB(NOW(),INTERVAL 6 DAY)+INTERVAL 25 MINUTE, DATE_SUB(NOW(),INTERVAL 6 DAY)+INTERVAL 50 MINUTE),
-- order 14
(14,4, 1, 2, DATE_SUB(NOW(),INTERVAL 6 DAY)+INTERVAL 25 MINUTE, DATE_SUB(NOW(),INTERVAL 6 DAY)+INTERVAL 37 MINUTE, DATE_SUB(NOW(),INTERVAL 6 DAY)+INTERVAL 56 MINUTE),
-- order 15
(15,1, 1, 2, DATE_SUB(NOW(),INTERVAL 5 DAY)+INTERVAL 15 MINUTE, DATE_SUB(NOW(),INTERVAL 5 DAY)+INTERVAL 27 MINUTE, DATE_SUB(NOW(),INTERVAL 5 DAY)+INTERVAL 46 MINUTE),
(15,4, 1, 2, DATE_SUB(NOW(),INTERVAL 5 DAY)+INTERVAL 25 MINUTE, DATE_SUB(NOW(),INTERVAL 5 DAY)+INTERVAL 37 MINUTE, DATE_SUB(NOW(),INTERVAL 5 DAY)+INTERVAL 57 MINUTE),
-- order 16
(16,3, 1, 2, DATE_SUB(NOW(),INTERVAL 5 DAY)+INTERVAL 20 MINUTE, DATE_SUB(NOW(),INTERVAL 5 DAY)+INTERVAL 32 MINUTE, DATE_SUB(NOW(),INTERVAL 5 DAY)+INTERVAL 52 MINUTE),
(16,5, 1, 2, DATE_SUB(NOW(),INTERVAL 5 DAY)+INTERVAL 15 MINUTE, DATE_SUB(NOW(),INTERVAL 5 DAY)+INTERVAL 25 MINUTE, DATE_SUB(NOW(),INTERVAL 5 DAY)+INTERVAL 52 MINUTE),
-- order 17
(17,5, 1, 2, DATE_SUB(NOW(),INTERVAL 4 DAY)+INTERVAL 15 MINUTE, DATE_SUB(NOW(),INTERVAL 4 DAY)+INTERVAL 25 MINUTE, DATE_SUB(NOW(),INTERVAL 4 DAY)+INTERVAL 42 MINUTE),
-- order 18
(18,2, 1, 2, DATE_SUB(NOW(),INTERVAL 4 DAY)+INTERVAL 18 MINUTE, DATE_SUB(NOW(),INTERVAL 4 DAY)+INTERVAL 30 MINUTE, DATE_SUB(NOW(),INTERVAL 4 DAY)+INTERVAL 50 MINUTE),
(18,4, 1, 2, DATE_SUB(NOW(),INTERVAL 4 DAY)+INTERVAL 25 MINUTE, DATE_SUB(NOW(),INTERVAL 4 DAY)+INTERVAL 37 MINUTE, DATE_SUB(NOW(),INTERVAL 4 DAY)+INTERVAL 57 MINUTE),
-- order 19
(19,3, 1, 2, DATE_SUB(NOW(),INTERVAL 3 DAY)+INTERVAL 20 MINUTE, DATE_SUB(NOW(),INTERVAL 3 DAY)+INTERVAL 32 MINUTE, DATE_SUB(NOW(),INTERVAL 3 DAY)+INTERVAL 52 MINUTE),
-- order 20
(20,1, 1, 2, DATE_SUB(NOW(),INTERVAL 3 DAY)+INTERVAL 15 MINUTE, DATE_SUB(NOW(),INTERVAL 3 DAY)+INTERVAL 27 MINUTE, DATE_SUB(NOW(),INTERVAL 3 DAY)+INTERVAL 45 MINUTE),
-- order 21
(21,1, 2, 2, DATE_SUB(NOW(),INTERVAL 2 DAY)+INTERVAL 15 MINUTE, DATE_SUB(NOW(),INTERVAL 2 DAY)+INTERVAL 27 MINUTE, DATE_SUB(NOW(),INTERVAL 2 DAY)+INTERVAL 47 MINUTE),
(21,4, 1, 2, DATE_SUB(NOW(),INTERVAL 2 DAY)+INTERVAL 25 MINUTE, DATE_SUB(NOW(),INTERVAL 2 DAY)+INTERVAL 37 MINUTE, DATE_SUB(NOW(),INTERVAL 2 DAY)+INTERVAL 57 MINUTE),
(21,6, 2, 2, DATE_SUB(NOW(),INTERVAL 2 DAY)+INTERVAL 8  MINUTE, DATE_SUB(NOW(),INTERVAL 2 DAY)+INTERVAL 37 MINUTE, DATE_SUB(NOW(),INTERVAL 2 DAY)+INTERVAL 57 MINUTE),
-- order 22
(22,4, 1, 2, DATE_SUB(NOW(),INTERVAL 2 DAY)+INTERVAL 25 MINUTE, DATE_SUB(NOW(),INTERVAL 2 DAY)+INTERVAL 37 MINUTE, DATE_SUB(NOW(),INTERVAL 2 DAY)+INTERVAL 56 MINUTE),
-- order 23
(23,1, 1, 2, DATE_SUB(NOW(),INTERVAL 1 DAY)+INTERVAL 15 MINUTE, DATE_SUB(NOW(),INTERVAL 1 DAY)+INTERVAL 27 MINUTE, DATE_SUB(NOW(),INTERVAL 1 DAY)+INTERVAL 46 MINUTE),
(23,3, 1, 2, DATE_SUB(NOW(),INTERVAL 1 DAY)+INTERVAL 20 MINUTE, DATE_SUB(NOW(),INTERVAL 1 DAY)+INTERVAL 32 MINUTE, DATE_SUB(NOW(),INTERVAL 1 DAY)+INTERVAL 52 MINUTE),
-- order 24
(24,5, 1, 2, DATE_SUB(NOW(),INTERVAL 1 DAY)+INTERVAL 15 MINUTE, DATE_SUB(NOW(),INTERVAL 1 DAY)+INTERVAL 25 MINUTE, DATE_SUB(NOW(),INTERVAL 1 DAY)+INTERVAL 42 MINUTE),
-- order 25
(25,3, 1, 2, DATE_SUB(NOW(),INTERVAL 1 DAY)+INTERVAL 20 MINUTE, DATE_SUB(NOW(),INTERVAL 1 DAY)+INTERVAL 32 MINUTE, DATE_SUB(NOW(),INTERVAL 1 DAY)+INTERVAL 51 MINUTE),
-- order 26 (today, out for delivery)
(26,1, 1, 1, NOW()-INTERVAL 15 MINUTE, NOW()-INTERVAL 5 MINUTE, NULL),
(26,5, 1, 1, NOW()-INTERVAL 15 MINUTE, NOW()-INTERVAL 5 MINUTE, NULL),
-- order 27 (today, being prepared)
(27,4, 1, 0, NULL, NULL, NULL),
-- order 28 (today, out for delivery)
(28,3, 1, 1, NOW()-INTERVAL 18 MINUTE, NOW()-INTERVAL 8 MINUTE, NULL),
(28,6, 1, 1, NOW()-INTERVAL 8  MINUTE, NOW()-INTERVAL 8 MINUTE, NULL),
-- order 29 (today, being prepared)
(29,5, 1, 0, NULL, NULL, NULL),
-- order 30 (today, being prepared)
(30,1, 1, 0, NULL, NULL, NULL);

-- ── Occasions (more variety for sales history) ────────────────
INSERT IGNORE INTO Occasions (name, date) VALUES
('Weekend',  NULL),
('Lunch',    NULL),
('Dinner',   NULL);

-- ── Sales_History ─────────────────────────────────────────────
-- Mirrors delivered Menu_Orders_Items (orders 1-25)
INSERT INTO Sales_History (quantity, item_id, menu_order_id, occasion_id)
SELECT
    moi.quantity,
    moi.item_id,
    moi.menu_order_id,
    CASE
        WHEN DAYOFWEEK(mo.order_time) IN (1,7) THEN (SELECT occasion_id FROM Occasions WHERE name='Weekend')
        WHEN HOUR(mo.order_time) BETWEEN 11 AND 15 THEN (SELECT occasion_id FROM Occasions WHERE name='Lunch')
        ELSE (SELECT occasion_id FROM Occasions WHERE name='Dinner')
    END
FROM Menu_Orders_Items moi
JOIN Menu_Orders mo ON mo.menu_order_id = moi.menu_order_id
WHERE moi.status = 2;

-- ── Sustainability_Records ────────────────────────────────────
-- carbon footprint estimated per delivered order (kg CO2e)
INSERT INTO Sustainability_Records (date, carbon_footprint, item_id, menu_order_id)
SELECT
    mo.order_time,
    ROUND(i.price * 0.08, 2),   -- rough heuristic: 8% of item price in kg CO2e
    moi.item_id,
    moi.menu_order_id
FROM Menu_Orders_Items moi
JOIN Menu_Orders mo  ON mo.menu_order_id  = moi.menu_order_id
JOIN Items       i   ON i.item_id         = moi.item_id
WHERE moi.status = 2;

-- ── Waste_Records ─────────────────────────────────────────────
-- 3 waste events on different batches
INSERT INTO Waste_Records (quantity, timestamp, inventory_batch_id) VALUES
(1.50, DATE_SUB(NOW(),INTERVAL 10 DAY), 5),  -- Chicken batch partially spoiled
(0.80, DATE_SUB(NOW(),INTERVAL 6  DAY), 3),  -- Mozzarella nearing expiry
(2.00, DATE_SUB(NOW(),INTERVAL 2  DAY), 1);  -- Tomato overstock trimmed

-- ── Logs ──────────────────────────────────────────────────────
-- status: 0=in_storage, 1=used, 2=expired
INSERT INTO Logs (timestamp, quantity, status, ingredient_id) VALUES
-- usage events (status=1)
(DATE_SUB(NOW(),INTERVAL 13 DAY), 0.70, 1, 1),
(DATE_SUB(NOW(),INTERVAL 12 DAY), 1.20, 1, 2),
(DATE_SUB(NOW(),INTERVAL 11 DAY), 0.60, 1, 3),
(DATE_SUB(NOW(),INTERVAL 10 DAY), 0.40, 1, 5),
(DATE_SUB(NOW(),INTERVAL 9  DAY), 0.80, 1, 1),
(DATE_SUB(NOW(),INTERVAL 8  DAY), 0.50, 1, 10),
(DATE_SUB(NOW(),INTERVAL 7  DAY), 0.30, 1, 9),
(DATE_SUB(NOW(),INTERVAL 6  DAY), 0.90, 1, 2),
(DATE_SUB(NOW(),INTERVAL 5  DAY), 0.60, 1, 4),
(DATE_SUB(NOW(),INTERVAL 4  DAY), 1.00, 1, 5),
(DATE_SUB(NOW(),INTERVAL 3  DAY), 0.40, 1, 6),
(DATE_SUB(NOW(),INTERVAL 2  DAY), 0.70, 1, 1),
(DATE_SUB(NOW(),INTERVAL 1  DAY), 0.50, 1, 3),
-- in-storage snapshots (status=0)
(DATE_SUB(NOW(),INTERVAL 7  DAY), 20.00, 0, 1),
(DATE_SUB(NOW(),INTERVAL 7  DAY), 38.00, 0, 2),
(DATE_SUB(NOW(),INTERVAL 7  DAY), 11.50, 0, 3),
-- expired (status=2)
(DATE_SUB(NOW(),INTERVAL 3  DAY),  1.50, 2, 5),
(DATE_SUB(NOW(),INTERVAL 1  DAY),  0.80, 2, 3);

-- ── Alerts & Alerted ──────────────────────────────────────────
INSERT INTO Alerts (message) VALUES
('Mozzarella stock below minimum threshold'),
('Chicken batch expiring within 5 days'),
('New supplier order placed for Tomatoes'),
('Low stock alert: Butter below reorder level'),
('Compliance inspection due next week');

-- alert all manager + chef users (user_ids 1,2,3)
INSERT IGNORE INTO Alerted (alert_id, user_id, created_at, read_at) VALUES
(1, 1, DATE_SUB(NOW(),INTERVAL 4 DAY), DATE_SUB(NOW(),INTERVAL 3 DAY)),
(1, 2, DATE_SUB(NOW(),INTERVAL 4 DAY), NULL),
(2, 1, DATE_SUB(NOW(),INTERVAL 2 DAY), DATE_SUB(NOW(),INTERVAL 1 DAY)),
(2, 2, DATE_SUB(NOW(),INTERVAL 2 DAY), NULL),
(3, 1, DATE_SUB(NOW(),INTERVAL 6 DAY), DATE_SUB(NOW(),INTERVAL 5 DAY)),
(3, 4, DATE_SUB(NOW(),INTERVAL 6 DAY), DATE_SUB(NOW(),INTERVAL 5 DAY)),
(4, 1, DATE_SUB(NOW(),INTERVAL 1 DAY), NULL),
(4, 2, DATE_SUB(NOW(),INTERVAL 1 DAY), NULL),
(5, 1, NOW(),                           NULL),
(5, 4, NOW(),                           NULL);

-- ── Ingredient_Reorder_Forecast ───────────────────────────────
INSERT IGNORE INTO Ingredient_Reorder_Forecast (ingredient_id, forecast_date, predicted_min_stock, applied) VALUES
(1,  CURDATE(),                    6.00, 0),
(2,  CURDATE(),                   11.00, 0),
(3,  CURDATE(),                    3.50, 0),
(5,  CURDATE(),                    5.00, 0),
(1,  DATE_ADD(CURDATE(),INTERVAL 1 DAY), 6.50, 0),
(3,  DATE_ADD(CURDATE(),INTERVAL 1 DAY), 4.00, 0),
(6,  DATE_ADD(CURDATE(),INTERVAL 2 DAY), 5.50, 0),
(10, DATE_ADD(CURDATE(),INTERVAL 2 DAY), 3.50, 0);

-- ── Item_Price_Override ───────────────────────────────────────
INSERT IGNORE INTO Item_Price_Override (item_id, effective_date, price, reason, applied) VALUES
(1, DATE_ADD(CURDATE(),INTERVAL 1 DAY), 13.99, 'high_demand_forecast',  0),
(2, DATE_ADD(CURDATE(),INTERVAL 1 DAY), 15.49, 'high_demand_forecast',  0),
(5, CURDATE(),                          9.99,  'low_demand_discount',   0),
(6, CURDATE(),                          4.49,  'low_demand_discount',   0);

SELECT 'Extra dummy data loaded successfully' AS status;
