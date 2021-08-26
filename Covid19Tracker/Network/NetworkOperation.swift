//
//  NetworkOperation.swift
//  Covid19Tracker
//
//  Created by Chaithra Thalpanaje Shrikrishna on 18/08/21.
//

import Foundation
import Alamofire

typealias CovidSummarySuccessHandler = (CovidSummary) -> Void
typealias CovidSummaryFailureHandler = (NetworkError) -> Void

class BaseOperation {
    var jwtToken: HTTPHeaders? {
        var headers: HTTPHeaders?
        headers = ["Content-Type": "application/json"]
        return headers
    }

    var eventToken: HTTPHeaders? {
        var headers: HTTPHeaders?
        headers = ["Content-Type": "application/json"]
        return headers
    }
}

class NetworkOperation<T>: BaseOperation where T: Codable {
    func performRequest (_ request: URLRequest, completionHandler: @escaping (Alamofire.Result<T>) -> Void) {
        Alamofire.request(request).responseData( completionHandler: { (response) in
            switch response.result {
            case .success(let data) :
                if let statusCode = response.response?.statusCode {
                    if statusCode >= 200, statusCode < 300 {
                        if !data.isEmpty {
                            do {
                                let decoder = JSONDecoder()
                                decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                                    let container = try decoder.singleValueContainer()
                                    let dateStr = try container.decode(String.self)
                                    
                                    let formatter = DateFormatter()
                                    formatter.calendar = Calendar(identifier: .iso8601)
                                    formatter.locale = Locale(identifier: "en_US_POSIX")
                                    formatter.timeZone = TimeZone(secondsFromGMT: 0)
                                    
                                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
                                    if let date = formatter.date(from: dateStr) {
                                        return date
                                    }
                                    
                                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                                    if let date = formatter.date(from: dateStr) {
                                        return date
                                    }
                                    
                                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
                                    if let date = formatter.date(from: dateStr) {
                                        return date
                                    }
                                    
                                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                                    if let date = formatter.date(from: dateStr) {
                                        return date
                                    }
                                    
                                    throw NetworkError.incorrectDataReturned
                                })
                                let dataObject = try decoder.decode(T.self, from: data)
                                completionHandler(Alamofire.Result.success(dataObject))

                            } catch let error {
                                print(error)
                                completionHandler(Alamofire.Result.failure(NetworkError.incorrectDataReturned))
                            }
                        } else {
                            completionHandler(Alamofire.Result.success(true as! T))
                        }
                    } else {
                        completionHandler(Alamofire.Result.failure(NetworkError.custom(message: "\(statusCode)")))
                    }
                }
            case .failure(let error) :
                print(error)
                completionHandler(Alamofire.Result.failure(error))
            }
        })
    }
}
extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
    
    static let defaultFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
        return formatter
    }()
}
