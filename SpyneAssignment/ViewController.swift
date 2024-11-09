//
//  ViewController.swift
//  SpyneAssignment
//
//  Created by Akash on 08/11/24.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    
}

class TabBarViewController: UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstVC = CameraViewController()
        let secondVC = DownloadsViewController()
        
        firstVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        secondVC.tabBarItem = UITabBarItem(title: "Progress", image: UIImage(systemName: "star"), tag: 0)
        
        tabBar.layer.shadowColor = UIColor.gray.cgColor
        tabBar.layer.shadowOpacity = 0.5
        tabBar.layer.shadowOffset = CGSize.zero
        tabBar.layer.borderColor = UIColor.black.cgColor
        tabBar.layer.borderWidth = 0
        tabBar.clipsToBounds = false
        tabBar.backgroundColor = UIColor.gray
        
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
       
        tabBarItem.isSpringLoaded = true
        
        self.viewControllers = [firstVC, secondVC]
        
    }
}