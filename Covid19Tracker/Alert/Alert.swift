//
//  Alert.swift
//  Covid19Tracker
//
//  Created by Chaithra Thalpanaje Shrikrishna on 19/08/21.
//

import Foundation
import UIKit
protocol Alertable { }
extension Alertable where Self: UIViewController {
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in }
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
            self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showAlertWithSettings(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in }
        alertController.addAction(okAction)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        alertController.addAction(settingsAction)
        
        DispatchQueue.main.async {
            self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
}
