//
//  NewPodcastTableViewController.swift
//  VK Podcasts (Vezdekod)
//
//  Created by Alex Yatsenko on 16.09.2020.
//  Copyright © 2020 AlexislogS. All rights reserved.
//

import UIKit

final class NewPodcastTableViewController: UITableViewController {
    
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var podcastImageView: UIImageView! {
        didSet {
            podcastImageView.layer.cornerRadius = 8
            podcastImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                         action: #selector(uploadImage(recognizer:))))
        }
    }
    @IBOutlet private weak var podcastTitleTextField: UITextField!
    @IBOutlet private weak var podcastDescriptionTextField: UITextField!
    @IBOutlet private weak var explicitButton: UIButton!
    @IBOutlet private weak var excludeButton: UIButton!
    @IBOutlet private weak var trailerButton: UIButton!
    @IBOutlet private weak var uploadStackView: UIStackView!
    
    @IBOutlet private weak var defaultPodcastImageView: UIImageView!
    @IBOutlet private weak var podcastNameLabel: UILabel!
    @IBOutlet private weak var podcastDurationLabel: UILabel!
    @IBOutlet private weak var podcastEditLabel: UILabel!
    @IBOutlet private weak var podcastEditButton: UIButton!
    
    private var imageChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [explicitButton, excludeButton, trailerButton].forEach { $0?.setImage(#imageLiteral(resourceName: "check_box_on_24"), for: .selected)}
    }
    
    @IBAction func checkBoxPressed(_ sender: UIButton) {
        sender.isSelected = sender.isSelected ? false : true
    }
    
    @IBAction func uploadPressed(_ sender: UIButton) {
        sender.isHidden = true
        uploadStackView.isHidden = true
        [defaultPodcastImageView, podcastNameLabel, podcastDurationLabel, podcastEditLabel, podcastEditButton].forEach { $0?.isHidden = false }
    }
    
    @IBAction func podcastEditButtonPressed() {
        
    }
    
    @IBAction private func doneButtonPressed() {
        
    }
    
    @objc private func uploadImage(recognizer: UITapGestureRecognizer) {
        guard recognizer.state == .recognized else { return }
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        camera.setValue(UIImage(systemName: "camera"), forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        let photo = UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.chooseImagePicker(source: .photoLibrary)
        })
        photo.setValue(UIImage(systemName: "photo"), forKey: "image")
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        cancel.setValue(UIImage(systemName: "xmark"), forKey: "image")
        cancel.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        [camera, photo, cancel].forEach { actionSheet.addAction($0) }
        present(actionSheet, animated: true)
    }
}

    // MARK: - UITextFieldDelegate

extension NewPodcastTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == podcastTitleTextField {
            podcastDescriptionTextField.becomeFirstResponder()
        } else {
            podcastDescriptionTextField.resignFirstResponder()
        }
        return true
    }
}

    // MARK: - UIImagePickerControllerDelegate

extension NewPodcastTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        } else {
            showAlert(with: AlertTitle.failedToGetImage,
                      and: AlertTitle.pleaseTryAgain)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage {
            podcastImageView.contentMode = .scaleAspectFill
            podcastImageView.image = image
            imageChanged = true
        }
        picker.presentingViewController?.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.presentingViewController?.dismiss(animated: true)
    }
}
