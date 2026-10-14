# DermaFlow PHP/MySQL backend

## Local setup
1. Start Apache and MySQL with XAMPP, Laragon, or another local PHP stack.
2. Run `schema.sql` in MySQL or phpMyAdmin.
3. Review `config.php` and set your local database credentials.
4. Serve the project through PHP, for example: `php -S localhost:8000 -t ..` from this folder.
5. If you already imported the older schema, run `migration_v2.sql` to add product image paths.
6. Run `migration_v3.sql` to add routine requests and re-seed/update all three products.

The generated product visuals live in `../assets/` and are fictional DermaFlow brand assets for this portfolio demo. The catalog contains six products across hydration, calm & repair, and glow, and the dedicated `../shop.html` page provides category filters. The Flow Guide in the browser is intentionally static and works without an API; the hero form can persist routine requests through the PHP endpoint when MySQL is available.

## API examples
- `GET /backend/api.php?action=products`
- `GET /backend/api.php?action=products&category=hydration`
- `GET /backend/api.php?action=assistant&question=My%20skin%20is%20dry` (legacy API assistant)
- `POST /backend/api.php?action=create_routine_request` with JSON: `{"name":"Faheem","location":"Lahore","product":"Dew Drop Barrier Serum"}`
- `POST /backend/api.php?action=create_order` with JSON: `{"customer_name":"Faheem","customer_email":"you@example.com","items":[{"product_id":1,"quantity":1}]}`

The assistant endpoint is a deterministic demo rule engine. Replace it with a real AI service only after adding server-side authentication, rate limiting, validation, and privacy controls.
