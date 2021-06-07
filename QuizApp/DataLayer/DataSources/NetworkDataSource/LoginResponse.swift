//
//  LoginResponse.swift
//  QuizApp
//
//  Created by Kompjuter on 16/05/2021.
//

import Foundation

struct LoginResponse: Codable {
    let token: String
    let id: Int
    
    enum CodingKeys: String, CodingKey{
        case token
        case id = "user_id"
    }
}
