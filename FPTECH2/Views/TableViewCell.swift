//
//  TableViewCell.swift
//  FPTECH2
//
//  Created by Manoj Bojja on 09/08/18.
//  Copyright © 2018 Manoj Bojja. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var lableName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUi(name:String, id: String){
        self.lableName.text = name
    }
    
    func updateUi(name: String, id: String, isDisabled: Bool){
        self.lableName.text = name
        if isDisabled{
            self.contentView.alpha = 0.5
            self.lableName.alpha = 0.5
        }
    }

}
