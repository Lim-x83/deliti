<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include '../config.php';

$data = json_decode(file_get_contents("php://input"), true);

if(!empty($data['user_id'])) {
    try {
        $stmt = $pdo->prepare("
            SELECT ci.*, mi.name, mi.price, mi.image_path 
            FROM cart_items ci 
            JOIN menu_items mi ON ci.menu_item_id = mi.id 
            WHERE ci.user_id = ? AND ci.quantity > 0
        ");
        $stmt->execute([$data['user_id']]);
        $cart_items = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        echo json_encode([
            'success' => true,
            'items' => $cart_items
        ]);
        
    } catch(PDOException $e) {
        echo json_encode([
            'success' => false,
            'message' => 'Database error: ' . $e->getMessage()
        ]);
    }
} else {
    echo json_encode([
        'success' => false,
        'message' => 'User ID required'
    ]);
}
?>