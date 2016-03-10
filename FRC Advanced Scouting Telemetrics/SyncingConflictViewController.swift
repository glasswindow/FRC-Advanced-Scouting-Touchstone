//
//  SyncingConflictViewController.swift
//  FRC Advanced Scouting Telemetrics
//
//  Created by Aaron Kampmeier on 3/8/16.
//  Copyright © 2016 Kampfire Technologies. All rights reserved.
//

import UIKit

class SyncingConflictViewController: UIViewController, UITableViewDataSource {
	@IBOutlet weak var conflictManagementTable: UITableView!
	@IBOutlet weak var conflictMessage: UILabel!
	@IBOutlet weak var doneButton: UIBarButtonItem!
	
	var conflictInfo: [NSObject: AnyObject]?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		conflictManagementTable.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		return conflictManagementTable.dequeueReusableCellWithIdentifier("cell")!
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
