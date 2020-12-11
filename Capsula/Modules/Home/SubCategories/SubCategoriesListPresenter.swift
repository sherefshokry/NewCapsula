//
//  SubCategoriesListPresenter.swift
//  Capsula
//
//  Created SherifShokry on 2/8/20.
//  Copyright © 2020 SherifShokry. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

class SubCategoriesListPresenter : ViewToPresenterSubCategoriesListProtocol{
   
    
    
    var view: PresenterToViewSubCategoriesListProtocol?
    var interactor: PresenterToIntetractorSubCategoriesListProtocol?
    var router: PresenterToRouterSubCategoriesListProtocol?
    var subCategoriesData : [Category] = []
    var storeId : Int = -1
    var  category : Category = Category()
    var numberOfRows : Int {
           return subCategoriesData.count
       }
       
       func configureSubCategoryCell(cell: CategoryCell, indexPath: IndexPath) {
           cell.setCategoryData(category: subCategoriesData[indexPath.item])
       }
    
       func getSubCategoryData() {
        self.view?.changeState(state: .loading)
        if storeId == -1 {
              self.interactor?.getSubCategoriesData(categoryId: category.categoryId ?? -1)
        }else{
            self.interactor?.getSubCategoriesData(categoryId: category.categoryId ?? -1,storeId: storeId)
        }
     
       }
       
       func didSelectSubCategory(indexPath: IndexPath) {
        self.router?.openItemsScreen(from: self.view, subCategory: subCategoriesData[indexPath.item])
       }
       
    
    
}

extension SubCategoriesListPresenter : InteractorToPresenterSubCategoriesListProtocol {
    
    
    func subCategoriesDataFetchedSuccessfully(subCategoriesResponse: [Category]) {
        
           self.subCategoriesData = subCategoriesResponse
           self.view?.changeState(state: .ready)
       }
       
       func subCategoriesDataFailedToFetch(error: String) {
           self.view?.changeState(state: .error(error))
       }
       
       
 
}

