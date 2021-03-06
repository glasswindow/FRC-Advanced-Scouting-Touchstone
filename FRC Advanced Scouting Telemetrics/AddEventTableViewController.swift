//
//  AddEventTableViewController.swift
//  FRC Advanced Scouting Touchstone
//
//  Created by Aaron Kampmeier on 12/18/16.
//  Copyright © 2016 Kampfire Technologies. All rights reserved.
//

import UIKit

class AddEventTableViewController: UITableViewController {
    private var loadingView: UIView?
    private var searchController: UISearchController?
	
    private var events = [Event]() {
        didSet {
            loadingView?.isHidden = true
            filteredEvents = events
            tableView.reloadData()
        }
    }
    
    private var filteredEvents = [Event]()
    
    private var selectedEvent: Event? {
        didSet {
            performSegue(withIdentifier: "eventInfo", sender: tableView)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        setUp()
        
        //Add search functionality
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController?.searchBar
        }
        
        self.navigationItem.prompt = "Choose an event to add and track"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setUp(withYear year: String? = nil) {
        //Create a loading view and add it to the table view to indicate loading of the events
        events = []
        
        loadingView = UIView()
        let width: CGFloat = 30
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width/2)
        let y = (tableView.frame.height / 2) - (height/2) - (self.navigationController?.navigationBar.frame.height)!
        loadingView?.frame = CGRect(x: x, y: y, width: width, height: height)
        
        let spinnerView = UIActivityIndicatorView(style: .gray)
        spinnerView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinnerView.startAnimating()
        
        loadingView?.addSubview(spinnerView)
        
        self.tableView.addSubview(loadingView!)
        
        Globals.appSyncClient?.fetch(query: ListAvailableEventsQuery(year: year), cachePolicy: .fetchIgnoringCacheData, resultHandler: {[weak self] (result, error) in
            if Globals.handleAppSyncErrors(forQuery: "ListAvailableEvents", result: result, error: error) {
                if let gotEvents = result?.data?.listAvailableEvents?.map({$0!.fragments.event}) {
                    self?.events = gotEvents
                }
            } else {
                let alert = UIAlertController(title: "Unable to Load Events", message: "There was an error loading events from the cloud. Make sure you are connected to the internet.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self?.navigationController?.dismiss(animated: true, completion: nil)}))
                self?.present(alert, animated: true, completion: nil)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func yearButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField? = nil
        let alert = UIAlertController(title: "Enter Year", message: "Enter the year you would like to load events from in the format YYYY.", preferredStyle: .alert)
        alert.addTextField {tf in
            textField = tf
        }
        
        alert.addAction(UIAlertAction(title: "Done", style: .default) {alertAction in
            self.setUp(withYear: textField?.text)
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredEvents.count
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "event", for: indexPath)

        cell.textLabel?.text = filteredEvents[indexPath.row].name
        cell.detailTextLabel?.text = filteredEvents[indexPath.row].address

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedEvent = filteredEvents[indexPath.row]
    }
	

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "eventInfo" {
            let eventInfoVC = segue.destination as! EventInfoVC
            eventInfoVC.selectedEvent = selectedEvent
        }
    }
 

}

extension AddEventTableViewController: UISearchResultsUpdating {
    internal func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!.lowercased()
        
        if searchController.isActive {
            filteredEvents = events.filter {frcEvent in
                return frcEvent.name.lowercased().contains(searchText)
//                    || frcEvent.district?.displayName.lowercased().contains(searchText) ?? false
                    || frcEvent.eventTypeString.lowercased().contains(searchText)
                    || frcEvent.address?.lowercased().contains(searchText) ?? false
            }
        } else {
            filteredEvents = events
        }
        tableView.reloadData()
    }
}
