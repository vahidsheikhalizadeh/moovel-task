//
//  DataCell.swift
//  moovel
//
//  Created by shick on 11.08.18.
//  Copyright © 2018 vahid. All rights reserved.
//

import UIKit

class DataCell: UITableViewCell {
    
    static let cellIdentifierName = "UserCustomCell"

    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var registrationDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUserData(user: User) {
        
        let imageUrl = user.userImage
        let imageData = try! Data(contentsOf: imageUrl)
        userImage.image = UIImage(data: imageData)
        
        
        userName.text = user.userName
        registrationDate.text = user.registrDate
        print("registration date: \(user.location)")
    }
}
