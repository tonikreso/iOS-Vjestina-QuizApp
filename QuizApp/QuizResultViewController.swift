//
//  QuizResultViewController.swift
//  QuizApp
//
//  Created by Kompjuter on 04/05/2021.
//

import Foundation
import UIKit
import PureLayout

class QuizResultViewController: SharedViewController, UITextFieldDelegate {
    
    private var router: AppRouterProtocol!
    private var numberOfCorrect: Int!
    private var numberOfQuestions: Int!
    
    private var resultLabel: UILabel!
    private var finishButton: UIButton!
    
    convenience init(router: AppRouterProtocol, numberOfCorrect: Int, numberOfQuestions: Int) {
        self.init()
        self.router = router
        self.numberOfCorrect = numberOfCorrect
        self.numberOfQuestions = numberOfQuestions
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        styleViews()
        defineLayoutForViews()
    }
    
    private func buildViews() {
        resultLabel = UILabel()
        view.addSubview(resultLabel)
        
        finishButton = UIButton()
        view.addSubview(finishButton)
    }
    
    private func styleViews() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        resultLabel.text = "\(numberOfCorrect!)/\(numberOfQuestions!)"
        resultLabel.font = UIFont.systemFont(ofSize: 120, weight: UIFont.Weight(rawValue: 1))
        resultLabel.textColor = .white
        
        finishButton.backgroundColor = .white
        finishButton.setAttributedTitle(NSAttributedString(string: "Finish Quiz", attributes: [NSAttributedString.Key.foregroundColor: GlobalConstants.gradientColor1, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)]), for: .normal)
        finishButton.layer.cornerRadius = 25
        finishButton.contentEdgeInsets = UIEdgeInsets.init(top: 15, left: 25, bottom: 15, right: 25)
        finishButton.addTarget(self, action: #selector(finish), for: .touchUpInside)
    }
    
    private func defineLayoutForViews() {
        resultLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        resultLabel.autoAlignAxis(.horizontal, toSameAxisOf: resultLabel.superview!, withOffset: -50)
        
        finishButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 15)
        finishButton.autoPinEdge(toSuperviewSafeArea: .left, withInset: 15)
        finishButton.autoPinEdge(toSuperviewSafeArea: .right, withInset: 15)
    }
    
    @objc func finish(sender: UIButton!) {
        router.showQuizzesViewController()
    }
    
}
