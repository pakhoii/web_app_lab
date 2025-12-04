package com.example.productmanagement.controller;

import com.example.productmanagement.entity.Product;
import com.example.productmanagement.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import jakarta.validation.Valid;
import org.springframework.validation.BindingResult;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import org.springframework.web.multipart.MultipartFile;
import java.util.UUID;

import java.math.BigDecimal;
import java.util.List;

@Controller
@RequestMapping("/products")
public class ProductController {

    private final ProductService productService;
    private static final String UPLOAD_DIR = "uploads/";

    @Autowired
    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    // Helper method to add common attributes like categories
    private void addCommonAttributes(Model model) {
        List<String> categories = productService.getAllCategories();
        model.addAttribute("categories", categories);
    }

    @GetMapping
    public String listProducts(@RequestParam(value = "category", required = false) String category,
                               @RequestParam(defaultValue = "0") int page,
                               @RequestParam(defaultValue = "10") int size,
                               @RequestParam(required = false) String sortBy,
                               @RequestParam(defaultValue = "asc") String sortDir,
                               Model model) {
        Page<Product> products;
        Pageable pageable;

        if (sortBy != null) {
            Sort sort = sortDir.equals("asc") ? Sort.by(sortBy).ascending() : Sort.by(sortBy).descending();
            pageable = PageRequest.of(page, size, sort);
        } else {
            pageable = PageRequest.of(page, size);
        }

        if (category == null || category.isEmpty()) {
            products = productService.getAllProducts(pageable);
        } else {
            products = productService.getProductsByCategory(category, pageable);
        }

        // Add attributes
        model.addAttribute("products", products);
        model.addAttribute("selectedCategory", category);
        model.addAttribute("baseUrl", "/products");
        model.addAttribute("sortBy", sortBy);
        model.addAttribute("sortDir", sortDir);

        addCommonAttributes(model);

        return "product-list";
    }

    @GetMapping("/advanced-search")
    public String advancedSearch(
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) BigDecimal minPrice,
            @RequestParam(required = false) BigDecimal maxPrice,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String sortBy,
            @RequestParam(defaultValue = "asc") String sortDir,
            Model model) {

        Pageable pageable;

        if (sortBy != null) {
            Sort sort = sortDir.equals("asc") ? Sort.by(sortBy).ascending() : Sort.by(sortBy).descending();
            pageable = PageRequest.of(page, size, sort);
        } else {
            pageable = PageRequest.of(page, size);
        }

        Page<Product> products = productService.advanceSearch(name, category, minPrice, maxPrice, pageable);

        model.addAttribute("products", products);
        model.addAttribute("name", name);
        model.addAttribute("selectedCategory", category);
        model.addAttribute("minPrice", minPrice);
        model.addAttribute("maxPrice", maxPrice);
        model.addAttribute("sortBy", sortBy);
        model.addAttribute("sortDir", sortDir);

        model.addAttribute("baseUrl", "/products/advanced-search");

        addCommonAttributes(model);

        return "product-list";
    }

    @GetMapping("/search")
    public String searchProducts(@RequestParam("keyword") String keyword,
                                 @RequestParam(defaultValue = "0") int page,
                                 @RequestParam(defaultValue = "10") int size,
                                 @RequestParam(required = false) String sortBy,
                                 @RequestParam(defaultValue = "asc") String sortDir,
                                 Model model) {

        Pageable pageable;

        if (sortBy != null) {
            Sort sort = sortDir.equals("asc") ? Sort.by(sortBy).ascending() : Sort.by(sortBy).descending();
            pageable = PageRequest.of(page, size, sort);
        } else {
            pageable = PageRequest.of(page, size);
        }

        Page<Product> products = productService.searchProducts(keyword, pageable);

        model.addAttribute("products", products);
        model.addAttribute("keyword", keyword);
        model.addAttribute("baseUrl", "/products/search");
        model.addAttribute("sortBy", sortBy);
        model.addAttribute("sortDir", sortDir);

        addCommonAttributes(model);

        return "product-list";
    }

    @GetMapping("/new")
    public String showNewForm(Model model) {
        Product product = new Product();
        model.addAttribute("product", product);
        return "product-form";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id,
                               @RequestParam(value = "source", required = false) String source, // THÊM: Nhận biết trang nguồn
                               Model model,
                               RedirectAttributes redirectAttributes) {
        return productService.getProductById(id)
                .map(product -> {
                    model.addAttribute("product", product);
                    String returnPath = (source != null && source.equals("dashboard")) ? "/dashboard" : "/products";
                    model.addAttribute("returnPath", returnPath); // THÊM
                    return "product-form";
                })
                .orElseGet(() -> {
                    redirectAttributes.addFlashAttribute("error", "Product not found");
                    return "redirect:/products";
                });
    }

    @PostMapping("/save")
    public String saveProduct(@Valid @ModelAttribute("product") Product product,
                              BindingResult result,
                                @RequestParam("imageFile") MultipartFile imageFile,
                              RedirectAttributes redirectAttributes) {

        if (result.hasErrors()) {
            return "product-form";
        }

        try {
            if (!imageFile.isEmpty()) {
                String filename = saveImage(imageFile, product.getName());
                product.setImagePath(filename);
                System.out.println(product.getImagePath());
            } else if (product.getId() == null) {
                product.setImagePath("default.jpg");
            }

            productService.saveProduct(product);
            redirectAttributes.addFlashAttribute("message",
                    product.getId() == null ? "Product added successfully!" : "Product updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error saving product: " + e.getMessage());
        }
        return "redirect:/products";
    }

    @GetMapping("/delete/{id}")
    public String deleteProduct(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            productService.deleteProduct(id);
            redirectAttributes.addFlashAttribute("message", "Product deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error deleting product: " + e.getMessage());
        }
        return "redirect:/products";
    }

    private String saveImage(MultipartFile file, String name) throws IOException {
        Path uploadPath = Paths.get(UPLOAD_DIR);

        // Create the directory if it doesn't exist
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        // Sanitize the product name to be safe for filenames (remove spaces/special chars)
        String safeName = name.replaceAll("[^a-zA-Z0-9.\\-]", "_");
        String originalFileName = file.getOriginalFilename();
        String fileExtension = "";
        int dotIndex = originalFileName.lastIndexOf(".");
        if (dotIndex > 0) {
            fileExtension = originalFileName.substring(dotIndex);
        }
        String fileName = safeName + "_" + UUID.randomUUID().toString() + fileExtension;

        // Save the file
        Path filePath = uploadPath.resolve(fileName);

        // Use StandardCopyOption.REPLACE_EXISTING to avoid errors if file exists
        Files.copy(file.getInputStream(), filePath, java.nio.file.StandardCopyOption.REPLACE_EXISTING);
        System.out.println("File saved to: " + filePath.toString());
        return fileName;
    }
}