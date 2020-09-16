//
//  EditPodcastViewController.swift
//  VK Podcasts (Vezdekod)
//
//  Created by Alex Yatsenko on 16.09.2020.
//  Copyright © 2020 AlexislogS. All rights reserved.
//

import UIKit
import MediaPlayer

final class EditPodcastViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var selectSongButton: UIButton!
    
    var podcastURL: URL?
    private var player: AVPlayer!
    private var timeCodes = [TimeCode]()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let podcastURL = podcastURL {
            player = AVPlayer(url: podcastURL)
        }
    }
    
    @IBAction func playPressed() {
        if player.timeControlStatus == .playing {
            player.pause()
        } else if player.status == .readyToPlay {
            player.play()
        }
    }
    
    @IBAction func addNewTimecodePressed() {
        let timecode = TimeCode(title: "Начало обсуждения", time: "05:41")
        timeCodes.append(timecode)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    @IBAction func selectSongPressed() {
        if selectSongButton.isSelected {
            showChangeSongActionSheet()
            return
        }
        selectSongButton.setImage(#imageLiteral(resourceName: "Frame 19-1"), for: .selected)
        selectSongButton.isSelected = true
        #if targetEnvironment(simulator)
        print("music selected")
        if let path = Bundle.main.path(forResource: "Ehrling - Take Me Away", ofType: "wav") {
            player.replaceCurrentItem(with: AVPlayerItem(asset: AVAsset(url: URL(fileURLWithPath: path))))
        }
        #else
        changeMusic()
        #endif
    }
    
    private func showChangeSongActionSheet() {
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: AlertTitle.changeMusic, style: .default) { _ in
            self.changeMusic()
        })
        actionSheet.addAction(UIAlertAction(title: AlertTitle.deleteMusic, style: .destructive) { _ in
            guard let podcastURL = self.podcastURL else { return }
            self.player.replaceCurrentItem(with: AVPlayerItem(asset: AVAsset(url: podcastURL)))
        })
        actionSheet.addAction(UIAlertAction(title: AlertTitle.cancel, style: .cancel))
        present(actionSheet, animated: true)
    }
    
    private func changeMusic() {
        let controller = MPMediaPickerController(mediaTypes: .music)
        controller.allowsPickingMultipleItems = true
        controller.popoverPresentationController?.sourceView = selectSongButton
        controller.delegate = self
        present(controller, animated: true)
    }
}

    // MARK: - MPMediaPickerControllerDelegate

extension EditPodcastViewController: MPMediaPickerControllerDelegate {
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController,
                     didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        let musicPlayer = MPMusicPlayerController.systemMusicPlayer
        musicPlayer.setQueue(with: mediaItemCollection)
        mediaPicker.dismiss(animated: true)
        musicPlayer.play()
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true)
    }
}

    // MARK: - UITableViewDataSource

extension EditPodcastViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeCodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimeCodeCell.reuseID, for: indexPath) as! TimeCodeCell
        let timeCode = timeCodes[indexPath.row]
        cell.configure(timeCode: timeCode)
        return cell
    }
}

extension EditPodcastViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            timeCodes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
