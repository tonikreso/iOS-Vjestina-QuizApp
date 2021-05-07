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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func setStartScreen(in window: UIWindow?) {
        let vc = QuizzesViewController(router: self)
        
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
        
        navigationController.viewControllers.insert(tabBarController, at: 0)
        navigationController.popToRootViewController(animated: true)
    }
    
    func showLoginViewController() {
        let vc = LoginViewController(router: self)
        
        navigationController.viewControllers.insert(vc, at: 0)
        navigationController.popToRootViewController(animated: true)
    }
    
    func showQuizViewController(questions: [Question]) {
        let vc = QuizViewController(router: self, questions: questions)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showQuizResultViewController(numberOfCorrect: Int, numberOfQuestions: Int) {
        let vc = QuizResultViewController(router: self, numberOfCorrect: numberOfCorrect, numberOfQuestions: numberOfQuestions)
        
        navigationController.pushViewController(vc, animated: true)
    }
}

