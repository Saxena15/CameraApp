//
//  DownloadsViewModel.swift
//  SpyneAssignment
//
//  Created by Akash on 09/11/24.
//

import Foundation
import Photos
import UIKit


class DownloadsViewModel: ObservableObject{
    
    @Published var metaData = []
    let file = FilesManager()
    let targetSize = CGSize(width: 100, height: 100)
    var db = RealmDB()
    
    
    func convertDate(_ ts: String) -> String{
        
        let date = Date(timeIntervalSince1970: Double(ts) ?? 0)

        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"

        let dateString = dayTimePeriodFormatter.string(from: date)

        return dateString
    }
    
    func iterateAndFetchImage(_ ts: String) -> UIImage{
        var img : UIImage?
        file.requestAllPhotos { assets in
            assets.forEach { asset in
                if asset.name.contains(ts){
                    img =  asset.image
                }
            }
        }
        
        return img ?? UIImage(systemName: "questionmark")!
    }
    
    
}

struct MetaImage{
    var imageName: String
    var image: UIImage
    var dateAdded: String
}
