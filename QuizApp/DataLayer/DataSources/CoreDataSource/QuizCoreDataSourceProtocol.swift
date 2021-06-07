//
//  QuizCoreDataSourceProtocol.swift
//  QuizApp
//
//  Created by Kompjuter on 26/05/2021.
//

protocol QuizCoreDataSourceProtocol {
    
    func fetchQuizFromCoreData(filter: FilterSettings) -> [Quiz]
    func saveNewQuizzes(_ quizzes: [Quiz])
    func deleteQuiz(withId id: Int)
}
