//
//  LoginViewController.swift
//  QuizApp
//
//  Created by Kompjuter on 11/04/2021.
//

import Foundation
import UIKit
import PureLayout

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    private var router: AppRouterProtocol!
    
    private var nameLabel: UILabel!
    private var emailTextField: MyTextField!
    private var passwordTextField: UITextField!
    private var button: UIButton!
    private var passwordButton: UIButton!
    private var gradientLayer: CAGradientLayer!
    private var alert: UIAlertController!
    
    private var nameLabelFont = "HelveticaNeue-Bold"
    private var gradientColor1 = UIColor(red: 58/255, green: 55/255, blue: 129/255, alpha: 1)
    private var gradientColor2 = UIColor(red: 101/255, green: 73/255, blue: 154/255, alpha: 1)
    
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
        
        gradientLayer = CAGradientLayer()
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        alert = UIAlertController(title: "Login Error", message: "Incorrect username or password. Try again.", preferredStyle: .alert)
    }
    
    private func styleViews() {
        gradientLayer.colors = [gradientColor1.cgColor, gradientColor2.cgColor]
        
        nameLabel.text = "PopQuiz"
        nameLabel.font = UIFont(name: nameLabelFont, size: 30.0)
        nameLabel.textColor = .white
        
        emailTextField.backgroundColor = UIColor(red: 137/255, green: 123/255, blue: 178/255, alpha: 1)
        emailTextField.textColor = .white
        emailTextField.keyboardType = UIKeyboardType.emailAddress
        
        passwordTextField.backgroundColor = UIColor(red: 137/255, green: 123/255, blue: 178/255, alpha: 1)
        passwordTextField.textColor = .white
        passwordTextField.isSecureTextEntry = true
        passwordTextField.rightViewMode = .whileEditing
        
        passwordButton.setImage(UIImage(named: "ic_eye_open"), for: .normal)
        passwordButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        passwordButton.addTarget(self, action: #selector(self.refresh), for: .touchUpInside)
        
        button.backgroundColor = .white
        button.isEnabled = false
        button.alpha = 0.5
        button.setAttributedTitle(NSAttributedString(string: "Login", attributes: [NSAttributedString.Key.foregroundColor: gradientColor1, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)]), for: .normal)
        button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        
    }
    
    private func defineLayoutForViews() {
        nameLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 20)
        nameLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        
        emailTextField.autoAlignAxis(.vertical, toSameAxisOf: nameLabel)
        emailTextField.autoPinEdge(.top, to: .bottom, of: nameLabel, withOffset: 150)
        emailTextField.autoSetDimensions(to: CGSize(width: 300, height: 50))
        emailTextField.layer.cornerRadius = 25
        
        passwordTextField.autoAlignAxis(.vertical, toSameAxisOf: nameLabel)
        passwordTextField.autoPinEdge(.top, to: .bottom, of: emailTextField, withOffset: 15)
        passwordTextField.autoSetDimensions(to: CGSize(width: 300, height: 50))
        passwordTextField.layer.cornerRadius = 25
        
        button.autoAlignAxis(.vertical, toSameAxisOf: nameLabel)
        button.autoPinEdge(.top, to: .bottom, of: passwordTextField, withOffset: 15)
        button.autoSetDimensions(to: CGSize(width: 300, height: 50))
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
    override func viewDidLayoutSubviews() {
        gradientLayer.frame = view.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
    }
    
    @objc func loginAction(sender: UIButton!) {
        let loginStatus = DataService().login(email: emailTextField.text!, password: passwordTextField.text!)
        print(emailTextField.text!)
        print(passwordTextField.text!)
        if case .success  = loginStatus {
            router.showQuizzesViewController()
        }
        if case .error(400, "Bad Request") = loginStatus {
            self.present(alert, animated: true, completion:{
                self.alert.view.superview?.isUserInteractionEnabled = true
                self.alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
             })
        }
    }
    @objc func dismissOnTapOutside(){
       self.dismiss(animated: true, completion: nil)
    }
}
