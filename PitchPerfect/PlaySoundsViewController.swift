//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by 오충협 on 2017. 1. 9..
//  Copyright © 2017년 mju. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var recordedAudioURL: URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    var sliderTimer: Timer!
    
    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var audioSlider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
    
    @IBAction func playSoundForButton(_ sender: UIButton) {
        switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        configureUI(.playing)
        
        sliderTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(PlaySoundsViewController.updateAudioTime), userInfo: nil, repeats:true)
        RunLoop.main.add(self.sliderTimer!, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        stopAudio()
    }
    
    @IBAction func changeAudioTime(_ sender: AnyObject) {
        
    }
    
    //
    func updateAudioTime(){
        let nodeTime:AVAudioTime = self.audioPlayerNode.lastRenderTime!
        let playerTime:AVAudioTime = audioPlayerNode.playerTime(forNodeTime: nodeTime)!        
        let seconds:TimeInterval = Double(playerTime.sampleTime) / Double(playerTime.sampleRate)
        self.audioSlider.value = Float(seconds)
    }
    
    
}
