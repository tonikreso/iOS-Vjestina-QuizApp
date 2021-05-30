//
//  Result.swift
//  QuizApp
//
//  Created by Kompjuter on 15/05/2021.
//

import Foundation

enum Result<Success, Failure> where Failure : Error {
    case sucess(Success)
    case failure(Failure)
}
