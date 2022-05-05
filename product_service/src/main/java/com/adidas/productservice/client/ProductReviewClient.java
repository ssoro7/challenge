package com.adidas.productservice.client;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import com.adidas.productservice.dto.ProductReview;

@Component
public class ProductReviewClient {

  private static final Logger LOG = LoggerFactory.getLogger("ProductReviewClient");
  private RestTemplate restTemplate;
  private String productReviewServiceUrl;

  public ProductReviewClient(RestTemplate restTemplate, @Value("${product-review-service.url}") String url) {
    this.restTemplate = restTemplate;
    this.productReviewServiceUrl = url + "/review/{productId}";
  }

  public ProductReview getProductReview(final String productId) {
    try {
        LOG.info("Get review for product {}", productId);
        final ResponseEntity<ProductReview> response = restTemplate.exchange(
            productReviewServiceUrl, HttpMethod.GET, null, ProductReview.class, productId);
        LOG.info("Product Review Service response:{}", response.getStatusCode());
        return response.getBody();
    } catch (final Exception exception) {
        LOG.error("{} when calling Product Review Service", exception.getMessage());
        throw new RuntimeException(exception);
    }
  }
}
