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
    private let imageManager = PHImageManager.default()
    private let targetSize = CGSize(width: 100, height: 100)
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
    
    var spyneAssets: [CustomSpyneAsset] = []
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
    
    func requestAllPhotos(onComplete : @escaping(([CustomSpyneAsset]) -> Void)){
        PHPhotoLibrary.requestAuthorization{status in
            switch status{
            case .authorized, .limited:
                let fetchOptions = PHFetchOptions()
                let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                for i in 0..<allPhotos.count{
                    var asset =  allPhotos[i]
                        
                    guard let fileName = self.getAssetFileName(asset: asset) else { return }
                    
                    if fileName.contains("spyne"){
                        
                        self.imageManager.requestImage(for: asset, targetSize: self.targetSize, contentMode: .aspectFill, options: nil){image, _ in
                            
                            guard let img = image else {
                                return
                            }
                            
                            let spyneAsset = CustomSpyneAsset(image: img, name: fileName)
                            
                        }
                        
                       
                    }
                }
                
                onComplete(self.spyneAssets)
                
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
    
}

struct CustomSpyneAsset{
    var image: UIImage
    var name: String
}
