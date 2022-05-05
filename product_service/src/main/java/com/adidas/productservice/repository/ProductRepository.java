package com.adidas.productservice.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.adidas.productservice.dto.Product;

@Repository
public interface ProductRepository extends CrudRepository<Product, String> {

}
