//
//  TimeCodeCell.swift
//  VK Podcasts (Vezdekod)
//
//  Created by Alex Yatsenko on 16.09.2020.
//  Copyright © 2020 AlexislogS. All rights reserved.
//

import UIKit

final class TimeCodeCell: UITableViewCell {

    @IBOutlet private weak var timeCodeTitle: UITextField!
    @IBOutlet private weak var timeCodeTime: UITextField!
    
    static let reuseID = "timeCodeCell"
    
    func configure(timeCode: TimeCode) {
        timeCodeTitle.text = timeCode.title
        timeCodeTime.text = timeCode.time
    }
}
