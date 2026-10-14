<?php
// Environment overrides for managed hosting (Railway). Falls back to local defaults.
$host = getenv('MYSQLHOST') ?: '127.0.0.1';
$name = getenv('MYSQLDATABASE') ?: 'dermaflow';
$user = getenv('MYSQLUSER') ?: 'root';
$pass = getenv('MYSQLPASSWORD');
if ($pass === false) { $pass = ''; }
define('DB_HOST', $host);
define('DB_NAME', $name);
define('DB_USER', $user);
define('DB_PASS', $pass);

function db(): PDO {
    static $pdo = null;
    if ($pdo instanceof PDO) return $pdo;
    $pdo = new PDO(
        'mysql:host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=utf8mb4',
        DB_USER,
        DB_PASS,
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC]
    );
    return $pdo;
}
