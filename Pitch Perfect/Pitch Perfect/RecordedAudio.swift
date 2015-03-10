//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Liza Martynova on 10.3.15.
//  Copyright (c) 2015 Sleepless Dev. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(url:NSURL!, title: String!) {
        self.filePathUrl = url
        self.title = title        
    }
}