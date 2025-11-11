<?php
include 'config.php';

header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");

// Get JSON input
$input = file_get_contents("php://input");
$data = json_decode($input);

if(!$data) {
    echo json_encode(['success' => false, 'message' => 'No data received']);
    exit;
}

if(isset($data->name) && isset($data->email) && isset($data->password) && isset($data->phone)) {
    try {
        // Check if email already exists
        $checkStmt = $pdo->prepare("SELECT id FROM users WHERE email = ?");
        $checkStmt->execute([$data->email]);
        
        if($checkStmt->fetch()) {
            echo json_encode(['success' => false, 'message' => 'Email already exists']);
            exit;
        }
        
        // Hash the password
        $hashedPassword = password_hash($data->password, PASSWORD_DEFAULT);
        
        $stmt = $pdo->prepare("INSERT INTO users (name, email, password, phone) VALUES (?, ?, ?, ?)");
        
        if($stmt->execute([$data->name, $data->email, $hashedPassword, $data->phone])) {
            // Get the newly created user
            $userStmt = $pdo->prepare("SELECT id, name, email, phone FROM users WHERE email = ?");
            $userStmt->execute([$data->email]);
            $user = $userStmt->fetch(PDO::FETCH_ASSOC);
            
            echo json_encode([
                'success' => true, 
                'message' => 'Registration successful!',
                'user' => $user
            ]);
        } else {
            echo json_encode(['success' => false, 'message' => 'Registration failed']);
        }
    } catch(PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'All fields are required']);
}
?>