<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'config.php';

$data = json_decode(file_get_contents("php://input"), true);

if(!empty($data['email']) && !empty($data['password'])) {
    $name = $data['name'];
    $email = $data['email'];
    $password = $data['password'];
    $phone = $data['phone'] ?? '';
    
    // ← MAKE SURE THIS LINE EXISTS IN register.php
    $hashed_password = password_hash($password, PASSWORD_DEFAULT);
    
    try {
        $stmt = $pdo->prepare("INSERT INTO users (name, email, password, phone) VALUES (?, ?, ?, ?)");
        $stmt->execute([$name, $email, $hashed_password, $phone]);
        
        echo json_encode([
            'success' => true,
            'message' => 'Registration successful'
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