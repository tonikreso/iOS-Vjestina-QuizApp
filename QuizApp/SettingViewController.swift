//
//  SettingViewController.swift
//  QuizApp
//
//  Created by Kompjuter on 03/05/2021.
//

import Foundation
import UIKit
import PureLayout

class SettingViewController: SharedViewController, UITextFieldDelegate {
    
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
        usernameLabel = UILabel()
        view.addSubview(usernameLabel)
        
        nameSurnameLabel = UILabel()
        view.addSubview(nameSurnameLabel)
        
        logoutButton = UIButton()
        view.addSubview(logoutButton)
    }
    
    private func styleViews() {
        usernameLabel.text = "USERNAME"
        usernameLabel.textColor = .white
        usernameLabel.font = UIFont.systemFont(ofSize: 12)
        
        nameSurnameLabel.text = "Toni Krešo"
        nameSurnameLabel.textColor = .white
        nameSurnameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        logoutButton.backgroundColor = .white
        logoutButton.setAttributedTitle(NSAttributedString(string: "Log Out", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)]), for: .normal)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
    }
    
    private func defineLayoutForViews() {
        usernameLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 20)
        usernameLabel.autoPinEdge(toSuperviewSafeArea: .left, withInset: 15)
        
        nameSurnameLabel.autoPinEdge(.top, to: .bottom, of: usernameLabel, withOffset: 10)
        nameSurnameLabel.autoPinEdge(toSuperviewSafeArea: .left, withInset: 15)
        
        logoutButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 15)
        logoutButton.autoAlignAxis(toSuperviewAxis: .vertical)
        logoutButton.autoSetDimensions(to: CGSize(width: 300, height: 50))
        logoutButton.layer.cornerRadius = 25
    }
    
    @objc func logout(sender: UIButton!) {
        router.showLoginViewController()
    }
}
