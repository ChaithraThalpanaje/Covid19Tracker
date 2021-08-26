//
//  ViewController.swift
//  Covid19Tracker
//
//  Created by Chaithra Thalpanaje Shrikrishna on 18/08/21.
//

import UIKit

class ViewController: UIViewController, Alertable {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
            let covidCoordinator = CovidSummarySceneCoordinator()
            CovidSummarysSceneCompositor.compositeCovidSummary(coordinator: covidCoordinator)
            covidCoordinator.baseVC!.modalPresentationStyle    =   .fullScreen
            self.show(covidCoordinator.baseVC!, sender: self)
        }
    }
    
}

