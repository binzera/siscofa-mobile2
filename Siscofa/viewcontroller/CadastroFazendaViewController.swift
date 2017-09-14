//
//  CadastroFazendaViewController.swift
//  Siscofa
//
//  Created by Glaubert Moreira Schult on 23/06/17.
//  Copyright © 2017 GMS. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ObjectMapper

class CadastroFazendaViewController: UIViewController {
    

    @IBOutlet var tfNomeFazenda: UITextField!

    @IBOutlet var tfTamanho: UITextField!
    
    init() {
        super.init(nibName: "CadastroFazenda", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    @IBAction func cadastrar(_ sender: Any) {
        let nome = tfNomeFazenda.text!
        let tamanho = tfTamanho.text!
        
        if nome == "" {
            return Alert(controller: self).show(message: "Informe o nome da Fazenda.")
        }
        
        if tamanho == "" {
            return Alert(controller: self).show(message: "Informe o tamanho da Fazenda.")
        }
        
        let usuarioLogado =  UtilSerializer().load()
        
        let parameters : Parameters = [
            "nome" : nome,
            "qtdAlqueires" : tamanho,
            "usuario" :
                ["id" : usuarioLogado.id!]
        ]
        
        
        let URL = Configuracao.getWSURL() + "/fazendas/cadastrarFazenda"
        
        Alamofire.request(URL,  method: .post, parameters: parameters, encoding: JSONEncoding.default).responseObject { (response: DataResponse<Resultado>) in
            if response.error == nil {
                if let resultado = response.result.value {
                    if let mensagem = resultado.mensagem {
                        Alert(controller: self).show(message: mensagem)
                    }
                }
            } else {
                Alert(controller: self).show(message: (response.error?.localizedDescription)!)
            }
        }
        
    }
    
    @IBAction func voltar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
