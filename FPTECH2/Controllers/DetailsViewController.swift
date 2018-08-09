//
//  DetailsViewController.swift
//  FPTECH2
//
//  Created by Manoj Bojja on 09/08/18.
//  Copyright © 2018 Manoj Bojja. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableViewData = [Medicine]()
    var tableViewRestrictionsData = [Int]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? TableViewCell{
            let updateObject = tableViewData[indexPath.row]
            var isDisabled = false
            for id in self.tableViewRestrictionsData{
                if "\(updateObject.id)" == "\(id)"{
                    isDisabled = true
                    cell.isUserInteractionEnabled = false
                    break
                }
            }
            cell.updateUi(name: updateObject.name, id: "\(updateObject.id)", isDisabled:  isDisabled)
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}
