//
//  QuizzesViewController.swift
//  QuizApp
//
//  Created by Kompjuter on 13/04/2021.
//

import Foundation
import UIKit
import PureLayout

class QuizzesViewController: SharedViewController, UITableViewDataSource, UITableViewDelegate {
    private var router: AppRouterProtocol!
    
    private var nameLabel: UILabel!
    private var getQuizButton: UIButton!
    private var funFactLabel: UILabel!
    private var infoButton: UIButton!
    private var tableView: UITableView!
    private var quizzes: [Quiz]!
    private var categoryDict: [QuizCategory: [Quiz]]!
    private var indexDict: [Int: QuizCategory]!
    private var funFactText: UILabel!
    
    let cellIdentifier = "cellId"
    
    private var nameLabelFont = "HelveticaNeue-Bold"
    
    convenience init(router: AppRouterProtocol) {
        self.init()
        self.router = router
    }
    
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
        
        tableView = UITableView()
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        categoryDict = [QuizCategory: [Quiz]]()
        indexDict = [Int: QuizCategory]()
    }
    
    private func styleViews() {
        nameLabel.text = "PopQuiz"
        nameLabel.font = UIFont(name: nameLabelFont, size: 25.0)
        nameLabel.textColor = .white
        
        getQuizButton.backgroundColor = .white
        getQuizButton.setAttributedTitle(NSAttributedString(string: "Get Quiz", attributes: [NSAttributedString.Key.foregroundColor: GlobalConstants.gradientColor1, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)]), for: .normal)
        getQuizButton.addTarget(self, action: #selector(getQuizzes), for: .touchUpInside)
        
        funFactLabel.text = "Fun fact"
        funFactLabel.font = UIFont(name: nameLabelFont, size: 25.0)
        funFactLabel.textColor = .white
        funFactLabel.isHidden = true
        
        funFactText.font = UIFont(name: nameLabelFont, size: 16)
        funFactText.textColor = .white
        funFactText.isHidden = true
        
        tableView.isHidden = true
        tableView.rowHeight = 150
        tableView.backgroundColor = UIColor.white.withAlphaComponent(0)
    }
    
    private func defineLayoutForViews() {
        nameLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 20)
        nameLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        
        getQuizButton.autoAlignAxis(.vertical, toSameAxisOf: nameLabel)
        getQuizButton.autoPinEdge(.top, to: .bottom, of: nameLabel, withOffset: 35)
        getQuizButton.autoSetDimensions(to: CGSize(width: 300, height: 50))
        getQuizButton.layer.cornerRadius = 25
        
        funFactLabel.autoPinEdge(.top, to: .bottom, of: getQuizButton, withOffset: 35)
        funFactLabel.autoPinEdge(toSuperviewSafeArea: .left, withInset: 10)
        funFactLabel.autoPinEdge(toSuperviewSafeArea: .right, withInset: 10)
        
        funFactText.autoPinEdge(.top, to: .bottom, of: funFactLabel, withOffset: 5)
        funFactText.autoPinEdge(toSuperviewSafeArea: .left, withInset: 10)
        funFactText.autoPinEdge(toSuperviewSafeArea: .right, withInset: 10)
        funFactText.numberOfLines = 0
        
        tableView.autoPinEdge(.top, to: .bottom, of: funFactText, withOffset: 10)
        tableView.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 10)
        tableView.autoPinEdge(toSuperviewSafeArea: .right, withInset: 10)
        tableView.autoPinEdge(toSuperviewSafeArea: .left, withInset: 10)
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
        var numberOfQuizzes = 0
        var i = 0
        for quiz in quizzes {
            numberOfQuizzes += 1
            if !categoryDict.keys.contains(quiz.category) {
                let tmp : [Quiz] = []
                categoryDict[quiz.category] = tmp
                indexDict[i] = quiz.category
                i += 1
            }
            categoryDict[quiz.category]?.append(quiz)
        }
        
        tableView.reloadData()
        
        funFactText.text = "There are \(questions.count) questions that contain the word \"NBA\""
        
        funFactLabel.isHidden = false
        funFactText.isHidden = false
        tableView.isHidden = false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoryDict.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let indexSection = indexDict[section] else {
            return 0
        }
        guard let sectionDict = categoryDict[indexSection] else {
            return 0
        }
        return sectionDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let quizCategory = indexDict[indexPath.section]
        let quiz = categoryDict[quizCategory!]![indexPath.row]
        
        let cell = tableView.dequeueReusableCell(
        withIdentifier: cellIdentifier,
        for: indexPath) as! CustomTableViewCell// 4.
        
        
        cell.setMyValues(imageUrl: quiz.imageUrl, title: quiz.title, descriptionText: quiz.description, level: "\(quiz.level)")
        
        //cell.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tappedOnCell)))
        //let quizCategory = indexDict[indexPath.section]
        //let quiz = categoryDict[quizCategory!]
        //var cellConfig: UIListContentConfiguration = cell.defaultContentConfiguration() // 5.
        //cellConfig.text = quiz![indexPath.row].description
        //cell.contentConfiguration = cellConfig
        return cell
    }
    
    @objc func tappedOnCell(sender: CustomTableViewCell!) {
        print("Clicked here")
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return indexDict[section].map { $0.rawValue }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let tmpView = view as? UITableViewHeaderFooterView {
            tmpView.backgroundConfiguration?.backgroundColor = UIColor.white.withAlphaComponent(0)
            tmpView.textLabel?.textColor = .white
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let quizCategory = indexDict[indexPath.section]
        let quiz = categoryDict[quizCategory!]![indexPath.row]
        let questions = quiz.questions
        router.showQuizViewController(questions: questions)
    }
    
}
