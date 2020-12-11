//
//  PolicyResponse.swift
//  Capsula
//
//  Created by SherifShokry on 12/5/20.
//  Copyright © 2020 SherifShokry. All rights reserved.
//

import Foundation

struct  PolicyResponse : Codable {
    var  policyList : [Policy]?
    
    
   enum CodingKeys: String, CodingKey {
      case  policyList  = "list"
    }
    
    init(){
     policyList  = []
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do { policyList  = try container.decodeIfPresent(.policyList) ?? [] }
        catch { policyList  = [] }
    }
}

