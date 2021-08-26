//
//  CovidSummaryViewModel.swift
//  Covid19Tracker
//
//  Created by Chaithra Thalpanaje Shrikrishna on 19/08/21.
//

import Foundation
import UIKit

protocol SceneCoordinatorProtocol: AnyObject {
    var baseVC: UIViewController? { get set }
}
protocol CovidSummarySceneCoordinatorProtocol: SceneCoordinatorProtocol {
    func showCovidSummary(covidSummary: Countries)
}
class CovidSummaryViewModel: CovidSummaryViewModelProtocol {

    var coordinator: CovidSummarySceneCoordinatorProtocol

    init(coordinator: CovidSummarySceneCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    func showCovidSummary(covidSummary: Countries) {
        coordinator.showCovidSummary(covidSummary: covidSummary)
    }
}
