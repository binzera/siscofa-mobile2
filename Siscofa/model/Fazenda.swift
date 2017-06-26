//
//  Fazenda.swift
//  Siscofa
//
//  Created by Glaubert Moreira Schult on 25/06/17.
//  Copyright © 2017 GMS. All rights reserved.
//

import Foundation
import ObjectMapper

class Fazenda : GenericEntity {
    
    var id : Int?
    var nome: String?
    var qtdAlqueires : Int?
    var usuario : Usuario?
    //var lotes : Array<Lote>
    //var movimentacoes : Array<MovimentacaoGado>
    
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        id = aDecoder.decodeObject(forKey: "id") as? Int
        nome = aDecoder.decodeObject(forKey: "nome") as? String
        qtdAlqueires = aDecoder.decodeObject(forKey: "qtdAlqueires") as? Int
        usuario = aDecoder.decodeObject(forKey: "usuario") as? Usuario
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(id, forKey: "id")
        aCoder.encode(nome, forKey: "nome")
        aCoder.encode(qtdAlqueires, forKey: "qtdAlqueires")
        aCoder.encode(usuario, forKey: "usuario")
    }
    
    required init() {
        super.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        id <- map["id"]
        nome <- map["nome"]
        qtdAlqueires <- map["qtdAlqueires"]
        usuario <- map["usuario"]
        updated <- map["updated"]
        created <- map ["created"]
    }
    
    
    
    
}
