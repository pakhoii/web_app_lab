package com.example.productmanagement.controller;

import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.io.IOException;

@Controller
@RequestMapping("/export")
public class ExportController {

    @GetMapping("/excel")
    public void exportToExcel(HttpServletResponse response) throws IOException {
        // Create Excel workbook
        // Write data
        // Send to browser

    }
}