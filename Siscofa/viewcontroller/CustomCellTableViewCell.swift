//
//  CustomClassTableViewCell.swift
//  Siscofa
//
//  Created by Glaubert Moreira Schult on 09/07/17.
//  Copyright © 2017 GMS. All rights reserved.
//

import UIKit

class CustomCellTableViewCell: UITableViewCell {
    @IBOutlet var lbQuantidade: UILabel!
    @IBOutlet var lbPeso: UILabel!
    @IBOutlet var lbValor: UILabel!
    @IBOutlet var lbSexo: UILabel!
    @IBOutlet var lbData: UILabel!
    @IBOutlet var lbTipo: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
