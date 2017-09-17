//
//  File.swift
//  MusicPlayer
//
//  Created by Staham Nguyen on 17/09/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

class SecondVC: UIViewController {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var backwardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func updateImageView(image: UIImage) {
        background.image = image
        coverImageView.image = image
    }
    
}
