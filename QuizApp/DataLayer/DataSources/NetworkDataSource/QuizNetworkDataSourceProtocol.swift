//
//  NetworkDataSourceProtocol.swift
//  QuizApp
//
//  Created by Kompjuter on 29/05/2021.
//

protocol QuizNetworkDataSourceProtocol {
    
    func fetchQuizzesFromNetwork() -> [Quiz]
    
}
