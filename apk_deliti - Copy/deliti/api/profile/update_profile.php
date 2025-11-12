<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include '../config.php';

$data = json_decode(file_get_contents("php://input"), true);

if(!empty($data['user_id'])) {
    try {
        $allowedFields = ['name', 'phone', 'profile_picture'];
        $updateFields = [];
        $updateValues = [];
        
        foreach($allowedFields as $field) {
            if(isset($data[$field])) {
                $updateFields[] = "$field = ?";
                $updateValues[] = $data[$field];
            }
        }
        
        if(!empty($updateFields)) {
            $updateValues[] = $data['user_id'];
            $sql = "UPDATE users SET " . implode(', ', $updateFields) . " WHERE id = ?";
            $stmt = $pdo->prepare($sql);
            
            if($stmt->execute($updateValues)) {
                echo json_encode([
                    'success' => true,
                    'message' => 'Profile updated successfully'
                ]);
            } else {
                echo json_encode([
                    'success' => false,
                    'message' => 'Update failed'
                ]);
            }
        } else {
            echo json_encode([
                'success' => false,
                'message' => 'No fields to update'
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
        'message' => 'User ID required'
    ]);
}
?>