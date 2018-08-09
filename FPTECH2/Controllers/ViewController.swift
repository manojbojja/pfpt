//
//  ViewController.swift
//  FPTECH2
//
//  Created by Manoj Bojja on 09/08/18.
//  Copyright © 2018 Manoj Bojja. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var toggleBar: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    private var medicineDict = [Medicine]()
    private var typeDict = [Medicine]()
    
    private var typeRestrictionDict = [String: [Int]]()
    private var medicineRestrictionDict = [String: [Int]]()
    
    private var selectedType = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        if Connectivity.isConnectedToInternet{
            self.downloadTableData {
                self.activityIndicator.stopAnimating()
                self.updateUi()
            }
        }else{
            self.activityIndicator.stopAnimating()
            self.tableView.isHidden = true
            self.errorLabel.text = "\(ERROR_NO_INTERNET)"
            self.errorLabel.isHidden = false
        }
        
    }
    
    @IBAction func toggleClicked(_ sender: Any) {
        self.selectedType = !selectedType
        self.updateUi()
    }
    
    func updateUi(){
        
        if medicineDict.count == 0{
            self.errorLabel.text = "\(ERROR_JSON_PARSE)"
            self.errorLabel.isHidden = false
            self.tableView.isHidden = true
        }else{
            self.tableView.isHidden = false
            self.errorLabel.isHidden = !self.errorLabel.isHidden
            self.tableView.reloadData()
            self.tableView.tableFooterView = UIView()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell{
            let updateObject = self.selectedType ? medicineDict[indexPath.row] : typeDict[indexPath.row]
            cell.updateUi(name: updateObject.name, id: "\(updateObject.id)")
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: "detailsSegue", sender: indexPath.row)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectedType{
            return self.medicineDict.count
        }else{
            return self.typeDict.count
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailsViewController{
            if let sender = sender as? Int{
                if self.selectedType {
                    destination.tableViewData = typeDict
                    destination.tableViewRestrictionsData = self.medicineRestrictionDict["\(medicineDict[sender].id)"]!
                }else{
                    destination.tableViewData = medicineDict
                    destination.tableViewRestrictionsData = self.typeRestrictionDict["\(typeDict[sender].id)"]!
                }
            }
        }
    }
    
    func downloadTableData(completed: @escaping DownloadComplete){
        Alamofire.request("\(BASE_URL)").responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, Any>{
                
                if let medicines = dict["medicines"] as? [Dictionary<String, Any>]{
                    for record in medicines{
                        let medicineObject = Medicine(id: record["id"] as! Int, name: record["name"] as! String)
                        self.medicineDict.append(medicineObject)
                        self.medicineRestrictionDict["\(String(describing: record["id"]!))"] = []
                    }
                }
                
                if let type = dict["type"] as? [Dictionary<String, Any>]{
                    for record in type{
                        let typeObject = Medicine(id: record["id"] as! Int, name: record["name"] as! String)
                        self.typeDict.append(typeObject)
                        self.typeRestrictionDict["\(String(describing: record["id"]!))"] = []
                    }
                }
                
                if let restriction = dict["restrictions"] as? [[Dictionary<String, Any>]]{
                    for record in restriction{
                        var indexKey = ""
                        var valuesArray = [Int]()
                        for recordObject  in record{
                            for (key, value) in recordObject{
                                indexKey = key
                                self.medicineRestrictionDict[(value as! String)]?.append(Int(key )!)
                                valuesArray.append(Int(value as! String)!)
                            }
                        }
                        self.typeRestrictionDict[indexKey] = valuesArray
                    }
                }
            }
            completed()
        }
    }

}

