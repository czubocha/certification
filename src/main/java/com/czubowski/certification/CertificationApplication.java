package com.czubowski.certification;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

@SpringBootApplication
public class CertificationApplication {

    public static void main(String[] args) {
        SpringApplication.run(CertificationApplication.class, args);
    }

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurerAdapter() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/greeting").allowedOrigins("http://localhost:4200").allowedOrigins("http://certification-cicd-ALB-1297317549.eu-central-1.elb.amazonaws.com:8080");
            }
        };
    }
}
