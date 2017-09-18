//
//  File.swift
//  MusicPlayer
//
//  Created by Staham Nguyen on 17/09/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit
import AVFoundation

var playingSongIndex = 0

let musicFormat = ".mp3"
private let noInfo = ""

private let titleOfVC = "Playing"

private var defaultPlayedTimeLabelText = "00:00"

class SecondVC: UIViewController {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var playedTime: UILabel!
    @IBOutlet weak var remainingTime: UILabel!
    @IBOutlet weak var playedTimeSlider: UISlider!
    
    @IBOutlet weak var backwardButton: CustomButton!
    @IBOutlet weak var playButton: CustomButton!
    @IBOutlet weak var forwardButton: CustomButton!
    
    private var audioPathInUrl = NSURL()
    
    private var remainingSecond: Int = 0
    private var remainingMinute: Int = 0
    private var playedSecond: Int = 0
    private var playedMinute: Int = 0
    private var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = titleOfVC
        
        songNameLabel.sizeToFit()
        artistNameLabel.sizeToFit()
        
        updateUI(forSongWithName: songList[playingSongIndex])
        playSong(withName: songList[playingSongIndex])
    }
    
    // ---   MAIN SETUP FUNCS   ---
    
    private func updateUI(forSongWithName name: String) {
        
        if let audioPathInString = Bundle.main.path(forResource: name, ofType: musicFormat) {
            
            audioPathInUrl = NSURL(fileURLWithPath: audioPathInString)
            
            let selectedSong = AVPlayerItem(url: audioPathInUrl as URL)
            let metadataList = selectedSong.asset.metadata
            
            let asset = AVURLAsset(url: NSURL(fileURLWithPath: audioPathInString) as URL, options: nil)
            let audioDuration = asset.duration
            let audioDurationInSecond = CMTimeGetSeconds(audioDuration)
            let audioDurationInSecondInt = Int(floorf(Float(audioDurationInSecond)))
            
            // Check if there are some main metadata missing or not
            
            let artistMetadata = metadataList.filter { $0.commonKey == "artist" }
            let titleMetadata = metadataList.filter { $0.commonKey == "title" }
            let artworkMetadata = metadataList.filter { $0.commonKey == "artwork" }
            
            // Update UI based on whether the main metadata are missing or not
            
            if artistMetadata.isEmpty {
                updateArtistName(withText: noInfo)
            } else {
                if let stringValue = artistMetadata[0].value as? String {
                    updateArtistName(withText: stringValue)
                }
            }
            
            if artworkMetadata.isEmpty {
                updateImageView(image: #imageLiteral(resourceName: "default"))
            } else {
                if let audioImage = UIImage(data: artworkMetadata[0].value as! Data) {
                    updateImageView(image: audioImage)
                }
            }
            
            if titleMetadata.isEmpty {
                updateSongName(withText: songList[playingSongIndex])
            } else {
                if let stringValue = titleMetadata[0].value as? String {
                    updateSongName(withText: stringValue)
                }
            }
            
            updatePlayingProgessDisplay(withSongDuration: audioDurationInSecondInt)
            
        }
        
    }
    
    private func playSong(withName name: String) {
        
        if let audioPathInString = Bundle.main.path(forResource: name, ofType: musicFormat) {
            
            audioPathInUrl = NSURL(fileURLWithPath: audioPathInString)
            
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: audioPathInUrl as URL)
            } catch {
                print(error)
                return
            }
            
            audioPlayer.play()
        }
    }
    
    // ---   SUPPORTIVE FUNCS   ---
    
    private func updateImageView(image: UIImage) {
        background.image = image
        coverImageView.image = image
    }
    
    private func updateSongName(withText text: String) {
        songNameLabel.text = text
    }
    
    private func updateArtistName(withText text: String) {
        artistNameLabel.text = text
    }
    
    private func updatePlayingProgessDisplay(withSongDuration durationInSecond: Int) {
        
        //Setup slider
        playedTimeSlider.value = 0
        playedTimeSlider.maximumValue = Float(durationInSecond)
        playedTimeSlider.minimumValue = 0
        
        // Initial values
        let remainingTimeInMinute = durationInSecond / 60
        let remainingTimeInSecond = durationInSecond % 60
        let formattedRemainingTimeInMinute = String(format: "%02d", remainingTimeInMinute)
        let formattedRemainingTimeInSecond = String(format: "%02d", remainingTimeInSecond)
        remainingTime.text = formattedRemainingTimeInMinute + ":" + formattedRemainingTimeInSecond
        
        // Kick off the timer
        self.remainingSecond = remainingTimeInSecond
        self.remainingMinute = remainingTimeInMinute
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        if self.remainingSecond > 0 {
            self.remainingSecond -= 1
            adjustRemainingTimeLabelTextWith(minute: remainingMinute, second: remainingSecond)
        } else {
            if remainingMinute < 1 {
                forwardButtonPressed(self) // Auto move forward to the next song if the current is finished
            } else {
                remainingMinute -= 1
                remainingSecond = 59
                adjustRemainingTimeLabelTextWith(minute: remainingMinute, second: remainingSecond)
            }
        }
        
        if self.playedSecond < 59 {
            self.playedSecond += 1
            adjustPlayedTimeLabelTextWith(minute: playedMinute, second: playedSecond)
        } else {
            playedMinute += 1
            playedSecond = 0
            adjustPlayedTimeLabelTextWith(minute: playedMinute, second: playedSecond)
        }
        
        playedTimeSlider.value += 1
    }
    
    private func adjustRemainingTimeLabelTextWith(minute: Int, second: Int) {
        let formattedRemainingTimeInMinute = String(format: "%02d", minute)
        let formattedRemainingTimeInSecond = String(format: "%02d", second)
        remainingTime.text = formattedRemainingTimeInMinute + ":" + formattedRemainingTimeInSecond
    }
    
    private func adjustPlayedTimeLabelTextWith(minute: Int, second: Int) {
        let formattedPlayedTimeInMinute = String(format: "%02d", minute)
        let formattedPlayedTimeInSecond = String(format: "%02d", second)
        playedTime.text = formattedPlayedTimeInMinute + ":" + formattedPlayedTimeInSecond
    }
    
    private func resetAudioPlayerAndTimerDisplay() {
        timer.invalidate()
        playedSecond = 0
        playedMinute = 0
        playedTimeSlider.value = 0
        playedTime.text = defaultPlayedTimeLabelText
    }
    
    private func moveToSong(with index: Int) {
        let songName = songList[index]
        playSong(withName: songName)
        updateUI(forSongWithName: songName)
    }
    
    // ---   BUTTONS' FUNCS   ----
    
    @IBAction func playButtonPressed(_ sender: Any) {
        if audioPlayer.isPlaying {
            timer.invalidate()
            audioPlayer.pause()
            playButton.setImage(#imageLiteral(resourceName: "playButton"), for: .normal)
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
            audioPlayer.play()
            playButton.setImage(#imageLiteral(resourceName: "pauseButton"), for: .normal)
        }
        
    }
    
    @IBAction func forwardButtonPressed(_ sender: Any) {
        resetAudioPlayerAndTimerDisplay()
        playingSongIndex = playingSongIndex == songList.count - 1 ? 0 : playingSongIndex + 1
        moveToSong(with: playingSongIndex)
    }
    
    @IBAction func backwardButtonPressed(_ sender: Any) {
        resetAudioPlayerAndTimerDisplay()
        playingSongIndex = playingSongIndex == 0 ? songList.count - 1 : playingSongIndex - 1
        moveToSong(with: playingSongIndex)
    }
    
    @IBAction func valueOfSliderChanged(_ sender: UISlider) {
        
        // Stop current timer
        timer.invalidate()
        
        // Setup new time
        let chosenTimeInInt = Int(floorf(sender.value))
        let remainingTimeInInt = Int(floorf(sender.maximumValue)) - chosenTimeInInt
        playedSecond = chosenTimeInInt % 60
        playedMinute = chosenTimeInInt / 60
        remainingSecond = remainingTimeInInt % 60
        remainingMinute = remainingTimeInInt / 60
        
        // Update UI
        adjustRemainingTimeLabelTextWith(minute: remainingMinute, second: remainingSecond)
        adjustPlayedTimeLabelTextWith(minute: playedMinute, second: playedSecond)
        
        // Setup new playing time for audio player
        let chosenTimeInDouble = Double(chosenTimeInInt)
        audioPlayer.currentTime = chosenTimeInDouble
        
        // Kick off new timer if the audio player is still playing. If it not, then waiting for user to press Play button
        if audioPlayer.isPlaying {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        }
    }
}
