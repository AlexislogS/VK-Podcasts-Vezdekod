//
//  PreviewCell.swift
//  VK Podcasts (Vezdekod)
//
//  Created by Alex Yatsenko on 17.09.2020.
//  Copyright © 2020 AlexislogS. All rights reserved.
//

import UIKit

final class PreviewCell: UITableViewCell {

    static let reuseID = "previewCell"

    @IBOutlet private weak var timeCodeTitle: UILabel!
    @IBOutlet private weak var timeCodeTime: UILabel!
    
    func configure(timeCode: TimeCode) {
        timeCodeTitle.text = timeCode.title
        timeCodeTime.text = timeCode.time
    }
}
