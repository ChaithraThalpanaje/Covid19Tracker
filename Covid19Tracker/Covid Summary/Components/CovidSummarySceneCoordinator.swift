//
//  CovidSummarySceneCoordinator.swift
//  Covid19Tracker
//
//  Created by Chaithra Thalpanaje Shrikrishna on 19/08/21.
//

import Foundation
import UIKit
class CovidSummarySceneCoordinator: CovidSummarySceneCoordinatorProtocol {
    var baseVC: UIViewController?
    
    func showCovidSummary(covidSummary: Countries) {
        let detailsCoordinator = CountryDetailsSceneCoordinator()
        CountryDetailsSceneCompositor.composite(countryDetailsSceneCoordinator: detailsCoordinator, countryObject: covidSummary)
        detailsCoordinator.baseVC!.modalPresentationStyle = .fullScreen
        (self.baseVC as! UINavigationController).pushViewController(detailsCoordinator.baseVC!, animated: true)
    }
}
