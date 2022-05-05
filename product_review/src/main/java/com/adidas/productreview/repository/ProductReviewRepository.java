package com.adidas.productreview.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.adidas.productreview.dto.ProductReview;

@Repository
public interface ProductReviewRepository extends CrudRepository<ProductReview, String> {

}
