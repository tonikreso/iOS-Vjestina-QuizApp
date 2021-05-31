//
//  QuizListPresenter.swift
//  QuizApp
//
//  Created by Kompjuter on 30/05/2021.
//

import Foundation

final class QuizListPresenter {

    private var coordinator: AppRouterProtocol! //TODO jel mi treba coordinator
    private var quizUseCase: QuizUseCase!
    private var quizViewModels: [QuizViewModel] = []
    private var sectionNames: [String] = []
    private var currentFilterSettings: FilterSettings

    init(quizUseCase: QuizUseCase, coordinator: AppRouterProtocol) {
        self.coordinator = coordinator
        self.quizUseCase = quizUseCase
        self.currentFilterSettings = FilterSettings()
    }

    func refreshQuizzes() throws {
        try quizUseCase.refreshData()
        filterQuizzes(filter: currentFilterSettings)
    }

    func filterQuizzes(filter: FilterSettings) {
        currentFilterSettings = filter
        quizViewModels = quizUseCase
            .getQuizzes(filter: filter)
            .map { QuizViewModel($0) }
        sectionNames = Set(quizViewModels.map { $0.category.rawValue }).sorted()
    }

    func deleteQuiz(at indexPath: IndexPath) {
        guard let id = viewModelForIndexPath(indexPath)?.id else { return }
        quizUseCase.deleteQuiz(withId: id)
        filterQuizzes(filter: currentFilterSettings)
    }

    func numberOfSections() -> Int {
        print("\(sectionNames.count) sections")
        return sectionNames.count
    }

    func numberOfRows(for section: Int) -> Int {
        quizViewModels
            .filter { $0.category.rawValue == sectionNames[section] }
            .count
    }

    func viewModelForIndexPath(_ indexPath: IndexPath) -> QuizViewModel? {
        quizViewModels
            .filter { $0.category.rawValue == sectionNames[indexPath.section] }[indexPath.row]
    }

    func titleForSection(_ section: Int) -> String {
        print("section names \(sectionNames)")
        return sectionNames[section]
    }
}

