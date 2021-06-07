//
//  QuizViewModel.swift
//  QuizApp
//
//  Created by Kompjuter on 30/05/2021.
//
import UIKit

struct QuizViewModel {
    
    let id: Int
    let title: String
    let description: String
    let category: QuizCategory
    let level: Int
    let imageUrl: String
    let questions: [Question]
    var image: UIImage?
    
    init(_ quiz: Quiz) {
        self.id = quiz.id
        self.title = quiz.title
        self.description = quiz.description
        self.category = quiz.category
        self.level = quiz.level
        self.imageUrl = quiz.imageUrl
        self.questions = quiz.questions
        if let storedImageData = quiz.storedImageData {
            self.image = UIImage(data: storedImageData)
        } else {
            self.image = UIImage(named: "football-strategy")
        }
    }
}
