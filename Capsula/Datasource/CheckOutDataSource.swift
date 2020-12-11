//
//  CheckOutDataSource.swift
//  Capsula
//
//  Created by SherifShokry on 4/20/20.
//  Copyright © 2020 SherifShokry. All rights reserved.
//

import Foundation
import Moya

public enum CheckOutDataSource {
    case checkout(CheckoutRequest)
    case getDeliveryCost
    case prepareCheckout(Int)
    case ordersList(Int)
    case orderTrackingList(Int)
    case orderDetails(Int)
    case cancelOrder(Int)
    case prepareRegistration(Int)
    case saveCard(Int,String)
    case validateAddress
    
}

extension CheckOutDataSource : TargetType {
    
    public var baseURL: URL {
        
        switch self {
            case .cancelOrder(let orderId):
            return URL(string: "\(Constants.BASE_URL)/Order/CancelOrder?orderId=\(orderId)")!
         case .orderTrackingList(let orderId):
             return URL(string: "\(Constants.BASE_URL)/Order/GetOrderTracking?orderId=\(orderId)")!
        case .orderDetails(let orderId):
            return URL(string: "\(Constants.BASE_URL)/Order/GetOrderDetails?orderId=\(orderId)")!
        case .saveCard(let paymentMethod , let resourcePath):
              return URL(string: "\(Constants.BASE_URL)/CheckOut/SaveCard?registerMethodType=\(paymentMethod)&resourcePath=\(resourcePath)")!
        case .ordersList(let page):
            return URL(string: "\(Constants.BASE_URL)/Order/GetOrders?PageNumber=\(page)&PageSize=\(Constants.per_page)")!
        default:
            return URL(string: "\(Constants.BASE_URL)")!
        }}
  
    public var path: String {
        switch self {
        case .checkout(_):
            return "/CheckOut"
        case .ordersList:
            return ""
        case .orderTrackingList(_):
            return ""
        case .orderDetails(_):
            return ""
        case .cancelOrder(_):
            return ""
        case .getDeliveryCost:
            return "/CheckOut/GetDeliveryCost"
        case .prepareCheckout(let paymentMethodID):
            return "/CheckOut/PrepareCheckout/\(paymentMethodID)"
        case .prepareRegistration(let paymentMethodID):
             return "/CheckOut/PrepareRegisteration/\(paymentMethodID)"
        case .saveCard:
            return ""
        case .validateAddress:
            return "/CheckOut/ValidateDeliveryAddress"
        }
    }
    
    public var method: Moya.Method {
        switch self {
         case .checkout(_):
            return .post
        case .ordersList:
            return .get
        case .orderTrackingList:
            return .get
        case .orderDetails(_):
            return .get
        case .cancelOrder(_):
            return .put
        case .getDeliveryCost:
            return .get
        case .prepareCheckout(_):
            return .get
        case .prepareRegistration(_):
            return .get
        case .saveCard(_,_):
            return .get
        case .validateAddress:
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .checkout(let request):
           return .requestParameters(parameters: request.getParams(), encoding: JSONEncoding.default)
        case .ordersList:
            return .requestPlain
        case .orderTrackingList(_):
            return .requestPlain
        case .orderDetails(_):
            return .requestPlain
        case .cancelOrder(_):
            return .requestPlain
        case .getDeliveryCost:
            return .requestPlain
        case .prepareCheckout(_):
            return .requestPlain
        case .prepareRegistration(_):
            return .requestPlain
        case .saveCard(_,_):
            return .requestPlain
        case .validateAddress:
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
