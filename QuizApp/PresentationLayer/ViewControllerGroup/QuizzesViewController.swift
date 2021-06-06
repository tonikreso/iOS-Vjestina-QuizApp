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
    
    private var scrollView: UIScrollView!
    private var nameLabel: UILabel!
    //private var getQuizButton: UIButton!
    
    private var presenter: QuizListPresenter!
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
    
    
    func addPresenter(presenter: QuizListPresenter) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        styleViews()
        defineLayoutForViews()
        refreshQuizzes()
    }
    
    private func refreshQuizzes() {
        do {
            try presenter.refreshQuizzes()
            tableView.reloadData()
        } catch {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    private func buildViews() {
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        nameLabel = UILabel()
        scrollView.addSubview(nameLabel)
        
//        getQuizButton = UIButton()
//        scrollView.addSubview(getQuizButton)
        
        funFactLabel = UILabel()
        scrollView.addSubview(funFactLabel)
        
        funFactText = UILabel()
        scrollView.addSubview(funFactText)
        
        infoButton = UIButton()
        scrollView.addSubview(infoButton)
        
        tableView = UITableView()
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        scrollView.addSubview(tableView)
        
        
        categoryDict = [QuizCategory: [Quiz]]()
        indexDict = [Int: QuizCategory]()
    }
    
    private func styleViews() {
        
        nameLabel.text = "PopQuiz"
        nameLabel.font = UIFont(name: nameLabelFont, size: 25.0)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        
//        getQuizButton.backgroundColor = .white
//        getQuizButton.setAttributedTitle(NSAttributedString(string: "Get Quiz", attributes: [NSAttributedString.Key.foregroundColor: GlobalConstants.gradientColor1, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)]), for: .normal)
//        getQuizButton.addTarget(self, action: #selector(getQuizzes), for: .touchUpInside)
        
        //funFactLabel.text = "Fun fact"
        funFactLabel.font = UIFont(name: nameLabelFont, size: 25.0)
        funFactLabel.textColor = .white
        
        funFactText.font = UIFont(name: nameLabelFont, size: 16)
        funFactText.textColor = .white
        
        tableView.rowHeight = 150
        tableView.backgroundColor = UIColor.white.withAlphaComponent(0)
        
    }
    
    private func defineLayoutForViews() {
        scrollView.autoPinEdge(toSuperviewSafeArea: .top, withInset: 0)
        scrollView.autoPinEdge(toSuperviewSafeArea: .right, withInset: 0)
        scrollView.autoPinEdge(toSuperviewSafeArea: .left, withInset: 0)
        scrollView.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 0)
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        
        
        
        nameLabel.autoPinEdge(.top, to: .top, of: scrollView, withOffset: 35)
        nameLabel.autoPinEdge(toSuperviewSafeArea: .right, withInset: 20)
        nameLabel.autoPinEdge(toSuperviewSafeArea: .left, withInset: 20)
        
//        getQuizButton.autoPinEdge(toSuperviewSafeArea: .left, withInset: 20)
//        getQuizButton.autoPinEdge(toSuperviewSafeArea: .right, withInset: 20)
//        getQuizButton.autoPinEdge(.top, to: .bottom, of: nameLabel, withOffset: 35)
//        getQuizButton.contentEdgeInsets = UIEdgeInsets.init(top: 15, left: 25, bottom: 15, right: 25)
//        getQuizButton.layer.cornerRadius = 25
        
        funFactLabel.autoPinEdge(.top, to: .bottom, of: nameLabel, withOffset: 35)
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
    
//    @objc func getQuizzes(sender: UIButton!) {
//        quizzes = NetworkService.singletonNetworkService.getQuizzes()
//
//        let questions = self.quizzes.map {
//            $0.questions
//        }.flatMap({ (element: [Question]) -> [Question] in
//            return element
//        }).map {
//            $0.question
//        }.filter {
//            $0.contains("NBA")
//        }
//        self.categoryDict = [QuizCategory: [Quiz]]()
//        self.indexDict = [Int: QuizCategory]()
//        var numberOfQuizzes = 0
//        var i = 0
//        for quiz in self.quizzes {
//            numberOfQuizzes += 1
//            if !self.categoryDict.keys.contains(quiz.category) {
//                let tmp : [Quiz] = []
//                self.categoryDict[quiz.category] = tmp
//                self.indexDict[i] = quiz.category
//                i += 1
//            }
//            self.categoryDict[quiz.category]?.append(quiz)
//        }
//
//        self.tableView.reloadData()
//
//        self.funFactText.text = "There are \(questions.count) questions that contain the word \"NBA\""
//
//
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRows(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier,
            for: indexPath) as? CustomTableViewCell,
            let viewModel = presenter.viewModelForIndexPath(indexPath)
        else {
            return UITableViewCell()
        }
        
        
        //cell.setMyValues(imageUrl: quiz.imageUrl, title: quiz.title, descriptionText: quiz.description, level: "\(quiz.level)")
        cell.set(viewModel: viewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        presenter.titleForSection(section)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let tmpView = view as? UITableViewHeaderFooterView {
            tmpView.backgroundConfiguration?.backgroundColor = UIColor.white.withAlphaComponent(0)
            tmpView.textLabel?.textColor = .white
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewModel = presenter.viewModelForIndexPath(indexPath)
        guard let questions = viewModel?.questions else { return }
        
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(viewModel?.id, forKey: "quiz_id")
        router.showQuizViewController(questions: questions)
    }
    
}

