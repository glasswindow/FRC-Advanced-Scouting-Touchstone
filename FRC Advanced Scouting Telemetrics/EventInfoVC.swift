//
//  EventInfoVCViewController.swift
//  FRC Advanced Scouting Touchstone
//
//  Created by Aaron Kampmeier on 12/27/16.
//  Copyright © 2016 Kampfire Technologies. All rights reserved.
//

import UIKit
import Crashlytics
import AWSMobileClient

class EventInfoVC: UIViewController, UITableViewDataSource {
    var selectedEvent: Event?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var eventShortName: UILabel!
    @IBOutlet weak var eventType: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView.isHidden = true
        loadingView.layer.cornerRadius = 10

        // Do any additional setup after loading the view.
        eventShortName.text = selectedEvent?.name
        eventType.text = selectedEvent?.eventTypeString
        
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "CloudImportNoAllianceData"), object: nil, queue: nil, using: receivedNoAllianceData)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //Check if we are using syncing
        if Globals.isInSpectatorMode {
            assertionFailure()
        } else {
            if let eventKey = selectedEvent?.key {
                self.activityIndicator.startAnimating()
                self.loadingView.isHidden = false
                self.view.isUserInteractionEnabled = false
                self.navigationController?.navigationBar.isUserInteractionEnabled = false
                
                //Add the event to be tracked
                Globals.appDelegate.appSyncClient?.perform(mutation: AddTrackedEventMutation(eventKey: eventKey), resultHandler: {[weak self] (result, error) in
                    if Globals.handleAppSyncErrors(forQuery: "AddTrackedEventMutation", result: result, error: error) {
                        self?.finishedImport(didComplete: true, withError: nil)
                    } else {
                        //Show error
                        self?.finishedImport(didComplete: false, withError: error)
                    }
                })
            }
        }
    }
    
    func finishedImport(didComplete: Bool, withError error: Error?) {
        //Reenable user interaction
        self.view.isUserInteractionEnabled = true
        
        if didComplete {
            CLSNSLogv("Did complete event import", getVaList([]))
            if let error = error {
                CLSNSLogv("With error: \(error)", getVaList([]))
            }
            
            //Close the view. Use both methods to support the admin console 
            self.dismiss(animated: true, completion: nil)
        } else {
            let errorMessage: String?
            if let error = error {
                CLSNSLogv("Didn't complete event import with error: \(error)", getVaList([]))
                errorMessage = error.localizedDescription
            } else {
                CLSNSLogv("Didn't complete event import", getVaList([]))
                errorMessage = nil
            }
            
            let alert = UIAlertController(title: "Unable to Add", message: "An error occurred when adding the event: \(errorMessage ?? "__")", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
            self.loadingView.isHidden = true
            self.view.isUserInteractionEnabled = true
            self.navigationController?.navigationBar.isUserInteractionEnabled = true
        }
        
        Answers.logCustomEvent(withName: "Attempted Event Import", customAttributes: ["Successful":didComplete])
    }
    
    func receivedNoAllianceData(notification: Notification) {
        let alert = UIAlertController(title: "Too Early", message: "The cloud system has no data on the match schedule and alliances at this event. This is most likely due to the event being too far away date-wise for them to have finalized a schedule. Please reload data at a later date.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = selectedEvent?.website {
            return 4
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            //Year cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "nameValue")
            
            let keyLabel = cell?.viewWithTag(1) as! UILabel
            keyLabel.text = "Year"
            keyLabel.constraints.filter({$0.identifier == "keyWidth"}).first?.constant = keyLabel.intrinsicContentSize.width
            
            (cell?.viewWithTag(2) as! UILabel).text = selectedEvent?.year.description
            
            return cell!
        case 1:
            //Address
            let cell = tableView.dequeueReusableCell(withIdentifier: "nameValue")
            
            let keyLabel = cell?.viewWithTag(1) as! UILabel
            keyLabel.text = "Address"
            keyLabel.constraints.filter({$0.identifier == "keyWidth"}).first?.constant = keyLabel.intrinsicContentSize.width
            
            (cell?.viewWithTag(2) as! UILabel).text = selectedEvent?.address
            
            return cell!
        case 2:
            //Official FIRST FMS
            let cell = tableView.dequeueReusableCell(withIdentifier: "nameValue")
            
            let keyLabel = cell?.viewWithTag(1) as! UILabel
            keyLabel.text = "Location"
            keyLabel.constraints.filter({$0.identifier == "keyWidth"}).first?.constant = keyLabel.intrinsicContentSize.width
            (cell?.viewWithTag(2) as! UILabel).text = selectedEvent?.locationName ?? "Unkown"
            //TODO: Find another way to describe if it is official or not
//            let keyLabel = cell?.viewWithTag(1) as! UILabel
//            keyLabel.text = "Uses Official FIRST FMS"
//            keyLabel.constraints.filter({$0.identifier == "keyWidth"}).first?.constant = keyLabel.intrinsicContentSize.width
//
//            (cell?.viewWithTag(2) as! UILabel).text = selectedEvent?.official.description.capitalized
            
            return cell!
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "websiteButton")
            
            (cell?.viewWithTag(1) as! UIButton).addTarget(self, action: #selector(websiteButtonPressed(_:)), for: .touchUpInside)
            
            return cell!
        default:
            return UITableViewCell()
        }
    }
    
    @objc func websiteButtonPressed(_ sender: UIButton) {
        if let url = URL(string: selectedEvent?.website ?? "") {
            UIApplication.shared.openURL(url)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
