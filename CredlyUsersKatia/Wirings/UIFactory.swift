//
//  UIFactory.swift
//  CredlyUsersKatia
//
//  Created by Katia Maeda on 2023-02-26.
//

import Foundation
import UIKit

protocol Storyboarded {
    static func instantiate() -> Self?
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self? {
        let identifierName = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: identifierName) as? Self
    }
}

public final class UIFactory {
    func makeUsersListViewController() -> UsersListViewController {
        guard let controller = UsersListViewController.instantiate() else {
            let errorMessage = "Could not instantiate view controller UsersListViewController from the Storyboard."
            fatalError(errorMessage)
        }
        
        return controller
    }
}
