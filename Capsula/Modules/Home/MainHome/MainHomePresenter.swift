//
//  MainHomePresenter.swift
//  Capsula
//
//  Created SherifShokry on 2/2/20.
//  Copyright © 2020 SherifShokry. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//
import Foundation

class MainHomePresenter : ViewToPresenterMainHomeProtocol{
 
  
    var view: PresenterToViewMainHomeProtocol?
    var interactor: PresenterToIntetractorMainHomeProtocol?
    var router: PresenterToRouterMainHomeProtocol?
    var storesData : [Store] = []
    var page : Int = 0
    var isFinishedPaging = false
  
     
    func viewDidLoad(){
        if Utils.loadUser()?.accessToken ?? "" != "" {
                   self.interactor?.updateUserData()
      }
    }
    
    
    func swipeToRefresh(){
       storesData = []
       page = 0
       isFinishedPaging = false
       self.interactor?.emptyAllStores()
       getStoresData()
    }
    
    
    func  getStoresData() {
        let count = storesData.count
        page =  ( count / Constants.per_page ) + 1
        self.view?.changeState(state: .loading)
        self.interactor?.getStoresData(page: page)
      }
    
    func loadPagingData(indexPath : IndexPath){
           let count = storesData.count
           let newsCount = (count - 1)
            if indexPath.row == newsCount && !isFinishedPaging {
               self.getStoresData()
           }
       }
    
    
    func refreshDevice(){
        self.interactor?.refreshDevice()
    }
    
    
    var numberOfRows : Int {
        return storesData.count
    }
    
    func configureStoreCell(cell: StoreCell, indexPath: IndexPath) {
        cell.setStoreData(store: storesData[indexPath.item])
    }
    
    
    func didSelectStore(indexPath: IndexPath) {
        self.router?.openCategoriesScreen(from: self.view, storeId: storesData[indexPath.row].storeId ?? -1 )
       }
    
 
    
}
extension MainHomePresenter : InteractorToPresenterMainHomeProtocol {
 
    func storesDataFetchedSuccessfully(storesResponse: [Store]) {
        
        
        self.storesData = storesResponse
        self.view?.changeEmptyStoresStatus(isHidden: storesResponse.count > 0)
        self.view?.changeState(state: .ready)
    }
    
    func storesDataFailedToFetch(error: String) {
        self.view?.changeState(state: .error(error))
    }
    
    
    func homeDataFailedToFetch(error: String) {
        self.view?.changeState(state: .error(error))
    }

    func stopPagination(){
           isFinishedPaging = true
     }
    
}
