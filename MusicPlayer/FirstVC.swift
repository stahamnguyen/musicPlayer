//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Staham Nguyen on 17/09/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit
import AVFoundation

var songList = [String]()

var audioPlayer = AVAudioPlayer()

private let titleOfVC = "Song list"

class FirstVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSongName()
        
        navigationItem.title = titleOfVC
        
        tableView.tableFooterView = UIView()
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
            print(error)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = songList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playingSongIndex = indexPath.row
    }

}

