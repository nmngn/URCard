//
//  ListCardViewController.swift
//  URCards
//
//  Created by Nam Ngây on 14/01/2022.
//

import UIKit
import RealmSwift

class ListCardViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var IDSet = 0
    let realm = try! Realm()
    var listCard = [Card]()
    var dismissVC: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        backgroundImage.applyBlurEffect()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissVC?()
    }
    
    func getListCard() {
        let list = realm.objects(Card.self).filter("IDSet = %d", IDSet).toArray()
        self.listCard = list.reversed()
        self.tableView.reloadData()
    }
    
    func configView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.separatorStyle = .none
            $0.tableFooterView = UIView()
            $0.registerNibCellFor(type: CardContentTableViewCell.self)
            $0.keyboardDismissMode = .onDrag
        }
    }

    @IBAction func addCard(_ sender: UIButton) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Card", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            if let text = textField.text {
                if !text.isEmpty {
                    self.saveData(content: text)
                }
            }
            self.getListCard()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Card Content"
            textField = alertTextField
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func saveData(content: String) {
        do {
            realm.beginWrite()
            let newCard = Card()
            newCard.IDSet = self.IDSet
            newCard.IDCard = self.listCard.count + 1
            newCard.content = content
            try? realm.commitWrite()
            try? realm.safeWrite {
                realm.add(newCard)
                self.view.makeToast("Lưu thành công")
            }
        }
    }
    
    func updateCard(id: Int, content: String) {
        let card = realm.objects(Card.self).filter("IDCard = %d", id)
        
        do {
            if let item = card.first {
                try! realm.write {
                    item.content = content
                    self.view.makeToast("Lưu thành công")
                }
            }
        }
    }
    
    func removeCard(id: Int) {
        let card = self.realm.objects(Card.self).filter("IDCard = %d", id)
        try! self.realm.write({
            self.realm.delete(card)
        })
        getListCard()
    }
    
}

extension ListCardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCard.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardContentTableViewCell", for: indexPath) as?
                CardContentTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        cell.setupData(data: listCard[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeCard(id: listCard[indexPath.row].IDCard)
        }
    }
    
}
