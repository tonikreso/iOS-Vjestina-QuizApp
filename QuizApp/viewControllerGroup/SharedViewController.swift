//
//  SharedViewController.swift
//  QuizApp
//
//  Created by Kompjuter on 03/05/2021.
//

import Foundation
import UIKit

class SharedViewController: UIViewController {
    
    private var router: AppRouterProtocol!
    private var gradientLayer: CAGradientLayer!
    
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
        gradientLayer = CAGradientLayer()
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func styleViews() {
        gradientLayer.colors = [GlobalConstants.gradientColor1.cgColor, GlobalConstants.gradientColor2.cgColor]
    }
    
    private func defineLayoutForViews() {
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
    }
    
    override func viewDidLayoutSubviews() {
        gradientLayer.frame = view.bounds
    }
    
    
}
