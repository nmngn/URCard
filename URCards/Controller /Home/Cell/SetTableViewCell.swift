//
//  SetTableViewCell.swift
//  URCard
//
//  Created by Nam Ngây on 12/01/2022.
//

import UIKit

protocol HomeViewDelegate: Any {
    func sendSetName(id: Int, name: String)
}

class SetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    var delegate: HomeViewDelegate?
    var id = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.do {
            $0.delegate = self
            $0.makeShadow()
            $0.autocorrectionType = .no
            $0.setLeftPaddingPoints(16)
            $0.setRightPaddingPoints(16)
            $0.isEnabled = false
        }
    }
    
    func setupData(data: SetCard, color: UIColor) {
        id = data.IDSet
        textField.text = data.name
//        textField.textColor = color
    }

    @IBAction func changeSetName(_ sender: UIButton) {
        textField.isEnabled = true
    }
}

extension SetTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            if !text.isEmpty {
                textField.isEnabled = false
                delegate?.sendSetName(id: self.id, name: text)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
