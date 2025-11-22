package com.student.controller;

import com.student.dao.StudentDAO;
import com.student.model.Student;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/student")
public class StudentController extends HttpServlet {

    private StudentDAO studentDAO;

    @Override
    public void init() {
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

//        System.out.println(action);

        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteStudent(request, response);
                break;
            case "search":
                searchStudents(request, response);
            case "sort":
                sortStudents(request, response);
                break;
            case "filter":
                filterStudents(request, response);
                break;
            default:
                listStudents(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        switch (action) {
            case "insert":
                insertStudent(request, response);
                break;
            case "update":
                updateStudent(request, response);
                break;
        }
    }

    // List all students
    private void listStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Define records per page
        int recordsPerPage = 10;

        // Get the current page number from the request parameter
        int currentPage = 1; // Default to page 1
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                // If the parameter is not a valid number, default to page 1
                currentPage = 1;
            }
        }

        // Get total records to calculate total pages
        int totalRecords = studentDAO.getTotalStudents();
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        // Handle edge cases for page numbers
        // Ensure currentPage is not less than 1
        if (currentPage < 1) {
            currentPage = 1;
        }
        // Ensure currentPage does not exceed totalPages (if there are any pages)
        if (totalPages > 0 && currentPage > totalPages) {
            currentPage = totalPages;
        }

        // Calculate the offset for the SQL query
        // The offset is the starting index for the records on the current page
        int offset = (currentPage - 1) * recordsPerPage;

        // Get the paginated list of students from the DAO
        List<Student> students = studentDAO.getStudentsPaginated(offset, recordsPerPage);

        // Set all necessary attributes for the view (JSP)
        request.setAttribute("students", students);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        // Forward the request to the view
        RequestDispatcher dispatcher = request.getRequestDispatcher("./views/student-list.jsp");
        dispatcher.forward(request, response);
    }

    // Show form for new student
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
        dispatcher.forward(request, response);
    }

    // Show form for editing student
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Student existingStudent = studentDAO.getStudentById(id);

        request.setAttribute("student", existingStudent);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
        dispatcher.forward(request, response);
    }

    // Insert new student
    private void insertStudent(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String studentCode = request.getParameter("studentCode");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");

        Student newStudent = new Student(studentCode, fullName, email, major);

        if (!validateStudent(newStudent, request)) {
            request.setAttribute("student", newStudent);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
            dispatcher. forward(request, response);
            return;
        }

        if (studentDAO.addStudent(newStudent)) {
            response.sendRedirect("student?action=list&message=Student added successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to add student");
        }
    }

    // Update student
    private void updateStudent(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        int id = Integer.parseInt(request.getParameter("id"));
        String studentCode = request.getParameter("studentCode");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");

        Student student = new Student(studentCode, fullName, email, major);
        student.setId(id);

        if (!validateStudent(student, request)) {
            request.setAttribute("student", student);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
            dispatcher.forward(request, response);
            return;
        }

        if (studentDAO.updateStudent(student)) {
            response.sendRedirect("student?action=list&message=Student updated successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to update student");
        }
    }

    // Delete student
    private void deleteStudent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        if (studentDAO.deleteStudent(id)) {
            response.sendRedirect("student?action=list&message=Student deleted successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to delete student");
        }
    }

    private void searchStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Student> students;

        if (keyword != null && !keyword.trim().isEmpty()) {
            students = studentDAO.searchStudents(keyword);
        } else {
            students = studentDAO.getAllStudents();
        }

        // Set both students list and keyword as request attributes
        // 'students' is for displaying the results
        // 'keyword' is to keep the search term in the search box on the JSP page
        request.setAttribute("students", students);
        request.setAttribute("keyword", keyword);

        RequestDispatcher dispatcher = request.getRequestDispatcher("./views/student-list.jsp");
        dispatcher.forward(request, response);
    }

    private boolean validateStudent(Student student, HttpServletRequest request) {
        boolean isValid = true;

        String codePattern = "[A-Z]{2}[0-9]{3,}";
        String emailPattern = "^[A-Za-z0-9+_.-]+@(.+)$";

        // Validate Student Code
        if (student.getStudentCode() == null || student.getStudentCode().trim().isEmpty()) {
            request.setAttribute("errorCode", "Student code is required");
            isValid = false;
        } else if (!student.getStudentCode().trim().matches(codePattern)) {
            request.setAttribute("errorCode", "Invalid format. Use 2 uppercase letters + 3+ digits (e.g., SV001)");
            isValid = false;
        }

        // Validate Full Name
        if (student.getFullName() == null || student.getFullName().trim().isEmpty()) {
            request.setAttribute("errorName", "Full name is required");
            isValid = false;
        } else if (student.getFullName().trim().length() < 2) {
            request.setAttribute("errorName", "Full name must be at least 2 characters long");
            isValid = false;
        }

        // Validate Email (only if it's not empty)
        String email = student.getEmail();
        if (email != null && !email.trim().isEmpty()) {
            if (!email.trim().matches(emailPattern)) {
                request.setAttribute("errorEmail", "Please enter a valid email address");
                isValid = false;
            }
        }

        // Validate Major
        if (student.getMajor() == null || student.getMajor().trim().isEmpty()) {
            request.setAttribute("errorMajor", "Major is required");
            isValid = false;
        }

        return isValid;
    }

    private void sortStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get sort parameters from the request
        String sortBy = request.getParameter("sortBy");
        String order = request.getParameter("order");

        // Call the DAO method to get the sorted list
        List<Student> students = studentDAO.getStudentsSorted(sortBy, order);

        // Set attributes for the view
        // 'students' for the table data
        // 'sortBy' and 'order' to help the view indicate the current sort state
        request.setAttribute("students", students);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("order", order);

        // Forward to the list view
        RequestDispatcher dispatcher = request.getRequestDispatcher("./views/student-list.jsp");
        dispatcher.forward(request, response);
    }

    private void filterStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get filter parameter from the request
        String major = request.getParameter("filterMajor");
        List<Student> students;

        // Decide which DAO method to call
        // If major is null or empty, it means "All Majors" was selected
        if (major != null && !major.isEmpty()) {
            students = studentDAO.getStudentsByMajor(major);
        } else {
            // If no major is selected, get all students
            students = studentDAO.getAllStudents();
        }

        // Set attributes for the view
        // 'students' for the table data
        // 'filterMajor' to keep the dropdown selected on the chosen major
        request.setAttribute("students", students);
        request.setAttribute("filterMajor", major);

        // Forward to the list view
        RequestDispatcher dispatcher = request.getRequestDispatcher("./views/student-list.jsp");
        dispatcher.forward(request, response);
    }
}
