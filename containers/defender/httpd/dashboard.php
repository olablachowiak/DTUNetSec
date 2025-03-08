<?php
session_start();
if (!isset($_SESSION["logged_in"]) || $_SESSION["logged_in"] !== true) {
    header("Location: index.php");
    exit();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <style>
        body {
            background: #222;
            color: #fff;
            text-align: center;
            padding: 50px;
        }
        .container {
            max-width: 500px;
            margin: auto;
            background: #2c2f33;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
        }
        .btn-custom {
            background: #f39c12;
            color: #fff;
            border: none;
        }
        .btn-custom:hover {
            background: #e67e22;
        }
    </style>
</head>
<body>

    <div class="container">
        <h2>Welcome to the Admin Dashboard</h2>
        <p>You have successfully logged in.</p>
        <a href="logout.php" class="btn btn-custom">Logout</a>
    </div>

</body>
</html>
