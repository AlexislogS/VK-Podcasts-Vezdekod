//
//  PreviewViewController.swift
//  VK Podcasts (Vezdekod)
//
//  Created by Alex Yatsenko on 17.09.2020.
//  Copyright © 2020 AlexislogS. All rights reserved.
//

import UIKit

final class PreviewViewController: UIViewController {
    
    var timeCodes = [TimeCode]()
    var podcastImage: UIImage?
    var podcastTitle: String?
    var podcastDescription: String?
    var podcastDuration: String?
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var previewImageView: UIImageView!
    @IBOutlet private weak var previewTitleLabel: UILabel!
    @IBOutlet private weak var previewDescriptionLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewImageView.image = podcastImage
        previewTitleLabel.text = podcastTitle
        previewDescriptionLabel.text = podcastDescription
        durationLabel.text = "Длительность: \(podcastDuration ?? "0")"
    }
}

    // MARK: - UITableViewDataSource

extension PreviewViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return timeCodes.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PreviewCell.reuseID, for: indexPath) as! PreviewCell
        let timeCode = timeCodes[indexPath.row]
        cell.configure(timeCode: timeCode)
        return cell
    }
}
