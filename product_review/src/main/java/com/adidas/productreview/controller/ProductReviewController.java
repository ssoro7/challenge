package com.adidas.productreview.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


import com.adidas.productreview.dto.ProductReview;
import com.adidas.productreview.service.ProductReviewService;

@RestController
@RequestMapping("/review")
public class ProductReviewController {

  private static final Logger LOG = LoggerFactory.getLogger("ProductReviewController");
	private ProductReviewService service;
	
	public ProductReviewController(ProductReviewService service) {
		this.service = service;
	}
	
	@GetMapping("/{productId}")
	public ProductReview get(@PathVariable String productId) {
    LOG.info("Handle review request for product {}", productId);
    return service.get(productId);
	}
}
