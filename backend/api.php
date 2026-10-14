<?php
require __DIR__ . '/config.php';
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Content-Type');

function body(): array { return json_decode(file_get_contents('php://input'), true) ?: []; }
function out(array $data, int $status = 200): never { http_response_code($status); echo json_encode($data); exit; }

try {
    $action = $_GET['action'] ?? 'products';
    $pdo = db();

    if ($action === 'products') {
        $sql = 'SELECT id, name, slug, description, category, price, stock, image_path FROM products WHERE stock > 0';
        $params = [];
        if (!empty($_GET['category'])) { $sql .= ' AND category = :category'; $params['category'] = $_GET['category']; }
        $sql .= ' ORDER BY created_at DESC';
        $stmt = $pdo->prepare($sql); $stmt->execute($params);
        out(['data' => $stmt->fetchAll()]);
    }

    if ($action === 'create_routine_request' && $_SERVER['REQUEST_METHOD'] === 'POST') {
        $data = body();
        $name = trim((string)($data['name'] ?? ''));
        $location = trim((string)($data['location'] ?? ''));
        $product = trim((string)($data['product'] ?? ''));
        if ($name === '' || $location === '' || $product === '') out(['error' => 'Name, location, and product are required.'], 422);
        $stmt = $pdo->prepare('INSERT INTO routine_requests (customer_name, location, product_name) VALUES (?, ?, ?)');
        $stmt->execute([$name, $location, $product]);
        out(['message' => 'Your product is on the way.', 'request_id' => (int)$pdo->lastInsertId(), 'status' => 'requested'], 201);
    }

    if ($action === 'create_order' && $_SERVER['REQUEST_METHOD'] === 'POST') {
        $data = body();
        if (empty($data['customer_name']) || empty($data['customer_email']) || empty($data['items'])) out(['error' => 'Customer details and items are required.'], 422);
        $pdo->beginTransaction();
        $total = 0; $items = [];
        $lookup = $pdo->prepare('SELECT id, price, stock FROM products WHERE id = ? FOR UPDATE');
        foreach ($data['items'] as $item) {
            $lookup->execute([(int)$item['product_id']]); $product = $lookup->fetch();
            $qty = max(1, (int)$item['quantity']);
            if (!$product || $product['stock'] < $qty) throw new RuntimeException('A product is unavailable or out of stock.');
            $total += $product['price'] * $qty;
            $items[] = [$product, $qty];
        }
        $order = $pdo->prepare('INSERT INTO orders (customer_name, customer_email, total) VALUES (?, ?, ?)');
        $order->execute([$data['customer_name'], $data['customer_email'], $total]);
        $orderId = (int)$pdo->lastInsertId();
        $add = $pdo->prepare('INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES (?, ?, ?, ?)');
        $reduce = $pdo->prepare('UPDATE products SET stock = stock - ? WHERE id = ?');
        foreach ($items as [$product, $qty]) { $add->execute([$orderId, $product['id'], $qty, $product['price']]); $reduce->execute([$qty, $product['id']]); }
        $pdo->commit(); out(['message' => 'Order created.', 'order_id' => $orderId, 'total' => number_format($total, 2, '.', '')], 201);
    }

    if ($action === 'assistant') {
        $question = strtolower(trim($_GET['question'] ?? body()['question'] ?? ''));
        $answer = 'Tell me your skin type and your main goal, such as hydration, sensitivity, breakouts, or glow.';
        if (str_contains($question, 'dry') || str_contains($question, 'hydrate')) $answer = 'For dry or dehydrated skin, start with Soft Reset Cleanser and Dew Drop Barrier Serum.';
        if (str_contains($question, 'oily') || str_contains($question, 'breakout')) $answer = 'For oily or breakout-prone skin, keep the routine light and consistent; start with Soft Reset Cleanser and Day Shield SPF 40.';
        if (str_contains($question, 'sensitive') || str_contains($question, 'calm')) $answer = 'For sensitive skin, choose a gentle cleanser, introduce one product at a time, and patch-test before regular use.';
        out(['answer' => $answer, 'disclaimer' => 'This demo is not medical advice.']);
    }

    out(['error' => 'Unknown action.'], 404);
} catch (Throwable $e) {
    if (isset($pdo) && $pdo->inTransaction()) $pdo->rollBack();
    out(['error' => 'Request could not be completed.', 'detail' => $e->getMessage()], 500);
}
