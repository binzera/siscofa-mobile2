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
    
    @IBOutlet var tfData: UITextField!
    @IBOutlet var tfIdade: UITextField!
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
    var datePiker: UIDatePicker!
    
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
        //self.addDoneButtonOnKeyboard()
    }
    
//    func addDoneButtonOnKeyboard()
//    {
//        var doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
//        doneToolbar.barStyle = UIBarStyle.BlackTranslucent
//
//        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
//        var done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("doneButtonAction"))
//
//        var items = NSMutableArray()
//        items.addObject(flexSpace)
//        items.addObject(done)
//
//        doneToolbar.items = items
//        doneToolbar.sizeToFit()
//
//        self.textView.inputAccessoryView = doneToolbar
//        self.textField.inputAccessoryView = doneToolbar
//
//    }
//
//    func doneButtonAction()
//    {
//        self.textViewDescription.resignFirstResponder()
//        self.textViewDescription.resignFirstResponder()
//    }
    
    @IBAction func voltar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func salvar(_ sender: Any) {
        if(tfFazenda.text == ""){
            return Alert(controller: self).show(message: "Informe a Fazenda dessa movimentação.")
        }
        if(tfTipoMov.text == ""){
            return Alert(controller: self).show(message: "Informe tipo de movimentação.")
        }
        if(tfQuantidade.text == ""){
            return Alert(controller: self).show(message: "Informe a quantidade de cabeças.")
        }
        if(tfPeso.text == ""){
            return Alert(controller: self).show(message: "Informe peso médio em arrobas")
        }
        if tfData.text == "" {
            return Alert(controller: self).show(message: "Informe a data dessa movimentação.")
        }
        
        var sexo = "M"
        if(self.rdSexo.selectedSegmentIndex == 1) {
            sexo = "F"
        }
        
        let quantidade = tfQuantidade.text!
        let peso = tfPeso.text!
        let valor = tfValor.text!
        let idade = tfIdade.text!
        let data = tfData.text!
        
        let parameters : Parameters = [
            "peso" : peso,
            "quantidade" : quantidade,
            "sexo" : sexo,
            "idade" : idade,
            "valor": valor,
            "data" : data,
            "fazenda" :
                ["id" : fazendaSelecionado.id!],
            "tipoMovimentacao" :
                ["id" : tipoMovSelecionado.id!]
        ]
        
        
        let URL = Configuracao.getWSURL() + "/movimentacao/inserir"
        
        Alamofire.request(URL,  method: .post, parameters: parameters, encoding: JSONEncoding.default).responseObject { (response: DataResponse<Resultado>) in
            //Verifica se houve erro com a requisição
            if response.error == nil {
                if let resultado = response.result.value {
                    if resultado.erro != nil {
                        Alert(controller: self).show(message: (resultado.erro?.mensagem)!)
                    } else if let mensagem = resultado.mensagem {
                        Alert(controller: self).show(message: mensagem)
                    }
                }
            } else {
                Alert(controller: self).show(message: (response.error?.localizedDescription)!)
            }
        }
    }
    
    @IBAction func dataBeginEdit(_ sender: Any) {
        self.datePiker = UIDatePicker()
        //datePiker.setDate(Date(), animated: true)
        datePiker.datePickerMode = UIDatePickerMode.date
        tfData.inputView = datePiker
        datePiker.addTarget(self, action: #selector(datePikerChangedAction), for: UIControlEvents.valueChanged)
        
        
    }
    
    func datePikerChangedAction(sender: UIDatePicker){
        let formatador = DateFormatter()
        formatador.dateFormat = "YYYY-MM-dd"
        self.tfData.text = formatador.string(from: sender.date)
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
    
//    @IBAction func loteEdit(_ sender: Any) {
//        if(tfFazenda.text! == ""){
//            Alert(controller: self).show(message: "Selecione a Fazenda.")
//            return
//        }
//        self.lotePicker = UIPickerView()
//        lotePicker.dataSource = self
//        lotePicker.delegate = self
//        tfLote.inputView = lotePicker
//        tag = "lote"
//    }
    
    func carregarArrayTipoMovimentacao() {
        let URL = Configuracao.getWSURL() + "/tipomov/listar"
        
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
                        }
                    }
                }
            } else {
                Alert(controller: self).show(message: "Erro ao carregar informações do Servidor")
            }
        }
    }
    
//    func carregarArrayLotes() {
//        let URL = "http://localhost:8080/siscofa/lote/porFazenda"
//        
//        let parameters : Parameters = [
//            "id" : fazendaSelecionado.id!
//        ]
//        Alamofire.request(URL,  method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseObject { (response: DataResponse<Resultado>) in
//            if response.error == nil {
//                if let resultado = response.result.value {
//                    if let array = Mapper<Lote>().mapArray(JSONObject: resultado.dados){
//                       self.lotesArray = array
//                    }
//                }
//            } else {
//                Alert(controller: self).show(message: (response.error?.localizedDescription)!)
//            }
//        }
//    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if tag == "tipoMov" {
            return tiposMovArray.count
        }
        if tag == "fazenda" {
            return fazendasArray.count
        }
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if tag == "tipoMov" {
            return tiposMovArray[row].descricao! as String
        }
        if tag == "fazenda" {
            return fazendasArray[row].nome! as String
        }
        return ""
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if tag == "tipoMov" {
            tfTipoMov.text = tiposMovArray[row].descricao! as String
            tipoMovSelecionado = tiposMovArray[row]
            self.view.endEditing(true)
        }
        if tag == "fazenda" {
            tfFazenda.text = self.fazendasArray[row].nome! as String
            fazendaSelecionado = fazendasArray[row]
            self.view.endEditing(true)
        }
        
    }
}
