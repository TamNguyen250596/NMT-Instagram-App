//
//  RegisterVC.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 05/01/2022.
//

import UIKit

class RegisterVC: UIViewController {
    //MARK: Properties
    private var viewModel = RegisterViewModel()
    var imageDidChoose: UIImage?
    weak var delegate: AuthenticationDelegate?
    
    private lazy var pickUpImgBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "plus_photo"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(pickUpImage), for: .touchUpInside)
        return btn
    }()
    
    private let emailTextField: UITextField = {
        let textField = CustomTextField(placeholder: "Email")
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = CustomTextField(placeholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let fullNameTextField: UITextField = {
        let textField = CustomTextField(placeholder: "Full Name")
        return textField
    }()
    
    private let userNameTextField: UITextField = {
        let textField = CustomTextField(placeholder: "User Name")
        return textField
    }()
    
    private let signUpBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.attributedDesign(titleBtn: "Sign Up")
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return btn
    }()
    
    private let alreadyHaveAccountBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.attributedTitle(firstPart: "Already have an account? ", secondPart: "Log In")
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
    @objc func handleSignUp() {
        guard let email = emailTextField.text else {return}
        guard let password =  passwordTextField.text else {return}
        guard let fullName = fullNameTextField.text else {return}
        guard let userName = userNameTextField.text else {return}
        guard let profileImage = imageDidChoose else {return}
        
        let userID = AuthorIDs(email: email, password: password, fullName: fullName, userName: userName, profileImage: profileImage)
        AuthorService.registerUser(withCredential: userID, completion: { (error) in
            if let error = error {
                print("DEBUG failed to register the user \(error.localizedDescription)")
                return
            }
        
            self.delegate?.anuthenticalDidComplete()
        })
    }
    
    @objc func goBackToLoginVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = emailTextField.text
        } else if sender == passwordTextField {
            viewModel.password = passwordTextField.text
        } else if sender == fullNameTextField {
            viewModel.fullName = fullNameTextField.text
        } else if sender == userNameTextField {
            viewModel.userName = userNameTextField.text
        }
        
        if viewModel.formIsValid {
            signUpBtn.isEnabled = true
            signUpBtn.backgroundColor = viewModel.backgroundColor
            signUpBtn.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        } else {
            signUpBtn.isEnabled = false
            signUpBtn.backgroundColor = viewModel.backgroundColor
            signUpBtn.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        }
    }
    
    @objc func pickUpImage() {
        showPhotoMenu()
    }

    //MARK: Helpers
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        let gradient = GradientColor(frame: view.bounds)
        view.addSubview(gradient)
        
        view.addSubview(pickUpImgBtn)
        pickUpImgBtn.centerX(inView: view)
        pickUpImgBtn.setDimensions(height: 140, width: 140)
        pickUpImgBtn.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, fullNameTextField, userNameTextField, signUpBtn])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        view.addSubview(stackView)
        stackView.anchor(top: pickUpImgBtn.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountBtn)
        alreadyHaveAccountBtn.centerX(inView: view)
        alreadyHaveAccountBtn.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 10)
    }
    
    func addNotificationObsers() {
        emailTextField.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
    }
}

//MARK: Image Picker Delegates
extension RegisterVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageDidChoose = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        pickUpImgBtn.layer.cornerRadius = pickUpImgBtn.frame.width / 2
        pickUpImgBtn.layer.masksToBounds = true
        pickUpImgBtn.layer.borderColor = UIColor.white.cgColor
        pickUpImgBtn.layer.borderWidth = 2
        pickUpImgBtn.setImage(imageDidChoose?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated:  true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:  true, completion: nil)
    }
    
    //MARK: Image Helper Methods
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.view.tintColor = view.tintColor
        present(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.view.tintColor = view.tintColor
        present(imagePicker, animated: true, completion: nil)
    }
    
    func considerMeansOfChoosingPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu() {
        considerMeansOfChoosingPhoto()
        
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet)
        
        let actCancel = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil)
        alert.addAction(actCancel)
        
        let actPhoto = UIAlertAction(
            title: "Take Photo",
            style: .default,
            handler: { [weak self] _ in
                
                if let weakSelf = self {
                    weakSelf.takePhotoWithCamera()
                }
            })
        alert.addAction(actPhoto)
        
        let actLibrary = UIAlertAction(
            title: "Choose From Library",
            style: .default,
            handler: { [weak self] _ in
                
                if let weakSelf = self {
                    weakSelf.choosePhotoFromLibrary()
                }
            })
        alert.addAction(actLibrary)
        
        present(alert, animated: true, completion: nil)
    }
}
