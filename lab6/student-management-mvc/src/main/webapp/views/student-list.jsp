<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Student List - MVC</title>
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
        padding: 20px;
    }

    .container {
        max-width: 1200px;
        margin: 0 auto;
        background: white;
        border-radius: 10px;
        padding: 30px;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
    }

    h1 {
        color: #333;
        margin-bottom: 10px;
        font-size: 32px;
    }

    .subtitle {
        color: #666;
        margin-bottom: 30px;
        font-style: italic;
    }

    .message {
        padding: 15px;
        margin-bottom: 20px;
        border-radius: 5px;
        font-weight: 500;
    }

    .success {
        background-color: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
    }

    .alert-error {
        background-color: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
        padding: 15px;
        margin-bottom: 20px;
        border-radius: 5px;
        font-weight: 500;
    }

    .btn {
        display: inline-block;
        padding: 12px 24px;
        text-decoration: none;
        border-radius: 5px;
        font-weight: 500;
        transition: all 0.3s;
        border: none;
        cursor: pointer;
        font-size: 14px;
    }

    .btn-primary {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
    }

    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
    }

    .btn-secondary {
        background-color: #6c757d;
        color: white;
    }

    .btn-danger {
        background-color: #dc3545;
        color: white;
        padding: 8px 16px;
        font-size: 13px;
    }

    .btn-danger:hover {
        background-color: #c82333;
    }

    .controls-container {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
        flex-wrap: wrap;
        gap: 20px;
    }

    .controls-left {
        display: flex;
        gap: 15px;
        align-items: center;
    }

    .search-form,
    .filter-form {
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .search-input,
    .filter-select {
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 5px;
        font-size: 14px;
    }

    .search-input {
        width: 250px;
    }

    .btn-action {
        padding: 10px 15px;
        background-color: #007bff;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
    }

    .btn-clear {
        text-decoration: none;
        color: #007bff;
        font-weight: 500;
    }

    .search-results-info {
        background-color: #e9ecef;
        padding: 10px 15px;
        border-radius: 5px;
        margin-bottom: 20px;
        color: #495057;
    }

    table {
        width: 100%;
        border-collapse: collapse;
    }

    thead {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    }

    th,
    td {
        padding: 15px;
        text-align: left;
        border-bottom: 1px solid #ddd;
    }

    th {
        font-weight: 600;
        text-transform: uppercase;
        font-size: 13px;
        letter-spacing: 0.5px;
    }

    th a {
        color: white;
        text-decoration: none;
    }

    th a:hover {
        text-decoration: underline;
    }

    .sort-indicator {
        margin-left: 5px;
    }

    tbody tr {
        transition: background-color 0.2s;
    }

    tbody tr:hover {
        background-color: #f8f9fa;
    }

    .actions {
        display: flex;
        gap: 10px;
    }

    .empty-state {
        text-align: center;
        padding: 60px 20px;
        color: #999;
    }

    .empty-state-icon {
        font-size: 64px;
        margin-bottom: 20px;
    }

    .pagination-container {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 25px;
        padding-top: 20px;
        border-top: 1px solid #eee;
    }
    .pagination {
        display: flex;
        gap: 5px;
    }
    .pagination a, .pagination span {
        display: inline-block;
        padding: 8px 14px;
        text-decoration: none;
        border: 1px solid #ddd;
        border-radius: 5px;
        color: #337ab7;
        transition: background-color 0.2s;
    }
    .pagination a:hover {
        background-color: #f0f0f0;
    }
    .pagination .active {
        background-color: #667eea;
        color: white;
        border-color: #667eea;
        font-weight: bold;
    }
    .pagination .disabled {
        color: #ccc;
        pointer-events: none;
        border-color: #eee;
    }
    .page-info {
        color: #666;
        font-size: 14px;
    }

    /* css */
    .navbar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 16px;
        width: 100%;
        padding: 12px 20px;
        border-radius: 10px;
        background: rgba(255, 255, 255, 0.06);
        backdrop-filter: blur(6px);
        -webkit-backdrop-filter: blur(6px);
        box-shadow: 0 6px 18px rgba(0,0,0,0.18);
        margin-bottom: 18px;
    }

    .navbar h2 {
        margin: 0;
        font-size: 18px;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 10px;
        color: #ffffff;
        letter-spacing: 0.2px;
    }

    .navbar-right {
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .user-info {
        display: flex;
        align-items: center;
        gap: 10px;
        color: #ffffff;
        font-weight: 500;
        font-size: 14px;
    }

    .role-badge {
        display: inline-block;
        padding: 4px 8px;
        border-radius: 999px;
        font-size: 12px;
        text-transform: capitalize;
        color: #fff;
        background: rgba(255,255,255,0.12);
        border: 1px solid rgba(255,255,255,0.08);
    }

    .role-admin    { background: linear-gradient(90deg,#ff6b6b,#ff3b3b); }
    .role-teacher  { background: linear-gradient(90deg,#4f9ef6,#2b7cff); }
    .role-student  { background: linear-gradient(90deg,#6fd96f,#2db44a); }

    .navbar-right a {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 8px 12px;
        border-radius: 8px;
        text-decoration: none;
        font-weight: 600;
        font-size: 13px;
        color: #ffffff;
        background: rgba(255,255,255,0.08);
        border: 1px solid rgba(255,255,255,0.06);
        transition: transform 0.15s ease, box-shadow 0.15s ease, background 0.15s ease;
    }

    .navbar-right a:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 18px rgba(102, 102, 170, 0.18);
        background: rgba(255,255,255,0.12);
    }

    @media (max-width: 720px) {
        .navbar {
            flex-direction: column;
            align-items: flex-start;
            gap: 10px;
            padding: 12px 16px;
        }
        .navbar-right {
            width: 100%;
            display: flex;
            justify-content: space-between;
            gap: 8px;
        }
        .user-info { font-size: 13px; }
        .navbar-right a { padding: 6px 10px; font-size: 13px; }
    }

</style>
</head>
<body>
    <div class="navbar">
    <h2>📚 Student Management System</h2>
    <div class="navbar-right">
        <div class="user-info">
            <span>Welcome, ${sessionScope.fullName}</span>
            <span class="role-badge role-${sessionScope.role}">
                ${sessionScope.role}
            </span>
        </div>
        <a href="dashboard">Dashboard</a>
        <a href="logout">Logout</a>
    </div>
    </div>

    <div class="container">
    <p class="subtitle">MVC Pattern with Jakarta EE & JSTL</p>

    <c:if test="${not empty param.message}">
        <div class="message success">✅ ${param.message}</div>
    </c:if>

    <c:if test="${not empty param.error}">
        <div class="alert alert-error">
            ${param.error}
        </div>
    </c:if>

    <div class="controls-container">
        <div class="controls-left">
            <!-- TODO: Add button - Admin only -->
            <c:if test="${sessionScope.role eq 'admin'}">
                <div style="margin: 20px 0;">
                    <a href="student?action=new" class="btn-add btn btn-primary">➕ Add New Student</a>
                </div>
            </c:if>
            <form action="student" method="get" class="filter-form">
                <input type="hidden" name="action" value="filter">
                <select name="filterMajor" class="filter-select" onchange="this.form.submit()">
                    <option value="">-- All Majors --</option>
                    <option value="Computer Science" ${filterMajor == 'Computer Science' ? 'selected' : ''}>Computer Science</option>
                    <option value="Information Technology" ${filterMajor == 'Information Technology' ? 'selected' : ''}>Information Technology</option>
                    <option value="Software Engineering" ${filterMajor == 'Software Engineering' ? 'selected' : ''}>Software Engineering</option>
                    <option value="Business Administration" ${filterMajor == 'Business Administration' ? 'selected' : ''}>Business Administration</option>
                </select>
                <c:if test="${not empty filterMajor}">
                    <a href="student?action=list" class="btn-clear">Clear Filter</a>
                </c:if>
            </form>
        </div>

        <form action="student" method="get" class="search-form">
            <input type="hidden" name="action" value="search">
            <input type="text" name="keyword" class="search-input" placeholder="Search by code, name, email..." value="<c:out value='${keyword}'/>">
            <button type="submit" class="btn-action">🔍</button>
            <c:if test="${not empty keyword}">
                <a href="student?action=list" class="btn-clear">Clear Search</a>
            </c:if>
        </form>
    </div>

    <c:if test="${not empty keyword}">
        <h4 class="search-results-info">Search results for: "<strong><c:out value="${keyword}"/></strong>"</h4>
    </c:if>
    <c:if test="${not empty filterMajor}">
        <h4 class="search-results-info">Filtered by Major: <strong>${filterMajor}</strong></h4>
    </c:if>

    <c:choose>
        <c:when test="${not empty students}">
            <table>
                <thead>
                <tr>
                    <c:set var="nextOrder" value="${(sortBy != null && order == 'asc') ? 'desc' : 'asc'}" />
                    <th>
                        <a href="student?action=sort&sortBy=id&order=${sortBy == 'id' ? nextOrder : 'asc'}">
                            ID
                            <c:if test="${sortBy == 'id'}"><span class="sort-indicator">${order == 'asc' ? '▲' : '▼'}</span></c:if>
                        </a>
                    </th>
                    <th>
                        <a href="student?action=sort&sortBy=student_code&order=${sortBy == 'student_code' ? nextOrder : 'asc'}">
                            Student Code
                            <c:if test="${sortBy == 'student_code'}"><span class="sort-indicator">${order == 'asc' ? '▲' : '▼'}</span></c:if>
                        </a>
                    </th>
                    <th>
                        <a href="student?action=sort&sortBy=full_name&order=${sortBy == 'full_name' ? nextOrder : 'asc'}">
                            Full Name
                            <c:if test="${sortBy == 'full_name'}"><span class="sort-indicator">${order == 'asc' ? '▲' : '▼'}</span></c:if>
                        </a>
                    </th>
                    <th>
                        <a href="student?action=sort&sortBy=email&order=${sortBy == 'email' ? nextOrder : 'asc'}">
                            Email
                            <c:if test="${sortBy == 'email'}"><span class="sort-indicator">${order == 'asc' ? '▲' : '▼'}</span></c:if>
                        </a>
                    </th>
                    <th>
                        <a href="student?action=sort&sortBy=major&order=${sortBy == 'major' ? nextOrder : 'asc'}">
                            Major
                            <c:if test="${sortBy == 'major'}"><span class="sort-indicator">${order == 'asc' ? '▲' : '▼'}</span></c:if>
                        </a>
                    </th>
                    <!-- In table header -->
                    <c:if test="${sessionScope.role eq 'admin'}">
                        <th>Actions</th>
                    </c:if>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="student" items="${students}">
                    <tr>
                        <td>${student.id}</td>
                        <td><strong>${student.studentCode}</strong></td>
                        <td>${student.fullName}</td>
                        <td>${student.email}</td>
                        <td>${student.major}</td>
                        <!-- In table rows -->
                        <c:if test="${sessionScope.role eq 'admin'}">
                            <td>
                                <div class="actions">
                                    <a href="student?action=edit&id=${student.id}" class="btn btn-secondary">✏️ Edit</a>
                                    <a href="student?action=delete&id=${student.id}" class="btn btn-danger" onclick="return confirm('Are you sure?')">🗑️ Delete</a>
                                </div>
                            </td>
                        </c:if>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <c:if test="${totalPages > 1}">
                <div class="pagination-container">
                    <div class="page-info">
                        Showing page <strong>${currentPage}</strong> of <strong>${totalPages}</strong>
                    </div>

                    <div class="pagination">
                        <c:choose>
                            <c:when test="${currentPage > 1}">
                                <a href="student?action=list&page=${currentPage - 1}">« Previous</a>
                            </c:when>
                            <c:otherwise>
                                <span class="disabled">« Previous</span>
                            </c:otherwise>
                        </c:choose>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="student?action=list&page=${i}" class="${i == currentPage ? 'active' : ''}">${i}</a>
                        </c:forEach>

                        <c:choose>
                            <c:when test="${currentPage < totalPages}">
                                <a href="student?action=list&page=${currentPage + 1}">Next »</a>
                            </c:when>
                            <c:otherwise>
                                <span class="disabled">Next »</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <div class="empty-state-icon">📭</div>
                <c:choose>
                    <c:when test="${not empty keyword}">
                        <h3>No students found for "<c:out value="${keyword}"/>"</h3>
                        <p>Try searching with a different keyword or clear the search.</p>
                    </c:when>
                    <c:when test="${not empty filterMajor}">
                        <h3>No students found in the major "${filterMajor}"</h3>
                        <p>Try selecting a different major or clearing the filter.</p>
                    </c:when>
                    <c:otherwise>
                        <h3>No students found</h3>
                        <p>Start by adding a new student.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:otherwise>
    </c:choose>
    </div>
</body>
</html>