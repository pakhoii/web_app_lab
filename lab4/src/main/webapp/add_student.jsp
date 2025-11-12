<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Student</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 20px;
        }

        .container {
            max-width: 600px;
            margin: 30px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }

        h2 {
            color: #34495e;
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #ecf0f1;
            padding-bottom: 15px;
            font-weight: 600;
        }

        .message {
            padding: 15px 20px;
            border-radius: 6px;
            margin-bottom: 25px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
            animation: fadeIn 0.4s ease-out;
            font-size: 15px;
        }

        .success {
            background-color: #e8f8f5;
            border-left: 6px solid #1abc9c;
            color: #117a65;
        }

        .error {
            background-color: #fdedec;
            border-left: 6px solid #e74c3c;
            color: #c0392b;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            font-weight: 600;
            color: #34495e;
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
        }

        input[type="text"],
        input[type="email"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #dcdfe6;
            border-radius: 5px;
            font-size: 15px;
            transition: border-color 0.3s, box-shadow 0.3s;
            box-sizing: border-box; /* Ensures padding doesn't affect total width */
        }

        input:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 5px rgba(52,152,219,0.3);
        }

        .required {
            color: #e74c3c;
            font-weight: 700;
            margin-left: 4px;
        }

        .btn-group {
            display: flex;
            justify-content: flex-end;
            margin-top: 30px;
            gap: 10px;
        }

        .btn-submit {
            background-color: #28a745;
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.2s, opacity 0.2s;
            font-weight: 600;
        }

        .btn-submit:hover {
            background-color: #218838;
        }

        .btn-submit:disabled {
            background-color: #7fc18f;
            cursor: not-allowed;
            opacity: 0.7;
        }

        .btn-cancel {
            background-color: #6c757d;
            color: white;
            padding: 12px 25px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 16px;
            transition: background-color 0.2s;
            text-align: center;
        }

        .btn-cancel:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>➕ Add New Student</h2>

    <% if (request.getParameter("success") != null) { %>
    <div class="message success">
        ✅ **Success:** <%= request.getParameter("success") %>
    </div>
    <% } %>

    <% if (request.getParameter("error") != null) { %>
    <div class="message error">
        ✗ **Error:** <%= request.getParameter("error") %>
    </div>
    <% } %>

    <form action="process_add.jsp" method="POST" onsubmit="return validateAndSubmit(this)">
        <div class="form-group">
            <label for="student_code">Student Code <span class="required">*</span></label>
            <input type="text" id="student_code" name="student_code"
                   placeholder="e.g., SV001"
                   required minlength="3" maxlength="10">
        </div>

        <div class="form-group">
            <label for="full_name">Full Name <span class="required">*</span></label>
            <input type="text" id="full_name" name="full_name"
                   required placeholder="Enter full name"
                   minlength="3" maxlength="100">
        </div>

        <div class="form-group">
            <label for="email">Email (Optional)</label>
            <input type="email" id="email" name="email"
                   placeholder="student@email.com"
                   maxlength="100">
        </div>

        <div class="form-group">
            <label for="major">Major (Optional)</label>
            <input type="text" id="major" name="major"
                   placeholder="e.g., Computer Science"
                   maxlength="50">
        </div>

        <div class="btn-group">
            <a href="list_students.jsp" class="btn-cancel">Cancel</a>
            <button type="submit" class="btn-submit">💾 Save Student</button>
        </div>
    </form>
</div>

<script>
    // Fades out and hides the status messages after 3 seconds.
    setTimeout(function() {
        var messages = document.querySelectorAll('.message');
        messages.forEach(function(msg) {
            msg.style.opacity = "0";
            msg.style.transition = "opacity 0.5s ease-out";
            setTimeout(() => msg.style.display = "none", 500);
        });
    }, 3000);

    // Client-side validation and submission button management
    function validateAndSubmit(form) {
        var studentCodeInput = form.querySelector('#student_code');
        var fullNameInput = form.querySelector('#full_name');

        if (studentCodeInput.value.trim() === "") {
            alert("Student Code is required.");
            studentCodeInput.focus();
            return false;
        }

        if (fullNameInput.value.trim() === "") {
            alert("Full Name is required.");
            fullNameInput.focus();
            return false;
        }

        // Disable button to prevent double submission
        var btn = form.querySelector('.btn-submit');
        btn.disabled = true;
        btn.textContent = "Processing…";
        return true;
    }
</script>
</body>
</html>