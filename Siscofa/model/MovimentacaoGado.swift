//
//  MovimentacaoGado.swift
//  Siscofa
//
//  Created by Glaubert Moreira Schult on 26/06/17.
//  Copyright © 2017 GMS. All rights reserved.
//

import Foundation
import ObjectMapper

class MovimentacaoGado : GenericEntity {
    
    var id : Int?
    var peso: Int?
    var quantidade : Int?
    var sexo : Character?
    var valor : Double?
    var usuario : Usuario?
    var lote : Lote?
    var fazenda : Fazenda?
    var tipoMovimentacao : TipoMovimentacao?
    //var lotes : Array<Lote>
    //var movimentacoes : Array<MovimentacaoGado>
    
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        id = aDecoder.decodeObject(forKey: "id") as? Int
        quantidade = aDecoder.decodeObject(forKey: "quantidade") as? Int
        peso = aDecoder.decodeObject(forKey: "peso") as? Int
        sexo = (aDecoder.decodeObject(forKey: "sexo") as? Character)!
        usuario = aDecoder.decodeObject(forKey: "usuario") as? Usuario
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(id, forKey: "id")
        aCoder.encode(quantidade, forKey: "peso")
        aCoder.encode(peso, forKey: "quantidade")
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
        peso <- map["peso"]
        quantidade <- map["quantidade"]
        sexo <- map["sexo"]
        valor <- map["valor"]
        usuario <- map["usuario"]
        fazenda <- map["fazenda"]
        tipoMovimentacao <- map["tipoMovimentacao"]
        updated <- map["updated"]
        created <- map ["created"]
    }
    
    
    
    
}
