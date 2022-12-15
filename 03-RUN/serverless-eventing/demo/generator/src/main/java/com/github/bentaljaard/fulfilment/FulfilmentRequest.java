package com.github.bentaljaard.fulfilment;

import javax.inject.Inject;

import net.datafaker.Faker;

public class FulfilmentRequest {
    
    @Override
    public String toString() {
        return "FulfilmentRequest [id=" + id + ", fulfilmentCenter=" + fulfilmentCenter + ", productCode=" + productCode
                + ", description=" + description + ", quantity=" + quantity + ", customer=" + customer + ", address="
                + address + "]";
    }
    public FulfilmentRequest(String id, String fulfilmentCenter, String productCode, String description, int quantity,
            String customer, String address) {
        this.id = id;
        this.fulfilmentCenter = fulfilmentCenter;
        this.productCode = productCode;
        this.description = description;
        this.quantity = quantity;
        this.customer = customer;
        this.address = address;
    }
    private String id;
    private String fulfilmentCenter;
    private String productCode;
    private String description;
    private int quantity;
    private String customer;
    private String address;
    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }
    public String getFulfilmentCenter() {
        return fulfilmentCenter;
    }
    public void setFulfilmentCenter(String fulfilmentCenter) {
        this.fulfilmentCenter = fulfilmentCenter;
    }
    public String getProductCode() {
        return productCode;
    }
    public void setProductCode(String productCode) {
        this.productCode = productCode;
    }
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }
    public int getQuantity() {
        return quantity;
    }
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    public String getCustomer() {
        return customer;
    }
    public void setCustomer(String customer) {
        this.customer = customer;
    }
    public String getAddress() {
        return address;
    }
    public void setAddress(String address) {
        this.address = address;
    }

    

}
