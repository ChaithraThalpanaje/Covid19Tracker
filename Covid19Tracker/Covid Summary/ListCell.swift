//
//  ListCell.swift
//  Covid19Tracker
//
//  Created by Chaithra Thalpanaje Shrikrishna on 19/08/21.
//

import Foundation
import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var countryImageview: UIImageView!
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var tapView: UIView!
    var tapCellAction: ActionHandler?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func setupUI() {
        lblCountryName.textColor = UIColor.black
        lblType.textColor = UIColor.darkGray
        lblCountryName.font = UIFont.boldSystemFont(ofSize: 18)
        lblType.font = UIFont.systemFont(ofSize: 12)
    }

    @IBAction func tapAction(sender: UIButton) {
        tapCellAction?()
    }
}
