package com.example.productmanagement.service;

import com.example.productmanagement.entity.Product;
import com.example.productmanagement.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class ProductServiceImpl implements ProductService {

    private final ProductRepository productRepository;

    @Autowired
    public ProductServiceImpl(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @Override
    public Page<Product> getAllProducts(Pageable pageable) {
        return productRepository.findAll(pageable);
    }

    @Override
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    @Override
    public Optional<Product> getProductById(Long id) {
        return productRepository.findById(id);
    }

    @Override
    public Product saveProduct(Product product) {
        // Validation logic can go here
        return productRepository.save(product);
    }

    @Override
    public void deleteProduct(Long id) {
        productRepository.deleteById(id);
    }

    @Override
    public Page<Product> searchProducts(String category, Pageable pageable) {
        return productRepository.findByNameContaining(category, pageable);
    }

    @Override
    public Page<Product> getProductsByCategory(String category, Pageable pageable) {
        return productRepository.findByCategory(category, pageable);
    }

    @Override
    public Page<Product> advanceSearch(String name, String category, BigDecimal minPrice, BigDecimal maxPrice, Pageable pageable) {
        return productRepository.advanceSearch(name, category, minPrice, maxPrice, pageable);
    }

    @Override
    public List<String> getAllCategories() {
        return productRepository.findAllCategories();
    }

    @Override
    public BigDecimal getTotalValue() {
        return productRepository.calculateTotalValue();
    }

    @Override
    public long getProductCountByCategory(String category) {
        return productRepository.countByCategory(category);
    }

    @Override
    public BigDecimal getAveragePrice() {
        return productRepository.calculateAveragePrice();
    }

    @Override
    public List<Product> getLowStockProducts(int threshold) {
        return productRepository.findLowStockProducts(threshold);
    }

    @Override
    public void addRouteAttributes(Model model, String baseUrl) {
        model.addAttribute("baseUrl", baseUrl);
    }
}
