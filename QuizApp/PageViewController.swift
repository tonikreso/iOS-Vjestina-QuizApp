//
//  PageViewController.swift
//  QuizApp
//
//  Created by Kompjuter on 07/05/2021.
//

import Foundation
import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource{
    private var router: AppRouterProtocol!
    private var controllers: [UIViewController]!
    private var numberOfCorrect = 0
    private var displayedIndex = 0
    var currentIndex: Int {
        guard let tmp = viewControllers?.first else { return 0 }
        return controllers.firstIndex(of: tmp) ?? 0
    }
    
    func setRouter(router: AppRouterProtocol) {
        self.router = router
    }
    
    func getCurrentIndex() -> Int {
        return currentIndex
    }
    
    func getNumberOfChildren() -> Int {
        return controllers.count
    }
    
    func addControllers(controllers: [UIViewController]!) {
        self.controllers = controllers
        print(controllers.count)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let firstVC = controllers.first else { return }
        dataSource = nil
        
        setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard
            let vc = viewController as? QuizViewController,
            let controllerIndex = controllers.firstIndex(of: vc),
            controllerIndex - 1 >= 0,
            controllerIndex - 1 < controllers.count
        else {
            return nil
        }
        displayedIndex = controllerIndex - 1
        return controllers[displayedIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard
            let vc = viewController as? QuizViewController,
            let controllerIndex = controllers.firstIndex(of: vc),
            controllerIndex + 1 < controllers.count
        else {
            return nil
        }
        
        displayedIndex = controllerIndex + 1
        return controllers[displayedIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    }
    
    func goToNext(isCorrect: Bool) {
        if isCorrect {
            numberOfCorrect += 1
        }
        if currentIndex + 1 >= controllers.count {
            router.showQuizResultViewController(numberOfCorrect: numberOfCorrect, numberOfQuestions: controllers.count)
        } else {
            setViewControllers([controllers[currentIndex + 1]], direction: .forward, animated: false, completion: nil)
        }
    }
}
