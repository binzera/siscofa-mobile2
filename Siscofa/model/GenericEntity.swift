//
//  GenericEntity.swift
//  Siscofa
//
//  Created by Glaubert Moreira Schult on 05/03/17.
//  Copyright © 2017 GMS. All rights reserved.
//

import Foundation
import ObjectMapper

class GenericEntity : NSObject, Mappable, NSCoding {
    
    var created: Int?
    var updated: Int?
    
    required override init(){
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        created <- map["created"]
        updated <- map["updated"]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(created, forKey: "created")
        aCoder.encode(updated, forKey: "updated")
    }
    
    required init?(coder aDecoder: NSCoder) {
        created = aDecoder.decodeObject(forKey: "created") as? Int
        updated = aDecoder.decodeObject(forKey : "updated") as? Int
    }
    
}
