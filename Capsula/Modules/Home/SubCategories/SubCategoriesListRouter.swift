//
//  SubCategoriesListRouter.swift
//  Capsula
//
//  Created SherifShokry on 2/8/20.
//  Copyright © 2020 SherifShokry. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class SubCategoriesListRouter : PresenterToRouterSubCategoriesListProtocol {
    
    static func createModule(category : Category) -> UIViewController {
        
        let view = SubCategoriesListViewController.instantiateFromStoryBoard(appStoryBoard: .Home)
        let presenter : ViewToPresenterSubCategoriesListProtocol & InteractorToPresenterSubCategoriesListProtocol = SubCategoriesListPresenter()
        let interactor : PresenterToIntetractorSubCategoriesListProtocol = SubCategoriesListInteractor()
        let router : PresenterToRouterSubCategoriesListProtocol = SubCategoriesListRouter()
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.category = category
        presenter.view = view
        presenter.router = router
        interactor.presenter = presenter
        return view
    }
    
    
    static func createModule(category : Category, storeId : Int) -> UIViewController {
          
          let view = SubCategoriesListViewController.instantiateFromStoryBoard(appStoryBoard: .Home)
          let presenter : ViewToPresenterSubCategoriesListProtocol & InteractorToPresenterSubCategoriesListProtocol = SubCategoriesListPresenter()
          let interactor : PresenterToIntetractorSubCategoriesListProtocol = SubCategoriesListInteractor()
          let router : PresenterToRouterSubCategoriesListProtocol = SubCategoriesListRouter()
          
          view.presenter = presenter
          presenter.interactor = interactor
          presenter.category = category
          presenter.storeId = storeId
          presenter.view = view
          presenter.router = router
          interactor.presenter = presenter
          return view
      }
    
    
    func openItemsScreen(from sourceView: PresenterToViewSubCategoriesListProtocol?, subCategory : Category) {
        let  vc = ItemsListRouter.createModule(category: subCategory)
        if let sourceView = sourceView as? UIViewController {
            sourceView.present(vc,animated: true, completion: nil)
        }
    }
    
    
    func openItemsScreen(from sourceView: PresenterToViewSubCategoriesListProtocol?, subCategory : Category,storeId : Int) {
           let  vc = ItemsListRouter.createModule(category: subCategory, storeId: storeId)
           if let sourceView = sourceView as? UIViewController {
               sourceView.present(vc,animated: true, completion: nil)
           }
       }
    
    
}
