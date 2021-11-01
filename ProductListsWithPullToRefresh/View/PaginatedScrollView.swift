//
//  PaginatedScrollView.swift
//  ProductListsWithPullToRefresh
//
//  Created by Jageloo Yadav on 01/11/21.
//

import Foundation
import UIKit


protocol PaginatedScrollViewProtocol: class {
    func observeScrolling()
    func removeRfresshControl()
    func removeLoadMoreLoader()
}

protocol PaginationDelegate: class {
    func refresh()
    func loadMore()
}

class PaginatedTableView: UITableView {
    weak var paginationDelegate: PaginationDelegate?
    
    private var isLoading = false
    
    init(delegate: PaginationDelegate? = nil) {
        self.paginationDelegate = delegate
        super.init(frame: .zero, style: .plain)
        self.setup()
    }
    
    private func setup() {
        let indiactor = UIActivityIndicatorView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}

extension PaginatedTableView: PaginatedScrollViewProtocol {
    func observeScrolling() {
        if contentOffset.y <= CGFloat(-70.0), !isLoading {
            self.paginationDelegate?.refresh()
        }
        if contentOffset.y + UIScreen.main.bounds.height >= contentSize.height {
            self.paginationDelegate?.loadMore()
        }
    }
    
    func removeRfresshControl() {
    }
    
    func removeLoadMoreLoader() {
    }
}
