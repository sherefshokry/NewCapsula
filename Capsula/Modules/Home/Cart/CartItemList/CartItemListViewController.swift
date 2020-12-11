//
//  CartItemListViewController.swift
//  Capsula
//
//  Created SherifShokry on 3/29/20.
//  Copyright © 2020 SherifShokry. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import SwipeCellKit
import KVNProgress
import Intercom

class CartItemListViewController: UIViewController {
    
    var presenter : ViewToPresenterCartItemListProtocol?
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var numberOfItemsLabel : UILabel!
    @IBOutlet weak var numberOfItemsCartLabel : UILabel!
    @IBOutlet weak var totalPrice : UILabel!
    @IBOutlet weak var clearAllBtn : UIButton!
    var items = [Item]()
    var nextPressed: (()->())?
    
    private var state: State = .loading {
        didSet {
            switch state {
            case .ready:
                KVNProgress.dismiss()
                tableView.reloadData()
            case .loading:
                KVNProgress.show(withStatus: "", on: self.view)
            case .error(let error):
                KVNProgress.dismiss()
                self.showMessage(error)
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearAllBtn.setUnderLineText(text: Strings.shared.clearAll)
        if items.count > 0 {
            Utils.updateUserCart(list: items){
                
            }
        }
        
        self.presenter?.viewDidLoad()
     
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if Utils.loadUser()?.accessToken ?? "" != "" {
               Intercom.setLauncherVisible(true)
            }
        }
    
    
    
    @IBAction func nextPressed(_ sender : UIButton){
        if Utils.loadUser()?.accessToken ?? "" != "" {
           self.presenter?.validateCartItems()
        }else{
            UIApplication.shared.windows[0].visibleViewController?.areYouSureMsg(Msg: Strings.shared.pleaseLogin, funcToLoad: { (yes) in
                if yes {
                    Utils.openLoginScreen(isDeliveryMan: false)
                }
            })
        }
        
    }
    
    
    @IBAction func clearAllPressed(_ sender : UIButton){
       
        Utils.emptyLocalCart()
        self.presenter?.emptyList()
    }
    
}
extension CartItemListViewController : UITableViewDataSource , UITableViewDelegate,SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
         
         if LocalizationSystem.sharedInstance.getLanguage() == "ar"{
              guard orientation == .left else { return nil }
         }else{
             guard orientation == .right else { return nil }
         }
        
         let deleteAction = SwipeAction(style: .destructive, title: "") { action, indexPath in
             self.presenter?.deleteItem(indexPath: indexPath)
         }
         
         deleteAction.image = UIImage(named: "icDelete")
         return [deleteAction]
     }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.presenter?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartITemCell.identifier, for: indexPath) as! CartITemCell
           cell.delegate = self
        self.presenter?.configureCartCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    

    
}

extension CartItemListViewController : PresenterToViewCartItemListProtocol {
      func changeState(state: State) {
          self.state = state
      }
    
    func reloadTableView(){
        tableView.reloadData()
    }
    
    func setNumberOfItemsLabel(numberOfItems :Int){
        self.numberOfItemsLabel.text = "\(numberOfItems) " + Strings.shared.items
        self.numberOfItemsCartLabel.text = "\(numberOfItems) " + Strings.shared.items
    }
    
    func setTotalPrice(totalPrice : Double){
        self.totalPrice.text = "\(Double(round(100*totalPrice)/100))"
    }
    
    
    func navigateToCartDetails(){
        
        if nextPressed != nil {
                 self.nextPressed?()
             }
        
    }

}