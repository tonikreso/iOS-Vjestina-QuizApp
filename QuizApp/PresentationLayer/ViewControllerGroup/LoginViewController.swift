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
    
    override func viewWillAppear(_ animated: Bool) {
        nameLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
        nameLabel.alpha = 0
        emailTextField.transform = emailTextField.transform.translatedBy(x: -view.frame.width, y: 0)
        passwordTextField.transform = passwordTextField.transform.translatedBy(x: -view.frame.width, y: 0)
        button.transform = button.transform.translatedBy(x: -view.frame.width, y: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut , animations: {
            self.nameLabel.transform = .identity;
            self.nameLabel.alpha = 1
        })
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut , animations: {
            self.emailTextField.transform = .identity
        })
        UIView.animate(withDuration: 1.5, delay: 0.25, options: .curveEaseInOut , animations: {
            self.passwordTextField.transform = .identity
        })
        UIView.animate(withDuration: 1.5, delay: 0.5, options: .curveEaseInOut , animations: {
            self.button.transform = .identity
        })
    }
    
    private func startLeaving() {
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut , animations: {
            self.nameLabel.transform = self.nameLabel.transform.translatedBy(x: 0, y: -self.view.frame.height)
            
        })
        UIView.animate(withDuration: 1.5, delay: 0.25, options: .curveEaseInOut , animations: {
            self.emailTextField.transform = self.emailTextField.transform.translatedBy(x: 0, y: -self.view.frame.height)
            
        })
        UIView.animate(withDuration: 1.5, delay: 0.5, options: .curveEaseInOut , animations: {
            self.passwordTextField.transform = self.passwordTextField.transform.translatedBy(x: 0, y: -self.view.frame.height)

        })
        UIView.animate(withDuration: 1.5, delay: 0.75, options: .curveEaseInOut , animations: {
            self.button.transform = self.button.transform.translatedBy(x: 0, y: -self.view.frame.height)
        })
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
        passwordTextField.endEditing(true)
        let loggedIn = NetworkService.singletonNetworkService.postLogin(username: emailTextField.text!, password: passwordTextField.text!)
        if loggedIn {
            
            startLeaving()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.router.showQuizzesViewController()
            }
        } else {
            self.present(self.alert, animated: true, completion:{
                self.alert.view.superview?.isUserInteractionEnabled = true
                self.alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
             })
        }
        
    }
    
    @objc func dismissOnTapOutside(){
       self.dismiss(animated: true, completion: nil)
    }
}
