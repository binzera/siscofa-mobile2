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
        
        let tabTwo = SecondViewController()
        
        let tabTwoBarItem = UITabBarItem(title: "Teste", image: UIImage(named: "register.png"), selectedImage: UIImage(named: "register.png"))
        
        tabOne.tabBarItem = tabOneBarItem
        tabOne.view.backgroundColor = UIColor.blue
        
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
