USE dermaflow;

CREATE TABLE IF NOT EXISTS routine_requests (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  customer_name VARCHAR(120) NOT NULL,
  location VARCHAR(160) NOT NULL,
  product_name VARCHAR(120) NOT NULL,
  status ENUM('requested','in_transit','delivered') DEFAULT 'requested',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO products (name, slug, description, category, price, stock, image_path) VALUES
('Dew Drop Barrier Serum','dew-drop-serum','Ceramides and squalane for a calm, hydrated barrier.','hydration',28.00,40,'assets/dew-drop-serum.png'),
('Soft Reset Cleanser','soft-reset-cleanser','A gentle oat-amino-acid cleanser for everyday use.','calm',22.00,55,'assets/soft-reset-cleanser.png'),
('Day Shield SPF 40','day-shield-spf-40','A lightweight sunscreen with an invisible finish.','glow',25.00,35,'assets/day-shield-spf40.png'),
('Fresh Rain Hydrating Mist','fresh-rain-hydrating-mist','A weightless facial mist that refreshes and softens throughout the day.','hydration',24.00,45,'assets/fresh-rain-hydrating-mist.png'),
('Reset Clay Mask','reset-clay-mask','A balanced clay mask for a clearer, smoother-feeling reset.','calm',26.00,30,'assets/reset-clay-mask.png'),
('Quiet Focus Eye Cream','quiet-focus-eye-cream','A lightweight eye cream for a rested-looking finish.','glow',30.00,28,'assets/quiet-focus-eye-cream.png')
ON DUPLICATE KEY UPDATE
  description = VALUES(description),
  category = VALUES(category),
  price = VALUES(price),
  image_path = VALUES(image_path);
