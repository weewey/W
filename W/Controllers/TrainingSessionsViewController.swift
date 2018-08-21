//
//  TrainingSessionsViewController.swift
//  W
//
//  Created by yewwee on 18/08/2018.
//  Copyright © 2018 yewwee. All rights reserved.
//

import UIKit

class TrainingSessionTableViewCell : UITableViewCell {
    
    @IBOutlet weak var typeOfRun: UILabel!
    @IBOutlet weak var timeOfDay: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var runImage: UIImageView!
    @IBOutlet weak var coachComments: UILabel!
    
}

class TrainingSessionsViewController: UIViewController {

    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var getTrainingPlan: UIButton!
    var trainingSessionClient: TrainingSessionClient?
    @IBOutlet weak var tableView: UITableView!
    var trainingSessionsToRender : [TrainingSession]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func getTrainingPlanPressed(_ sender: Any) {
        let dateRequested = DatePicker.date
        getTrainingSessionClient().getSessionsFor(date: dateRequested){ trainingSession, error in
            guard error == nil else {
                print(error)
                return
            }
            guard trainingSession?.isEmpty == false else {
                print("No training for Today!")
                return
            }
            self.trainingSessionsToRender = trainingSession
            self.tableView.reloadData()
        }
    }
    
    private
    
    func getTrainingSessionClient() -> TrainingSessionClient {
        guard trainingSessionClient == nil else {
            return trainingSessionClient!
        }
        return TrainingSessionClient()
    }

}

extension TrainingSessionsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard trainingSessionsToRender != nil else {
            return 0
        }
        return trainingSessionsToRender!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentTrainingSession = trainingSessionsToRender![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath) as! TrainingSessionTableViewCell
        cell.coachComments.text = currentTrainingSession.coachComments
        cell.distance.text = String(currentTrainingSession.distanceInKm)
        cell.timeOfDay.text = currentTrainingSession.timeOfDay.rawValue
        cell.typeOfRun.text = currentTrainingSession.type.rawValue.uppercased()
        cell.runImage.image = UIImage(named: "easy-running")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!) as! TrainingSessionTableViewCell
        print(currentCell.coachComments.text)
    }
}
