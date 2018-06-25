//
//  DeleteAddressUseCaseMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class DeleteAddressUseCaseMock: DeleteAddressUseCase {
    var isNeedToReturnError = false
    
    override func deleteCustomerAddress(id: String, callback: @escaping ApiCallback<Void>) {
        callback((), isNeedToReturnError ? ShopAppError.content(isNetworkError: false) : nil)
    }
}
