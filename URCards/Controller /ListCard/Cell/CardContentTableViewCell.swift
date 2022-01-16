//
//  CardContentTableViewCell.swift
//  URCards
//
//  Created by Nam Ngây on 15/01/2022.
//

import UIKit

class CardContentTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var subView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupData(data: Card, color: UIColor) {
        contentLabel.text = "\(data.IDCard). \(data.content)"
        contentLabel.textColor = color
    }
    
}
