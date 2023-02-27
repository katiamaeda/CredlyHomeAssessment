//
//  UserTableViewCell.swift
//  CredlyProjectKatia
//
//  Created by Katia Maeda on 2023-02-25.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    public static var identifier = "\(String(describing: UserTableViewCell.self))"
}
