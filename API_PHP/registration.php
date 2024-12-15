<?php
header('Content-Type: application/json');

$host = 'localhost';
$db   = 'kesehatankampus_db'; 
$user = 'root';    
$pass = '';         
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];

try {
    $pdo = new PDO($dsn, $user, $pass, $options);
} catch (\PDOException $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Database connection failed.']);
    exit;
}

// Get input data
$data = json_decode(file_get_contents('php://input'), true);
$full_name = $data['full_name'] ?? '';
$email = $data['email'] ?? '';
$password = $data['password'] ?? '';
$phone_number = $data['phone_number'] ?? ''; 

// Validation
if (empty($full_name) || empty($email) || empty($password) || empty($phone_number)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Please fill all the fields.']);
    exit;
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Invalid email format.']);
    exit;
}

if (!preg_match('/^\d{10,13}$/', $phone_number)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Invalid phone number format. Must be 10-13 digits.']);
    exit;
}

if (strlen($password) < 6) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Password must be at least 6 characters long.']);
    exit;
}

// Check if email already exists
$stmt = $pdo->prepare('SELECT COUNT(*) FROM users WHERE email = ?');
$stmt->execute([$email]);
$email_exists = $stmt->fetchColumn();

if ($email_exists > 0) {
    http_response_code(409); 
    echo json_encode(['success' => false, 'message' => 'Email already registered.']);
    exit;
}

// Check if phone number already exists
$stmt = $pdo->prepare('SELECT COUNT(*) FROM users WHERE phone_number = ?');
$stmt->execute([$phone_number]);
$phone_exists = $stmt->fetchColumn();

if ($phone_exists > 0) {
    http_response_code(409); 
    echo json_encode(['success' => false, 'message' => 'Phone number already registered.']);
    exit;
}

// Hash the password
$hashed_password = password_hash($password, PASSWORD_DEFAULT);

// Insert into database
$stmt = $pdo->prepare('INSERT INTO users (full_name, email, password, phone_number) VALUES (?, ?, ?, ?)');
try {
    if ($stmt->execute([$full_name, $email, $hashed_password, $phone_number])) {
        echo json_encode(['success' => true, 'message' => 'Registration successful.']);
    } else {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Registration failed.']);
    }
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Database insertion failed.', 'error' => $e->getMessage()]);
}
?>
