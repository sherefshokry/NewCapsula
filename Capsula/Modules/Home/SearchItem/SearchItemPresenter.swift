//
//  SearchItemPresenter.swift
//  Capsula
//
//  Created SherifShokry on 2/24/20.
//  Copyright © 2020 SherifShokry. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

class SearchItemPresenter : ViewToPresenterSearchItemProtocol{
    
    var view: PresenterToViewSearchItemProtocol?
    var interactor: PresenterToIntetractorSearchItemProtocol?
    var router: PresenterToRouterSearchItemProtocol?
    var itemsData = [Item]()
    var page : Int = 0
    var isFinishedPaging = false
    var filterType = -1
    var searchText = ""
    var numberOfRows : Int {
        return itemsData.count
    }
    
    func swipeToRefresh(){
             itemsData = []
               page = 0
               isFinishedPaging = false
               self.interactor?.emptyAllItems()
               itemsSearch()
            }
    
    func emptyData(){
          itemsData =  []
          self.interactor?.emptyAllItems()
          page = 0
          isFinishedPaging = false
      }
    
    func configureItemCell(cell: ItemCell, indexPath: IndexPath) {
        cell.setData(item: itemsData[indexPath.item])
        cell.addToCardPressed = { (selectedItem) in
            Utils.updateUserCart(list: [selectedItem]){
                if Utils.loadUser()?.accessToken ?? "" != "" {
                    self.view?.changeState(state: .loading)
                    self.interactor?.addItemsToCart(itemData: selectedItem)
                }}
            
        }
        
    }
    
    func setSearchText(searchText : String){
        self.searchText = searchText
    }
    
    func setFilterType(type : Int){
        self.filterType = type
    }
    
    func itemsSearch() {
        let count = itemsData.count
        page =  ( count / Constants.per_page ) + 1
        self.view?.changeState(state: .loading)
        self.interactor?.itemsSearch(searchText: self.searchText, filterType: self.filterType, page: page)
    }
    
    func loadPagingData(indexPath : IndexPath){
           let count = itemsData.count
           let newsCount = (count - 1)
            if indexPath.row == newsCount && !isFinishedPaging {
               self.itemsSearch()
           }
       }
    
    func didSelectItem(indexPath: IndexPath) {
        self.router?.openItemDetailsScreen(from: self.view, item: itemsData[indexPath.row])
    }
}

extension SearchItemPresenter : InteractorToPresenterSearchItemProtocol {
    func itemsDataFetchedSuccessfully(itemsResponse: [Item]) {
        self.itemsData = itemsResponse
        self.view?.changeState(state: .ready)
    }
    
    func itemsDataFailedToFetch(error: String) {
        self.view?.changeState(state: .error(error))
    }
    
    func  itemsDataAddedToCartSuccessfully(itemsResponse: [Item]){
        
        var user =  Utils.loadUser()
        user?.user?.cartContent = itemsResponse
        Utils.saveUser(user: user ?? UserResponse())
        NotificationCenter.default.post(name: Notification.Name(Constants.CART_UPDATE_NOTIFICATION), object: nil)
        self.view?.changeState(state: .ready)
        self.view?.showPopup(message: Strings.shared.itemAdded)
        
        
    }
    func stopPagination(){
              isFinishedPaging = true
        }
    
}
