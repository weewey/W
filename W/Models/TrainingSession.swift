//
//  TrainingSession.swift
//  W
//
//  Created by yewwee on 18/08/2018.
//  Copyright © 2018 yewwee. All rights reserved.
//

import Foundation

struct TrainingSession {
    let date: String
    let distanceInKm: Int
    let coachComments: String
    let type: TrainingCategory
    let timeOfDay : TimeOfDay
    
    init(date: String, distanceInKm: Int, coachComments: String, type: TrainingCategory, timeOfDay: TimeOfDay) {
        self.date = date
        self.distanceInKm = distanceInKm
        self.coachComments = coachComments
        self.type = type
        self.timeOfDay = timeOfDay
    }
}

enum TrainingCategory: String {
    case easy = "easy"
    case interval = "interval"
    case longRun = "longRun"
    case tempoRun = "tempoRun"
    case fartlek = "fartlek"
}

enum TimeOfDay: String {
    case AM = "AM"
    case PM = "PM"
}
