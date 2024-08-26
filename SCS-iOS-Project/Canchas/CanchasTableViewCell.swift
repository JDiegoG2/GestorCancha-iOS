//
//  CanchaTableViewCell.swift
//  SCS-iOS-Project
//
//  Created by Diego Gatica on 21/08/24.
//

import UIKit

class CanchasTableViewCell: UITableViewCell {

    @IBOutlet weak var tipoCanchaLabel: UILabel!
    @IBOutlet weak var numeroDeCanchaLabel: UILabel!
    @IBOutlet weak var precioCanchaLabel: UILabel!
    @IBOutlet weak var sedeCanchaLabel: UILabel!
    @IBOutlet weak var disponibilidadCanchaLabel: UILabel!
    @IBOutlet weak var disponibilidadCanchaFinLabel: UILabel!
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
