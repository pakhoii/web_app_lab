package com.example.productmanagement.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Path;
import java.nio.file.Paths;

@Configuration
public class MvcConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        Path uploadDir = Paths.get("uploads");
        String uploadPath = uploadDir.toFile().getAbsolutePath();

        // Trên Linux/Ubuntu, Paths.get("uploads") sẽ cho ra đường dẫn tuyệt đối
        // VD: /home/user/project/uploads
        // Ta sử dụng "file:///" và nối với đường dẫn tuyệt đối đã có.
        // Paths.get() trên Linux đã dùng "/" nên không cần thay thế dấu phân cách.
        String fileUri = "file:///" + uploadPath + "/";

        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(fileUri);

        System.out.println("✅ Serving uploaded resources from: " + fileUri);
    }
}