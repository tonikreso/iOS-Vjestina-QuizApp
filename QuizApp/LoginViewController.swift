//
//  LoginViewController.swift
//  QuizApp
//
//  Created by Kompjuter on 11/04/2021.
//

import Foundation
import UIKit
import PureLayout

class LoginViewController: SharedViewController, UITextFieldDelegate {
    
    private var router: AppRouterProtocol!
    
    private var nameLabel: UILabel!
    private var emailTextField: MyTextField!
    private var passwordTextField: MyTextField!
    private var button: UIButton!
    private var passwordButton: UIButton!
    private var alert: UIAlertController!
    
    private let nameLabelFont = "HelveticaNeue-Bold"
    
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
        nameLabel = UILabel()
        view.addSubview(nameLabel)
        
        emailTextField = MyTextField()
        view.addSubview(emailTextField)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: emailTextField.font!.pointSize, weight: UIFont.Weight.thin)])
        emailTextField.delegate = self
        
        passwordTextField = MyTextField()
        view.addSubview(passwordTextField)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: passwordTextField.font!.pointSize, weight: UIFont.Weight.thin)])
        passwordTextField.delegate = self
        
        passwordButton = UIButton()
        passwordTextField.rightView = passwordButton
        
        button = UIButton()
        view.addSubview(button)
        
        alert = UIAlertController(title: "Login Error", message: "Incorrect username or password. Try again.", preferredStyle: .alert)
    }
    
    private func styleViews() {
        nameLabel.text = "PopQuiz"
        nameLabel.font = UIFont(name: nameLabelFont, size: 30.0)
        nameLabel.textColor = .white
        
        emailTextField.backgroundColor = GlobalConstants.answerColor
        emailTextField.textColor = .white
        emailTextField.keyboardType = UIKeyboardType.emailAddress
        
        passwordTextField.backgroundColor = GlobalConstants.answerColor
        passwordTextField.textColor = .white
        passwordTextField.isSecureTextEntry = true
        passwordTextField.rightViewMode = .whileEditing
        
        passwordButton.setImage(UIImage(named: "ic_eye_open"), for: .normal)
        passwordButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        passwordButton.addTarget(self, action: #selector(self.refresh), for: .touchUpInside)
        
        button.backgroundColor = .white
        button.isEnabled = false
        button.alpha = 0.5
        button.setAttributedTitle(NSAttributedString(string: "Login", attributes: [NSAttributedString.Key.foregroundColor: GlobalConstants.gradientColor1, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)]), for: .normal)
        button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets.init(top: 15, left: 25, bottom: 15, right: 25)
        
    }
    
    private func defineLayoutForViews() {
        nameLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 20)
        nameLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        
        emailTextField.autoPinEdge(.bottom, to: .top, of: passwordTextField, withOffset: -15)
        emailTextField.autoPinEdge(toSuperviewSafeArea: .right, withInset: 20)
        emailTextField.autoPinEdge(toSuperviewSafeArea: .left, withInset: 20)
        emailTextField.layer.cornerRadius = 25
        
        passwordTextField.autoPinEdge(toSuperviewSafeArea: .right, withInset: 20)
        passwordTextField.autoPinEdge(toSuperviewSafeArea: .left, withInset: 20)
        passwordTextField.layer.cornerRadius = 25
        passwordTextField.autoCenterInSuperview()
        
        button.autoPinEdge(.top, to: .bottom, of: passwordTextField, withOffset: 15)
        button.autoPinEdge(toSuperviewSafeArea: .right, withInset: 20)
        button.autoPinEdge(toSuperviewSafeArea: .left, withInset: 20)
        button.layer.cornerRadius = 25
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.white.cgColor
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        button.isEnabled = emailTextField.text != "" && passwordTextField.text != ""
        if(button.isEnabled) {
            button.alpha = 1.0
        } else {
            button.alpha = 0.5
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
        if(passwordTextField.isSecureTextEntry) {
            passwordButton.setImage(UIImage(named: "ic_eye_open"), for: .normal)
        } else {
            passwordButton.setImage(UIImage(named: "ic_eye_closed"), for: .normal)
        }
    }
    
    @objc func loginAction(sender: UIButton!) {
        guard let url = URL(string: "https://iosquiz.herokuapp.com/api/session") else { return }
        let parameters: [String: Any] = [
            "username" : emailTextField.text!,
            "password" : passwordTextField.text!
        ]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        NetworkService().executeUrlRequest(request) { (result: Result<LoginResponse, RequestError>) in
            switch result {
            case.failure(let error):
                DispatchQueue.main.async {
                    self.present(self.alert, animated: true, completion:{
                        self.alert.view.superview?.isUserInteractionEnabled = true
                        self.alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
                     })
                }
                
                return
            case.sucess(let value):
                let userDefaults = UserDefaults.standard
                userDefaults.setValue(value.id, forKey: "user_id")
                userDefaults.setValue(value.token, forKey: "user_token")
                DispatchQueue.main.async {
                    self.router.showQuizzesViewController()
                }
                
            }
            
        }
    }
    @objc func dismissOnTapOutside(){
       self.dismiss(animated: true, completion: nil)
    }
}
