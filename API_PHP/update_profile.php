<?php
$host = 'localhost';
$db = 'kesehatankampus_db';
$user = 'root';
$password = '';

// Create connection
$conn = new mysqli($host, $user, $password, $db);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get JSON input
$data = json_decode(file_get_contents('php://input'), true);

// Validasi input JSON
if (!isset($data['user_id']) || !isset($data['full_name']) || !isset($data['email']) || !isset($data['phone_number'])) {
    echo json_encode(["error" => "Missing data"]);
    http_response_code(400);
    exit();
}

// Pastikan user_id adalah integer
$user_id = intval($data['user_id']);
$full_name = $conn->real_escape_string($data['full_name']);
$email = $conn->real_escape_string($data['email']);
$phone_number = $conn->real_escape_string($data['phone_number']);

// Validasi format email
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    echo json_encode(["error" => "Invalid email format"]);
    http_response_code(400);
    exit();
}

// Check if user exists using prepared statement
$sql = "SELECT * FROM users WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $user_id); 
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo json_encode(["error" => "User not found"]);
    http_response_code(404);
    exit();
}

// Update user data using prepared statement
$update_sql = "UPDATE users SET full_name = ?, email = ?, phone_number = ? WHERE id = ?";
$update_stmt = $conn->prepare($update_sql);
$update_stmt->bind_param("sssi", $full_name, $email, $phone_number, $user_id); 
$update_result = $update_stmt->execute();

if ($update_result) {
    echo json_encode(["message" => "Profile updated successfully"]);
} else {
    echo json_encode(["error" => "Failed to update profile: " . $conn->error]);
    http_response_code(500);
}

// Close statements and connection
$stmt->close();
$update_stmt->close();
$conn->close();
?>
