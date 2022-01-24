//
//  ImageUploader.swift
//  Instagram
//
//  Created by Nguyen Minh Tam on 07/01/2022.
//

import FirebaseStorage

struct ImageUploader {
    static func uploadImage(image: UIImage, completion: @escaping CompletionHandlerStringToVoid) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        let fileName = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "profile_images/\(fileName)")
        
        ref.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("DEBUG: Failed to upload \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL(completion: { (url, error) in
                guard let imageUrl = url?.absoluteString else {return}
                completion(imageUrl)
            })
            
        }
    }
    
    static func uploadImageForPostService(image: UIImage, completion: @escaping CompletionHandlerStringToVoid) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        let fileName = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "post_images/\(fileName)")
        
        ref.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("DEBUG: Failed to upload \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL(completion: { (url, error) in
                guard let imageUrl = url?.absoluteString else {return}
                completion(imageUrl)
            })
            
        }
    }
}
