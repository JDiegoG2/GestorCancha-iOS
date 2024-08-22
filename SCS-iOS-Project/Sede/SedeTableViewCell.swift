//
//  SedeTableViewCell.swift
//  SCS-iOS-Project
//
//  Created by Diego Gatica on 21/08/24.
//

import UIKit

class SedeTableViewCell: UITableViewCell {

    @IBOutlet weak var idSedesLabel: UILabel!
    @IBOutlet weak var SedeLabel: UILabel!
    @IBOutlet weak var direccionSedeLabel: UILabel!
    @IBOutlet weak var telefonoSedeLabel: UILabel!
    @IBOutlet weak var estadoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
