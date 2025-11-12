<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%!
    String highlightText(String text, String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) return text;
        return text.replaceAll("(?i)(" + keyword + ")", "<span style='background: yellow;'>$1</span>");
        // (?i): allow both uppercase and lowercase
        // $1: matching part
    }
%>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student List</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        h1 { color: #333; }
        .message {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin-bottom: 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
        }
        th {
            background-color: #007bff;
            color: white;
            padding: 12px;
            text-align: left;
        }
        td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }
        tr:hover { background-color: #f8f9fa; }
        .action-link {
            color: #007bff;
            text-decoration: none;
            margin-right: 10px;
        }
        .delete-link { color: #dc3545; }

        .table-responsive {
            overflow-x: auto;
        }

        @media (max-width: 768px) {
            table {
                font-size: 12px;
            }
            th, td {
                padding: 5px;
            }
        }

        .pagination {
            display: flex;
            gap: 8px;
            justify-content: center;
            margin-top: 20px;
        }

        .pagination a, .pagination strong {
            padding: 8px 14px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            border: 1px solid #3498db;
            color: #3498db;
            transition: 0.2s;
        }

        .pagination a:hover {
            background-color: #3498db;
            color: white;
        }

        .pagination strong {
            background-color: #3498db;
            color: white;
            border-color: #2980b9;
        }
    </style>
</head>
<body>
<h1>📚 Student Management System</h1>

<% if (request.getParameter("message") != null) { %>
<div class="message success">
    <%= request.getParameter("message") %>
</div>
<% } %>

<% if (request.getParameter("error") != null) { %>
<div class="message error">
    <%= request.getParameter("error") %>
</div>
<% } %>

<a href="add_student.jsp" class="btn">➕ Add New Student</a>

<form action="list_students.jsp" method="GET"
        style="margin: 10px 0;">
    <input type="text" name="keyword" placeholder="Search by name or code...">
    <button type="submit">Search</button>
    <a href="list_students.jsp">Clear</a>
</form>

<table class="table-responsive">
    <thead>
    <tr>
        <th>ID</th>
        <th>Student Code</th>
        <th>Full Name</th>
        <th>Email</th>
        <th>Major</th>
        <th>Created At</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String keyword = request.getParameter("keyword");
    int currentPage = 1;
    int recordsPerPage = 10;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student_management","root","khoi");
        String pageParam = request.getParameter("page");
        if (pageParam != null) currentPage = Integer.parseInt(pageParam);
        int offset = (currentPage - 1) * recordsPerPage;

        int totalRecords;
        if (keyword == null || keyword.trim().isEmpty()) {
            pstmt = conn.prepareStatement("SELECT COUNT(*) FROM students");
        } else {
            pstmt = conn.prepareStatement(
                "SELECT COUNT(*) FROM students WHERE full_name LIKE ? OR student_code LIKE ? OR major LIKE ?"
            );
            String search = "%" + keyword + "%";
            pstmt.setString(1, search);
            pstmt.setString(2, search);
            pstmt.setString(3, search);
        }

        ResultSet countRs = pstmt.executeQuery();
        countRs.next();
        totalRecords = countRs.getInt(1);
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
        pstmt.close();

        if (keyword == null || keyword.trim().isEmpty()) {
            pstmt = conn.prepareStatement("SELECT * FROM students ORDER BY id DESC LIMIT ?, ?");
            pstmt.setInt(1, offset);
            pstmt.setInt(2, recordsPerPage);
        } else {
            pstmt = conn.prepareStatement(
                "SELECT * FROM students WHERE full_name LIKE ? OR student_code LIKE ? OR major LIKE ? ORDER BY id DESC LIMIT ?, ?"
            );
            String search = "%" + keyword + "%";
            pstmt.setString(1, search);
            pstmt.setString(2, search);
            pstmt.setString(3, search);
            pstmt.setInt(4, offset);
            pstmt.setInt(5, recordsPerPage);
        }

        rs = pstmt.executeQuery();
%>

    <tbody>
    <%
        while (rs.next()) {
    %>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= highlightText(rs.getString("student_code"), keyword) %></td>
        <td><%= highlightText(rs.getString("full_name"), keyword) %></td>
        <td><%= rs.getString("email") != null ? highlightText(rs.getString("email"), keyword) : "N/A" %></td>
        <td><%= rs.getString("major") != null ? highlightText(rs.getString("major"), keyword) : "N/A" %></td>
        <td><%= rs.getTimestamp("created_at") %></td>
        <td>
            <a href="edit_student.jsp?id=<%= rs.getInt("id") %>" class="action-link">✏️ Edit</a>
            <a href="delete_student.jsp?id=<%= rs.getInt("id") %>" class="action-link delete-link"
               onclick="return confirm('Are you sure?')">🗑️ Delete</a>
        </td>
    </tr>
    <%
        } // end while
    %>
    </tbody>

    <div class="pagination" style="margin: 20px 0;">
        <% if (currentPage > 1) { %>
        <a href="list_students.jsp?page=<%= currentPage - 1 %>">Previous</a>
        <% } %>

        <% for (int i = 1; i <= totalPages; i++) { %>
        <% if (i == currentPage) { %>
        <strong><%= i %></strong>
        <% } else { %>
        <a href="list_students.jsp?page=<%= i %>"><%= i %></a>
        <% } %>
        <% } %>

        <% if (currentPage < totalPages) { %>
        <a href="list_students.jsp?page=<%= currentPage + 1 %>">Next</a>
        <% } %>
    </div>

    <%
        } catch (Exception e) {
            out.println("<tr><td colspan='7'>Error: " + e.getMessage() + "</td></tr>");
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    %>

    </tbody>
</table>
</body>
</html>
