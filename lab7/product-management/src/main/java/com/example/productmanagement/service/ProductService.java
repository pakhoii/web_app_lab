package com.example.productmanagement.service;

import com.example.productmanagement.entity.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.ui.Model;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

public interface ProductService {

    Page<Product> getAllProducts(Pageable pageable);

    List<Product> getAllProducts();

    Optional<Product> getProductById(Long id);

    Product saveProduct(Product product);

    void deleteProduct(Long id);

    Page<Product> searchProducts(String category, Pageable pageable);


    Page<Product> getProductsByCategory(String category, Pageable pageable);

    Page<Product> advanceSearch(String name, String category, java.math.BigDecimal minPrice, java.math.BigDecimal maxPrice, Pageable pageable);

    List<String> getAllCategories();

    BigDecimal getTotalValue();

    long getProductCountByCategory(String category);

    BigDecimal getAveragePrice();

    List<Product> getLowStockProducts(int threshold);

    void addRouteAttributes(Model model, String baseUrl);
}
