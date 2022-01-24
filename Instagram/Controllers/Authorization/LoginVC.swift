//
//  LoginVC.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 05/01/2022.
//

import UIKit
import Firebase
import GoogleSignIn

protocol AuthenticationDelegate: AnyObject {
    func anuthenticalDidComplete()
}

class LoginVC: UIViewController {
    //MARK: Properties
    private var viewModel = LoginVewModel()
    weak var delegate: AuthenticationDelegate?
    
    private let iconImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "Instagram_logo_white"))
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    private let emialTextField: UITextField = {
        let textField = CustomTextField(placeholder: "Email")
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = CustomTextField(placeholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.attributedDesign(titleBtn: "Log In")
        btn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return btn
    }()
    
    private lazy var forgotPassword: UIButton = {
        let btn = UIButton(type: .system)
        btn.attributedTitle(firstPart: "Forgot your password?" + "\n", secondPart: "Get help signing in.")
        btn.titleLabel?.numberOfLines = 0
        btn.titleLabel?.textAlignment = .center
        btn.addTarget(self, action: #selector(openResetPasswordVC), for: .touchUpInside)
        return btn
    }()
    
    private let orSeparatorView = OrView()
    
    private lazy var googleLoginBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "google-icon"), for: .normal)
        btn.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)
        return btn
    }()
    
    private lazy var facebookLoginBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "facebook-icon"), for: .normal)
        btn.addTarget(self, action: #selector(handleFacebookLogin), for: .touchUpInside)
        return btn
    }()
    
    private let createNewAccount: UIButton = {
        let btn = UIButton(type: .system)
        btn.attributedTitle(firstPart: "Don't have an account? ", secondPart: "Sign Up")
        btn.addTarget(self, action: #selector(openRegisterVC), for: .touchUpInside)
        return btn
    }()

    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        addNotificationObsers()
    }
    
    //MARK: Actions
    @objc func handleLogin() {
        guard let email = emialTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        showLoader(true)
        
        AuthorService.loginUser(withEmail: email, password: password, completion: { (result, error) in
            if let error = error {
                print("DEBUG failed to login the user \(error.localizedDescription)")
                return
            }
            
            self.delegate?.anuthenticalDidComplete()
        })
        
        showLoader(false)
    }
    
    @objc func handleGoogleLogin() {
        AuthorService.loginByGoogle(presentingVC: self, completion: { (error) in
            
            if let error = error {
                print("DEBUG failed to login the user \(error.localizedDescription)")
                return
            }
            
            self.delegate?.anuthenticalDidComplete()
            
        })
    }
    
    @objc func handleFacebookLogin() {
        
    }
    
    @objc func openResetPasswordVC() {
        let targetVC = ResetPasswordVC()
        targetVC.delegate = self
        targetVC.email = emialTextField.text
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    
    @objc func openRegisterVC() {
        let targetVC = RegisterVC()
        targetVC.delegate = delegate
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emialTextField {
            viewModel.email = emialTextField.text
        } else if sender == passwordTextField {
            viewModel.password = passwordTextField.text
        }
        
        if viewModel.formIsValid {
            loginBtn.isEnabled = true
            loginBtn.backgroundColor = viewModel.backgroundColor
            loginBtn.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        } else {
            loginBtn.isEnabled = false
            loginBtn.backgroundColor = viewModel.backgroundColor
            loginBtn.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        }
    }
    
    //MARK: Helpers
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        let gradient = GradientColor(frame: view.bounds)
        view.addSubview(gradient)
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stackView = UIStackView(arrangedSubviews: [emialTextField, passwordTextField, loginBtn, forgotPassword])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        view.addSubview(stackView)
        stackView.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(orSeparatorView)
        orSeparatorView.centerX(inView: view, topAnchor: stackView.bottomAnchor, paddingTop: 10)
        orSeparatorView.setDimensions(height: 30, width: view.bounds.width)
        
        let stackViewIcon = UIStackView(arrangedSubviews: [googleLoginBtn, facebookLoginBtn])
        stackViewIcon.axis = .horizontal
        stackViewIcon.spacing = 20
        stackViewIcon.distribution = .fillEqually
        
        view.addSubview(stackViewIcon)
        stackViewIcon.centerX(inView: orSeparatorView, topAnchor: orSeparatorView.bottomAnchor, paddingTop: 35)
        
        view.addSubview(createNewAccount)
        createNewAccount.centerX(inView: view)
        createNewAccount.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 10)
        
    }
    
    func addNotificationObsers() {
        emialTextField.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
    }

}

extension LoginVC: ResetPasswordVCDelegate {
    func handleEventFromResetButtn(form controller: ResetPasswordVC) {
        self.navigationController?.popViewController(animated: true)
        self.showMessage(withTitle: "Success", message: "You changed your email successfully!")
    }
}
