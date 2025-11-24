<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include '../config.php';

$data = json_decode(file_get_contents("php://input"), true);

if(!empty($data['order_id'])) {
    $order_id = $data['order_id'];
    
    try {
        // Update order status to cancelled (only if it's pending)
        $stmt = $pdo->prepare("UPDATE orders SET status = 'cancelled' WHERE id = ? AND status = 'pending'");
        $stmt->execute([$order_id]);
        
        $affectedRows = $stmt->rowCount();
        
        if($affectedRows > 0) {
            echo json_encode([
                'success' => true,
                'message' => 'Order cancelled successfully'
            ]);
        } else {
            echo json_encode([
                'success' => false,
                'message' => 'Order cannot be cancelled (may already be processed)'
            ]);
        }
        
    } catch(PDOException $e) {
        echo json_encode([
            'success' => false,
            'message' => 'Database error: ' . $e->getMessage()
        ]);
    }
} else {
    echo json_encode([
        'success' => false,
        'message' => 'Order ID required'
    ]);
}
?>