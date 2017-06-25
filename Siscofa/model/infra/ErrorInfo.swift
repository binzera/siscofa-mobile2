import Foundation
import ObjectMapper

class ErrorInfo : Mappable {
    
    var erroCode : Int?
    var mensagem : String?
    
//    init(erroCode : Int , mensagem : String) {
//        self.erroCode = erroCode
//        self.mensagem = mensagem
//    }
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        erroCode <- map["errorCode"]
        mensagem <- map["mensagem"]

    }
    
    
    
//    init?(json: [String: Any]) {
//        if json["errorCode"] != nil {
//            self.erroCode = json["errorCode"] as! Int
//        } else {
//            self.erroCode = 0
//        }
//        if json["mensagem"] != nil {
//            self.mensagem = json["mensagem"] as! String
//        } else {
//            self.mensagem = ""
//        }
//        
//    }
    
}
