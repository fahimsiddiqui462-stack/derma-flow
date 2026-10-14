CREATE DATABASE IF NOT EXISTS dermaflow CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE dermaflow;

CREATE TABLE products (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  slug VARCHAR(140) NOT NULL UNIQUE,
  description TEXT,
  category VARCHAR(60) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  stock INT UNSIGNED NOT NULL DEFAULT 0,
  image_path VARCHAR(255) NOT NULL DEFAULT '',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE routine_requests (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  customer_name VARCHAR(120) NOT NULL,
  location VARCHAR(160) NOT NULL,
  product_name VARCHAR(120) NOT NULL,
  status ENUM('requested','in_transit','delivered') DEFAULT 'requested',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  customer_name VARCHAR(120) NOT NULL,
  customer_email VARCHAR(190) NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  status ENUM('pending','paid','fulfilled','cancelled') DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  order_id INT UNSIGNED NOT NULL,
  product_id INT UNSIGNED NOT NULL,
  quantity INT UNSIGNED NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO products (name, slug, description, category, price, stock, image_path) VALUES
('Dew Drop Barrier Serum','dew-drop-serum','Ceramides and squalane for a calm, hydrated barrier.','hydration',28.00,40,'assets/dew-drop-serum.png'),
('Soft Reset Cleanser','soft-reset-cleanser','A gentle oat-amino-acid cleanser for everyday use.','calm',22.00,55,'assets/soft-reset-cleanser.png'),
('Day Shield SPF 40','day-shield-spf-40','A lightweight sunscreen with an invisible finish.','glow',25.00,35,'assets/day-shield-spf40.png'),
('Fresh Rain Hydrating Mist','fresh-rain-hydrating-mist','A weightless facial mist that refreshes and softens throughout the day.','hydration',24.00,45,'assets/fresh-rain-hydrating-mist.png'),
('Reset Clay Mask','reset-clay-mask','A balanced clay mask for a clearer, smoother-feeling reset.','calm',26.00,30,'assets/reset-clay-mask.png'),
('Quiet Focus Eye Cream','quiet-focus-eye-cream','A lightweight eye cream for a rested-looking finish.','glow',30.00,28,'assets/quiet-focus-eye-cream.png')
ON DUPLICATE KEY UPDATE name = VALUES(name);
