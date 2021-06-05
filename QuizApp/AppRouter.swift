//
//  AppRouter.swift
//  QuizApp
//
//  Created by Kompjuter on 03/05/2021.
//

import Foundation
import UIKit
import CoreData

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
        //let vc = createQuizzesViewController()
        let coreDataContext = CoreDataStack(modelName: "QuizDatabaseDataSource").managedContext
        let quizDataRepository = QuizDataRepository(networkDataSource: QuizNetworkDataSource(), coreDataSource: QuizCoreDataSource(coreDataContext: coreDataContext))
        let quizUseCase = QuizUseCase(quizRepository: quizDataRepository)
        let presenter = QuizListPresenter(quizUseCase: quizUseCase, coordinator: self)
        let vc = SearchQuizViewController(router: self)
        vc.addPresenter(presenter: presenter)
        //let vc = LoginViewController(router: self)
        
        navigationController.pushViewController(vc, animated: false)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func createQuizzesViewController() -> QuizzesViewController{
        let coreDataContext = CoreDataStack(modelName: "QuizDatabaseDataSource").managedContext
        let quizDataRepository = QuizDataRepository(networkDataSource: QuizNetworkDataSource(), coreDataSource: QuizCoreDataSource(coreDataContext: coreDataContext))
        let quizUseCase = QuizUseCase(quizRepository: quizDataRepository)
        let presenter = QuizListPresenter(quizUseCase: quizUseCase, coordinator: self)
        let tmpVC = QuizzesViewController(router: self)
        tmpVC.addPresenter(presenter: presenter)
        return tmpVC
        
    }
    func showQuizzesViewController() {
        let quizzesVC = createQuizzesViewController()
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
        
        NetworkService.singletonNetworkService.postResult(timeInterval: timeInterval, numberOfCorrect: numberOfCorrect)
        
        let vc = QuizResultViewController(router: self, numberOfCorrect: numberOfCorrect, numberOfQuestions: numberOfQuestions)
        
        navigationController.pushViewController(vc, animated: true)
    }
}

