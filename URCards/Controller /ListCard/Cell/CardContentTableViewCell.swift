//
//  CardContentTableViewCell.swift
//  URCards
//
//  Created by Nam Ngây on 15/01/2022.
//

import UIKit

class CardContentTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupData(data: Card) {
        contentLabel.text = "\(data.IDCard). \(data.content)"
    }
    
}
