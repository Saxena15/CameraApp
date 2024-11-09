//
//  DownloadsViewController.swift
//  SpyneAssignment
//
//  Created by Akash on 09/11/24.
//

import UIKit
import Photos

class DownloadsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    private let imageManager = PHImageManager.default()
    var db = RealmDB()
    var viewModel = DownloadsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ProgressTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ProgressTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProgressTableViewCell", for: indexPath) as! ProgressTableViewCell
        let data = db.fetchAllDataRealm()
        
        
        if data.count > 0{
            
            cell.thumbnailImg.image = viewModel.iterateAndFetchImage(data[indexPath.row].captureDate)
            cell.thumbnailName.text = data[indexPath.row].imageName
            cell.thumbnailDate.text = viewModel.convertDate(data[indexPath.row].captureDate)
            cell.cloudSavedImg.image = UIImage(systemName: "arrow.2.circlepath")
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return db.fetchAllDataRealm().count
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
