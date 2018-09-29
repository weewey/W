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

typealias RequestBody = [String: NSMutableDictionary]

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
        Alamofire.request("\(config.trainingSessionHost)/training_sessions/\(trainingSession.id)", method: .put, parameters: trainingSessionRequestBody(trainingSession: trainingSession), encoding: JSONEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success:
                    onComplete(nil)
                case .failure(let error):
                    print("TrainingSessionClient - Update Failed")
                    onComplete(error)
                }
        }
    }
    
    func trainingSessionRequestBody(trainingSession: TrainingSession) -> RequestBody {
        var requestParams: RequestBody
        requestParams = ["training_session" : ["distance_in_km" : String(trainingSession.distanceInKm),
                                               "time_of_day": trainingSession.timeOfDay.rawValue
            ]]
        if trainingSession.runDuration != nil {
            requestParams["training_session"]!["run_duration"] = String(trainingSession.runDuration!)
        }
        if trainingSession.feedback != nil {
            requestParams["training_session"]!["feedback"] = trainingSession.feedback!
        }
        if trainingSession.heartRate != nil {
            requestParams["training_session"]!["heart_rate"] = String(trainingSession.heartRate!)
        }
        if trainingSession.executedWorkoutPace != nil {
            requestParams["training_session"]!["executed_workout_pace"] = trainingSession.executedWorkoutPace!
        }
        return requestParams
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

