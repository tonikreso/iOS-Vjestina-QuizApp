//
//  AppRouter.swift
//  QuizApp
//
//  Created by Kompjuter on 03/05/2021.
//

import Foundation
import UIKit

protocol AppRouterProtocol {
    func setStartScreen(in window: UIWindow?)
    func showQuizzesViewController()
    func showLoginViewController()
    func showQuizViewController(questions: [Question])
    func showQuizResultViewController(numberOfCorrect: Int, numberOfQuestions: Int)
}

class AppRouter: AppRouterProtocol {
    
    private let navigationController: UINavigationController!
    private var startTime: DispatchTime!
    private var endTime: DispatchTime!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func setStartScreen(in window: UIWindow?) {
        let vc = LoginViewController(router: self)
        
        navigationController.pushViewController(vc, animated: false)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func showQuizzesViewController() {
        let quizzesVC = QuizzesViewController(router: self)
        quizzesVC.title = "Quizzes"
        let settingsVC = SettingViewController(router: self)
        settingsVC.title = "Settings"
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [quizzesVC, settingsVC]
        navigationController.setViewControllers([tabBarController], animated: true)
    }
    
    func showLoginViewController() {
        let vc = LoginViewController(router: self)
        
        navigationController.setViewControllers([vc], animated: true)
    }
    
    func showQuizViewController(questions: [Question]) {
        let vc = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        vc.setRouter(router: self)
        
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        
        var controllers = [UIViewController]()
        for question in questions {
            //TODO makni puno progressbarova
            let progressBar = UIProgressView()
            progressBar.trackTintColor = GlobalConstants.answerColor
            
            progressBar.progressTintColor = .white
            progressBar.layer.cornerRadius = 4
            stackView.addArrangedSubview(progressBar)
            
            let tmpVC = QuizViewController(pageController: vc, question: question, stackView: stackView)
            controllers.append(tmpVC)
        }
        
        vc.addControllers(controllers: controllers)
        startTime = DispatchTime.now() + Double(questions.count)*2.0
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showQuizResultViewController(numberOfCorrect: Int, numberOfQuestions: Int) {
        endTime = DispatchTime.now()
        let nanoTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        
        guard let url = URL(string: "https://iosquiz.herokuapp.com/api/result") else { return }
        let parameters: [String: Any] = [
            "quiz_id" : UserDefaults.standard.integer(forKey: "quiz_id"),
            "user_id" : UserDefaults.standard.integer(forKey: "user_id"),
            "time" : timeInterval,
            "no_of_correct" : numberOfCorrect
        ]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(UserDefaults.standard.string(forKey: "user_token")!, forHTTPHeaderField: "Authorization")
        request.httpBody = httpBody
        NetworkService().executeUrlRequest(request) { (result: Result<PostResultResponse, RequestError>) in
            switch result {
            case.failure(let error):
                return
            case.sucess(let value):
                print("result sent successfully \(value)")
            }
            
        }
        
        let vc = QuizResultViewController(router: self, numberOfCorrect: numberOfCorrect, numberOfQuestions: numberOfQuestions)
        
        navigationController.pushViewController(vc, animated: true)
    }
}

