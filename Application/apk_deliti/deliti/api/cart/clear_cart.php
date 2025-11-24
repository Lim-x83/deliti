<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include '../config.php';

$data = json_decode(file_get_contents("php://input"), true);

if(!empty($data['user_id'])) {
    $user_id = $data['user_id'];
    
    try {
        // Clear all items from cart (using user_id directly)
        $stmt = $pdo->prepare("DELETE FROM cart_items WHERE user_id = ?");
        $stmt->execute([$user_id]);
        
        echo json_encode([
            'success' => true,
            'message' => 'Cart cleared'
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