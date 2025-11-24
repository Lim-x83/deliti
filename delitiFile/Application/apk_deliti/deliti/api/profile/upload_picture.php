<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include '../config.php';

// Create uploads directory if it doesn't exist
$uploadDir = __DIR__ . '/../uploads/';
if (!is_dir($uploadDir)) {
    mkdir($uploadDir, 0777, true);
}

if($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_FILES['profile_picture']) && isset($_POST['user_id'])) {
    $userId = $_POST['user_id'];
    $file = $_FILES['profile_picture'];
    
    // Validate file
    $allowedTypes = ['image/jpeg', 'image/png', 'image/gif'];
    $maxSize = 5 * 1024 * 1024; // 5MB
    
    if(!in_array($file['type'], $allowedTypes)) {
        echo json_encode(['success' => false, 'message' => 'Invalid file type']);
        exit;
    }
    
    if($file['size'] > $maxSize) {
        echo json_encode(['success' => false, 'message' => 'File too large']);
        exit;
    }
    
    // Generate unique filename
    $fileExtension = pathinfo($file['name'], PATHINFO_EXTENSION);
    $fileName = 'profile_' . $userId . '_' . time() . '.' . $fileExtension;
    $filePath = $uploadDir . $fileName;
    
    if(move_uploaded_file($file['tmp_name'], $filePath)) {
        try {
            // Update database
            $stmt = $pdo->prepare("UPDATE users SET profile_picture = ? WHERE id = ?");
            if($stmt->execute([$fileName, $userId])) {
                echo json_encode([
                    'success' => true,
                    'message' => 'Profile picture updated',
                    'profile_picture' => $fileName
                ]);
            } else {
                echo json_encode(['success' => false, 'message' => 'Database update failed']);
            }
        } catch(PDOException $e) {
            echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
        }
    } else {
        echo json_encode(['success' => false, 'message' => 'File upload failed']);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Invalid request']);
}
?>