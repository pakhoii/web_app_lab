<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Student</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 20px;
            line-height: 1.6;
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
            display: flex;
            align-items: center;
            font-size: 15px;
            gap: 12px;
            animation: fadeIn 0.4s ease-out;
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
            from { opacity:0; transform:translateY(-10px); }
            to { opacity:1; transform:translateY(0); }
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

        input[type="text"], input[type="email"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #dcdfe6;
            border-radius: 5px;
            font-size: 15px;
            transition: border-color 0.3s, box-shadow 0.3s;
            box-sizing: border-box;
        }

        input:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 5px rgba(52,152,219,0.3);
        }

        .btn-group {
            display: flex;
            justify-content: flex-end;
            margin-top: 30px;
            gap: 10px;
        }

        .btn-submit {
            background-color: #ffc107;
            color: #333;
            padding: 12px 25px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.2s, opacity 0.2s;
            font-weight: 600;
        }

        .btn-submit:hover {
            background-color: #e0a800;
        }

        .btn-submit:disabled {
            background-color: #f3d88c;
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
        }

        .btn-cancel:hover {
            background-color: #5a6268;
        }

        .required {
            color: #e74c3c;
            font-weight: 700;
            margin-left: 4px;
        }

        small {
            color: #95a5a6;
            display: block;
            margin-top: 5px;
            font-style: italic;
            font-size: 13px;
        }
    </style>
</head>
<body>
<%
    String idParam = request.getParameter("id");
    if (idParam == null || idParam.trim().isEmpty()) {
        response.sendRedirect("list_students.jsp?error=Error: Missing student ID parameter.");
        return;
    }

    int studentId;
    try {
        studentId = Integer.parseInt(idParam);
    } catch (NumberFormatException e) {
        response.sendRedirect("list_students.jsp?error=Error: Invalid student ID format.");
        return;
    }

    String studentCode = "", fullName = "", email = "", major = "";
    String dbError = null;

    String url = "jdbc:mysql://localhost:3306/student_management";
    String user = "root";
    String password = "khoi";
    String sql = "SELECT student_code, full_name, email, major FROM students WHERE id = ?";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Use try-with-resources to automatically close JDBC resources
        try (Connection conn = DriverManager.getConnection(url, user, password);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, studentId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    studentCode = rs.getString("student_code");
                    fullName = rs.getString("full_name");
                    email = rs.getString("email") != null ? rs.getString("email") : "";
                    major = rs.getString("major") != null ? rs.getString("major") : "";
                } else {
                    response.sendRedirect("list_students.jsp?error=Error: Student not found with ID " + studentId);
                    return;
                }
            }
        }
    } catch (ClassNotFoundException e) {
        dbError = "JDBC Driver not found.";
    } catch (SQLException e) {
        e.printStackTrace();
        dbError = "Database error: " + e.getMessage();
    }

    if (dbError != null) {
        out.println("<div class='container'>");
        out.println("<h2>❌ System Error</h2>");
        out.println("<div class='message error'>🛑 " + dbError + "</div>");
        out.println("<a href='list_students.jsp' class='btn-cancel'>Go Back to List</a>");
        out.println("</div>");
        return;
    }
%>
<div class="container">
    <h2>✏️ Edit Student Information</h2>

    <% if (request.getParameter("success") != null) { %>
    <div class="message success">✅ **Success:** <%= request.getParameter("success") %></div>
    <% } %>
    <% if (request.getParameter("error") != null) { %>
    <div class="message error">✗ **Error:** <%= request.getParameter("error") %></div>
    <% } %>

    <form action="process_edit.jsp" method="POST" onsubmit="return submitForm(this)">
        <input type="hidden" name="id" value="<%= studentId %>">

        <div class="form-group">
            <label>Student Code</label>
            <input type="text" name="student_code" value="<%= studentCode %>" readonly>
            <small>Cannot be changed</small>
        </div>

        <div class="form-group">
            <label>Full Name <span class="required">*</span></label>
            <input type="text" name="full_name" value="<%= fullName %>" required>
        </div>

        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" value="<%= email %>" placeholder="e.g., student@university.edu">
        </div>

        <div class="form-group">
            <label>Major</label>
            <input type="text" name="major" value="<%= major %>" placeholder="e.g., Computer Science">
        </div>

        <div class="btn-group">
            <a href="list_students.jsp" class="btn-cancel">Cancel</a>
            <button type="submit" class="btn-submit">💾 Update Information</button>
        </div>
    </form>
</div>
<script>
    setTimeout(function() {
        var messages = document.querySelectorAll('.message');
        messages.forEach(function(msg) {
            msg.style.opacity = "0";
            msg.style.transition = "opacity 0.5s ease-out";
            setTimeout(() => msg.style.display = "none", 500);
        });
    }, 3000);

    function submitForm(form){
        // Basic client-side validation for required fields
        var fullNameInput = form.querySelector('input[name="full_name"]');
        if (!fullNameInput || fullNameInput.value.trim() === "") {
            alert("Full Name is required.");
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