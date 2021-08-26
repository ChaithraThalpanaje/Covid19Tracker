//
//  NetworkError.swift
//  Covid19Tracker
//
//  Created by Chaithra Thalpanaje Shrikrishna on 18/08/21.
//

import Foundation
public protocol ErrorResponseCodeProtocol {
    var responseCode: Int? { get }
    var isResponseSerializationError: Bool { get }
}

public enum NetworkError: Error, CustomStringConvertible {
    public var description: String {
        return self.localizedDescription
    }
    /// Unknown or not supported error.
    case unknown

    /// Not connected to the internet.
    case notConnectedToInternet

    /// Cannot reach the server.
    case notReachedServer

    /// Service is temporarily unavailable (status code == 503).
    case serviceUnavailable

    /// Incorrect data returned from the server.
    case incorrectDataReturned

    /// Authentication required
    case authenticationRequired

    /// Customer access token is invalid. Somebody logged in on another device.
    case invalidAccessToken

    /// Resource was not recognized
    case notRecognized

    /// Resource not found
    case resourceNotFound

    /// Request was aborted
    case aborted

    case custom(message: String)

    init(error: ErrorResponseCodeProtocol) {
        guard let responseCode = error.responseCode else {
            if error.isResponseSerializationError {
                self = .incorrectDataReturned
            } else {
                self = .unknown
            }
            return
        }

        switch responseCode {
        case 400:
            self = .notRecognized
        case 401:
            self = .authenticationRequired
        case 403:
            self = .invalidAccessToken
        case 404:
            self = .resourceNotFound
        case 500...599:
            self = .serviceUnavailable
        default:
            if error.isResponseSerializationError {
                self = .incorrectDataReturned
            } else {
                self = .unknown
            }
        }
    }
}
