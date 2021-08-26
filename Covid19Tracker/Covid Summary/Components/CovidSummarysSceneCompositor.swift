//
//  CovidSummarysSceneCompositor.swift
//  Covid19Tracker
//
//  Created by Chaithra Thalpanaje Shrikrishna on 18/08/21.
//


import Foundation
import UIKit
struct CovidSummarysSceneCompositor {

    static func compositeCovidSummary(coordinator: CovidSummarySceneCoordinatorProtocol) {
        // - components
        let favVC = CovidSummaryViewController.viewController()
        let favVM = CovidSummaryViewModel(coordinator: coordinator)
        favVM.coordinator = coordinator
        favVC.viewModel = favVM
        coordinator.baseVC = UINavigationController.init(rootViewController: favVC)

    }
}
