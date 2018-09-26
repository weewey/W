//
//  TrainingSession.swift
//  W
//
//  Created by yewwee on 18/08/2018.
//  Copyright © 2018 yewwee. All rights reserved.
//

import Foundation

struct TrainingSession {
    let id :String
    var date: String
    var distanceInKm: Float
    let coachComments: String
    let type: TrainingCategory
    var timeOfDay : TimeOfDay
    var executedWorkoutPace: String?
    var heartRate: Int?
    var runDuration: Int?
    var feedback: String?
    
    init(id: String, date: String, distanceInKm: Float, coachComments: String, type: TrainingCategory, timeOfDay: TimeOfDay, executedWorkoutPace: String? = nil, heartRate: Int? = nil, runDuration: Int? = nil, feedback: String? = nil) {
        self.id = id
        self.date = date
        self.distanceInKm = distanceInKm
        self.coachComments = coachComments
        self.type = type
        self.timeOfDay = timeOfDay
        self.executedWorkoutPace = executedWorkoutPace
        self.heartRate = heartRate
        self.runDuration = runDuration
        self.feedback = feedback
    }
}

enum TrainingCategory: String {
    case easy = "easy"
    case interval = "interval"
    case longRun = "longRun"
    case tempoRun = "tempoRun"
    case fartlek = "fartlek"
    case race = "race"
}

enum TimeOfDay: String {
    case AM = "AM"
    case PM = "PM"
}
