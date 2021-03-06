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
    
/*
     audio player node에 대한 간략한 설명
     audio player node는 파일의 프레임수에 따라 재생 정보를 받아 올 수 있습니다.
     sampleTime을 통해 몇번째 프레임인지 알 수 있고, sampleRate를 통해 단위 재생 프레임수를 알 수 있습니다.
     즉 sampleTime/sampleRate 를 한다면 현재 재생시간을 알 수 있습니다.
     단, AVAudioEngine 을 통해 소리를 늘리거나 줄여 재생시간이 변화한 경우는 반영되지 않습니다.
*/
    
    var recordedAudioURL: URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    //values for customizing
    var sliderTimer: Timer!
    var currentTimeTimer: Timer!
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
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        setPlayButtonHidden(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAudio()
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
        
        setTimer()
    }
    
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        stopAudio()
        restartPoint = nil
    }
    //slider를 클릭할때, pauseButton 버튼을 클릭할때
    @IBAction func pauseAudio(_ sender: AnyObject) {        
        if !isPaused{
            setPlayButtonHidden(false)
            audioPlayerTime = getPlayerTime()
            audioPlayerNode.stop()
            sliderTimer.invalidate()
            stopTimer.invalidate()
            currentTimeTimer.invalidate()
            isPaused = true
            if(PauseType(rawValue: sender.tag) == .button){
                buttonPaused = true
            }
        }
    }
    
    @IBAction func finishDragInSlider(_ sender: AnyObject) {
        //button으로 pause가 되지 않았을 시 옮긴 위치에서 오디오 재생
        if !buttonPaused{
            restartAudio(sender)
        }
    }
    @IBAction func changeValueInSlider(_ sender: AnyObject) {
        updateCurrentTime()
    }
    
    //음악을 다시 시작 할 위치, slider, stoptimer 세팅
    @IBAction func restartAudio(_ sender: AnyObject) {
        print(audioDuration)
        print(audioPlayerTime.sampleRate)
        print(audioSlider.value)
        restartPoint = AVAudioFramePosition(audioPlayerTime.sampleRate * Double(audioSlider.value))
        
        let length = Float(audioDuration!) - audioSlider.value
        let framestoplay = AVAudioFrameCount(Float(audioPlayerTime.sampleRate) * length)
        if framestoplay > 1000 {
            audioPlayerNode.scheduleSegment(audioFile, startingFrame: restartPoint, frameCount: framestoplay, at: nil,completionHandler: nil)
        }
        
        setTimer()
        scheduleStopTimer(rate: changeRatePitchNode.rate, isRestart: true)
        isPaused = false
        buttonPaused = false
        setPlayButtonHidden(true)
        audioPlayerNode.play()
    }
     
    //Timer for slider
    func setTimer(){
        sliderTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(PlaySoundsViewController.updateAudioSlider), userInfo: nil, repeats:true)
        currentTimeTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(PlaySoundsViewController.updateCurrentTime), userInfo: nil, repeats:true)
    }
    
    func updateCurrentTime(){
        let playerTime = audioSlider.value
        let currentTimeInSec = Int(round(playerTime/changeRatePitchNode.rate))
        currentTimeLabel.text = String(format:"%.2d:%.2d",currentTimeInSec/60, currentTimeInSec%60)
        
    }
    //오디오 재생시간 업데이트
    func updateAudioSlider(){
        let playerTime = getPlayerTime()
        var seconds:TimeInterval
        if (restartPoint != nil) {
            seconds = (Double(restartPoint)+Double(playerTime.sampleTime)) / playerTime.sampleRate
        }else{
            seconds = Double(playerTime.sampleTime) / playerTime.sampleRate
        }
        
        self.audioSlider.value = Float(seconds)
    }
    
    func getPlayerTime()->AVAudioTime{
        let nodeTime:AVAudioTime = self.audioPlayerNode.lastRenderTime!
        let playerTime:AVAudioTime = audioPlayerNode.playerTime(forNodeTime: nodeTime)!
        return playerTime
    }
    
    func setPlayButtonHidden(_ hidden: Bool){
        playButton.isHidden = hidden
        pauseButton.isHidden = !hidden
    }
    
    
}
