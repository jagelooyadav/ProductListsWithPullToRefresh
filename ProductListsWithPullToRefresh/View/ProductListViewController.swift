//
//  ViewController.swift
//  ProductListsWithPullToRefresh
//
//  Created by Jageloo Yadav on 30/10/21.
//

import UIKit

class ProductListViewController: UIViewController {
    @IBOutlet weak var tableView: PaginatedTableView!
    var prodcuctListViewModel: ProdcutListViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.paginationDelegate = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 200
        self.prodcuctListViewModel?.notify = { [weak self] in
            self?.tableView.reloadData()
        }
        self.prodcuctListViewModel?.fetchFeeds()
    }
}

extension ProductListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vm = self.prodcuctListViewModel.feeds[indexPath.row]
        self.prodcuctListViewModel.showDetail(detailVM: vm)
    }
}

extension ProductListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.prodcuctListViewModel.feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let model = self.prodcuctListViewModel.feeds[indexPath.row]
        cell.textLabel?.text = model.displayName
        cell.detailTextLabel?.text = model.detailText
        return cell
    }
}

extension ProductListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}

extension ProductListViewController: PaginationDelegate {
    func refresh() {
    }
    
    func loadMore() {
    }
}

