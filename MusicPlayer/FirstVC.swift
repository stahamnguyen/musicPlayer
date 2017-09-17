//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Staham Nguyen on 17/09/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit
import AVFoundation

private let musicFormat = ".mp3"

private var songList = [String]()
private var audioPlayer = AVAudioPlayer()

class FirstVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSongName()
    }
    
    private func getSongName() {
        let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        
        do {
            let songPaths = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            for songPath in songPaths {
                var song = songPath.absoluteString
                
                if song.contains(musicFormat) {
                    let findString = song.components(separatedBy: "/")
                    song = findString[findString.count - 1]
                    song = song.replacingOccurrences(of: "%20", with: " ")
                    song = song.replacingOccurrences(of: musicFormat, with: "")
                    songList.append(song)
                }
            }
            
        } catch {
            
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = songList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let audioPathInString = Bundle.main.path(forResource: songList[indexPath.row], ofType: musicFormat) {
            
            let audioPathInURL = NSURL(fileURLWithPath: audioPathInString)
            
            let selectedSong = AVPlayerItem(url: audioPathInURL as URL)
            let metadataList = selectedSong.asset.metadata
            
            tabBarController?.selectedIndex = 1
            
            for item in metadataList {
                if item.commonKey == "artwork" {
                    if let audioImage = UIImage(data: item.value as! Data) {
                        if let secondVC = tabBarController?.viewControllers?[1] as? SecondVC {
                            secondVC.updateImageView(image: audioImage)
                        }
                    }
                }
            }
        }
        
        
        
        
        
//
//        do {
//            try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
//            
//        } catch {
//            
//        }
//        
//        audioPlayer.play()
    }

}

