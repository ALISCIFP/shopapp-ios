//
//  CartTableProviderSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/7/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class CartTableProviderSpec: QuickSpec {
    override func spec() {
        var tableProvider: CartTableProvider!
        var tableView: UITableView!
        
        beforeEach {
            tableProvider = CartTableProvider()
            tableView = UITableView()
            tableView.registerNibForCell(CartTableViewCell.self)
        }
        
        describe("when provider initialized") {
            it("should have correct initial properties") {
                expect(tableProvider.cartProducts.count) == 0
                expect(tableProvider.totalPrice) == 0
                expect(tableProvider.currency) == ""
            }
            
            it("should return correct rows count") {
                let rowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: 0)
                expect(rowsCount) == 0
            }
            
            it("should return correct header view height") {
                let headerHeight = tableProvider.tableView(tableView, heightForHeaderInSection: 0)
                expect(headerHeight) == tableProvider.cartHeaderViewHeight
            }
            
            it("should return header view") {
                let header = tableProvider.tableView(tableView, viewForHeaderInSection: 0)
                expect(header).to(beAnInstanceOf(CartHeaderView.self))
            }
        }
        
        describe("when data did set") {
            var items: [CartProduct]!
            
            beforeEach {
                items = [TestHelper.cartProductWithQuantityOne]
                tableProvider.cartProducts = items
            }
            
            it("should return correct rows count") {
                let rowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: 0)
                expect(rowsCount) == items.count
            }
            
            it("should return correct cell") {
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)
                expect(cell).to(beAnInstanceOf(CartTableViewCell.self))
            }
            
            it("should return correct header view height") {
                let headerHeight = tableProvider.tableView(tableView, heightForHeaderInSection: 0)
                expect(headerHeight) == tableProvider.cartHeaderViewHeight
            }
            
            it("should return header view") {
                let header = tableProvider.tableView(tableView, viewForHeaderInSection: 0)
                expect(header).to(beAnInstanceOf(CartHeaderView.self))
            }
        }
        
        describe("when product did select") {
            var cartProduct: CartProduct!
            var providerDelegateMock: CartTableProviderDelegateMock!
            
            beforeEach {
                providerDelegateMock = CartTableProviderDelegateMock()
                tableProvider.delegate = providerDelegateMock
            }
            
            context("if product variant contains in cart products") {
                beforeEach {
                    cartProduct = TestHelper.cartProductWithQuantityOne
                    tableProvider.cartProducts = [TestHelper.cartProductWithQuantityOne]
                }
                
                it("should select cart product") {
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableProvider.tableView(tableView, didSelectRowAt: indexPath)
                    
                    expect(providerDelegateMock.selectedProductVariant) == cartProduct.productVariant
                }
            }
            
            context("if product variant doesn't contains in cart products") {
                beforeEach {
                    tableProvider.cartProducts = [TestHelper.cartProductWithoutProductVariant]
                }
                
                it("should not select cart product") {
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableProvider.tableView(tableView, didSelectRowAt: indexPath)
                    
                    expect(providerDelegateMock.selectedProductVariant).to(beNil())
                }
            }
        }
    }
}
