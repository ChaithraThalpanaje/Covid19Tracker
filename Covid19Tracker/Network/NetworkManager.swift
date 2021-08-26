//
//  NetworkManager.swift
//  Covid19Tracker
//
//  Created by Chaithra Thalpanaje Shrikrishna on 18/08/21.
//

import Foundation
import Alamofire

public typealias JSON = [String: Any]

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    private func getURLRequestFor(url: String, method: HTTPMethod, params: JSON? = nil) -> URLRequest {
        var request: URLRequest!
        do {
            request =   try URLRequest(url: URL(string: url)!, method: method, headers: BaseOperation().jwtToken)
            if let parameters = params {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                request.httpBody = jsonData
            }
        } catch let error {
            print("Failed to create request due to error \(error)")
        }
        return request
    }
    func fetchCovidSummary (url: String, completionHandler: @escaping (Alamofire.Result<CovidSummary>) -> Void) {
        let request = self.getURLRequestFor(url: url, method: .get)
        let networkOp = NetworkOperation<CovidSummary>()
        networkOp.performRequest(request, completionHandler: completionHandler)
    }
}
