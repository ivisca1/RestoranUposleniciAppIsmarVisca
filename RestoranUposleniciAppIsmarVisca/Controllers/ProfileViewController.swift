//
//  ProfileViewController.swift
//  RestoranUposleniciAppIsmarVisca
//
//  Created by User on 10. 7. 2023..
//

import UIKit
import RSKImageCropper

class ProfileViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var nameSurnameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpEverything()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyVariables.foodManager.delegate = self
        
        refreshView()
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        MyVariables.foodManager.logOutUser()
    }
    
    @IBAction func changeDetailsPressed(_ sender: UIButton) {
        let controller = ChangeUserDetailsViewController.instantiate()
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Očekivana je slika, ali je dostavljeno sljedeće:: \(info)")
        }
        
        picker.dismiss(animated: false, completion: { () -> Void in

            var imageCropVC : RSKImageCropViewController!

            imageCropVC = RSKImageCropViewController(image: image, cropMode: RSKImageCropMode.circle)

            imageCropVC.delegate = self

            self.navigationController?.pushViewController(imageCropVC, animated: true)

        })
    }
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        navigationController?.popViewController(animated: true)
    }

    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        profileImageView.image = croppedImage
        MyVariables.foodManager.uploadProfilePicture(image: croppedImage)
        navigationController?.popViewController(animated: true)
    }
}

extension ProfileViewController : FoodManagerDelegate {
    func didDownloadUpdatePicture(_ foodManager: FoodManager) {
        profileImageView.image = MyVariables.foodManager.image
    }
    
    func didLogOutUser(_ foodManager: FoodManager) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LogInNavigationController")

        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
    }
    
    func didUpdateUser(_ foodManager: FoodManager) {}
    func didFetchOrders(_ foodManager: FoodManager) {}
    func didSignInUser(_ foodManager: FoodManager, user: User?) {}
    func didFailWithError(error: String) {}
}

extension ProfileViewController {
    
    private func setUpEverything() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        
        profileImageView.image = MyVariables.foodManager.image
        
        MyVariables.foodManager.getProfilePicture()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func refreshView() {
        
        let user = MyVariables.foodManager.user!
        
        nameSurnameLabel.text = "\(user.name) \(user.surname)"
        phoneNumberLabel.text = user.phoneNumber
        emailLabel.text = user.email
        addressLabel.text = user.address
    }
}
