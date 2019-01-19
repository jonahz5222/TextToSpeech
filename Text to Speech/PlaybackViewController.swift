//
//  PlaybackViewController.swift
//  Text to Speech
//
//  Created by Jonah Zukosky on 1/19/19.
//  Copyright © 2019 Zukosky, Jonah. All rights reserved.
//

import UIKit
import AVFoundation

class PlaybackViewController: UIViewController {

    @IBOutlet weak var controlsContainer: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var singalongLabel: UILabel!
    
    var text: String?
    let synth = AVSpeechSynthesizer()
    
    let playIcon = UIImage(named: "playIcon")
    let pauseIcon = UIImage(named: "pauseIcon")
    
    var playbackRate: Float = 0.5
    
    let rateActionSheet: UIAlertController = UIAlertController(title: "Playback Rate", message: nil, preferredStyle: .actionSheet)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singalongLabel.text = text
        progressView.setProgress(0, animated: false)
        synth.delegate = self
        createActionSheet()
        
        controlsContainer.layer.cornerRadius = 20
        controlsContainer.clipsToBounds = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        synth.stopSpeaking(at: .immediate)
    }
    
    @IBAction func handlePlayButton(_ sender: Any) {
        if synth.isPaused {
            synth.continueSpeaking()
            playButton.setImage(pauseIcon, for: .normal)
        } else if synth.isSpeaking {
            synth.pauseSpeaking(at: .immediate)
            playButton.setImage(playIcon, for: .normal)
        } else {
            progressView.setProgress(0, animated: false)
            startPlayback()
            playButton.setImage(pauseIcon, for: .normal)
        }
        
    }
    
    @IBAction func handleStopButton(_ sender: Any) {
        synth.stopSpeaking(at: .immediate)
        progressView.setProgress(0, animated: false)
        playButton.setImage(playIcon, for: .normal)
        singalongLabel.attributedText = NSAttributedString(string: text ?? "")
    }
    
    
    
    @IBAction func handleRateButton(_ sender: Any) {
        self.present(rateActionSheet, animated: true, completion: { () in
            self.synth.stopSpeaking(at: .immediate)
            self.progressView.setProgress(0, animated: false)
        })
    }
    
    func createActionSheet() {
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        let halfSpeed = UIAlertAction(title: "0.5x", style: .default) { _ in
            self.playbackRate = 0.25
            self.rateButton.setTitle("0.5x", for: .normal)
        }
        
        let normalSpeed = UIAlertAction(title: "1x", style: .default) { _ in
            self.playbackRate = 0.5
            self.rateButton.setTitle("1x", for: .normal)
        }
        
        let doubleSpeed = UIAlertAction(title: "2x", style: .default) { _ in
            self.playbackRate = 1.0
            self.rateButton.setTitle("2x", for: .normal)
        }
        
        rateActionSheet.addAction(halfSpeed)
        rateActionSheet.addAction(normalSpeed)
        rateActionSheet.addAction(doubleSpeed)
        rateActionSheet.addAction(cancelActionButton)

    }
    
    
    func startPlayback() {
        guard let text = text else {
            return
        }

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        print(utterance.rate)
        utterance.rate = playbackRate
        print(utterance.rate)
        synth.speak(utterance)
    }

}

extension PlaybackViewController: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
        mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: characterRange)
        singalongLabel.attributedText = mutableAttributedString
        
        let progress = Float(characterRange.location + characterRange.length)
            / Float(utterance.speechString.count)
        
        self.progressView.setProgress(progress, animated: true)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        playButton.setImage(playIcon, for: .normal)
        self.progressView.setProgress(0, animated: false)
        singalongLabel.attributedText = NSAttributedString(string: utterance.speechString)

    }
}





