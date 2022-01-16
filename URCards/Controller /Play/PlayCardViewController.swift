//
//  PlayCardViewController.swift
//  URCard
//
//  Created by Nam Ngây on 12/01/2022.
//

import UIKit
import RealmSwift

class PlayCardViewController: UIViewController {

    @IBOutlet weak var allCardLabel: UILabel!
    @IBOutlet weak var showedCardLabel: UILabel!
    @IBOutlet weak var switchOption: UISwitch!
    @IBOutlet weak var imageCard: UIImageView!
    @IBOutlet weak var buttonFlip: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var theme: UIImageView!
    @IBOutlet weak var contentCardLabel: UILabel!
    
    var isOpen = false
    let realm = try! Realm()
    var listCard = [Card]()
    var showedCard = 0
    var IDSet = 0
    var isRemoveShowedCard = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCard.image = UIImage(named: "front")
        self.title = "Play"
        setupNavigationButton()
        changeTheme(theme)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getListCard()
    }
    
    func getListCard() {
        let listCard = realm.objects(Card.self).filter("IDSet = %d", IDSet).toArray()
        self.listCard = listCard
        setupView()
    }
    
    func setupNavigationButton() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        let backItem = UIBarButtonItem(image:  UIImage(named: "ic_left_arrow"), style: .plain, target: self, action: #selector(touchBackButton))
        navigationItem.leftBarButtonItems = [backItem]
        
        let rightItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action:
                                        #selector(showListCard))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func touchBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func showListCard() {
        let vc = ListCardViewController.init(nibName: "ListCardViewController", bundle: nil)
        vc.IDSet = IDSet
        vc.listCard = listCard
        vc.dismissVC = { [weak self] in
            self?.getListCard()
        }
        present(vc, animated: true, completion: nil)
    }
    
    func setupView() {
        switchOption.isOn = false
        allCardLabel.text = "\(self.listCard.count)"
        showedCardLabel.text = "\(self.showedCard)"
        contentCardLabel.isHidden = true
    }

    @IBAction func refreshOption(_ sender: UIButton) {
        getListCard()
    }
    
    @IBAction func mixedCard(_ sender: UIButton) {
        
    }
    
    @IBAction func isRemoveShowedCard(_ sender: UISwitch) {
        isRemoveShowedCard = sender.isOn
    }
    
    @IBAction func flipCard(_ sender: Any) {
        if isOpen {
            isOpen = false
            UIView.transition(with: imageCard, duration: 1, options: .transitionFlipFromRight, animations: {
                self.imageCard.image = UIImage(named: "front")
            }, completion: nil)
            contentCardLabel.isHidden = true
        } else {
            isOpen = true
            self.showedCard += 1
            showedCardLabel.text = "\(self.showedCard)"
            UIView.transition(with: imageCard, duration: 1, options: .transitionFlipFromRight, animations: {
                self.imageCard.image = UIImage(named: "back")
            }, completion: nil)
            if showedCard < listCard.count {
                if let card = listCard.randomElement() {
                    if isRemoveShowedCard {
                        listCard.removeAll(where: {$0.IDCard == card.IDCard})
                    }
                    contentCardLabel.text = "It's your turn 🙂\n\n\(card.IDCard). \(card.content)"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.contentCardLabel.isHidden = false
                    }
                }
            }
            
        }
    }
    
}
