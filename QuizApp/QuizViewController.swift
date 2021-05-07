//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Kompjuter on 03/05/2021.
//

import Foundation
import UIKit

class QuizViewController: SharedViewController, UITextFieldDelegate {
    
    private var router: AppRouterProtocol!
    private var questions: [Question]!
    private var questionIndex: Int!
    private var answerButtonArray: [UIButton]!
    private var numberOfCorrect: Int!
    
    private var questionNumberLabel: UILabel!
    private var questionTracker: UIProgressView!
    private var questionLabel: UILabel!
    private var answer1: UIButton!
    private var answer2: UIButton!
    private var answer3: UIButton!
    private var answer4: UIButton!
    
    convenience init(router: AppRouterProtocol, questions: [Question]) {
        self.init()
        self.router = router
        self.questions = questions
        self.questionIndex = 0
        self.numberOfCorrect = 0
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        styleViews()
        defineLayoutForViews()
    }
    
    private func buildViews() {
        questionNumberLabel = UILabel()
        view.addSubview(questionNumberLabel)
        
        questionTracker = UIProgressView()
        view.addSubview(questionTracker)
        
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
        questionNumberLabel.textColor = .white
        
        questionLabel.textColor = .white
        questionLabel.font = UIFont.boldSystemFont(ofSize: 23)
        questionLabel.numberOfLines = 0
        
        for answer in answerButtonArray {
            answer.layer.cornerRadius = 25
            answer.addTarget(self, action: #selector(checkCorrectAnswer), for: .touchUpInside)
            answer.contentHorizontalAlignment = .left
            answer.contentEdgeInsets = UIEdgeInsets.init(top: 15, left: 25, bottom: 15, right: 25)
            answer.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        }
        answer1.tag = 0
        answer2.tag = 1
        answer3.tag = 2
        answer4.tag = 3
        
        showNextQuestion(index: questionIndex)
    }
    
    private func defineLayoutForViews() {
        questionNumberLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 15)
        questionNumberLabel.autoPinEdge(toSuperviewSafeArea: .left, withInset: 15)
        
        questionTracker.autoPinEdge(.top, to: .bottom, of: questionNumberLabel, withOffset: 10)
        questionTracker.autoPinEdge(toSuperviewSafeArea: .left, withInset: 15)
        questionTracker.autoPinEdge(toSuperviewSafeArea: .right, withInset: 15)
        
        questionLabel.autoPinEdge(.top, to: .bottom, of: questionTracker, withOffset: 40)
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
    
    private func showNextQuestion(index: Int) {
        for answer in answerButtonArray {
            answer.isEnabled = true
            answer.backgroundColor = UIColor(red: 137/255, green: 123/255, blue: 178/255, alpha: 1)
        }
        questionNumberLabel.text = "\(index + 1)/\(questions.count)"
        
        questionTracker.setProgress(Float(index + 1)/Float(questions.count), animated: true)
        
        questionLabel.text = questions[index].question
        
        answer1.setTitle(questions[index].answers[0], for: .normal)
        answer2.setTitle(questions[index].answers[1], for: .normal)
        answer3.setTitle(questions[index].answers[2], for: .normal)
        answer4.setTitle(questions[index].answers[3], for: .normal)
    }
    
    @objc func checkCorrectAnswer(sender: UIButton!) {
        for answer in answerButtonArray {
            answer.isEnabled = false
        }
        let correctIndex = questions[questionIndex].correctAnswer
        answerButtonArray[correctIndex].backgroundColor = .systemGreen
        
        if correctIndex != sender.tag {
            answerButtonArray[sender.tag].backgroundColor = .systemRed
        } else {
            numberOfCorrect += 1
        }
        
        questionIndex += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if self.questionIndex >= self.questions.count {
                self.router.showQuizResultViewController(numberOfCorrect: self.numberOfCorrect, numberOfQuestions: self.questions.count)
            } else {
                self.showNextQuestion(index: self.questionIndex)
            }
        }
        
        
        
    }
    
}
