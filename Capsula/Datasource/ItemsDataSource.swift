//
//  ItemDataSource.swift
//  Capsula
//
//  Created by SherifShokry on 2/15/20.
//  Copyright © 2020 SherifShokry. All rights reserved.
//

import Foundation
import Moya

public enum ItemsDataSource {
    case getItemsData(Int,Int)
    case getItemsDataWithCategoryId(Int,Int)
    case getTopSellingItems
    case getTopRatingItems
    case getFreeDliveryITems
    case itemsSearch(String,Int,Int)
    case getItemsDataWithStoreId(Int,Int,Int)
}

extension ItemsDataSource : TargetType {
    
    public var baseURL: URL {
        switch self {
             case .getItemsData(let brandId,let page):
                return URL(string: "\(Constants.BASE_URL)/Item/GetItemsByBrandId?brandId=\(brandId)&PageNumber=\(page)&PageSize=\(Constants.per_page)")!
            case .getItemsDataWithCategoryId(let categoryId,let page):
            return URL(string: "\(Constants.BASE_URL)/Item/GetItemsBySubCategoryId?subCategoryId=\(categoryId)&PageNumber=\(page)&PageSize=\(Constants.per_page)")!
             case .getItemsDataWithStoreId(let categoryId, let storeId,let page):
                       return URL(string: "\(Constants.BASE_URL)/Item/GetItemsByStoreCategoryId?categoryId=\(categoryId)&storeId=\(storeId)&PageNumber=\(page)&PageSize=\(Constants.per_page)")!
            
            case .itemsSearch(let searchText, let filterType, let page):
                let urlString = "\(Constants.BASE_URL)/Item/ItemsSearch?itemName=\(searchText)&filterType=\(filterType)&PageNumber=\(page)&PageSize=\(Constants.per_page)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return URL(string: urlString)!
             default:
                  return URL(string: "\(Constants.BASE_URL)/Item")!
             }
    }
  
    public var path: String {
        switch self {
        case .getItemsData(_,_):
            return ""
        case .getTopSellingItems:
            return "/GetTopSellingItems"
        case .getTopRatingItems:
            return "/GetTopRatingItems"
        case .getItemsDataWithCategoryId(_,_):
            return ""
        case .itemsSearch(_,_,_):
            return ""
        case .getFreeDliveryITems:
            return "/GetFreeDeliveryItems"
        case .getItemsDataWithStoreId(_, _,_):
            return ""
        }
    }
    
    public var method: Moya.Method {
        switch self {
         case .getItemsData:
            return .get
        case .getTopSellingItems:
            return .get
        case .getTopRatingItems:
            return .get
        case .getItemsDataWithCategoryId(_,_):
            return .get
        case .itemsSearch(_, _,_):
            return .get
        case .getFreeDliveryITems:
            return .get
        case .getItemsDataWithStoreId(_, _,_):
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .getItemsData:
            return .requestPlain
        case .getTopSellingItems:
            return .requestPlain
        case .getTopRatingItems:
            return .requestPlain
        case .getItemsDataWithCategoryId(_,_):
            return .requestPlain
        case .itemsSearch(_, _,_):
            return .requestPlain
        case .getFreeDliveryITems:
            return .requestPlain
        case .getItemsDataWithStoreId(_, _,_):
            return .requestPlain
        }
    }
    
    public var headers: [String: String]? {
        return BaseDataSource.getHeader() as? [String : String] ?? [:]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}

