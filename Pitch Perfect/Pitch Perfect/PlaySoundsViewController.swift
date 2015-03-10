//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Liza Martynova on 9.3.15.
//  Copyright (c) 2015 Sleepless Dev. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    /// The player.
    var avPlayer:AVAudioPlayer!
    var error: NSError?
    
    func playWithRate(rate: Float) {
        audioEngine.stop()
        audioEngine.reset()
        avPlayer.stop()
        avPlayer.currentTime = 0
        avPlayer.rate = rate
        avPlayer.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        
        let cdate = NSDate()
        let format = NSDateFormatter()
        format.dateFormat = "yyyy.MM.dd"
        
        let fileURL = receivedAudio.filePathUrl
        
        self.avPlayer = AVAudioPlayer(contentsOfURL: fileURL, error: &error)
        if avPlayer == nil {
            if let e = error {
                println(e.localizedDescription)
            }
        }
        
        avPlayer.volume = 1.0
        avPlayer.enableRate = true
    }

    @IBAction func echoSoundAudio(sender: UIButton) {
        playAudioWithVariableReverb(50)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func slowSoundPlay(sender: UIButton) {
        playWithRate(0.5)
    }
    
    @IBAction func fastSoundPlay(sender: UIButton) {
        playWithRate(1.5)
    }
    
    @IBAction func stopAudioPlay(sender: UIButton) {
        avPlayer.stop()
    }
    
    @IBAction func playChipMunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        avPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func playAudioWithVariableReverb(wetDryMix: Float){
        avPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changeReverbEffect = AVAudioUnitReverb()
        changeReverbEffect.wetDryMix = wetDryMix
        audioEngine.attachNode(changeReverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: changeReverbEffect, format: nil)
        audioEngine.connect(changeReverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
