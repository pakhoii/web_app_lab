<%--
  Created by IntelliJ IDEA.
  User: pham-anh-khoi
  Date: 11/24/25
  Time: 8:57 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password - Student Management System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 400px;
        }

        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .login-header h1 {
            color: #333;
            font-size: 28px;
            margin-bottom: 10px;
        }

        .login-header p {
            color: #666;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: 500;
        }

        .form-group input[type="password"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        .form-group input:focus {
            outline: none;
            border-color: #667eea;
        }

        .btn-login {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .btn-login:hover {
            transform: translateY(-2px);
        }

        .alert {
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .alert-error {
            background: #fee;
            color: #c33;
            border: 1px solid #fcc;
        }

        .alert-success {
            background: #efe;
            color: #3c3;
            border: 1px solid #cfc;
        }

        .back-link {
            margin-top: 20px;
            text-align: center;
        }

        .back-link a {
            color: #667eea;
            text-decoration: none;
            font-size: 14px;
            transition: color 0.3s;
        }

        .back-link a:hover {
            color: #764ba2;
        }
    </style>
</head>
<body>
<div class="login-container">
    <div class="login-header">
        <h1>🔑 Change Password</h1>
        <p>Update your account password</p>
    </div>

    <!-- Error Message -->
    <c:if test="${not empty error}">
        <div class="alert alert-error">
            ❌ ${error}
        </div>
    </c:if>

    <!-- Success Message -->
    <c:if test="${not empty success}">
        <div class="alert alert-success">
            ✅ ${success}
        </div>
    </c:if>

    <!-- Change Password Form -->
    <form action="change-password" method="post">
        <div class="form-group">
            <label for="currentPassword">Current Password</label>
            <input type="password"
                   id="currentPassword"
                   name="currentPassword"
                   placeholder="Enter your current password"
                   required
                   autofocus>
        </div>

        <div class="form-group">
            <label for="newPassword">New Password</label>
            <input type="password"
                   id="newPassword"
                   name="newPassword"
                   placeholder="Enter your new password"
                   required>
        </div>

        <div class="form-group">
            <label for="confirmPassword">Confirm New Password</label>
            <input type="password"
                   id="confirmPassword"
                   name="confirmPassword"
                   placeholder="Confirm your new password"
                   required>
        </div>

        <button type="submit" class="btn-login">Change Password</button>
    </form>

    <!-- Back to Dashboard -->
    <div class="back-link">
        <a href="dashboard">← Back to Dashboard</a>
    </div>
</div>
</body>
</html>
