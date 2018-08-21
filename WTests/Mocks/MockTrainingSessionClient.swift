//
//  MockTrainingSessionClient.swift
//  WTests
//
//  Created by yewwee on 18/08/2018.
//  Copyright © 2018 yewwee. All rights reserved.
//

import Foundation
import SwiftyJSON

@testable import W

class MockTrainingSessionClient: TrainingSessionClient {
    var getSessionsForCalled: Bool
    
    override init() {
        self.getSessionsForCalled = false
    }
    
    override func getSessionsFor(date: Date, onComplete: @escaping ([TrainingSession]?, Error) -> Void) {
        self.getSessionsForCalled = true
        return
    }
    
}
