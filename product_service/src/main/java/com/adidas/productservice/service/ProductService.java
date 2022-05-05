package com.adidas.productservice.service;

import org.springframework.stereotype.Service;
import javax.persistence.EntityNotFoundException;
import com.adidas.productservice.client.ProductReviewClient;
import com.adidas.productservice.dto.Product;
import com.adidas.productservice.dto.ProductReview;
import com.adidas.productservice.dto.ProductReviewAggregate;
import com.adidas.productservice.repository.ProductRepository;

@Service
public class ProductService {

  private ProductRepository repository;
  private ProductReviewClient productReviewClient;

  public ProductService(final ProductReviewClient productReviewClient, final ProductRepository repository) {
    this.productReviewClient = productReviewClient;
    this.repository = repository;
  }

  public ProductReviewAggregate getProductWithReview(final String productId) {
    final Product product = getProduct(productId);
    final ProductReview productReview = productReviewClient.getProductReview(productId);
    return new ProductReviewAggregate(product, productReview);
  }

  private Product getProduct(final String productId) {
    return repository.findById(productId).orElseThrow(() -> new EntityNotFoundException());
  }
}
