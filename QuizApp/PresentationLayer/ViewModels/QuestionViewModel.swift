//
//  QuestionViewModel.swift
//  QuizApp
//
//  Created by Kompjuter on 30/05/2021.
//

struct QuestionViewModel {
    
    let id: Int
    let question: String
    let answers: [String]
    let correctAnswer: Int
    
    init(_ question: Question) {
        self.id = question.id
        self.question = question.question
        self.answers = question.answers
        self.correctAnswer = question.correctAnswer
    }
}
