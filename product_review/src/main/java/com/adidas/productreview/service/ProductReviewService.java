package com.adidas.productreview.service;

import javax.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import com.adidas.productreview.dto.ProductReview;
import com.adidas.productreview.repository.ProductReviewRepository;

@Service
public class ProductReviewService {

	private ProductReviewRepository repository;

	public ProductReviewService(ProductReviewRepository repository) {
		this.repository = repository;
	}
	
	public ProductReview get(String productId) {
		return repository.findById(productId).orElseThrow(() -> new EntityNotFoundException(productId));
	}
	

}
