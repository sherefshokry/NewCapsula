//
//  OrderDetailsResponse.swift
//  Capsula
//
//  Created by SherifShokry on 4/28/20.
//  Copyright © 2020 SherifShokry. All rights reserved.
//

import Foundation

struct  OrderDetailsResponse : Codable {
    let products : [Item]?
    let id : Int?
    let statusId : Int?
    let totalPrice : Double?
    let deliveryAddress : String?
    let prescriptionImageLink : String?
    let insuranceNumberImageLink : String?
    let paymentMethodId : Int?
    let itemsCost : Double?
    let vatCost : Double?
    let deliveryCost : Double?
    let finalTotalCost : Double?
    
  

    enum CodingKeys: String, CodingKey {
        case  products, id ,statusId = "orderStatusId" ,totalPrice , deliveryAddress ,prescriptionImageLink,
        insuranceNumberImageLink,paymentMethodId,itemsCost,vatCost,finalTotalCost,deliveryCost
    }
    
    init(){
        products = []
        id = -1
        statusId = -1
        totalPrice = 0.0
        deliveryAddress = ""
        prescriptionImageLink = ""
        insuranceNumberImageLink = ""
        paymentMethodId  = -1
        itemsCost = 0.0
        vatCost = 0.0
        finalTotalCost = 0.0
        deliveryCost = 0.0
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {  products = try container.decodeIfPresent(.products) ?? [] }
        catch {  products = [] }
        do { id = try container.decodeIfPresent(.id) ?? -1 }
        catch {  id =  -1 }
        do { statusId = try container.decodeIfPresent(.statusId) ?? -1 }
        catch { statusId =  -1 }
        do { totalPrice = try container.decodeIfPresent(.totalPrice) ?? 0.0 }
        catch { totalPrice =  0.0 }
        do { deliveryAddress = try container.decodeIfPresent(.deliveryAddress ) ?? "" }
        catch { deliveryAddress = "" }
        do { prescriptionImageLink = try container.decodeIfPresent(.prescriptionImageLink) ?? "" }
        catch { prescriptionImageLink = "" }
        do { insuranceNumberImageLink = try container.decodeIfPresent(.insuranceNumberImageLink) ?? "" }
        catch { insuranceNumberImageLink = "" }
        do { paymentMethodId = try container.decodeIfPresent(.paymentMethodId) ?? -1 }
        catch { paymentMethodId =  -1 }
        
        do { itemsCost = try container.decodeIfPresent(.itemsCost) ?? 0.0 }
        catch { itemsCost =  0.0 }
        
        do { vatCost = try container.decodeIfPresent(.vatCost) ?? 0.0 }
        catch { vatCost =  0.0 }
        
        do { finalTotalCost = try container.decodeIfPresent(.finalTotalCost) ?? 0.0 }
        catch { finalTotalCost =  0.0 }
        
        do { deliveryCost = try container.decodeIfPresent(.deliveryCost) ?? 0.0 }
               catch { deliveryCost =  0.0 }
      
    }
}
