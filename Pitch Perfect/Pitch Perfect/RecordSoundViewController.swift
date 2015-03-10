//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Liza Martynova on 6.3.15.
//  Copyright (c) 2015 Sleepless Dev. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!

    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var tapToRecordLabel: UILabel!
    
    var paused = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordLabel.hidden = true
        pauseButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        audioRecorder.pause()
        pauseButton.hidden = true
        paused = true
        recordButton.enabled = true
        recordLabel.text = "recording set on pause, tap to unpause"
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        tapToRecordLabel.hidden = true
        recordLabel.hidden = false
        stopButton.hidden = false
        recordButton.enabled = false
        pauseButton.hidden = false
        
        if !paused {
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            println(filePath)
            
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
            
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
        }
        audioRecorder.record()
        paused = false
        recordLabel.text = "recording, tap to pause"
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        tapToRecordLabel.hidden = false
        recordLabel.hidden = true
        stopButton.hidden = true
        recordButton.enabled = true
        pauseButton.hidden = true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag == true {
            recordedAudio = RecordedAudio(url: recorder.url, title: recorder.url.lastPathComponent)
            self.performSegueWithIdentifier("goPlaying", sender: recordedAudio)
        } else {
            println("recording went wrong")
            stopButton.hidden = true
            recordButton.enabled = true
            tapToRecordLabel.hidden = false
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
        let data = sender as RecordedAudio
        playSoundsVC.receivedAudio = data
    }
}

