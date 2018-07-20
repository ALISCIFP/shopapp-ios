//
//  CheckoutAddressListViewModel.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 2/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

class CheckoutAddressListViewModel: BaseAddressListViewModel {
    private var checkoutUseCase: CheckoutUseCase
    
    var didSelectBillingAddress = PublishSubject<Address>()
    var checkoutId: String!

    init(customerUseCase: CustomerUseCase, updateDefaultAddressUseCase: UpdateDefaultAddressUseCase, deleteAddressUseCase: DeleteAddressUseCase, checkoutUseCase: CheckoutUseCase) {
        self.checkoutUseCase = checkoutUseCase
        super.init(customerUseCase: customerUseCase, updateDefaultAddressUseCase: updateDefaultAddressUseCase, deleteAddressUseCase: deleteAddressUseCase)
    }

    override func processDeleteAddressResponse(with isSelected: Bool, type: AddressListType) {
        if isSelected, let defaultAddress = customerDefaultAddress.value {
            setDefaultAddress(with: defaultAddress, type: type)
        } else {
            loadCustomerAddresses(isTranslucentHud: true)
        }
    }
    
    func updateCheckoutShippingAddress(with address: Address) {
        state.onNext(ViewState.make.loading())
        checkoutUseCase.setShippingAddress(checkoutId: checkoutId, address: address) { [weak self] (_, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else {
                strongSelf.selectedAddress = address
                strongSelf.didSelectAddress.onNext(address)
                strongSelf.loadCustomerAddresses(isTranslucentHud: true)
            }
        }
    }
    
    private func setDefaultAddress(with address: Address, type: AddressListType) {
        if type == .shipping {
            updateCheckoutShippingAddress(with: address)
        } else {
            didSelectBillingAddress.onNext(address)
            loadCustomerAddresses(isTranslucentHud: true)
        }
    }
}
