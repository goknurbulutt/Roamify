//
//  StepTableViewCell.swift
//  Roamify
//
//  Created by Göknur Bulut on 26.03.2024.
//

import UIKit

class StepTableViewCell: UITableViewCell {

    @IBOutlet weak var stepLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    struct Step {
        var name: String
        var note: String
    }

}
