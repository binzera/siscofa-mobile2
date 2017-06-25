import Foundation
import AlamofireObjectMapper
import ObjectMapper


class Resultado : Mappable{
    
    var dados : Any?
    var erro : ErrorInfo?
    var sucesso : Bool?
    var mensagem : String?
    var array : [AnyObject]?
    
//    init(dados : AnyObject, erro : ErrorInfo, sucesso : Bool, mensagem : String) {
//        self.dados = dados
//        self.erro = erro
//        self.sucesso = sucesso
//        self.mensagem = mensagem
//    }
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        dados <- map["dados"]
        erro <- map["erro"]
        sucesso <- map["sucesso"]
        mensagem <- map["mensagem"]
        array <- map["dados"]
    }
    
//    public init?(json : Dictionary<String, Any>) {
//        self.dados = json["dados"] as AnyObject!
//        self.erro = json["erro"] as! ErrorInfo!
//        self.sucesso = json["sucesso"] as! Bool
//        self.mensagem = json["mensagem"] as! String
//    }
    
//    init?(json: [String: Any]) {
//        
//        if json["dados"] != nil {
//            self.dados = json["dados"] as AnyObject
//        } else {
//            self.dados = [] as AnyObject;
//        }
//        
//        if !(json["erro"]! is NSNull) {
//            print(json["erro"]!)
//            self.erro = ErrorInfo(json: json["erro"] as! [String : Any])!
//        } else {
//            self.erro = ErrorInfo(erroCode: 0, mensagem: "");
//        }
//        
//        if json["sucesso"] != nil {
//            self.sucesso = json["sucesso"] as! Bool
//        } else {
//            self.sucesso = false;
//        }
//        
//        if !(json["mensagem"] is NSNull) {
//            self.mensagem = json["mensagem"] as! String
//        } else {
//            self.mensagem = "";
//        }
//
//    }
   
}
