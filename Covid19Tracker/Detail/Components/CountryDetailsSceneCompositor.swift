//
//  CountryDetailsSceneCompositor.swift
//  Covid19Tracker
//
//  Created by Chaithra Thalpanaje Shrikrishna on 19/08/21.
//

import Foundation

struct CountryDetailsSceneCompositor {
    static func composite(countryDetailsSceneCoordinator: CountryDetailsSceneCoordinatorProtocol, countryObject: Countries?) {
        // - components
        let countryDetailsVC = CountryDetailsViewController.viewController()
        let viewModel = CountryDetailsViewModel(coordinator: countryDetailsSceneCoordinator, baseVC: countryDetailsVC)
        viewModel.countryObject = countryObject
        // - composite view controller
        countryDetailsVC.viewModel = viewModel
        
        // - composite coordinator
        countryDetailsSceneCoordinator.baseVC = countryDetailsVC
    }
}
