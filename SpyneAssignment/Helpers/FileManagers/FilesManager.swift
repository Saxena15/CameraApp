//
//  FileDownloadManager.swift
//  SpyneAssignment
//
//  Created by Akash on 08/11/24.
//

import Foundation
import AVFoundation
import Photos
import UIKit


class FilesManager{
    private let targetSize = CGSize(width: 100, height: 100)
    var spyneAssets: [MetaAsset] = []
    let imageManager = PHCachingImageManager()
    
    var isPhotoLibraryReadWriteAccessGranted: Bool {
        get async {
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            
            // Determine if the user previously authorized read/write access.
            var isAuthorized = status == .authorized
            
            // If the system hasn't determined the user's authorization status,
            // explicitly prompt them for approval.
            if status == .notDetermined {
                isAuthorized = await PHPhotoLibrary.requestAuthorization(for: .readWrite) == .authorized
            }
            
            return isAuthorized
        }
    }
    
    func save(_ photo: AVCapturePhoto ,_ timeStamp: String) async {
        // Confirm the user granted read/write access.
        guard await isPhotoLibraryReadWriteAccessGranted else { return }
        
        // Create a data representation of the photo and its attachments.
        if let photoData = photo.fileDataRepresentation() {
            PHPhotoLibrary.shared().performChanges {
                // Save the photo data.
                let creationRequest = PHAssetCreationRequest.forAsset()
                let option = PHAssetResourceCreationOptions()
                option.originalFilename = "spyne_\(timeStamp)"
                creationRequest.addResource(with: .photo, data: photoData, options: option)
                print("Photo saved to photos library")
            } completionHandler: { success, error in
                if let error {
                    print("Error saving photo: \(error.localizedDescription)")
                    return
                }
            }
        }
    }
    
    func requestAllPhotos(onComplete : @escaping(([MetaAsset]) -> Void)){
        PHPhotoLibrary.requestAuthorization{status in
            switch status{
            case .authorized, .limited:
                
                let assets = self.fetchPhotos()
                assets.forEach { asset in
                    guard let fileName = self.getAssetFileName(asset: asset) else { return }
                    
                    if fileName.lowercased().contains("spyne"){
                        self.fetchThumbnails(for: asset, targetSize: self.targetSize) { img in
                            guard let img = img else {return}
                            self.spyneAssets.append(MetaAsset(image: img, name: fileName))
                            onComplete(self.spyneAssets)
                        }
                    }
                  
                }
                
            case .denied, .notDetermined, .restricted:
                print("Not allowed")
                
            default:
                print("unknown")
                
            }
        }
    }
    
    func getAssetFileName(asset: PHAsset) -> String?{
        let resources = PHAssetResource.assetResources(for: asset)
        return resources.first?.originalFilename
    }
    
    private func fetchPhotos() -> [PHAsset]{
        var assets: [PHAsset] = []
        
        // Create a fetch options object to specify how assets should be fetched
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        // Optionally, you can limit the number of results for faster loading
        fetchOptions.fetchLimit = 100 // Fetch only the 100 most recent photos
        
        // Fetch assets
        let fetchedAssets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        // Iterate over the fetched assets and add them to the array
        fetchedAssets.enumerateObjects { (asset, _, _) in
            assets.append(asset)
        }
        
        return assets
    }
    
    private func fetchThumbnails(for asset: PHAsset, targetSize: CGSize, completion: @escaping (UIImage?) -> Void){
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .fastFormat
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { (image, _) in
            completion(image)
        }
    }
    
    //    func updateCacheAssets(for collectionView: UICollectionView){
    //
    //            imageManager.startCachingImages(for: assetsToCache,
    //                                            targetSize: CGSize(width: 100, height: 100),
    //                                            contentMode: .aspectFill,
    //                                            options: nil)
    //
    //        imageManager.
    //    }
    
}
