//
//  ProgressTableViewCell.swift
//  SpyneAssignment
//
//  Created by Akash on 08/11/24.
//

import UIKit

class ProgressTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImg: UIImageView!
    
    @IBOutlet weak var thumbnailDate: UILabel!
    
    @IBOutlet weak var thumbnailName: UILabel!
    
    @IBOutlet weak var cloudSavedImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        thumbnailName.textColor = .white
        thumbnailDate.textColor = .white
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.selectionStyle = .none
    }
    
}
