//
//  Policy.swift
//  Capsula
//
//  Created by SherifShokry on 12/5/20.
//  Copyright © 2020 SherifShokry. All rights reserved.
//

import Foundation

struct Policy : Codable {

    
    let  title: String?
    let  subject: String?
    var  isExpanded = false
    
    enum CodingKeys: String, CodingKey {
        case title, subject
    }
    
    init(){
  
        title = ""
        subject = ""
    
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do { title = try container.decodeIfPresent(.title) ?? "" }
        catch {  title = "" }
        do {   subject = try container.decodeIfPresent(.subject) ?? ""}
        catch { subject = "" }
    }
}
