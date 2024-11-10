//
//  RealmDB.swift
//  SpyneAssignment
//
//  Created by Akash on 08/11/24.
//

import Foundation
import RealmSwift
import UIKit

public class ImageTask:Object{
    @Persisted(primaryKey: true) var id : ObjectId
    @Persisted var imageURI: String
    @Persisted var imageName: String
    @Persisted var captureDate: String
    @Persisted var uploadStatus: Bool
    
}

class RealmDB: RealmTransactionsRepresentable{
    
    private var realm : Realm
    
    init(){
        self.realm = try! Realm()
    }
    
    // Saving fresh data
    func saveDataRealm(_ imageTask : ImageTask){
        try! realm.write {
            print("Data added to Realm")
            realm.add(imageTask)
        }
    }
    
    // fetching existing data
    func fetchAllDataRealm() -> Results<ImageTask>{
        let imageData = realm.objects(ImageTask.self)
        return imageData
    }
    
    // updating data
    func updateDataRealm(_ imageName: String){
        
        guard let imageData = realm.objects(ImageTask.self).first(where: { image in
            image.imageName.elementsEqual(imageName)
        }) else { return }
        
        try! realm.write {
            imageData.uploadStatus = true
            print("Data updated in Realm")
        }
        
        
    }
    
    //deleting data
    func deleteDataRealm(_ imageTask: ImageTask){
        print("Data deleted from Realm")
        realm.delete(imageTask)
    }
    
    func factoryRest() {
        print("Data cleaned from Realm")
        realm.deleteAll()
    }
    
}

public protocol RealmTransactionsRepresentable{
    func saveDataRealm(_ imageTask : ImageTask)
    func updateDataRealm(_ imageName: String)
    func fetchAllDataRealm() -> Results<ImageTask>
    func deleteDataRealm(_ imageTask: ImageTask)
    func factoryRest()
}

enum UploadStatus: String{
    case uploadPending = "Upload Pending"
    case uploadComplete = "Upload Complete"
}
