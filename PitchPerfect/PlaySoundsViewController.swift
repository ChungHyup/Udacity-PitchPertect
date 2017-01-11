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
    //values for customizing
    var sliderTimer: Timer!
    var restartPoint: AVAudioFramePosition!
    var audioDuration: Float!
    var audioPlayerTime: AVAudioTime!
    var currentButtonType:ButtonType!
    var changeRatePitchNode: AVAudioUnitTimePitch!
    
    var isPaused: Bool = false
    var buttonPaused: Bool = false
    
    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
    
    enum PauseType: Int {
        case slider = 0, button
    }
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
        audioSlider.isContinuous = false
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
        
        addSliderTimer()
    }
    
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        stopAudio()
        restartPoint = nil
    }
    
    @IBAction func pauseAudio(_ sender: AnyObject) {        
        if !isPaused{
            audioPlayerTime = getPlayerTime()
            audioPlayerNode.stop()
            sliderTimer.invalidate()
            stopTimer.invalidate()
            isPaused = true
            if(PauseType(rawValue: sender.tag) == .button){
                buttonPaused = true
            }
        }
    }
    
    @IBAction func changeAudioTime(_ sender: AnyObject) {
        if !buttonPaused{
            restartAudio(sender)
        }
    }
    
    @IBAction func restartAudio(_ sender: AnyObject) {
        restartPoint = AVAudioFramePosition(audioPlayerTime.sampleRate * Double(audioSlider.value))
        
        let length = Float(audioDuration!) - audioSlider.value
        let framestoplay = AVAudioFrameCount(Float(audioPlayerTime.sampleRate) * length)
        if framestoplay > 1000 {
            audioPlayerNode.scheduleSegment(audioFile, startingFrame: restartPoint, frameCount: framestoplay, at: nil,completionHandler: nil)
        }
        
        addSliderTimer()
        scheduleStopTimer(rate: changeRatePitchNode.rate, isRestart: true)
        isPaused = false
        buttonPaused = false
        audioPlayerNode.play()
    }
    
    func addSliderTimer(){
        sliderTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(PlaySoundsViewController.updateAudioTime), userInfo: nil, repeats:true)
        RunLoop.main.add(self.sliderTimer!, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func updateAudioTime(){
        let playerTime = getPlayerTime()
        var seconds:TimeInterval
        if (restartPoint != nil) {
            seconds = (Double(restartPoint)+Double(playerTime.sampleTime)) / Double(playerTime.sampleRate)
        }else{
            seconds = Double(playerTime.sampleTime) / Double(playerTime.sampleRate)
        }
        
        self.audioSlider.value = Float(seconds)
    }
    
    func getPlayerTime()->AVAudioTime{
        let nodeTime:AVAudioTime = self.audioPlayerNode.lastRenderTime!
        let playerTime:AVAudioTime = audioPlayerNode.playerTime(forNodeTime: nodeTime)!
        return playerTime
    }
    
    
}
