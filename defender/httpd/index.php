<?php
session_start();

if(isset($_POST['login'])) {
    $date_time = date("Y-m-d H:i:s");

    $username = $_POST['username'];
    $password = $_POST['password'];

    $url = $_SERVER['REQUEST_URI'];
    $remote_ip = $_SERVER["REMOTE_ADDR"];

    $current_user = shell_exec('whoami');
    $current_user = trim($current_user);
    $current_password = "root"; 

    $escapedUrl = escapeshellarg($url);

    # Here is the issue, among others...
    $log_message = $date_time . " " . $username . " Successful Login from: " . $remote_ip . " on: " . $escapedUrl;
    system("echo \"" . $log_message . "\" >> access.log");

    if($username == $current_user && $password === $current_password) {
        echo "Welcome!";
        $_SESSION["logged_in"] = true;
        header("Location: dashboard.php"); // Redirect to a dashboard or admin panel
    }
    else {
        echo "Wrong Password or Username!";
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - CWP</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <style>
        body {
            background: #222;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            color: #fff;
        }
        .login-container {
            background: #2c2f33;
            padding: 2rem;
            border-radius: 10px;
            width: 100%;
            max-width: 400px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
        }
        .login-container h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #f39c12;
        }
        .btn-custom {
            background: #f39c12;
            color: #fff;
            border: none;
        }
        .btn-custom:hover {
            background: #e67e22;
        }
        .form-control {
            background: #333;
            border: 1px solid #444;
            color: #fff;
        }
        .form-control::placeholder {
            color: #bbb;
        }
        .error-msg {
            color: red;
            text-align: center;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>

    <div class="login-container">
        <h2>CWP Admin Login</h2>
        <?php if (isset($error)) { echo "<p class='error-msg'>$error</p>"; } ?>
        <form method="post">
            <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input type="text" class="form-control" id="username" name="username" required placeholder="Enter username" value="<?php echo isset($username) ? $username : ''; ?>">
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" name="password" required placeholder="Enter password" value="<?php echo isset($password) ? $password : ''; ?>">
            </div>
            <button type="submit" class="btn btn-custom w-100">Login</button>
        </form>
    </div>

</body>
</html>
