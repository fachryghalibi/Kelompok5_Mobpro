<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");

// Ganti dengan konfigurasi database Anda
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "kesehatankampus_db";

// Membuat koneksi
$conn = new mysqli($servername, $username, $password, $dbname);

// Periksa koneksi
if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(["error" => "Koneksi database gagal: " . $conn->connect_error]);
    exit();
}

// Cek apakah id diterima dari query string
$articleId = isset($_GET['id']) ? (int)$_GET['id'] : null;

if ($articleId) {
    // Query untuk mengambil data artikel berdasarkan ID
    $stmt = $conn->prepare("SELECT id, title, author, read_time, image_url, content, created_at FROM articles WHERE id = ?");
    $stmt->bind_param("i", $articleId); // Bind parameter untuk mencegah SQL Injection
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $article = $result->fetch_assoc();
        echo json_encode([
            "status" => "success",
            "article" => [
                "id" => $article["id"],
                "title" => $article["title"],
                "author" => $article["author"],
                "read_time" => $article["read_time"],
                "image_url" => $article["image_url"],
                "content" => $article["content"],
                "created_at" => $article["created_at"]
            ]
        ]);
    } else {
        // Jika artikel tidak ditemukan
        echo json_encode(["status" => "error", "message" => "Article not found"]);
    }

    $stmt->close();
} else {
    // Query untuk mengambil semua artikel
    $sql = "SELECT id, title, author, read_time, image_url, content, created_at FROM articles ORDER BY created_at DESC";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $articles = [];
        while ($row = $result->fetch_assoc()) {
            $articles[] = [
                "id" => $row["id"],
                "title" => $row["title"],
                "author" => $row["author"],
                "read_time" => $row["read_time"],
                "image_url" => $row["image_url"],
                "content" => $row["content"],
                "created_at" => $row["created_at"]
            ];
        }
        echo json_encode(["status" => "success", "articles" => $articles]);
    } else {
        echo json_encode(["status" => "success", "articles" => []]);
    }
}

// Tutup koneksi
$conn->close();
?>
