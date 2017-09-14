//
//  RelMovimentacoesViewController.swift
//  Siscofa
//
//  Created by Glaubert Moreira Schult on 08/07/17.
//  Copyright © 2017 GMS. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ObjectMapper


class RelMovimentacaoViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tfFazenda: UITextField!
    @IBOutlet var tbMovs: UITableView!
    
    
    var fazendaPicker: UIPickerView!
    var fazendasArray = Array<Fazenda>()
    var fazendaSelecionado = Fazenda()
    var tag = "fazenda"
    
    var movimentacoesArray = Array<MovimentacaoGado>()

    @IBAction func voltar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func adicionar(_ sender: Any) {
        let viewCadastroMovimentacao = MovimentacaoViewController()
        self.present(viewCadastroMovimentacao, animated:true, completion:nil)
    }
    
    init() {
        super.init(nibName: "RelMovimentacao", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tbMovs.reloadData()
        self.tbMovs.reloadInputViews()
    }
    
    @IBAction func fazendaEdit(_ sender: Any) {
        carregarArrayFazendas()
        self.fazendaPicker = UIPickerView()
        fazendaPicker.dataSource = self
        fazendaPicker.delegate = self
        tfFazenda.inputView = fazendaPicker
        tag = "fazenda"
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
                            self.tbMovs.reloadData()
                        }
                    }
                }
            } else {
                Alert(controller: self).show(message: "Erro ao carregar informações do Servidor")
            }
        }
    }
    
    func carregarMovimentacoes(){
        let URL = Configuracao.getWSURL() + "/movimentacao/porFazenda"
        
        let parameters : Parameters = [
            "id" : fazendaSelecionado.id!
        ]
        
        Alamofire.request(URL,  method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseObject { (response: DataResponse<Resultado>) in
            if response.error == nil {
                if let resultado = response.result.value {
                    if resultado.erro != nil {
                        Alert(controller: self).show(message: (resultado.erro?.mensagem)!)
                    } else {
                        if let arrayMovimentacoes = Mapper<MovimentacaoGado>().mapArray(JSONObject: resultado.dados){
                            self.movimentacoesArray = arrayMovimentacoes
                            self.tbMovs.reloadData()
                            self.tbMovs.reloadInputViews()
                        }
                    }
                }
            } else {
                Alert(controller: self).show(message: "Erro ao carregar informações do Servidor")
            }
        }
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{

        if tag == "fazenda" {
            return fazendasArray.count
        }
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if tag == "fazenda" {
            return fazendasArray[row].nome! as String
        }
        return ""
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){

        if tag == "fazenda" {
            tfFazenda.text = self.fazendasArray[row].nome! as String
            fazendaSelecionado = fazendasArray[row]
            carregarMovimentacoes()
            self.view.endEditing(true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movimentacoesArray.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let viewCadastroFaz = CadastroFazendaViewController()
            self.present(viewCadastroFaz, animated:true, completion:nil)
            
        case 1:
            let viewCadastroMovimentacao = MovimentacaoViewController()
            self.present(viewCadastroMovimentacao, animated:true, completion:nil)
            
        default: print(indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let item = movimentacoesArray[row]
        self.tbMovs.register(UINib(nibName: "CustomCellTableViewCell", bundle: nil), forCellReuseIdentifier: "cellMov")
        let cell = self.tbMovs.dequeueReusableCell(withIdentifier: "cellMov", for: indexPath) as! CustomCellTableViewCell
        cell.lbData.text = String(describing: item.data!)
        cell.lbTipo.text = ""
        if item.tipoMovimentacao != nil {
            cell.lbTipo.text = String(describing: item.tipoMovimentacao!.descricao!)
        }
        cell.lbPeso.text = String(describing: item.peso!)
        cell.lbQuantidade.text = String(describing: item.quantidade!)
        cell.lbValor.text = String(describing: item.valor!)
        cell.lbSexo.text = String(describing: item.sexo!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 93
    }
}
