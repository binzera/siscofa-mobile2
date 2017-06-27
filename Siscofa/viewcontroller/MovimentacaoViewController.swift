//
//  MovimentacaoController.swift
//  Siscofa
//
//  Created by Glaubert Moreira Schult on 26/06/17.
//  Copyright © 2017 GMS. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ObjectMapper

class MovimentacaoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var rdSexo: UISegmentedControl!
    @IBOutlet var tfQuantidade: UITextField!
    @IBOutlet var tfPeso: UITextField!
    @IBOutlet var tfLote: UITextField!
    @IBOutlet var tfFazenda: UITextField!
    @IBOutlet var tfTipoMov: UITextField!
    @IBOutlet var tfValor: UITextField!
    
    var tipoMovPicker: UIPickerView!
    var lotePicker: UIPickerView!
    var fazendaPicker: UIPickerView!
    
    var tiposMovArray = Array<TipoMovimentacao>()
    var lotesArray = Array<Lote>()
    var fazendasArray = Array<Fazenda>()
    
    var tipoMovSelecionado = TipoMovimentacao()
    var fazendaSelecionado = Fazenda()
    var loteSelecionado = Lote()
    
    var tag = "fazenda"
    
    init() {
        super.init(nibName: "CadastroMovimentacao", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        carregarArrayFazendas()
        carregarArrayTipoMovimentacao()
    }
    
    @IBAction func voltar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func salvar(_ sender: Any) {
        var sexo = "M"
        if(self.rdSexo.selectedSegmentIndex == 1) {
            sexo = "F"
        }
        
        let quantidade = tfQuantidade.text!
        let peso = tfPeso.text!
        //let valor = tf
        
        let usuarioLogado =  UtilSerializer().load()
        
        let parameters : Parameters = [
            "qtdArrobas" : peso,
            "qtdGado" : quantidade,
            "sexo" : sexo,
            "racaGado" :
                ["id" : loteSelecionado.id!],
            "idade" :
                ["id" : tipoMovSelecionado.id!],
            "fazenda" :
                ["id" : fazendaSelecionado.id!],
            "usuario" :
                ["id" : usuarioLogado.id!]
        ]
        
        
        let URL = "http://localhost:8080/siscofa/lote/inserir"
        
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
    
    
    @IBAction func fazendaEdit(_ sender: Any) {
        self.fazendaPicker = UIPickerView()
        fazendaPicker.dataSource = self
        fazendaPicker.delegate = self
        tfFazenda.inputView = fazendaPicker
        tag = "fazenda"
        
    }
    
    @IBAction func tipoMovEdit(_ sender: Any) {
        self.tipoMovPicker = UIPickerView()
        tipoMovPicker.dataSource = self
        tipoMovPicker.delegate = self
        tfTipoMov.inputView = tipoMovPicker
        tag = "tipoMov"
    }
    
    @IBAction func loteEdit(_ sender: Any) {
        if(tfFazenda.text! == ""){
            Alert(controller: self).show(message: "Selecione a Fazenda.")
            return
        }
        self.lotePicker = UIPickerView()
        lotePicker.dataSource = self
        lotePicker.delegate = self
        tfLote.inputView = lotePicker
        tag = "lote"
    }
    
    func carregarArrayTipoMovimentacao() {
        let URL = "http://localhost:8080/siscofa/tipomov/listar"
        
        Alamofire.request(URL,  method: .get).responseObject { (response: DataResponse<Resultado>) in
            if response.error == nil {
                if let resultado = response.result.value {
                    if let array = Mapper<TipoMovimentacao>().mapArray(JSONObject: resultado.dados){
                        self.tiposMovArray = array
                    }
                }
            } else {
                Alert(controller: self).show(message: (response.error?.localizedDescription)!)
            }
        }
    }
    
    func carregarArrayFazendas() {
        let URL = "http://localhost:8080/siscofa/fazendas"
        
        Alamofire.request(URL,  method: .get).responseObject { (response: DataResponse<Resultado>) in
            if response.error == nil {
                if let resultado = response.result.value {
                    if let arrayFazendas = Mapper<Fazenda>().mapArray(JSONObject: resultado.dados){
                        self.fazendasArray = arrayFazendas
                    }
                }
            } else {
                Alert(controller: self).show(message: (response.error?.localizedDescription)!)
            }
        }
    }
    
    func carregarArrayLotes() {
        let URL = "http://localhost:8080/siscofa/lote/porFazenda"
        
        let parameters : Parameters = [
            "id" : fazendaSelecionado.id!
        ]
        Alamofire.request(URL,  method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseObject { (response: DataResponse<Resultado>) in
            if response.error == nil {
                if let resultado = response.result.value {
                    if let array = Mapper<Lote>().mapArray(JSONObject: resultado.dados){
                       self.lotesArray = array
                    }
                }
            } else {
                Alert(controller: self).show(message: (response.error?.localizedDescription)!)
            }
        }
    }
    
    
    
    func validarCamposFormulario(){
        if(tfQuantidade.text == ""){
            Alert(controller: self).show(message: "Informe a quantidade de cabeças desse lote")
            return
        }
        if(tfPeso.text == ""){
            Alert(controller: self).show(message: "Informe quantidade de arrobas desse lote.")
            return
        }
        if(tfFazenda.text == ""){
            Alert(controller: self).show(message: "Informe a Fazenda desse lote.")
            return
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if(tag == "lote") {
            return lotesArray.count
        }
        if tag == "tipoMov" {
            return tiposMovArray.count
        }
        if tag == "fazenda" {
            return fazendasArray.count
        }
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(tag == "lote") {
            return "Lote \(lotesArray[row].id!) - \(lotesArray[row].qtdGado!) cabeças"
        }
        if tag == "tipoMov" {
            return tiposMovArray[row].descricao! as String
        }
        if tag == "fazenda" {
            return fazendasArray[row].nome! as String
        }
        return ""
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if(tag == "lote") {
            tfLote.text = "Lote \(lotesArray[row].id!) - \(lotesArray[row].qtdGado!) cabeças"
            loteSelecionado = lotesArray[row]
            self.view.endEditing(true)
        }
        if tag == "tipoMov" {
            tfTipoMov.text = tiposMovArray[row].descricao! as String
            tipoMovSelecionado = tiposMovArray[row]
            self.view.endEditing(true)
        }
        if tag == "fazenda" {
            tfFazenda.text = self.fazendasArray[row].nome! as String
            fazendaSelecionado = fazendasArray[row]
            carregarArrayLotes()
            self.view.endEditing(true)
        }
        
    }
}
