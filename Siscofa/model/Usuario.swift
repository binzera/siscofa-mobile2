import Foundation
import ObjectMapper

class Usuario : GenericEntity{
    
    var id : Int?
    var nome : String?
    var email : String?
    var usuario : String?
    var senha : String?
    
    required init(){
       super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        id = aDecoder.decodeObject(forKey: "id") as? Int
        nome = aDecoder.decodeObject(forKey: "nome") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        usuario = aDecoder.decodeObject(forKey: "usuario") as? String
        senha = aDecoder.decodeObject(forKey: "senha") as? String
        
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(id, forKey: "id")
        aCoder.encode(nome, forKey: "nome")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(senha, forKey: "senha")
        aCoder.encode(usuario, forKey: "usuario")
    }
    
    override func mapping(map: Map) {
        id <- map["id"]
        nome <- map["nome"]
        email <- map["email"]
        usuario <- map["usuario"]
        senha <- map["senha"]
        created <- map["created"]
        updated <- map["updated"]
    }

}
