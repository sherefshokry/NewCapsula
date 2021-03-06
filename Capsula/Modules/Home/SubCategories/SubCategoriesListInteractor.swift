//
//  SubCategoriesListInteractor.swift
//  Capsula
//
//  Created SherifShokry on 2/8/20.
//  Copyright © 2020 SherifShokry. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import Moya

class SubCategoriesListInteractor : PresenterToIntetractorSubCategoriesListProtocol {
    
    var presenter: InteractorToPresenterSubCategoriesListProtocol?
    private let provider = MoyaProvider<CategoriesDataSource>()
           
    func getSubCategoriesData(categoryId : Int) {
        
        provider.request(.getSubCategoriesData(categoryId)) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let response):
                        do {
                    
                    let categoriesResponse = try response.map(BaseResponse<CategoriesResponse>.self)
                            self.presenter?.subCategoriesDataFetchedSuccessfully(subCategoriesResponse: categoriesResponse.data?.categoriesList ?? [])
                            
                            
                        } catch(let catchError) {
                            self.presenter?.subCategoriesDataFailedToFetch(error: catchError.localizedDescription)
                         }
                    case .failure(let error):
                        do{
                            if let body = try error.response?.mapJSON(){
                                let errorData = (body as! [String:Any])
                                self.presenter?.subCategoriesDataFailedToFetch(error: (errorData["errors"] as? String) ?? "")
                            }
                        }catch{
                            self.presenter?.subCategoriesDataFailedToFetch(error: error.localizedDescription)
                        }
                    }
                }
                
            }
    
    
    
    func getSubCategoriesData(categoryId : Int,storeId: Int) {
         
         provider.request(.getSubCategoriesDataByStoreId(categoryId, storeId)) { [weak self] result in
                     guard let self = self else { return }
                     switch result {
                     case .success(let response):
                         do {
                     
                     let categoriesResponse = try response.map(BaseResponse<CategoriesResponse>.self)
                             self.presenter?.subCategoriesDataFetchedSuccessfully(subCategoriesResponse: categoriesResponse.data?.categoriesList ?? [])
                             
                             
                         } catch(let catchError) {
                             self.presenter?.subCategoriesDataFailedToFetch(error: catchError.localizedDescription)
                          }
                     case .failure(let error):
                         do{
                             if let body = try error.response?.mapJSON(){
                                 let errorData = (body as! [String:Any])
                                 self.presenter?.subCategoriesDataFailedToFetch(error: (errorData["errors"] as? String) ?? "")
                             }
                         }catch{
                             self.presenter?.subCategoriesDataFailedToFetch(error: error.localizedDescription)
                         }
                     }
                 }
                 
             }
           
}

