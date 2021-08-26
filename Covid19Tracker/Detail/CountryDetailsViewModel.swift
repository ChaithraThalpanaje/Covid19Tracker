//
//  CountryDetailsViewModel.swift
//  Covid19Tracker
//
//  Created by Chaithra Thalpanaje Shrikrishna on 18/08/21.
//

import Foundation

class CountryDetailsViewModel: CountryDetailsViewModelProtocol {
    var coordinator: CountryDetailsSceneCoordinatorProtocol
    var baseVC: CountryDetailsViewController?
    var countryObject: Countries?
    init(coordinator: CountryDetailsSceneCoordinatorProtocol, baseVC: CountryDetailsViewController) {
        self.coordinator = coordinator
        self.baseVC = baseVC
    }
}
