//
//  ResultsViewController.swift
//  AmplifyTest05
//
//  Created by Keishin CHOU on 2019/12/24.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import UIKit
import Amplify

class ResultsViewController: UITableViewController {

    private var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        apiQuery()
        createSubscription() 
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = notes[indexPath.row].content

        return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func apiQuery() {
        _ = Amplify.API.query(from: Note.self, where: nil) { (event) in
            switch event {
                case .completed(let result):
                    switch result {
                    case .success(let notes):
    //                    guard let note = note else {
    //                        print("API Query completed but missing note")
    //                        return
    //                    }
                        self.notes = notes
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        print("API Query successful, got note: \(notes)")
                    case .failure(let error):
                        print("Completed with error: \(error.errorDescription)")
                    }
                case .failed(let error):
                    print("Failed with error \(error.errorDescription)")
                default:
                    print("Unexpected event")
            }
        }
    }
    
    func createSubscription() {
        _ = Amplify.API.subscribe(from: Note.self, type: .onCreate) { (event) in
            switch event {
            case .inProcess(let subscriptionEvent):
                switch subscriptionEvent {
                case .connection(let subscriptionConnectionState):
                    print("Subsription connect state is \(subscriptionConnectionState)")
                case .data(let result):
                    switch result {
                    case .success(let newItem):
                        print("Successfully got note from subscription: \(newItem)")
                        
                        self.notes.append(newItem)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        print("Got failed result with \(error.errorDescription)")
                    }
                }
            case .completed:
                print("Subscription has been closed")
            case .failed(let error):
                print("Got failed result with \(error.errorDescription)")
            default:
                print("Should never happen")
            }
        }
    }
    
}
