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
    var db = RealmDB()
    var viewModel: DownloadsViewModel
    
    init(viewModel: DownloadsViewModel) {
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
        
        self.viewModel.getTableData(self.viewModel.db.fetchAllDataRealm()) { val in
            if val{
                self.tableView.reloadData()
                self.tableView.tableHeaderView?.isHidden = true
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProgressTableViewCell", for: indexPath) as! ProgressTableViewCell
        
        cell.cloudSavedImg.image = viewModel.tableData[indexPath.row].isUploaded ? UIImage(systemName: "custom.checkmark.circle.fill") : UIImage(systemName: "arrow.2.circlepath")
        cell.thumbnailImg.image = viewModel.tableData[indexPath.row].image
        cell.thumbnailName.text = viewModel.tableData[indexPath.row].imageName
        cell.thumbnailDate.text = viewModel.tableData[indexPath.row].dateAdded
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableData.count
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        
        self.tableView.tableHeaderView = spinner
       
        self.tableView.tableHeaderView?.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: any UISpringLoadedInteractionContext) -> Bool {
        return true
    }
    
    func registerNib(){
        let nib = UINib(nibName: "ProgressTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ProgressTableViewCell")
    }
    
}
