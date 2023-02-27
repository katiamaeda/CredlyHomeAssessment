//
//  OneLabelTableViewCell.swift
//  CredlyProjectKatia
//
//  Created by Katia Maeda on 2023-02-25.
//

import UIKit

class OneLabelTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    public static var identifier = "\(String(describing: OneLabelTableViewCell.self))"
}
