package com.example.productmanagement.repository;

import com.example.productmanagement.entity.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {

    // Spring Data JPA generates implementation automatically!

    // Custom query methods (derived from method names)
    Page<Product> findByCategory(String category, Pageable pageable);

    // List<Product> findByNameContaining(String keyword);
    Page<Product> findByNameContaining(String keyword, Pageable pageable);

    List<Product> findByPriceBetween(BigDecimal minPrice, BigDecimal maxPrice);

    List<Product> findByCategoryOrderByPriceAsc(String category);

    boolean existsByProductCode(String productCode);

    @Query("SELECT p FROM Product p WHERE " +
            "(:name IS NULL OR :name = '' OR " +
            "LOWER(p.name) LIKE LOWER(CONCAT('%', :name, '%'))) AND " +
            "(:category IS NULL OR :category = '' OR p.category = :category) AND " +
            "(:minPrice IS NULL OR p.price >= :minPrice) AND " +
            "(:maxPrice IS NULL OR p.price <= :maxPrice)")
    Page<Product> advanceSearch(@Param("name") String name,
                                 @Param("category") String category,
                                 @Param("minPrice") BigDecimal minPrice,
                                 @Param("maxPrice") BigDecimal maxPrice
                                , Pageable pageable);

    @Query("SELECT DISTINCT p.category FROM Product p ORDER BY p.category")
    List<String> findAllCategories();

    @Query("SELECT COUNT(p) FROM Product p WHERE p.category = :category")
    long countByCategory(@Param("category") String category);

    @Query("SELECT SUM(p.price * p.quantity) FROM Product p")
    BigDecimal calculateTotalValue();

    @Query("SELECT AVG(p.price) FROM Product p")
    BigDecimal calculateAveragePrice();

    @Query("SELECT p FROM Product p WHERE p.quantity < :threshold")
    List<Product> findLowStockProducts(@Param("threshold") int threshold);

    // All basic CRUD methods inherited from JpaRepository:
    // - findAll()
    // - findById(Long id)
    // - save(Product product)
    // - deleteById(Long id)
    // - count()
    // - existsById(Long id)
}
