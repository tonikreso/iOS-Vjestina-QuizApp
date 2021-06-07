//
//  SearchQuizViewController.swift
//  QuizApp
//
//  Created by Kompjuter on 03/06/2021.
//
import Foundation
import UIKit
import PureLayout

class SearchQuizViewController: SharedViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    let cellIdentifier = "cellId"
    private var router: AppRouterProtocol!
    
    private var tableView: UITableView!
    private var presenter: QuizListPresenter!
    private var searchField: MyTextField!
    private var searchButton: UIButton!
    private var stackView: UIStackView!
    
    convenience init(router: AppRouterProtocol) {
        self.init()
        self.router = router
    }
    
    func addPresenter(presenter: QuizListPresenter) {
        self.presenter = presenter
    }
    
    private func refreshQuizzes() {
        do {
            print("tu sam")
            presenter.filterQuizzes(filter: FilterSettings(searchText: searchField.text))
            try presenter.refreshQuizzes()
            tableView.reloadData()
        } catch {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        styleViews()
        defineLayoutForViews()
    }
    
    private func buildViews() {
        stackView = UIStackView()
        view.addSubview(stackView)
        
        tableView = UITableView()
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        
        searchField = MyTextField()
        stackView.addArrangedSubview(searchField)
        
        searchButton = UIButton()
        stackView.addArrangedSubview(searchButton)
        
    }
    
    private func styleViews() {
        stackView.axis = .horizontal
        stackView.spacing = 15
        
        tableView.rowHeight = 150
        tableView.backgroundColor = .clear
        
        searchField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: searchField.font!.pointSize, weight: UIFont.Weight.thin)])
        searchField.delegate = self
        searchField.backgroundColor = GlobalConstants.answerColor
        searchField.textColor = .white
        searchField.layer.cornerRadius = 25
        
        searchButton.setTitle("Search", for: .normal)
        searchButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        searchButton.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
    }
    
    @objc func searchAction(sender: UIButton!) {
        refreshQuizzes()
    }
    
    private func defineLayoutForViews() {
        stackView.autoSetDimension(.height, toSize: 50)
        stackView.autoPinEdge(toSuperviewSafeArea: .top, withInset: 20)
        stackView.autoPinEdge(toSuperviewSafeArea: .left, withInset: 20)
        stackView.autoPinEdge(toSuperviewSafeArea: .right, withInset: 20)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.autoPinEdge(.top, to: .bottom, of: stackView, withOffset: 10)
        tableView.autoPinEdge(toSuperviewSafeArea: .right, withInset: 10)
        tableView.autoPinEdge(toSuperviewSafeArea: .left, withInset: 10)
        tableView.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 10)
    }
    
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.white.cgColor
    }
}
