//
//  ProgressViewController.swift
//  SpyneAssignment
//
//  Created by Akash on 08/11/24.
//

import UIKit
import Photos

class ProgressViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView = UITableView()
    var db = RealmDB()
    let file = FilesManager()
    private let imageManager = PHImageManager.default()
    let targetSize = CGSize(width: 100, height: 100)
    var metaData: [MetaImage] = []
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        self.view.backgroundColor = .white
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        requestPhotosFromLibrary()
        initialiseArray()
        print("@@@@@@@@@@@@@@@@\(db.fetchAllDataRealm())")
        self.metaData.append(MetaImage(imageName: "Hello", image: UIImage(), dateAdded: ""))
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return metaData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
//        cell.thumbnailImg.image = metaData[indexPath.row].image
//        cell.thumbnailName.text = metaData[indexPath.row].imageName
//        cell.thumbnailDate.text = metaData[indexPath.row].dateAdded
//        cell.cloudSavedImg.image = UIImage(named: "arrow.2.circlepath")
        
        let data = db.fetchAllDataRealm()
        
//        if data.count > 0{
////            cell.thumbnailImg.image = UIImage(named: "")
//            cell.thumbnailName.text = data[indexPath.row].imageName
//            cell.thumbnailDate.text = data[indexPath.row].captureDate
//            cell.cloudSavedImg.image = UIImage(systemName: "arrow.2.circlepath")
//            tableView.reloadData()
//        }else{
//            
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Deselect the row after tapping
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func setUpTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProgressTableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
//    func requestPhotosFromLibrary(){
//        file.requestAllPhotos { dataSet in
//            
//            for i in 0..<dataSet.count {
//                
//                let imageAsset = dataSet.object(at: i)
//                
//                guard let fileName = self.file.getAssetFileName(asset: imageAsset) else { return } // custom filter
//                
//                if fileName.contains("spyne"){
//                    
//                    self.imageManager.requestImage(for: dataSet.object(at: i), targetSize: self.targetSize, contentMode: .aspectFill, options: nil) { image, _ in
//                        
//                        guard let image = image else { return }
//                        
//                        self.db.fetchAllDataRealm().forEach { img in
//                           
//                            if img.imageName == fileName{
//                                self.metaData.append(MetaImage(imageName: fileName, image: image, dateAdded: img.captureDate))
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    func initialiseArray(){
        db.fetchAllDataRealm().forEach { item in
            self.metaData.append(MetaImage(imageName: item.imageName, image: UIImage(), dateAdded: item.captureDate))
        }
    }
}

