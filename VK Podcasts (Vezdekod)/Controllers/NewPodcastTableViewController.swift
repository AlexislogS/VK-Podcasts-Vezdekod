//
//  NewPodcastTableViewController.swift
//  VK Podcasts (Vezdekod)
//
//  Created by Alex Yatsenko on 16.09.2020.
//  Copyright © 2020 AlexislogS. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

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
    @IBOutlet private weak var uploadButton: UIButton!
    
    private var imageChanged = false
    private var podcastURL: URL?
    
    private var dateComponentsFormatter: DateComponentsFormatter {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute, .second]
    //        formatter.unitsStyle = .short
            return formatter
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [explicitButton, excludeButton, trailerButton].forEach { $0?.setImage(#imageLiteral(resourceName: "check_box_on_24"), for: .selected)}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editVC = segue.destination as? EditPodcastViewController {
            editVC.podcastURL = podcastURL
        }
    }
    
    @IBAction func checkBoxPressed(_ sender: UIButton) {
        sender.isSelected = sender.isSelected ? false : true
    }
    
    @IBAction func uploadPressed() {
        #if targetEnvironment(simulator)
        let path = Bundle.main.path(forResource: "test", ofType: "mp3")!
            let url = URL(fileURLWithPath: path)
            updateUIAfterImport(for: url)
        
        #else
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeAudio as String], in: .import)
        documentPicker.delegate = self
        present(documentPicker, animated: true)
        #endif
    }
    
    @IBAction private func doneButtonPressed() {
        handleDoneButton()
    }
    
    private func handleDoneButton() {
        if imageChanged,
            podcastTitleTextField.hasText,
            podcastDescriptionTextField.hasText {
        } else {
            showAlert(with: AlertTitle.wrongInput,
                      and: AlertTitle.pleaseFill)
        }
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
            handleDoneButton()
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

    // MARK: - UIDocumentPickerDelegate

extension NewPodcastTableViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first,
            let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let sandBoxURL = dir.appendingPathComponent(selectedFileURL.lastPathComponent)
        if FileManager.default.fileExists(atPath: sandBoxURL.path) {
            print("File already exists")
        } else {
            do {
                try FileManager.default.copyItem(at: selectedFileURL, to: sandBoxURL)
                updateUIAfterImport(for: selectedFileURL)
            } catch let error {
                showAlert(with: AlertTitle.failedToCopyFile,
                          and: error.localizedDescription)
            }
        }
    }
    
    private func updateUIAfterImport(for url: URL) {
        podcastURL = url
        podcastNameLabel.text = url.lastPathComponent
        let player = AVPlayer(url: url)
        podcastDurationLabel.text = dateComponentsFormatter.string(from: player.currentItem?.asset.duration.seconds ?? 0)
        [uploadButton, uploadStackView].forEach { $0?.isHidden = true }
        [defaultPodcastImageView, podcastNameLabel, podcastDurationLabel, podcastEditLabel, podcastEditButton].forEach { $0?.isHidden = false }
        doneButton.isEnabled = true
    }
}
