//
//  QuizzesViewController.swift
//  QuizApp
//
//  Created by Kompjuter on 13/04/2021.
//

import Foundation
import UIKit
import PureLayout

class QuizzesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var nameLabel: UILabel!
    private var getQuizButton: UIButton!
    private var funFactLabel: UILabel!
    private var infoButton: UIButton!
    private var gradientLayer: CAGradientLayer!
    private var tableView: UITableView!
    private var quizzes: [Quiz]!
    private var categoryDict: [QuizCategory: [Quiz]]!
    private var indexDict: [Int: QuizCategory]!
    private var funFactText: UILabel!
    
    let cellIdentifier = "cellId"
    
    private var gradientColor1 = UIColor(red: 58/255, green: 55/255, blue: 129/255, alpha: 1)
    private var gradientColor2 = UIColor(red: 130/255, green: 73/255, blue: 155/255, alpha: 1)
    private var nameLabelFont = "HelveticaNeue-Bold"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        styleViews()
        defineLayoutForViews()
    }
    
    private func buildViews() {
        nameLabel = UILabel()
        view.addSubview(nameLabel)
        
        getQuizButton = UIButton()
        view.addSubview(getQuizButton)
        
        funFactLabel = UILabel()
        view.addSubview(funFactLabel)
        
        funFactText = UILabel()
        view.addSubview(funFactText)
        
        infoButton = UIButton()
        view.addSubview(infoButton)
        
        gradientLayer = CAGradientLayer()
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        categoryDict = [QuizCategory: [Quiz]]()
        indexDict = [Int: QuizCategory]()
    }
    
    private func styleViews() {
        gradientLayer.colors = [gradientColor1.cgColor, gradientColor2.cgColor]
        
        nameLabel.text = "PopQuiz"
        nameLabel.font = UIFont(name: nameLabelFont, size: 25.0)
        nameLabel.textColor = .white
        
        getQuizButton.backgroundColor = .white
        getQuizButton.setAttributedTitle(NSAttributedString(string: "Get Quiz", attributes: [NSAttributedString.Key.foregroundColor: gradientColor1, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)]), for: .normal)
        getQuizButton.addTarget(self, action: #selector(getQuizzes), for: .touchUpInside)
        
        funFactLabel.text = "Fun fact"
        funFactLabel.font = UIFont(name: nameLabelFont, size: 25.0)
        funFactLabel.textColor = .white
        
        funFactText.font = UIFont(name: nameLabelFont, size: 16)
        funFactText.textColor = .white
    }
    
    private func defineLayoutForViews() {
        nameLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 20)
        nameLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        
        getQuizButton.autoAlignAxis(.vertical, toSameAxisOf: nameLabel)
        getQuizButton.autoPinEdge(.top, to: .bottom, of: nameLabel, withOffset: 35)
        getQuizButton.autoSetDimensions(to: CGSize(width: 300, height: 50))
        getQuizButton.layer.cornerRadius = 25
    }
    
    @objc func getQuizzes(sender: UIButton!) {
        quizzes = DataService().fetchQuizes()
        let questions = quizzes.map {
            $0.questions
        }.flatMap({ (element: [Question]) -> [Question] in
            return element
        }).map {
            $0.question
        }.filter {
            $0.contains("NBA")
        }
        categoryDict = [QuizCategory: [Quiz]]()
        indexDict = [Int: QuizCategory]()
        var i = 0
        for quiz in quizzes {
            if !categoryDict.keys.contains(quiz.category) {
                let tmp : [Quiz] = []
                categoryDict[quiz.category] = tmp
                indexDict[i] = quiz.category
                i += 1
            }
            categoryDict[quiz.category]?.append(quiz)
        }
        funFactLabel.autoPinEdge(.top, to: .bottom, of: getQuizButton, withOffset: 35)
        funFactLabel.autoPinEdge(toSuperviewSafeArea: .left, withInset: 10)
        funFactLabel.autoPinEdge(toSuperviewSafeArea: .right, withInset: 10)
        
        funFactText.text = "There are \(questions.count) questions that contain the word \"NBA\""
        funFactText.autoPinEdge(.top, to: .bottom, of: funFactLabel, withOffset: 5)
        funFactText.autoPinEdge(toSuperviewSafeArea: .left, withInset: 10)
        funFactText.autoPinEdge(toSuperviewSafeArea: .right, withInset: 10)
        funFactText.numberOfLines = 0
        
        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.autoPinEdge(.top, to: .bottom, of: funFactText, withOffset: 10)
        tableView.autoAlignAxis(.vertical, toSameAxisOf: nameLabel)
        tableView.autoSetDimensions(to: CGSize(width: view.bounds.width, height: 250))
        
        print(questions.count)
        print("Getting quizzes")
    }
    
    override func viewDidLayoutSubviews() {
        gradientLayer.frame = view.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoryDict.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryDict[indexDict[section]!]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell: UITableViewCell = tableView.dequeueReusableCell(
         withIdentifier: cellIdentifier,
         for: indexPath) // 4.
        
        let quizCategory = indexDict[indexPath.section]
        let quiz = categoryDict[quizCategory!]
         var cellConfig: UIListContentConfiguration = cell.defaultContentConfiguration() // 5.
        cellConfig.text = quiz![indexPath.row].description
         cellConfig.textProperties.color = .blue
         cell.contentConfiguration = cellConfig
         return cell
     }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return indexDict[section].map { $0.rawValue }
    }
}
