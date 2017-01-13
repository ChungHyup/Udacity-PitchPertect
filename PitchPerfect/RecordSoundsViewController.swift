//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by 오충협 on 2016. 12. 28..
//  Copyright © 2016년 mju. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    var durationTimer: Timer!
    var isPaused: Bool = false
    var isStrated: Bool = false
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false;
        durationLabel.isEnabled = false;
        pauseButton.isHidden = true;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        if isStrated {
            if isPaused {
                audioRecorder.record()
                isPaused = false
                recordButton.isHidden = true
                pauseButton.isHidden = false
                
            }else{
                audioRecorder.pause()
                isPaused = true
                recordButton.isHidden = false
                pauseButton.isHidden = true
            }
        }else{
            isStrated = true
            print("record button was pressed")
            recordingLabel.text = "Recording in Progress"
            stopRecordingButton.isEnabled = true
            durationLabel.isEnabled = true
            //recordButton.isEnabled = false
            recordButton.isHidden = true
            pauseButton.isHidden = false
            
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
            let recordingName = "recordedVoice.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = URL(string: pathArray.joined(separator: "/"))
            print(filePath)
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
            
            try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            //
            durationTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(RecordSoundsViewController.updateDurationLaber), userInfo: nil, repeats:true)
        }
    }
    
    @IBAction func stopRecording(_ sender: AnyObject) {
        print("stop recording button was pressed")
        recordButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        recordingLabel.text = "Tap to record"
        pauseButton.isHidden = true
        recordButton.isHidden = false
        isPaused = false
        isStrated = false
        
        
        audioRecorder.stop()
        durationTimer.invalidate()
        durationLabel.text = "00:00"
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func updateDurationLaber(){
        let currentSeconds: Int = Int(audioRecorder.currentTime)
        self.durationLabel.text = String(format:"%.2d:%.2d", currentSeconds/60, currentSeconds%60)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            print("recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

