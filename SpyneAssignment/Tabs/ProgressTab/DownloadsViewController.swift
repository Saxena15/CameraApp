//
//  DownloadsViewController.swift
//  SpyneAssignment
//
//  Created by Akash on 09/11/24.
//

import UIKit
import Photos

class DownloadsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var db : RealmDB
    var viewModel: DownloadsViewModel
    
    init(db: RealmDB, viewModel: DownloadsViewModel) {
        self.db = db
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        
        self.registerNib()
        self.setupActivityIndicator()
        self.prepareBasicDataAndFetch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProgressTableViewCell", for: indexPath) as! ProgressTableViewCell
        
        cell.cloudSavedImg.image = viewModel.tableData[indexPath.row].isUploaded ? UIImage(systemName: ImageNames.checkImg) : UIImage(systemName: ImageNames.syncImg)
        cell.thumbnailImg.image = viewModel.tableData[indexPath.row].image
        cell.thumbnailName.text = viewModel.tableData[indexPath.row].imageName
        cell.thumbnailDate.text = viewModel.convertDate(viewModel.tableData[indexPath.row].dateAdded)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableData.count
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell:ProgressTableViewCell = tableView.cellForRow(at: indexPath) as? ProgressTableViewCell{
            db.updateDataRealm(cell.thumbnailName.text ?? "")
        }
    }
    
    func registerNib(){
        let nib = UINib(nibName: "ProgressTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ProgressTableViewCell")
    }
    
    func setupActivityIndicator(){
        activityIndicator.style = .large
        activityIndicator.layer.cornerRadius = 12
        activityIndicator.backgroundColor = .gray
        activityIndicator.layer.opacity = 0.8
        activityIndicator.startAnimating()
    }
    
    func refreshData() {
        self.prepareBasicDataAndFetch()
        self.tableView.reloadData()
    }
    
    private func prepareBasicDataAndFetch(){
        
        let realmData = self.viewModel.db.fetchAllDataRealm()
        
        DispatchQueue.main.async {
            self.viewModel.getTableData(realmData) {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
                self.tableView.reloadData()
            }
        }
    }
}
