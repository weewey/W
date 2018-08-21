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
    
    func getSessionsFor(date: Date, onComplete: @escaping ([TrainingSession]?, Error?) -> Void) -> Void {
        let config = AppConfig()
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
                    print(trainingSessions)
                    onComplete(trainingSessions, nil)
                case.failure(let error):
                    onComplete(nil, error)
                }
        }
    }
    
    private func parseObjToTrainingSessions(obj: Data?) ->([TrainingSession]?, Error?) {
        do {
            let trainingSessionsObj = try JSON.init(data: obj!)
            print("in parseObjToTrainingSessions")
            print(trainingSessionsObj)
            var arrayOfTrainingSessions: [TrainingSession]? = []
            for (_, trainingSession) in trainingSessionsObj["trainingSessions"] {
                print("in the loop")
                print(trainingSession)
                arrayOfTrainingSessions!.append(TrainingSession(date: trainingSession["date"].stringValue,
                                                               distanceInKm: trainingSession["distanceInKm"].intValue,
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

