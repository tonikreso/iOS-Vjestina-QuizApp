//
//  LeaderboardViewController.swift
//  QuizApp
//
//  Created by Kompjuter on 21/05/2021.
//

import Foundation
import UIKit
import PureLayout

class LeaderBoardViewController: SharedViewController{
    
    private var router: AppRouterProtocol!
    
    private var usernameLabel: UILabel!
    private var nameSurnameLabel: UILabel!
    private var logoutButton: UIButton!
    
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
    }
    
    private func styleViews() {
    }
    
    private func defineLayoutForViews() {
    }
    
    
}
