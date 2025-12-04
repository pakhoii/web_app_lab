package com.example.productmanagement.controller;

import com.example.productmanagement.entity.Product;
import com.example.productmanagement.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/dashboard")
public class DashboardController {

    private final ProductService productService;

    @Autowired
    public DashboardController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping
    public String showDashboard(Model model) {
        // Total products count
        long totalProducts = productService.getAllProducts().size();
        model.addAttribute("totalProducts", totalProducts);

        // Total inventory value
        BigDecimal totalValue = productService.getTotalValue();
        model.addAttribute("totalValue", totalValue != null ? totalValue : BigDecimal.ZERO);

        // Average product price
        BigDecimal avgPrice = productService.getAveragePrice();
        model.addAttribute("avgPrice", avgPrice != null ? avgPrice : BigDecimal.ZERO);

        // Low stock alerts
        List<Product> lowStockProducts = productService.getLowStockProducts(10);
        model.addAttribute("lowStockProducts", lowStockProducts);
        model.addAttribute("lowStockCount", lowStockProducts.size());

        // Recent products (last 5 added)
        List<Product> recentProducts = productService.getAllProducts(
                PageRequest.of(0, 5, Sort.by(Sort.Direction.DESC, "id"))
        ).getContent();
        model.addAttribute("recentProducts", recentProducts);

        // Products by categor
        List<String> categories = productService.getAllCategories();
        Map<String, Long> categoryStats = new HashMap<>();

        if (categories != null) {
            for (String cat : categories) {
                long count = productService.getProductCountByCategory(cat);
                categoryStats.put(cat, count);
            }
        }
        model.addAttribute("categoryStats", categoryStats);

        return "dashboard";
    }
}