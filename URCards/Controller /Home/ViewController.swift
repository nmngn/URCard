//
//  ViewController.swift
//  URCard
//
//  Created by Nam Ngây on 12/01/2022.
//

import UIKit
import Then
import RealmSwift
import IQKeyboardManagerSwift
import Toast_Swift

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var theme: UIImageView!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    let realm = try! Realm()
    var listSet: [SetCard]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var contrastColor = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        configView()
        getListSet()
        changeTheme(theme)
        if self.traitCollection.userInterfaceStyle == .light {
            contrastColor = .black
        } else {
            contrastColor = UIColor.white.withAlphaComponent(0.8)
        }
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getListSet()
    }
    
    func getListSet() {
        do {
            let list = realm.objects(SetCard.self).toArray()
            self.listSet = list
            if list.count > 5 {
                UIView.animate(withDuration: 1, delay: 0.5, options: .curveEaseInOut, animations: {
                    self.tableViewHeightConstraint.constant = 437
                }, completion: nil)
            } else if list.count <= 5 {
                UIView.animate(withDuration: 1, delay: 0.5, options: .curveEaseInOut, animations: {
                    self.tableViewHeightConstraint.constant = 316
                }, completion: nil)
            }
        }
    }

    func configView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.separatorStyle = .none
            $0.tableFooterView = UIView()
            $0.registerNibCellFor(type: SetTableViewCell.self)
            $0.keyboardDismissMode = .onDrag
        }
    }
    
    func saveData(text: String) {
        do {
            realm.beginWrite()
            let newSet = SetCard()
            newSet.IDSet = realm.objects(SetCard.self).count + 1
            newSet.name = text
            try? realm.commitWrite()
            try? realm.safeWrite {
                realm.add(newSet)
                self.view.makeToast("Lưu thành công")
            }
        }
    }
    
    func updateSetName(id: Int, name: String) {
        let set = realm.objects(SetCard.self).filter("IDSet = %d", id)
        
        do {
            if let item = set.first {
                try! realm.write {
                    item.name = name
                    self.view.makeToast("Lưu thành công")
                }
            }
            
        }
    }
    
    @IBAction func addNewSet(_ sender: UIButton) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Set Card", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            if let text = textField.text {
                if !text.isEmpty {
                    self.saveData(text: text)
                }
            }
            self.getListSet()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Set Card Name"
            textField = alertTextField
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func removeSet(_ ID: Int, index: IndexPath) {
        let set = self.realm.objects(SetCard.self).filter("IDSet = %d", ID)
        let card = self.realm.objects(Card.self).filter("IDSet = %d", ID)
        try! self.realm.write({
            self.realm.delete(set)
            self.realm.delete(card)
        })
        getListSet()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listSet?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SetTableViewCell", for: indexPath) as? SetTableViewCell else { return UITableViewCell() }
        if let data = listSet?[indexPath.row] {
            cell.setupData(data: data, color: contrastColor)
        }
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let list = listSet?[indexPath.row] {
            let vc = PlayCardViewController.init(nibName: "PlayCardViewController", bundle: nil)
            vc.IDSet = list.IDSet
            vc.setName = list.name
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let data = listSet?[indexPath.row] {
                removeSet(data.IDSet, index: indexPath)
            }
        }
    }
}

extension ViewController: HomeViewDelegate {
    func sendSetName(id: Int, name: String) {
        updateSetName(id: id, name: name)
    }
}
