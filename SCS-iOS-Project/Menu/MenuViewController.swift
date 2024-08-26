//
//  MenuViewController.swift
//  SCS-iOS-Project
//
//  Created by Diego Gatica on 21/08/24.
//

import UIKit

class MenuViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if let sedeViewController = viewController as? SedeViewController {
            sedeViewController.fetchSedes()
        } else if let canchasViewController = viewController as? CanchasViewController {
            canchasViewController.fetchSedes()
            canchasViewController.fetchCanchas()
        }
    }
}
