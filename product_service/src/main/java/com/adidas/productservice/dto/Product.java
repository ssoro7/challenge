package com.adidas.productservice.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

import javax.persistence.Entity;
import javax.persistence.Id;

@JsonInclude(Include.NON_NULL)
@Entity
public class Product {
  @Id
  private String id;
  private String name;
  private String modelNumber;
  private String description;

  public Product() {
  }

  public Product(String id, String name, String modelNumber, String description) {
    this.id = id;
    this.name = name;
    this.modelNumber = modelNumber;
    this.description = description;
  }

  public String getId() {
    return id;
  }

  public void setId(String id) {
    this.id = id;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getModelNumber() {
    return modelNumber;
  }

  public void setModelNumber(String modelNumber) {
    this.modelNumber = modelNumber;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }
}