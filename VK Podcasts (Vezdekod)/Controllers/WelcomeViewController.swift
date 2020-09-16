//
//  ViewController.swift
//  VK Podcasts (Vezdekod)
//
//  Created by Alex Yatsenko on 16.09.2020.
//  Copyright © 2020 AlexislogS. All rights reserved.
//

import UIKit

final class WelcomeViewController: UIViewController {

    @IBAction func close(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
    
}

