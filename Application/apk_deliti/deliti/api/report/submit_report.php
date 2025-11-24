<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include '../config.php';

$data = json_decode(file_get_contents("php://input"), true);

if(!empty($data['name']) && !empty($data['email']) && !empty($data['subject']) && !empty($data['description'])) {
    $name = $data['name'];
    $email = $data['email'];
    $category = $data['category'];
    $subject = $data['subject'];
    $description = $data['description'];
    
    try {
        $stmt = $pdo->prepare("INSERT INTO reports (name, email, category, subject, description, status) VALUES (?, ?, ?, ?, ?, 'pending')");
        $stmt->execute([$name, $email, $category, $subject, $description]);
        
        echo json_encode([
            'success' => true,
            'message' => 'Report submitted successfully',
            'report_id' => $pdo->lastInsertId()
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
        'message' => 'All fields are required'
    ]);
}
?>