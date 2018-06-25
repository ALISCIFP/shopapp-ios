//
//  OrderListTableProviderSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class OrderListTableProviderSpec: QuickSpec {
    override func spec() {
        var tableProvider: OrderListTableProvider!
        var tableView: UITableView!
        
        beforeEach {
            tableProvider = OrderListTableProvider()
            tableView = UITableView()
            tableView.registerNibForCell(CheckoutCartTableViewCell.self)
            tableView.dataSource = tableProvider
            tableView.delegate = tableProvider
        }
        
        describe("when provider created") {
            it("should return correct sections count") {
                let sectionsCount = tableProvider.numberOfSections(in: tableView)
                expect(sectionsCount) == 0
            }
            
            it("should return correct rows count") {
                let rowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: 0)
                expect(rowsCount) == 1
            }
            
            it("should return header view") {
                let header = tableProvider.tableView(tableView, viewForHeaderInSection: 0)
                expect(header).to(beNil())
            }
            
            it("should return footer view") {
                let footer = tableProvider.tableView(tableView, viewForFooterInSection: 0)
                expect(footer).to(beNil())
            }
        }
        
        describe("when orders did set") {
            beforeEach {
                let order = TestHelper.orderWithProducts
                tableProvider.orders = [order, order, order]
            }
            
            it("should return correct sections count") {
                let sectionsCount = tableProvider.numberOfSections(in: tableView)
                expect(sectionsCount) == tableProvider.orders.count
            }
            
            it("should return correct header class type") {
                let header = tableProvider.tableView(tableView, viewForHeaderInSection: 0)
                expect(header).to(beAnInstanceOf(OrderHeaderView.self))
            }
            
            it("should return correct footer class type") {
                let footer = tableProvider.tableView(tableView, viewForFooterInSection: 0)
                expect(footer).to(beAnInstanceOf(OrderFooterView.self))
            }
            
            it("should return correct header height") {
                let headerHeight = tableProvider.tableView(tableView, heightForHeaderInSection: 0)
                expect(headerHeight) == kOrderHeaderViewHeight
            }
            
            it("should return correct footer height") {
                let footerHeight = tableProvider.tableView(tableView, heightForFooterInSection: 0)
                expect(footerHeight) == kOrderFooterViewHeight
            }
            
            it("should return correct cell class") {
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)
                expect(cell).to(beAnInstanceOf(CheckoutCartTableViewCell.self))
            }
        }
        
        describe("when order selected") {
            var orders: [Order] = []
            
            beforeEach {
                for _ in 1...2 {
                    orders.append(TestHelper.orderWithProducts)
                }
                tableProvider.orders = orders
            }
            
            it("should select order") {
                let providerDelegateMock = OrderListTableProviderDelegateMock()
                tableProvider.delegate = providerDelegateMock
                
                let header = tableProvider.tableView(tableView, viewForHeaderInSection: 0) as! OrderHeaderView
                header.delegate?.headerView(header, didTapWith: 0)
                expect(providerDelegateMock.selectedOrder) == orders.first
            }
        }
        
        describe("when product variant selected") {
            beforeEach {
                let order = TestHelper.orderWithProducts
                tableProvider.orders = [order, order, order]
            }
            
            it("should select product variant") {
                let providerDelegateMock = OrderListTableProviderDelegateMock()
                tableProvider.delegate = providerDelegateMock
                
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath) as! CheckoutCartTableViewCell
                cell.delegate?.tableViewCell(cell, didSelect: "product variant id", at: 0)
                expect(providerDelegateMock.selectedProductVariantId) == "product variant id"
                expect(providerDelegateMock.selectedIndex) == 0
            }
        }
    }
}
