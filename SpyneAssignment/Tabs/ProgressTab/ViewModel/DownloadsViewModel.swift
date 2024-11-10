//
//  DownloadsViewModel.swift
//  SpyneAssignment
//
//  Created by Akash on 09/11/24.
//

import Foundation
import Photos
import UIKit
import RealmSwift


class DownloadsViewModel: ObservableObject, DownloaderViewRepresentable{
    
    @Published var tableData: [CustomSpyneAsset]
    var file : FilesManager
    var shouldRefresh = false
    var db: RealmDB
    let imageManager = PHCachingImageManager()
    
    let targetSize = CGSize(width: 100, height: 100)
    
    init(file: FilesManager, db: RealmDB) {
        self.tableData = []
        self.file = file
        self.db = db
    }
    
    
    func convertDate(_ ts: String) -> String{
        
        let date = Date(timeIntervalSince1970: Double(ts) ?? 0)
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
        
        let dateString = dayTimePeriodFormatter.string(from: date)
        
        return dateString
    }
    
    
    func getTableData(_ dbData: Results<ImageTask>, completion: @escaping(() -> Void)){
        
        let _ = file.requestAllPhotos { metaData in
            for asset in metaData {
                if let data = dbData.first(where: { asset.name.contains($0.captureDate )}){
                    
                    let customSpyneAsset = CustomSpyneAsset(imageName: data.imageName, image: asset.image, dateAdded: data.captureDate, isUploaded: data.uploadStatus)
                    
                    if !self.tableData.contains(where: {$0.imageName == customSpyneAsset.imageName}){
                        self.tableData.append(CustomSpyneAsset(imageName: data.imageName, image: asset.image, dateAdded: data.captureDate, isUploaded: data.uploadStatus))
                    }
                }
                if self.tableData.count == metaData.count{
                    completion()
                }
            }
        }      
    }
}
