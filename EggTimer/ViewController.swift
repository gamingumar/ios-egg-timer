//
//  ViewController.swift
//  EggTimer
//
//  Created by gamingumar on 09/05/2023.
//  Copyright © 2023 While Geek. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    let eggTimes: [String: Float] = ["Soft": 3, "Medium": 4, "Hard": 7] // dictionary
    
    var secondsRemaining: Float = 60
    
    var timer = Timer()
    
    var hardness = "Soft"
    
    var player: AVAudioPlayer?
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }
            
            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        hardness = sender.currentTitle!
        
        timer.invalidate()
        
        secondsRemaining = eggTimes[hardness]!
        
        progressBar.progress = 0
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        
        print("final timer \(eggTimes[hardness]!)")
    }
    
    @objc func updateTimer() {
        if (secondsRemaining > 0) {
            
            secondsRemaining -= 1
            
            let totalTime = eggTimes[hardness]!
            
            let timePassed = totalTime - secondsRemaining

            let percentage = timePassed / totalTime

            titleLabel.text = "\(hardness)"
            
            print("Total Time \(totalTime) Rem Time: \(secondsRemaining) Time Passed: \(timePassed) Progress: \(percentage)")
            
            
            progressBar.progress = percentage
            
            
        } else {
            timer.invalidate()
            titleLabel.text = "Done!"
            playSound()
        }
    }
    
    
}
