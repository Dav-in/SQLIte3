//
//  ViewController.swift
//  SQLite3
//
//  Created by Davin Henrik on 10/31/21.
//

import UIKit
import SQLite3

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var myTableView : UITableView!
    
    @IBOutlet weak var processingLabel : UILabel!
    
    @IBOutlet weak var nameField : UITextField!
    @IBOutlet weak var ageField : UITextField!
    
    @IBOutlet weak var subBtn : UIButton!
    
    var db: DBProcessing = DBProcessing()
    
    var client : [ClientData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "customCell")
        myTableView.dataSource = self
    
        client = db.read()
    }

    
    @IBAction func uploadToDb(){
        let dbID = client.count + 1
        let userName : String? = nameField.text!
        let age : Int?  = Int(ageField.text!)
       
        if(userName != "" || age != 0){
        db.insert(id: dbID, username: userName!, age: age ?? 0)
            processingLabel.text = ""
            nameField.text = " "
            ageField.text = " "
            processingLabel.text = "Entry was successful"
            processingLabel.textColor = .green
        }
        else{
            processingLabel.text = "Invalid User data"
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return client.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "customCell")!
        
        cell.textLabel?.text = "\(client[indexPath.row].id) : " + client[indexPath.row].username + " " + String(client[indexPath.row].age)
        return cell
    }
}

