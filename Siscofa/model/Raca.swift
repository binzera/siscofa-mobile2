import Foundation
import ObjectMapper

class Raca : GenericEntity {
    
    var id : Int?
    var nome: String?

    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        id = aDecoder.decodeObject(forKey: "id") as? Int
        nome = aDecoder.decodeObject(forKey: "nome") as? String
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(id, forKey: "id")
        aCoder.encode(nome, forKey: "nome")
    }
    
    required init() {
        super.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        id <- map["id"]
        nome <- map["nome"]
        updated <- map["updated"]
        created <- map ["created"]
    }
    
    
    

}
