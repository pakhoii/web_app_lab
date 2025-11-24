package com.student.controller;

import com.student.dao.UserDAO;
import com.student.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/change-password")
public class ChangePasswordController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get user from session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        // Show change password form
        request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: Get current user from session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        User user = (User) session.getAttribute("user");

        // TODO: Get form parameters (currentPassword, newPassword, confirmPassword)
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (currentPassword == null || newPassword == null || confirmPassword == null ||
            currentPassword.trim().isEmpty() || newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required");
            request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
            return;
        }

        // TODO: Validate current password
        String username = user.getUsername();
        User dbUser = userDAO.authenticate(username, currentPassword);

        if (dbUser == null) {
            request.setAttribute("error", "Current password is incorrect");
            request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
            return;
        }

        // TODO: Validate new password (length, match)
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New password and confirm password do not match");
            request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
            return;
        }

        if (currentPassword.equals(newPassword)) {
            request.setAttribute("error", "New password must be different from current password");
            request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
            return;
        }

        // TODO: Hash new password
        // TODO: Update in database
        boolean updated = userDAO.updateUserPassword(user.getId(), newPassword);

        if (updated) {
            request.setAttribute("success", "Password changed successfully");
        } else {
            request.setAttribute("error", "Failed to change password. Please try again.");
        }

        // TODO: Show success/error message
        request.setAttribute("success", "Password changed successfully");
        request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
    }
}
