//
//  Idade.swift
//  Siscofa
//
//  Created by Glaubert Moreira Schult on 25/06/17.
//  Copyright © 2017 GMS. All rights reserved.
//

import Foundation
import ObjectMapper

class Idade : GenericEntity {
    
    var id : Int?
    var descricao: String?
    
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        id = aDecoder.decodeObject(forKey: "id") as? Int
        descricao = aDecoder.decodeObject(forKey: "descricao") as? String
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(id, forKey: "id")
        aCoder.encode(descricao, forKey: "descricao")
    }
    
    required init() {
        super.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        id <- map["id"]
        descricao <- map["descricao"]
        updated <- map["updated"]
        created <- map ["created"]
    }
}

