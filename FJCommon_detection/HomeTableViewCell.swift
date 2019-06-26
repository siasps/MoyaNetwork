//
//  HomeTableViewCell.swift
//  FJCommon_detection
//
//  Created by peng on 2019/6/25.
//  Copyright © 2019 peng. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var createTime: UILabel!
    @IBOutlet weak var descripation: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        print("++++++")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        print("-------")

    }

    
    public func reloadInformation(info:Dictionary<String,Any>){
        
        let id : Int32 = info["id"] as! Int32
        idLabel.text =  "id：" + String(id)
        createTime.text =  info["create_time"] as? String
        nameLabel.text = info["name"] as? String
        descripation.text = info["description"] as? String
        
    }

}
