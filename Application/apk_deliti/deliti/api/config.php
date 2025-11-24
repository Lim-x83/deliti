<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");


// XAMPP Database Configuration
$host = "localhost";
$dbname = "deliti_app";
$username = "root";
$password = "";


// HOSTINGER Database Configuration - UPDATE THESE!
// $host = "sql209.infinityfree.com";
// $dbname = "if0_40171189_deliti_app"; // ← FROM HOSTINGER
// $username = "if0_40171189"; // ← FROM HOSTINGER
// $password = "p5TIP30LVoSre"; // ← FROM HOSTINGER

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch(PDOException $e) {
    echo json_encode(["error" => "Connection failed: " . $e->getMessage()]);
    exit;
}
?>