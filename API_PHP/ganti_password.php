<?php
header('Content-Type: application/json');

// Konfigurasi koneksi database
$host = "localhost";
$username = "root";
$password = "";
$database = "kesehatankampus_db";

// Membuat koneksi
$conn = new mysqli($host, $username, $password, $database);

// Periksa koneksi
if ($conn->connect_error) {
    echo json_encode(["status" => "error", "message" => "Koneksi database gagal: " . $conn->connect_error]);
    exit;
}

// Ambil data dari request
$data = json_decode(file_get_contents("php://input"), true);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $userId = $data['user_id'] ?? null;
    $oldPassword = $data['old_password'] ?? null;
    $newPassword = $data['new_password'] ?? null;

    // Validasi input
    if (!$userId || !$oldPassword || !$newPassword) {
        echo json_encode(["status" => "error", "message" => "Semua field harus diisi"]);
        exit;
    }

    // Periksa apakah user ada
    $stmt = $conn->prepare("SELECT password FROM users WHERE id = ?");
    $stmt->bind_param("i", $userId);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        echo json_encode(["status" => "error", "message" => "Pengguna tidak ditemukan"]);
        exit;
    }

    $user = $result->fetch_assoc();

    // Verifikasi kata sandi lama
    if (!password_verify($oldPassword, $user['password'])) {
        echo json_encode(["status" => "error", "message" => "Kata sandi lama tidak sesuai"]);
        exit;
    }

    // Hash kata sandi baru
    $hashedPassword = password_hash($newPassword, PASSWORD_BCRYPT);

    // Update kata sandi
    $updateStmt = $conn->prepare("UPDATE users SET password = ? WHERE id = ?");
    $updateStmt->bind_param("si", $hashedPassword, $userId);

    if ($updateStmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Kata sandi berhasil diperbarui"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal memperbarui kata sandi"]);
    }

    $updateStmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Metode request tidak valid"]);
}

$conn->close();
?>
