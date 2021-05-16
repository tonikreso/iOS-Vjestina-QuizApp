//
//  RequestError.swift
//  QuizApp
//
//  Created by Kompjuter on 15/05/2021.
//

import Foundation


enum RequestError: Error {
    case clientError
    case serverError
    case noData
    case dataEncodingError
}
