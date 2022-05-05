package com.adidas.productservice.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonProperty.Access;

public class ProductReview {

  @JsonProperty(access = Access.WRITE_ONLY)
  private String productId;
  private float averageReviewScore;
  private int numberOfReviews;

  public ProductReview() {
  }

  public ProductReview(String productId, float averageReviewScore, int numberOfReviews) {
    this.productId = productId;
    this.averageReviewScore = averageReviewScore;
    this.numberOfReviews = numberOfReviews;
  }

  public String getProductId() {
    return productId;
  }

  public void setProductId(String productId) {
    this.productId = productId;
  }

  public float getAverageReviewScore() {
    return averageReviewScore;
  }

  public void setAverageReviewScore(float averageReviewScore) {
    this.averageReviewScore = averageReviewScore;
  }

  public int getNumberOfReviews() {
    return numberOfReviews;
  }

  public void setNumberOfReviews(int numberOfReviews) {
    this.numberOfReviews = numberOfReviews;
  }
}
