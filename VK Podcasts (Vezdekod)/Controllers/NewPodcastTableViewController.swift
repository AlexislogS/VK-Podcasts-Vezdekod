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
    @IBOutlet private weak var podcastImageView: UIImageView!
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
