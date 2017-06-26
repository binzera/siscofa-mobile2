//
//  Lote.swift
//  Siscofa
//
//  Created by Glaubert Moreira Schult on 25/06/17.
//  Copyright © 2017 GMS. All rights reserved.
//

import Foundation
import ObjectMapper

class Lote : GenericEntity {
    
    var id : Int?
    var qtdArrobas: Int?
    var qtdGado : Int?
    var sexo : Character?
    var valorArroba : Double?
    var usuario : Usuario?
    var fazenda : Fazenda?
    var raca : Raca?
    var idade : Idade?
    //var lotes : Array<Lote>
    //var movimentacoes : Array<MovimentacaoGado>
    
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        id = aDecoder.decodeObject(forKey: "id") as? Int
        qtdGado = aDecoder.decodeObject(forKey: "qtdGado") as? Int
        qtdArrobas = aDecoder.decodeObject(forKey: "qtdArrobas") as? Int
        sexo = (aDecoder.decodeObject(forKey: "sexo") as? Character)!
        usuario = aDecoder.decodeObject(forKey: "usuario") as? Usuario
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(id, forKey: "id")
        aCoder.encode(qtdArrobas, forKey: "qtdArrobas")
        aCoder.encode(qtdGado, forKey: "qtdGado")
        aCoder.encode(sexo, forKey: "sexo")
        aCoder.encode(fazenda, forKey: "fazenda")
        aCoder.encode(usuario, forKey: "usuario")
    }
    
    required init() {
        super.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        id <- map["id"]
        qtdArrobas <- map["qtdArrobas"]
        qtdGado <- map["qtdGado"]
        sexo <- map["sexo"]
        valorArroba <- map["valorArroba"]
        usuario <- map["usuario"]
        updated <- map["updated"]
        created <- map ["created"]
    }
    
    
    
    
}
