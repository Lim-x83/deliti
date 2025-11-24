<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include '../config.php';

$data = json_decode(file_get_contents("php://input"), true);

if(!empty($data['user_id']) && !empty($data['total_price']) && !empty($data['items'])) {
    $user_id = $data['user_id'];
    $total_price = $data['total_price'];
    $items = $data['items'];
    
    try {
        $pdo->beginTransaction();
        
        // 1. Create order
        $stmt = $pdo->prepare("INSERT INTO orders (user_id, total_price, status) VALUES (?, ?, 'pending')");
        $stmt->execute([$user_id, $total_price]);
        $order_id = $pdo->lastInsertId();
        
        // 2. Add order items
        $stmt = $pdo->prepare("INSERT INTO order_items (order_id, menu_item_id, quantity, price) VALUES (?, ?, ?, ?)");
        foreach($items as $item) {
            $stmt->execute([$order_id, $item['menu_item_id'], $item['quantity'], $item['price']]);
        }
        
        // 3. Clear user's cart
        $stmt = $pdo->prepare("DELETE FROM cart_items WHERE user_id = ?");
        $stmt->execute([$user_id]);
        
        $pdo->commit();
        
        echo json_encode([
            'success' => true,
            'message' => 'Order created successfully',
            'order_id' => $order_id
        ]);
        
    } catch(PDOException $e) {
        $pdo->rollBack();
        echo json_encode([
            'success' => false,
            'message' => 'Database error: ' . $e->getMessage()
        ]);
    }
} else {
    echo json_encode([
        'success' => false,
        'message' => 'Missing required data'
    ]);
}
?>