//
//  UploadPostController.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 12/01/2022.
//

import UIKit
import Firebase

protocol UploadPostDelegate: AnyObject {
    func dismissAnOpenVC()
}

class UploadPostController: UIViewController {
    //MARK: Properties
    private let postedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 3
        imageView.backgroundColor = .orange
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let commentView: UITextView = {
        let textView = CustomTextView()
        textView.placeholder = "Enter caption"
        textView.textColor = .darkText
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.positionShouldCenter = false
        return textView
    }()
    
    private let wordCountLbl: UILabel = {
        let label = UILabel()
        label.text = "0/100"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    var imageDidChoose: UIImage? {
        didSet {
            postedImage.image = imageDidChoose
        }
    }
    var user: User?
    weak var delegate: UploadPostDelegate?
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    //MARK: Actions
    @objc func cancelPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func sharePressed() {
        guard let image = imageDidChoose else {return}
        guard let user = user else {return}
        
        showLoader(true)
        
        PostService.postUserNews(
            caption: commentView.text, image: image, user: user,
            completion: { (error) in
                self.showLoader(false)
                
                if let error = error {
                    print("DEBUG: Error about posting \(error.localizedDescription)")
                    return
                }
    
                self.delegate?.dismissAnOpenVC()
            })
    }
    
    //MARK: Helpers
    func checkMaxLength(_ textView: UITextView) {
        if (textView.text.count) > 100 {
            textView.deleteBackward()
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        title = "Upload Post"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel, target: self,
            action: #selector(cancelPressed))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Share", style: .done, target: self,
            action: #selector(sharePressed))
        
        
        view.addSubview(postedImage)
        postedImage.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 10)
        postedImage.setDimensions(height: 180, width: 180)
        
        view.addSubview(commentView)
        commentView.anchor(top: postedImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingRight: 0, height: 200)
        commentView.delegate = self
        
        view.addSubview(wordCountLbl)
        wordCountLbl.anchor(bottom: commentView.bottomAnchor, right: commentView.rightAnchor,paddingBottom: 0, paddingRight: 0)
    }
}

// MARK: UITextViewDelegate
extension UploadPostController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        let wordCount = commentView.text.count
        wordCountLbl.text = "\(wordCount)/100"
        
        checkMaxLength(textView)
    }
}
