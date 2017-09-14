import Foundation
import UIKit
import Alamofire
import ObjectMapper


class LoginViewController : UIViewController {
    
    @IBOutlet var usuarioTextField: UITextField!
    @IBOutlet var senhaTextField: UITextField!
    
    @IBAction func logar() {
        
        let parameters : Parameters = [
            "usuario" : usuarioTextField.text!,
            "senha" : senhaTextField.text!
        ]
        
        let URL = Configuracao.getWSURL() + "/usuarios/logar"
        
        Alamofire.request(URL,  method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseObject { (response: DataResponse<Resultado>) in
            if response.error == nil {
                if let resultado = response.result.value {
                    print(resultado)
                    if !resultado.sucesso! {
                        if let mensagem = resultado.erro?.mensagem {
                            Alert(controller: self).show(message: mensagem)
                        }
                        Alert(controller: self).show(message: "Null Pointer no servidor")
                    }
                    if let mensagem = resultado.mensagem {
                        self.validaResposta(mensagem: mensagem, usuarioJsonObject: resultado.dados!)
                    }
                    
                    
                } else {
                    print(response.result.value ?? "erro")
                    Alert(controller: self).show(message: "Erro no Servidor")
                }
            } else {
                Alert(controller: self).show(message: (response.error?.localizedDescription)!)
            }
        }
        
    }
    
    func serializarUsuario(_ usuarioJsonObject : Any) -> Void {
        if let usuario = Mapper<Usuario>().map(JSONObject: usuarioJsonObject){
            UtilSerializer().save(usuario)
        }
    }
    
    func validaResposta(mensagem : String, usuarioJsonObject: Any) -> Void {
        switch mensagem {
            
        case "USER_NAO_CADASTRADO":
            Alert(controller: self).show(message: "Usuário não Cadastrado!")
            
        case "SENHA_INCORRETA":
            Alert(controller: self).show(message: "Senha inválida!")
            
        case "LOGIN_SUCESSO":
            if usuarioJsonObject != nil {
                self.serializarUsuario(usuarioJsonObject)
            }
            self.performSegue(withIdentifier: "sgLogin", sender: nil)
            
        default:
            Alert(controller: self).show(message: "O Servidor retornou algo inesperado, contate o administrador")
        }
    }
    
}

/** MAP ARRAY ***/
//if let arrayRacas = Mapper<Raca>().mapArray(JSONObject: resultado.dados){
//
//    for raca in arrayRacas{
//        print(raca.updated!)
//    }
//}

/**** responseJSON funcionando *******/
//Alamofire.request(URL).responseJSON { response in
//    //print(response.error ?? nil)
//    
//    if let json = response.result.value {
//        let jsonString = JSONHelper.JSONStringify(json as AnyObject)
//        if let user = Mapper<Resultado>().map(JSONString: json as! String) {
//            
//            print(user.dados!)
//            
//            //let jsonArray = JSONHelper.JSONParseDictionary(user.dados! as! String)
//            
//            if let customerArray = Mapper<Raca>().mapArray(JSONString: JSONHelper.JSONStringify(user.dados! as AnyObject)){
//                for raca in customerArray{
//                    print(raca.updated!)
//                }
//            }
//        }
//    }
//}


/***** Funcionando response Array *****/
//        Alamofire.request(URL).responseArray { (response: DataResponse<[Raca]>) in
//
//            if let resultado = response.result.value {
//                //print(resultado)
//                for raca in resultado {
//                    print(raca.nome!);
//
//                }
//            } else {
//                print("Deu MErda")
//            }
//        }
