//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Kompjuter on 03/05/2021.
//

import Foundation
import UIKit

class QuizViewController: SharedViewController, UITextFieldDelegate {
    
    private var pageController: PageViewController!
    private var question: Question!
    private var questionNumber: String!
    
    private var numberOfQuestionLabel: UILabel!
    private var progressBarView: ProgressBarView!
    private var answerButtonArray: [UIButton]!
    private var questionLabel: UILabel!
    private var answer1: UIButton!
    private var answer2: UIButton!
    private var answer3: UIButton!
    private var answer4: UIButton!
    
    convenience init(pageController: PageViewController, question: Question, progressBarView: ProgressBarView, displayText: String) {
        self.init()
        self.pageController = pageController
        self.question = question
        self.progressBarView = progressBarView
        self.questionNumber = displayText
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        styleViews()
        defineLayoutForViews()
    }
    
    private func buildViews() {
        numberOfQuestionLabel = UILabel()
        view.addSubview(numberOfQuestionLabel)
        
        view.addSubview(progressBarView)
        
        questionLabel = UILabel()
        view.addSubview(questionLabel)
        
        answer1 = UIButton()
        view.addSubview(answer1)
        answer2 = UIButton()
        view.addSubview(answer2)
        answer3 = UIButton()
        view.addSubview(answer3)
        answer4 = UIButton()
        view.addSubview(answer4)
        
        answerButtonArray = [answer1, answer2, answer3, answer4]
    }
    
    private func styleViews() {
        numberOfQuestionLabel.text = questionNumber
        numberOfQuestionLabel.textColor = .white
        
        questionLabel.textColor = .white
        questionLabel.font = UIFont.boldSystemFont(ofSize: 23)
        questionLabel.numberOfLines = 0
        
        for answer in answerButtonArray {
            answer.layer.cornerRadius = 25
            answer.addTarget(self, action: #selector(checkCorrectAnswer), for: .touchUpInside)
            answer.contentHorizontalAlignment = .left
            answer.contentEdgeInsets = UIEdgeInsets.init(top: 15, left: 25, bottom: 15, right: 25)
            answer.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            answer.backgroundColor = GlobalConstants.answerColor
        }
        answer1.tag = 0
        answer2.tag = 1
        answer3.tag = 2
        answer4.tag = 3
        
        showNextQuestion()
    }
    
    private func defineLayoutForViews() {
        numberOfQuestionLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 15)
        numberOfQuestionLabel.autoPinEdge(toSuperviewSafeArea: .left, withInset: 15)
        
        progressBarView.autoPinEdge(.top, to: .bottom, of: numberOfQuestionLabel, withOffset: 10)
        progressBarView.autoPinEdge(toSuperviewSafeArea: .left, withInset: 15)
        progressBarView.autoPinEdge(toSuperviewSafeArea: .right, withInset: 15)
        
        questionLabel.autoPinEdge(.top, to: .bottom, of: progressBarView, withOffset: 25)
        questionLabel.autoPinEdge(toSuperviewSafeArea: .left, withInset: 15)
        questionLabel.autoPinEdge(toSuperviewSafeArea: .right, withInset: 15)
        
        answer1.autoPinEdge(.top, to: .bottom, of: questionLabel, withOffset: 25)
        answer1.autoPinEdge(toSuperviewSafeArea: .left, withInset: 15)
        answer1.autoPinEdge(toSuperviewSafeArea: .right, withInset: 15)
        
        answer2.autoPinEdge(.top, to: .bottom, of: answer1, withOffset: 10)
        answer2.autoPinEdge(toSuperviewSafeArea: .left, withInset: 15)
        answer2.autoPinEdge(toSuperviewSafeArea: .right, withInset: 15)
        
        answer3.autoPinEdge(.top, to: .bottom, of: answer2, withOffset: 10)
        answer3.autoPinEdge(toSuperviewSafeArea: .left, withInset: 15)
        answer3.autoPinEdge(toSuperviewSafeArea: .right, withInset: 15)
        
        answer4.autoPinEdge(.top, to: .bottom, of: answer3, withOffset: 10)
        answer4.autoPinEdge(toSuperviewSafeArea: .left, withInset: 15)
        answer4.autoPinEdge(toSuperviewSafeArea: .right, withInset: 15)
    }
    
    private func showNextQuestion() {
        questionLabel.text = question.question
        
        answer1.setTitle(question.answers[0], for: .normal)
        answer2.setTitle(question.answers[1], for: .normal)
        answer3.setTitle(question.answers[2], for: .normal)
        answer4.setTitle(question.answers[3], for: .normal)
    }
    
    @objc func checkCorrectAnswer(sender: UIButton!) {
        for answer in answerButtonArray {
            answer.isEnabled = false
        }
        
        var isCorrect = true
        let correctIndex = question.correctAnswer
        answerButtonArray[correctIndex].backgroundColor = .systemGreen
        
        
        if correctIndex != sender.tag {
            answerButtonArray[sender.tag].backgroundColor = .systemRed
            isCorrect = false
        }
        
        self.pageController.goToNext(isCorrect: isCorrect)
        
    }
    
}
