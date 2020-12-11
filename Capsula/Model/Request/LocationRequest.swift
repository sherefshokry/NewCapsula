//
//  LocationRequest.swift
//  Capsula
//
//  Created by SherifShokry on 12/5/20.
//  Copyright © 2020 SherifShokry. All rights reserved.
//

import Foundation


public class LocationRequest  : Codable {
    
    var latitude = 0.0
    var longitude = 0.0
    var addressDesc = ""
    
    init(){
    }
 
    func getParams() -> [String : Any]{
        var params = [String : Any]()
        params["latitude"] = latitude
        params["longitude"] = longitude
        params["addressDesc"] = addressDesc
        return params
        
    }
}
