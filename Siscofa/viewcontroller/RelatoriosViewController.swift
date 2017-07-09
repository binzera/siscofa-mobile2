//
//  RelatoriosViewController.swift
//  Siscofa
//
//  Created by Glaubert Moreira Schult on 05/07/17.
//  Copyright © 2017 GMS. All rights reserved.
//


import Foundation
import UIKit


class RelatoriosViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tbMenu: UITableView!
    
    
    init() {
        super.init(nibName: "MenuCadastro", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let menu = ["Visualizar Movimentações", "Visualizar Fazendas"];
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let viewRelMov = RelMovimentacaoViewController()
            self.present(viewRelMov, animated:true, completion:nil)
            
        case 1:
            let viewCadastroMovimentacao = MovimentacaoViewController()
            self.present(viewCadastroMovimentacao, animated:true, completion:nil)
            
        default: print(indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let item = menu[row]
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        cell.textLabel!.text = item
        return cell
    }
}