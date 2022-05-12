package com.adidas.productservice.client;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import java.util.Optional;

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

        ProductReview review = new ProductReview(productId, 0, 0);
        //check for null response
        if (response.getBody() != null) {
          review = response.getBody();
        }
        else {
          LOG.warn("Null product review response");
        }
        return review;
    } 
    catch (final RestClientException restClientException) {
      LOG.error("{} when calling Product Review Service, the service is down", restClientException.getMessage());
      return new ProductReview(productId, 0, 0);
    }
    catch (final Exception exception) {
        LOG.error("{} Critical exception calling Product Review Service", exception.getMessage());
        return new ProductReview(productId, 0, 0);
    }
  }
}
