//
//  ShopAppProductRepository.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

public class ShopAppProductRepository: ProductRepository {
    private let api: API
    
    init(api: API) {
        self.api = api
    }
    
    public func getProducts(perPage: Int, paginationValue: Any?, sortBy: SortType?, keyword: String?, excludeKeyword: String?, callback: @escaping ApiCallback<[Product]>) {
        api.getProducts(perPage: perPage, paginationValue: paginationValue, sortBy: sortBy, keyword: keyword, excludeKeyword: excludeKeyword, callback: callback)
    }
    
    public func getProduct(id: String, callback: @escaping ApiCallback<Product>) {
        api.getProduct(id: id, callback: callback)
    }
    
    public func searchProducts(perPage: Int, paginationValue: Any?, query: String, callback: @escaping ApiCallback<[Product]>) {
        api.searchProducts(perPage: perPage, paginationValue: paginationValue, query: query, callback: callback)
    }
    
    public func getProductVariants(ids: [String], callback: @escaping ApiCallback<[ProductVariant]>) {
        api.getProductVariants(ids: ids, callback: callback)
    }
}
