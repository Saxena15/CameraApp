//
//  DownloadRepresentable.swift
//  SpyneAssignment
//
//  Created by Akash on 10/11/24.
//

import Foundation
import RealmSwift

public protocol DownloadRepresentable{
    func convertDate(_ ts: String) -> String
    func getTableData(_ dbData: Results<ImageTask>, completion: ((Bool) -> Void))
}
