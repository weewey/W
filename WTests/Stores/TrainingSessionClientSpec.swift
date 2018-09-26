//
//  TrainingSessionClientSpec.swift
//  WTests
//
//  Created by yewwee on 19/08/2018.
//  Copyright © 2018 yewwee. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
@testable import W

class TrainingSessionClientSpec: QuickSpec {
    
    override func spec() {
        let trainingSessionClient = TrainingSessionClient()
        
        describe("#getSessionsFor"){
            let expectedTrainingSession = TrainingSession(id:"training-session-uuid", date: "01/01/2018", distanceInKm: 10, coachComments: "test", type: .easy, timeOfDay: .AM)
            let returnedTrainingSessions =
                [ "trainingSessions":
                    [[ "date": expectedTrainingSession.date,
                       "type": expectedTrainingSession.type.rawValue,
                       "distanceInKm": String(expectedTrainingSession.distanceInKm),
                       "timeOfDay": expectedTrainingSession.timeOfDay.rawValue,
                       "coachComments": expectedTrainingSession.coachComments
                        ]]
            ]
            context("when the request is SUCCESSFUL") {
                beforeEach {
                    stub(condition: isPath("/training_sessions") && isMethodGET() ) { _ in
                        return OHHTTPStubsResponse(jsonObject: returnedTrainingSessions, statusCode: 200, headers: nil)
                    }
                }
                it("fetches the trainingSession") {
                    waitUntil(timeout: 1){ done in
                        trainingSessionClient.getSessionsFor(date: Date()){ trainingSessions, error in
                            expect(trainingSessions![0].date).to(equal(expectedTrainingSession.date))
                            expect(trainingSessions![0].type).to(equal(expectedTrainingSession.type))
                            expect(trainingSessions![0].timeOfDay).to(equal(expectedTrainingSession.timeOfDay))
                            expect(trainingSessions![0].distanceInKm).to(equal(expectedTrainingSession.distanceInKm))
                            expect(trainingSessions![0].coachComments).to(equal(expectedTrainingSession.coachComments))
                            done()
                        }
                    }
                }
            }
            context("when the request is UNSUCCESSFUL") {
                beforeEach {
                    stub(condition: isPath("/training_sessions") && isMethodGET()) { _ in
                        return OHHTTPStubsResponse(jsonObject: [] , statusCode: 400, headers: nil)
                    }
                }
                it("returns an error"){
                    waitUntil(timeout: 1){ done in
                        trainingSessionClient.getSessionsFor(date: Date()){ trainingSessions, error in
                            expect(error!).notTo(beNil())
                            expect(trainingSessions).to(beNil())
                            done()
                        }
                    }
                }
            }
        }
        
        func isRequestBodyCorrect() -> OHHTTPStubsTestBlock {
            return { request in
                let requestBody = request.ohhttpStubs_httpBody
                let bodyJson = String.init(data: requestBody!, encoding: String.Encoding.utf8)
                return bodyJson == ""
            }
        }
        
        describe("#updateSessionFor") {
            let trainingSession = TrainingSession(id:"training-session-uuid", date: "01/01/2018", distanceInKm: 10, coachComments: "test", type: .easy, timeOfDay: .AM)
            beforeEach {
                stub(condition: isPath("/training_session") && isMethodPUT() && isRequestBodyCorrect()) { _ in
                    return OHHTTPStubsResponse(jsonObject: {}, statusCode: 200, headers: nil)
                }
            }
            it("sends the updated trainingSession in the JSON body") {
                waitUntil(timeout: 1){ done in
                    trainingSessionClient.updateSessionFor(trainingSession: trainingSession) { error in
                        expect(error!).to(beNil())
                    }
                }
            }
        }
        
    }
}
