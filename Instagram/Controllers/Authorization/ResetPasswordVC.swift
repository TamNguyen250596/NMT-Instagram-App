//
//  ResetPasswordVC.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 21/01/2022.
//

import UIKit

protocol ResetPasswordVCDelegate: AnyObject {
    func handleEventFromResetButtn(form controller: ResetPasswordVC)
}

class ResetPasswordVC: UIViewController {
    //MARK: Properties
    private var viewModel = ResetPasswordViewModel()
    weak var delegate: ResetPasswordVCDelegate?
    var email: String?
    
    private let iconImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "Instagram_logo_white"))
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    private let emialTextField = CustomTextField(placeholder: "Email")
    
    private lazy var resetPassBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.attributedDesign(titleBtn: "Reset Password")
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(handleResetPass), for: .touchUpInside)
        return btn
    }()
    
    private lazy var backBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = .white
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.addTarget(self, action: #selector(goBackToLoginVC), for: .touchUpInside)
        return btn
    }()
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        addNotificationObsers()
    }
    
    //MARK: Actions
    @objc func handleResetPass() {
        guard let email = emialTextField.text else {return}
        
        showLoader(true)
        AuthorService.resetPassword(newEmail: email, completion: { (error) in
            if let error = error {
                print("DEBUG failed to reset the user \(error.localizedDescription)")
                self.showMessage(withTitle: "Error", message: "\(error)")
                return
            }
            
            self.delegate?.handleEventFromResetButtn(form: self)
        })
    }
    
    @objc func goBackToLoginVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emialTextField {
            viewModel.email = emialTextField.text
        }
        
        if viewModel.formIsValid {
            resetPassBtn.isEnabled = true
            resetPassBtn.backgroundColor = viewModel.backgroundColor
            resetPassBtn.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        } else {
            resetPassBtn.isEnabled = false
            resetPassBtn.backgroundColor = viewModel.backgroundColor
            resetPassBtn.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        }
    }
    
    //MARK: Helpers
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        let gradient = GradientColor(frame: view.bounds)
        view.addSubview(gradient)
        
        view.addSubview(backBtn)
        backBtn.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stackView = UIStackView(arrangedSubviews: [emialTextField, resetPassBtn])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        view.addSubview(stackView)
        stackView.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        if let email = email {
            emialTextField.text = email
            viewModel.email = email
            textDidChange(sender: emialTextField)
        }
    }
    
    func addNotificationObsers() {
        emialTextField.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
    }
    
}
