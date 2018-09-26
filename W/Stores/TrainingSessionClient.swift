//
//  TrainingSessionClient.swift
//  W
//
//  Created by yewwee on 18/08/2018.
//  Copyright © 2018 yewwee. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class TrainingSessionClient {
    let config = AppConfig()
    
    func getSessionsFor(date: Date, onComplete: @escaping ([TrainingSession]?, Error?) -> Void) -> Void {
        let requestParams = ["date": formatDate(date: date)]
        Alamofire.request("\(config.trainingSessionHost)/training_sessions", method: .get, parameters: requestParams, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    let (trainingSessions, error) = self.parseObjToTrainingSessions(obj: response.data)
                    guard error == nil else {
                        onComplete(nil, error)
                        return
                    }
                    onComplete(trainingSessions, nil)
                case.failure(let error):
                    onComplete(nil, error)
                }
        }
    }
    
    func updateSessionFor(trainingSession: TrainingSession, onComplete: @escaping (Error?) -> Void ) -> Void {
        let updatedTrainingSession : [String: Any] =
            [ "training_session" : [
                "distance_in_km" : trainingSession.distanceInKm,
                "duration": trainingSession.runDuration,
                "feedback": trainingSession.feedback,
                "heart_rate": trainingSession.heartRate,
                "executed_workout_pace": trainingSession.executedWorkoutPace
                ]
        ]
        Alamofire.request("\(config.trainingSessionHost)/training_sessions/\(trainingSession.id)", method: .put, parameters: updatedTrainingSession, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    onComplete(nil)
                case .failure(let error):
                    onComplete(error)
                }
        }
        
    }
    
    private func parseObjToTrainingSessions(obj: Data?) ->([TrainingSession]?, Error?) {
        do {
            let trainingSessionsObj = try JSON.init(data: obj!)
            print(trainingSessionsObj)
            var arrayOfTrainingSessions: [TrainingSession]? = []
            for (_, trainingSession) in trainingSessionsObj["trainingSessions"] {
                print(trainingSession)
                arrayOfTrainingSessions!.append(TrainingSession(id: trainingSession["id"].stringValue,
                                                                date: trainingSession["date"].stringValue,
                                                                distanceInKm: trainingSession["distanceInKm"].floatValue,
                                                                coachComments: trainingSession["coachComments"].stringValue,
                                                                type: TrainingCategory(rawValue: trainingSession["type"].stringValue)!,
                                                                timeOfDay: TimeOfDay(rawValue: trainingSession["timeOfDay"].stringValue)!))
            }
            return (arrayOfTrainingSessions, nil)
        } catch {
            return (nil, error)
        }
    }
    
    private func formatDate(date :Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
}

