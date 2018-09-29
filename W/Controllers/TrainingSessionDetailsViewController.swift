//
//  TrainingSessionDetailsViewController.swift
//  W
//
//  Created by yewwee on 18/09/2018.
//  Copyright © 2018 yewwee. All rights reserved.
//

import UIKit

class TrainingSessionDetailsViewController: UIViewController, UITextViewDelegate {

    var trainingSession :TrainingSession? = nil
    var trainingSessionClient :TrainingSessionClient? = nil
    
    @IBOutlet weak var trainingCategory: UILabel!
    @IBOutlet weak var runImage: UIImageView!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var timeOfDayLabel: UILabel!
    @IBOutlet weak var timeOfDaySwitch: UISwitch!
    @IBOutlet weak var runDistance: UITextField!
    @IBOutlet weak var coachComments: UITextView!
    @IBOutlet weak var executedWorkoutPace: UITextField!
    @IBOutlet weak var heartRate: UITextField!
    @IBOutlet weak var runDuration: UITextField!
    @IBOutlet weak var feedback: UITextView!
    
    @IBAction func timeOfDaySwitchPressed(_ sender: UISwitch) {
        timeOfDaySwitch.isOn = !timeOfDaySwitch.isOn
        if timeOfDaySwitch.isOn == true {
            timeOfDayLabel.text = TimeOfDay.AM.rawValue
        } else {
            timeOfDayLabel.text = TimeOfDay.PM.rawValue
        }
        trainingSession!.timeOfDay = TimeOfDay(rawValue: timeOfDayLabel.text!)!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.feedback.delegate = self
        setLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dateFieldUpdated(_ sender: Any) {
        trainingSession!.date = date.text!
    }
    
    @IBAction func runDistanceUpdated(_ sender: Any) {
        trainingSession!.distanceInKm = Float(runDistance.text!)!
    }
    
    @IBAction func heartRateUpdated(_ sender: Any) {
        trainingSession!.heartRate = Int(heartRate.text!)
    }
    
    @IBAction func executedWorkPaceUpdated(_ sender: Any) {
        trainingSession?.executedWorkoutPace = executedWorkoutPace.text
    }
    
    @IBAction func updateTrainingSessionButtonPressed(_ sender: Any) {
        trainingSessionClient!.updateSessionFor(trainingSession: trainingSession!){ error in
            if error != nil {
                print(error)
                print("Training session update failed!")
                return
            }
            self.presentAlert(alertTitle: "Update Status", alertMessage: "Training Session Update Successfully!")
            print("Update success")
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text)
        trainingSession?.feedback = textView.text
    }
    
    private
    
    func setLabels() {
        runImage.image = UIImage(named: "easy-running")
        trainingCategory.text = trainingSession?.type.rawValue.uppercased()
        date.text = trainingSession?.date
        if trainingSession?.timeOfDay == TimeOfDay.PM {
            timeOfDaySwitch.isOn = false
        }
        timeOfDayLabel.text = trainingSession?.timeOfDay.rawValue
        runDistance.text = String(trainingSession!.distanceInKm)
        coachComments.text = trainingSession!.coachComments
        executedWorkoutPace.text = trainingSession?.executedWorkoutPace
        if trainingSession?.heartRate != nil {
            heartRate.text = String(trainingSession!.heartRate!)
        }
        if trainingSession?.runDuration != nil {
            runDuration.text = String(trainingSession!.runDuration!)
        }
        if trainingSession?.feedback != nil{
            feedback.text = trainingSession!.feedback!
        }
    }
    
    func presentAlert(alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
