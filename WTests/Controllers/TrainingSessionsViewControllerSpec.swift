//
//  TrainingSessionsViewControllerSpec.swift
//  WTests
//
//  Created by yewwee on 18/08/2018.
//  Copyright © 2018 yewwee. All rights reserved.
//

import Nimble
import Quick
@testable import W

class TrainingSessionsViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: TrainingSessionsViewController!
        let mockTrainingSessionClient = MockTrainingSessionClient()
        
        beforeEach {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            viewController = storyboard.instantiateViewController(withIdentifier: "TrainingSessionsViewControllerID") as! TrainingSessionsViewController
            viewController.trainingSessionClient = mockTrainingSessionClient
            viewController.loadView()
        }
        
        describe("#getTrainingPlanPressed"){
            it("calls #getSessionsFor"){
                viewController.getTrainingPlan.sendActions(for: .touchUpInside)
                expect(mockTrainingSessionClient.getSessionsForCalled).to(beTrue())
            }
        }
    }
}
