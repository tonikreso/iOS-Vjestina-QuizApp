//
//  QuizDataRepository.swift
//  QuizApp
//
//  Created by Kompjuter on 29/05/2021.
//

class QuizDataRepository: QuizRepositoryProtocol {
    
    private let networkDataSource: QuizNetworkDataSourceProtocol
    private let coreDataSource: QuizCoreDataSourceProtocol
    
    init(networkDataSource: QuizNetworkDataSourceProtocol, coreDataSource: QuizCoreDataSourceProtocol) {
        self.networkDataSource = networkDataSource
        self.coreDataSource = coreDataSource
    }
    
    func fetchRemoteData() throws {
        let quizzes = networkDataSource.fetchQuizzesFromNetwork()
        coreDataSource.saveNewQuizzes(quizzes)
    }
    
    func fetchLocalData(filter: FilterSettings) -> [Quiz] {
        coreDataSource.fetchQuizFromCoreData(filter: filter)
    }
    
    func deleteLocalData(withId id: Int) {
        coreDataSource.deleteQuiz(withId: id)
    }
}
