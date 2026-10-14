USE dermaflow;

ALTER TABLE products ADD COLUMN image_path VARCHAR(255) NOT NULL DEFAULT '' AFTER stock;

UPDATE products SET image_path = 'assets/dew-drop-serum.png' WHERE slug = 'dew-drop-serum';
UPDATE products SET image_path = 'assets/soft-reset-cleanser.png' WHERE slug = 'soft-reset-cleanser';
UPDATE products SET image_path = 'assets/day-shield-spf40.png' WHERE slug = 'day-shield-spf-40';
