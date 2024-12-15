<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Koneksi ke database
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "kesehatankampus_db"; 

$conn = new mysqli($servername, $username, $password, $dbname);

// Periksa koneksi
if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(["message" => "Koneksi ke database gagal"]);
    exit();
}

// Mendapatkan data dari permintaan
$data = json_decode(file_get_contents("php://input"), true);

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $email = $data["email"];
    $password = $data["password"];

    // Validasi input
    if (empty($email) || empty($password)) {
        http_response_code(400);
        echo json_encode(["message" => "Email dan password wajib diisi"]);
        exit();
    }

    // Periksa pengguna di database
    $stmt = $conn->prepare("SELECT * FROM users WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc();

        // Verifikasi password
        if (password_verify($password, $user["password"])) {
            http_response_code(200);
            echo json_encode([
                "success" => true,
                "message" => "Login berhasil",
                "user_id" => $user["id"], 
                "full_name" => $user["full_name"], 
                "email" => $user["email"],
                "created_at" => $user["created_at"],
                "phone_number" => $user["phone_number"]
            ]);
        } else {
            http_response_code(401);
            echo json_encode(["message" => "Password salah"]);
        }
    } else {
        http_response_code(404);
        echo json_encode(["message" => "Email tidak ditemukan"]);
    }

    $stmt->close();
} else {
    http_response_code(405);
    echo json_encode(["message" => "Metode tidak diizinkan"]);
}

$conn->close();
?>
