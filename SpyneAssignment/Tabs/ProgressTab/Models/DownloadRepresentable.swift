//
//  DownloaderViewRepresentable.swift
//  SpyneAssignment
//
//  Created by Akash on 10/11/24.
//

import Foundation
import RealmSwift

public protocol DownloaderViewRepresentable{
    func convertDate(_ ts: String) -> String
    func getTableData(_ dbData: Results<ImageTask>, completion: @escaping(() -> Void))
}
