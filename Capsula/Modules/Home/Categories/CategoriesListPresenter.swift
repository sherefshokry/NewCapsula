//
//  CategoriesListPresenter.swift
//  Capsula
//
//  Created SherifShokry on 2/7/20.
//  Copyright © 2020 SherifShokry. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

class CategoriesListPresenter : ViewToPresenterCategoriesListProtocol{
    
    
    var view: PresenterToViewCategoriesListProtocol?
    var interactor: PresenterToIntetractorCategoriesListProtocol?
    var router: PresenterToRouterCategoriesListProtocol?
    var categoriesData : [Category] = []
    var page : Int = 0
    var isFinishedPaging = false
    var storeId : Int = -1
    var numberOfRows : Int {
        return categoriesData.count
    }
    
    func configureCategoryCell(cell: CategoryCell, indexPath: IndexPath) {
        cell.setCategoryData(category: categoriesData[indexPath.item])
    }
    
    func swipeToRefresh(){
          categoriesData = []
          page = 0
          isFinishedPaging = false
          self.interactor?.emptyAllList()
          getCategoriesData()
       }
    
    func getCategoriesData() {
        
        let count = categoriesData.count
        page =  ( count / Constants.per_page ) + 1
        self.view?.changeState(state: .loading)
        
        if storeId == -1 {
            self.interactor?.getCategoriesData(page: page)
        }else{
            self.interactor?.getCategoriesData(storeId: storeId, page: page)
        }
        
    }
    
    
    func loadPagingData(indexPath : IndexPath){
              let count = categoriesData.count
              let newsCount = (count - 1)
               if indexPath.row == newsCount && !isFinishedPaging {
                  self.getCategoriesData()
              }
    }
    
    func didSelectCategory(indexPath: IndexPath) {
          self.router?.openItemsScreen(from: self.view, category: categoriesData[indexPath.item],storeId : storeId)
    }
    
    
}

extension CategoriesListPresenter : InteractorToPresenterCategoriesListProtocol {
    func categoriesDataFetchedSuccessfully(categoriesResponse: [Category]) {
        self.categoriesData = categoriesResponse
        self.view?.changeState(state: .ready)
    }
    
    func categoriesDataFailedToFetch(error: String) {
        self.view?.changeState(state: .error(error))
    }
    
    func stopPagination(){
        
              isFinishedPaging = true
        }
    
}
