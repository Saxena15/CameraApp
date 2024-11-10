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
        
        let firstVC = CameraViewController(db: RealmDB(), file: FilesManager())
        let secondVC = DownloadsViewController(db: RealmDB(), viewModel: DownloadsViewModel(file: FilesManager(), db: RealmDB()))
        
        firstVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        secondVC.tabBarItem = UITabBarItem(title: "Progress", image: UIImage(systemName: "star.fill"), tag: 0)
        
        self.tabBarBasicSetup()
        self.viewControllers = [firstVC, secondVC]    
    }

    private func tabBarBasicSetup(){
        tabBar.layer.shadowColor = UIColor.gray.cgColor
        tabBar.layer.shadowOpacity = 0.5
        tabBar.layer.shadowOffset = CGSize.zero
        tabBar.layer.borderColor = UIColor.black.cgColor
        tabBar.layer.borderWidth = 0
        tabBar.clipsToBounds = false
        tabBar.layer.opacity = 0.8
        tabBar.backgroundColor = UIColor.black
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
    }
}
