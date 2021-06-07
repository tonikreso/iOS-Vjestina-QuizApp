//
//  NetworkDataSource.swift
//  QuizApp
//
//  Created by Kompjuter on 29/05/2021.
//

class QuizNetworkDataSource: QuizNetworkDataSourceProtocol {
    
    func fetchQuizzesFromNetwork() -> [Quiz] {
        return NetworkService.singletonNetworkService.getQuizzes()
    }
}
