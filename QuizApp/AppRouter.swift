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
        let vc = LoginViewController(router: self)
        
        navigationController.pushViewController(vc, animated: false)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func createPresenter() -> QuizListPresenter {
        let coreDataContext = CoreDataStack(modelName: "QuizDatabaseDataSource").managedContext
        let quizDataRepository = QuizDataRepository(networkDataSource: QuizNetworkDataSource(), coreDataSource: QuizCoreDataSource(coreDataContext: coreDataContext))
        let quizUseCase = QuizUseCase(quizRepository: quizDataRepository)
        let presenter = QuizListPresenter(quizUseCase: quizUseCase, coordinator: self)
        return presenter
        
    }
    
    private func createSearchQuizViewController() -> SearchQuizViewController {
        let vc = SearchQuizViewController(router: self)
        vc.addPresenter(presenter: createPresenter())
        return vc
    }
    
    private func createQuizzesViewController() -> QuizzesViewController{
        let tmpVC = QuizzesViewController(router: self)
        tmpVC.addPresenter(presenter: createPresenter())
        return tmpVC
    }
    
    func showQuizzesViewController() {
        let quizzesVC = createQuizzesViewController()
        quizzesVC.title = "Quizzes"
        let settingsVC = SettingViewController(router: self)
        settingsVC.title = "Settings"
        let searchVC = createSearchQuizViewController()
        searchVC.title = "Search"
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [quizzesVC, settingsVC, searchVC]
        navigationController.setViewControllers([tabBarController], animated: true)
    }
    
    func showLoginViewController() {
        let vc = LoginViewController(router: self)
        
        navigationController.setViewControllers([vc], animated: true)
    }
    
    func showQuizViewController(questions: [Question]) {
        let vc = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        vc.setRouter(router: self)
        
        let progressBarView = ProgressBarView()
        progressBarView.initialize(numberOfQuestions: questions.count)
        
        var controllers = [UIViewController]()
        for index in 0...(questions.count - 1) {
            
            let tmpVC = QuizViewController(pageController: vc, question: questions[index], progressBarView: progressBarView, displayText: "\(index + 1)/\(questions.count)")
            controllers.append(tmpVC)
        }
        
        vc.addControllersAndProgressBar(controllers: controllers, progressBar: progressBarView)
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

