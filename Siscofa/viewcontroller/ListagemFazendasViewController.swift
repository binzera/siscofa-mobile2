//
//  ListagemFazendasViewController.swift
//  Siscofa
//
//  Created by Glaubert Moreira Schult on 10/07/17.
//  Copyright © 2017 GMS. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ObjectMapper


class ListagemFazendasViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tbFazendas: UITableView!
    
    var fazendasArray = Array<Fazenda>()
    
    init() {
        super.init(nibName: "ListagemFazendas", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func voltar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        carregarArrayFazendas()
        self.tbFazendas.reloadData()
    }
    
    func carregarArrayFazendas() {
        
        let URL = Configuracao.getWSURL() + "/fazendas/fazendasOfUser"
        
        let usuarioLogado =  UtilSerializer().load()
        
        let parameters : Parameters = [
            "id" : usuarioLogado.id!,
            "nome" : usuarioLogado.nome!
        ]
        
        
        Alamofire.request(URL,  method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseObject { (response: DataResponse<Resultado>) in
            if response.error == nil {
                if let resultado = response.result.value {
                    if resultado.erro != nil {
                        Alert(controller: self).show(message: (resultado.erro?.mensagem)!)
                    } else {
                        if let arrayFazendas = Mapper<Fazenda>().mapArray(JSONObject: resultado.dados){
                            self.fazendasArray = arrayFazendas
                            self.tbFazendas.reloadData()
                        }
                    }
                }
            } else {
                Alert(controller: self).show(message: "Erro ao carregar informações do Servidor")
            }
        }
    }
    
    
    @IBAction func adicionar(_ sender: Any) {
        let view = CadastroFazendaViewController()
        self.present(view, animated:true, completion:nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fazendasArray.count;
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch indexPath.row {
//        case 0:
//            let viewCadastroFaz = CadastroFazendaViewController()
//            self.present(viewCadastroFaz, animated:true, completion:nil)
//            
//        case 1:
//            let viewCadastroMovimentacao = MovimentacaoViewController()
//            self.present(viewCadastroMovimentacao, animated:true, completion:nil)
//            
//        default: print(indexPath.row)
//        }
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let item = fazendasArray[row]
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        cell.textLabel!.text = item.nome
        return cell
    }


}
