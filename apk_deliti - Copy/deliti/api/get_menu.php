<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'config.php';

try {
    $stmt = $pdo->query("SELECT * FROM menu_items WHERE is_available = 1");
    $menu_items = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    if(!$menu_items) {
        $menu_items = [];
    }
    
    echo json_encode($menu_items);
    
} catch(PDOException $e) {
    echo json_encode([
        'error' => true,
        'message' => 'Database error: ' . $e->getMessage()
    ]);
}
?>