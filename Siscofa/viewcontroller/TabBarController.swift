//
//  TabBarController.swift
//  Siscofa
//
//  Created by Glaubert Moreira Schult on 05/03/17.
//  Copyright © 2017 GMS. All rights reserved.
//

import Foundation
import UIKit

class TabBarController : UITabBarController, UITabBarControllerDelegate {
    
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create Tab one
        let tabOne = MenuCadastroViewController()
        
        let tabOneBarItem = UITabBarItem(title: "Cadastro", image: UIImage(named: "register.png"), selectedImage: UIImage(named: "register.png"))
        
        let tabTwo = RelatoriosViewController()
        
        let tabTwoBarItem = UITabBarItem(title: "Relatórios", image: UIImage(named: "statistics.png"), selectedImage: UIImage(named: "statistics.png"))
        
        tabOne.tabBarItem = tabOneBarItem
        tabOne.view.backgroundColor = UIColor.white
        
        tabTwo.tabBarItem = tabTwoBarItem
        tabTwo.view.backgroundColor = UIColor.white
        
        
        
        self.viewControllers = [tabOne,tabTwo]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(viewController.title!)")
    }
    
    
}
