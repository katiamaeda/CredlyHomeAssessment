//
//  ViewController.swift
//  CredlyProjectKatia
//
//  Created by Katia Maeda on 2023-02-25.
//

import UIKit
import Combine


class UsersListViewController: UIViewController, Storyboarded {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    
    public weak var coordinator: MainCoordinator?
    
    private let refreshControl = UIRefreshControl()
    private let viewModel: UsersListViewModel = UsersListViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.isHidden = false
        
        setupTableView()
        setupViewModelBinding()
        registerReusableViews()
    }
    
    private func setupTableView() {
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        
        // Pull to refresh
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    private func setupViewModelBinding() {
        viewModel.$users
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.loadingView.isHidden = true
                self?.tableView.isHidden = false
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
            .store(in: &subscriptions)
    }
    
    private func registerReusableViews() {
        tableView.register(UINib(nibName: UserTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: UserTableViewCell.identifier)
        tableView.register(UINib(nibName: OneLabelTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: OneLabelTableViewCell.identifier)
    }
    
    @objc private func refreshData(_ sender: Any) {
        viewModel.loadData()
    }
}

extension UsersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.loadState {
        case .loading:
            tableView.isHidden = true
            return .init()
        case .empty:
            return onLabelCell(tableView, indexPath, NSLocalizedString("users_list_view_empty", comment: ""))
        case .error:
            return onLabelCell(tableView, indexPath, NSLocalizedString("users_list_view_error_message", comment: ""))
        case .loaded:
            return listingCell(tableView, indexPath)
        }
    }
    
    private func onLabelCell(_ tableView: UITableView, _ indexPath: IndexPath, _ message: String) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OneLabelTableViewCell.identifier, for: indexPath) as? OneLabelTableViewCell else {
            return .init()
        }
        
        cell.label.text = message
        cell.label.font = UIFont.preferredFont(forTextStyle: .body)
        cell.label.adjustsFontForContentSizeCategory = true
        return cell
    }
    
    private func listingCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell else {
            return .init()
        }
        
        let user = viewModel.users[indexPath.row]

        cell.nameLabel.text = user.name
        cell.emailLabel.text = user.email
        cell.phoneLabel.text = user.phone
        
        cell.nameLabel.font = UIFont.preferredFont(forTextStyle: .body)
        cell.nameLabel.adjustsFontForContentSizeCategory = true
        cell.emailLabel.font = UIFont.preferredFont(forTextStyle: .body)
        cell.emailLabel.adjustsFontForContentSizeCategory = true
        cell.phoneLabel.font = UIFont.preferredFont(forTextStyle: .body)
        cell.phoneLabel.adjustsFontForContentSizeCategory = true
        
        return cell
    }
}

extension UsersListViewController: UITableViewDelegate {
    
}

