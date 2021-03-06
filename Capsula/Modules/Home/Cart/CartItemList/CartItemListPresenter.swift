//
//  CartItemListPresenter.swift
//  Capsula
//
//  Created SherifShokry on 3/29/20.
//  Copyright © 2020 SherifShokry. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//
import Foundation

class CartItemListPresenter : ViewToPresenterCartItemListProtocol{
    
    var itemsData = [Item]()
    var view: PresenterToViewCartItemListProtocol?
    var interactor: PresenterToIntetractorCartItemListProtocol?
    var router: PresenterToRouterCartItemListProtocol?
    var numberOfRows : Int {
           return itemsData.count
       }
    
    func viewDidLoad()  {
        let localCart = Utils.loadLocalCart() ?? []
          itemsData = localCart
        if Utils.loadUser()?.accessToken ?? "" != "" {
            self.view?.changeState(state: .loading)
            self.interactor?.addItems(itemsData: itemsData)
        }
       
          refreshAllCart()
    }
    
    func validateCartItems(){
        
        self.view?.changeState(state: .loading)
        self.interactor?.validateItems()
        
        
    }
    
    
    func emptyList(){
       
        if Utils.loadUser()?.accessToken ?? "" != "" {
            self.view?.changeState(state: .loading)
            self.interactor?.deleteAll()
        }else{
            Utils.emptyLocalCart()
            itemsData = []
            self.refreshAllCart()
            NotificationCenter.default.post(name: Notification.Name(Constants.CART_UPDATE_NOTIFICATION), object: nil)
        }
    
    }
    
    func deleteItem(indexPath : IndexPath){
        
        if Utils.loadUser()?.accessToken ?? "" != "" {
            self.view?.changeState(state: .loading)
            self.interactor?.deleteItem(itemId: itemsData[indexPath.row].mainId ?? -1)
            
        }else{
            itemsData.remove(at: indexPath.row)
            Utils.addAllLocalCart(itemsList: itemsData)
            refreshAllCart()
        }
        
       
        NotificationCenter.default.post(name: Notification.Name(Constants.CART_UPDATE_NOTIFICATION), object: nil)
    }
    
    func configureCartCell(cell: CartITemCell, indexPath: IndexPath) {
        cell.setItemData(item: itemsData[indexPath.row])
        cell.onPlusPressd = { (selectedItem) in
            
            let itemIndex = self.itemsData.firstIndex(of: selectedItem) ?? -1
              (self.itemsData[itemIndex].itemQuantity) =   (self.itemsData[itemIndex].itemQuantity ?? 1)  + 1
            
            if Utils.loadUser()?.accessToken ?? "" != "" {
                self.view?.changeState(state: .loading)
                self.interactor?.updateItem(item: self.itemsData[indexPath.row])
            }else{
                Utils.addAllLocalCart(itemsList: self.itemsData)
                self.refreshAllCart()
            }
            self.refreshAllCart()
        }
        
        cell.onMinusPressd = { (selectedItem) in
            let itemIndex =  self.itemsData.firstIndex(of: selectedItem) ?? -1
            if (self.itemsData[itemIndex].itemQuantity ?? 1) > 1 {
                (self.itemsData[itemIndex].itemQuantity) =   (self.itemsData[itemIndex ].itemQuantity ?? 1)  - 1
                if Utils.loadUser()?.accessToken ?? "" != "" {
                    self.view?.changeState(state: .loading)
                    self.interactor?.updateItem(item: self.itemsData[indexPath.row])
                }else{
                     Utils.addAllLocalCart(itemsList: self.itemsData)
                }
                self.refreshAllCart()
             }
          }
       }
    

    func refreshAllCart(){
        self.view?.reloadTableView()
        self.view?.setNumberOfItemsLabel(numberOfItems: itemsData.count)
        self.calcTotalPrice()
    }
    
    func calcTotalPrice() {
        var totalPrice = 0.0
        itemsData.forEach { (item) in
            if item.offerType == -1 {
                totalPrice = totalPrice + ((item.price ?? 0.0) * Double(item.itemQuantity ?? 1))
            }else{
                totalPrice = totalPrice + ((item.priceInOffer ?? 0.0) * Double(item.itemQuantity ?? 1))
            }
        }
        self.view?.setTotalPrice(totalPrice : totalPrice)
     }
    
}

extension CartItemListPresenter : InteractorToPresenterCartItemListProtocol {
    
    func itemsDataFetchedSuccessfully(itemsResponse: [Item]) {
        
         Utils.addAllLocalCart(itemsList: itemsResponse)
        itemsData = itemsResponse
        var user =  Utils.loadUser()
        user?.user?.cartContent = itemsResponse
        Utils.saveUser(user: user ?? UserResponse())
        refreshAllCart()
        self.view?.changeState(state: .ready)
        NotificationCenter.default.post(name: Notification.Name(Constants.CART_UPDATE_NOTIFICATION), object: nil)
    }
    
    func itemsValidatedSuccessfully(){
        //navigate to cart details
        self.view?.navigateToCartDetails()
    }
    
    
    func itemsDataFailedToFetch(error: String) {
        self.view?.changeState(state: .error(error))
    }
    
    func itemsDeletedSuccessfully(){
          Utils.emptyLocalCart()
          itemsData = []
          self.refreshAllCart()
        var user =  Utils.loadUser()
        user?.user?.cartContent = []
        Utils.saveUser(user: user ?? UserResponse())
        self.view?.changeState(state: .ready)
        NotificationCenter.default.post(name: Notification.Name(Constants.CART_UPDATE_NOTIFICATION), object: nil)
    }
 
}

