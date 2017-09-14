//
//  CadastroLoteViewController.swift
//  Siscofa
//
//  Created by Glaubert Moreira Schult on 25/06/17.
//  Copyright © 2017 GMS. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ObjectMapper

class CadastroLoteViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var rdSexo: UISegmentedControl!
    @IBOutlet var tfQuantidade: UITextField!
    @IBOutlet var tfPeso: UITextField!
    @IBOutlet var tfRaca: UITextField!
    @IBOutlet var tfIdade: UITextField!
    @IBOutlet var tfFazenda: UITextField!
    
    var idadePicker: UIPickerView!
    var racaPicker: UIPickerView!
    var fazendaPicker: UIPickerView!
    
    var idadesArray = Array<Idade>()
    var racasArray = Array<Raca>()
    var fazendasArray = Array<Fazenda>()
    
    var idadeSelecionado = Idade()
    var fazendaSelecionado = Fazenda()
    var racaSelecionado = Raca()
    
    var tag = "raca"
    
    init() {
        super.init(nibName: "CadastroLote", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        carregarArrayFazendas()
        carregarArrayRacas()
        carregarArrayIdades()
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
                ["id" : racaSelecionado.id!],
            "idade" :
                ["id" : idadeSelecionado.id!],
            "fazenda" :
                ["id" : fazendaSelecionado.id!],
            "usuario" :
                ["id" : usuarioLogado.id!]
        ]
        
        
        let URL = Configuracao.getWSURL() + "/lote/inserir"
        
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
    
    @IBAction func idadeEdit(_ sender: Any) {
        self.idadePicker = UIPickerView()
        idadePicker.dataSource = self
        idadePicker.delegate = self
        tfIdade.inputView = idadePicker
        tag = "idade"
    }
    
    @IBAction func racaEdit(_ sender: Any) {
        self.racaPicker = UIPickerView()
        racaPicker.dataSource = self
        racaPicker.delegate = self
        tfRaca.inputView = racaPicker
        tag = "raca"
    }
    
    func carregarArrayRacas() {
        let URL = "http://localhost:8080/siscofa/racas"
        
        Alamofire.request(URL,  method: .get).responseObject { (response: DataResponse<Resultado>) in
            if response.error == nil {
                if let resultado = response.result.value {
                    if let arrayRacas = Mapper<Raca>().mapArray(JSONObject: resultado.dados){
                        self.racasArray = arrayRacas
                    }
                }
            } else {
                Alert(controller: self).show(message: (response.error?.localizedDescription)!)
            }
        }
    }
    
    func carregarArrayFazendas() {
        let URL = Configuracao.getWSURL() + "/fazendas"
        
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
    
    func carregarArrayIdades() {
        let URL = Configuracao.getWSURL() + "/idades"
        
        Alamofire.request(URL,  method: .get).responseObject { (response: DataResponse<Resultado>) in
            if response.error == nil {
                if let resultado = response.result.value {
                    if let arrayIdades = Mapper<Idade>().mapArray(JSONObject: resultado.dados){
                        self.idadesArray = arrayIdades
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
        if(tfIdade.text == ""){
            Alert(controller: self).show(message: "Informe a idade do lote.")
            return
        }
        if(tfRaca.text == ""){
            Alert(controller: self).show(message: "Informe a raça do lote.")
            return
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if(tag == "raca") {
            return racasArray.count
        }
        if tag == "idade" {
            return idadesArray.count
        }
        if tag == "fazenda" {
            return fazendasArray.count
        }
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(tag == "raca") {
            return racasArray[row].nome! as String
        }
        if tag == "idade" {
            return idadesArray[row].descricao! as String
        }
        if tag == "fazenda" {
            return fazendasArray[row].nome! as String
        }
        return ""
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if(tag == "raca") {
            tfRaca.text = self.racasArray[row].nome! as String
            racaSelecionado = racasArray[row]
            self.view.endEditing(true)
        }
        if tag == "idade" {
            tfIdade.text = self.idadesArray[row].descricao! as String
            idadeSelecionado = idadesArray[row]
            self.view.endEditing(true)
        }
        if tag == "fazenda" {
            tfFazenda.text = self.fazendasArray[row].nome! as String
            fazendaSelecionado = fazendasArray[row]
            self.view.endEditing(true)
        }
        
    }
}
