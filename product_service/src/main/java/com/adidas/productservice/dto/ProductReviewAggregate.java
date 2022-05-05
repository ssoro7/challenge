package com.adidas.productservice.dto;

public class ProductReviewAggregate {

  private Product product;
  private ProductReview review;

  public ProductReviewAggregate(Product product, ProductReview review) {
    this.product = product;
    this.review = review;
  }

  public Product getProduct() {
    return product;
  }

  public void setProduct(Product product) {
    this.product = product;
  }

  public ProductReview getReview() {
    return review;
  }

  public void setReview(ProductReview review) {
    this.review = review;
  }
}
