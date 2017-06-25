import Foundation
import ObjectMapper

class Raca : GenericEntity {
    
    var id : Int?
    var nome: String?

    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init() {
        super.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        id <- map["id"]
        nome <- map["nome"]
    }
    
    
    

}
