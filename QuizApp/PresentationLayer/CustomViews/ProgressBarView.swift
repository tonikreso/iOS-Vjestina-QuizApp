//
//  ProgressBarView.swift
//  QuizApp
//
//  Created by Kompjuter on 06/06/2021.
//

import Foundation
import UIKit
import PureLayout

class ProgressBarView: UIView {
    var stackView: UIStackView!
    
    init(numberOfQuestions: Int) {
        super.init(frame: .zero)
        self.initialize(numberOfQuestions: numberOfQuestions)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize(numberOfQuestions: Int) {
        stackView = UIStackView()
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        
        for _ in 0...(numberOfQuestions - 1) {
            let progressBar = UIProgressView()
            progressBar.trackTintColor = GlobalConstants.answerColor
            
            progressBar.progressTintColor = .white
            progressBar.layer.cornerRadius = 4
            stackView.addArrangedSubview(progressBar)
        }
        self.addSubview(stackView)
        stackView.autoPinEdgesToSuperviewSafeArea()
    }
    
    func answerAt(index: Int, correct: Bool) {   
        let tmpProgressView = stackView.subviews[index] as? UIProgressView
        
        if(correct) {
            tmpProgressView?.progressTintColor = .systemGreen
        } else {
            tmpProgressView?.progressTintColor = .systemRed
        }
    }
    
    func startedAt(index: Int) {
        let tmpProgressView = stackView.subviews[index] as? UIProgressView
        tmpProgressView?.setProgress(1, animated: false)
    }
}
