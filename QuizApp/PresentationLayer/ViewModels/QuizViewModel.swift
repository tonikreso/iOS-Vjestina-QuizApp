//
//  QuizViewModel.swift
//  QuizApp
//
//  Created by Kompjuter on 30/05/2021.
//

struct QuizViewModel {
    
    let id: Int
    let title: String
    let description: String
    let category: QuizCategory
    let level: Int
    let imageUrl: String
    let questions: [Question]
    
    init(_ quiz: Quiz) {
        self.id = quiz.id
        self.title = quiz.title
        self.description = quiz.description
        self.category = quiz.category
        self.level = quiz.level
        self.imageUrl = quiz.imageUrl
        self.questions = quiz.questions
    }
}
