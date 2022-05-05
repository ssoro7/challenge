package com.adidas.productservice.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import com.adidas.productservice.dto.ProductReviewAggregate;
import com.adidas.productservice.service.ProductService;

@RestController
public class ProductController {

  private static final Logger LOG = LoggerFactory.getLogger("ProductController");
  private ProductService service;

  public ProductController(ProductService service) {
    this.service = service;
  }

  @GetMapping("/product/{productId}")
  public ProductReviewAggregate getProductWithReview(@PathVariable String productId) {
    LOG.info("Handle request for product {}", productId);
    return service.getProductWithReview(productId);
  }
}
