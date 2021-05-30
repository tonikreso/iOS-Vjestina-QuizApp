//
//  QuizUseCase.swift
//  QuizApp
//
//  Created by Kompjuter on 29/05/2021.
//

final class QuizUseCase {
    private let quizRepository: QuizRepositoryProtocol
    
    init(quizRepository: QuizRepositoryProtocol) {
        self.quizRepository = quizRepository
    }
    
    func refreshData() throws {
        try quizRepository.fetchRemoteData()
    }
    
    func getQuizzes(filter: FilterSettings) -> [Quiz]{
        quizRepository.fetchLocalData(filter: filter)
    }
    
    func deleteQuiz(withId id: Int) {
        quizRepository.deleteLocalData(withId: id)
    }
}
