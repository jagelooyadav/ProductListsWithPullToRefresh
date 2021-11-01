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
    
    let indiactor = UIActivityIndicatorView.init(style: .large)
    
    private var isLoading = false
    
    init(delegate: PaginationDelegate? = nil) {
        self.paginationDelegate = delegate
        super.init(frame: .zero, style: .plain)
        self.setup()
    }
    
    private func setup() {
        let refreshView = UIView.init(frame: CGRect.init(x: 0, y: -80, width: UIScreen.main.bounds.width, height: 80))
        self.addSubview(refreshView)
        refreshView.backgroundColor = UIColor.red
        refreshView.addSubview(indiactor)
        indiactor.frame = CGRect.init(x: 0, y: 0, width: 100, height: 100)
        indiactor.center = refreshView.center
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        self.backgroundColor = .blue
    }
}

extension PaginatedTableView: PaginatedScrollViewProtocol {
    func observeScrolling() {
        if contentOffset.y <= CGFloat(-70.0), !isLoading {
            self.contentInset = UIEdgeInsets.init(top: 80, left: 0, bottom: 0, right: 0)
            indiactor.stopAnimating()
            self.paginationDelegate?.refresh()
        }
        if contentOffset.y + UIScreen.main.bounds.height >= contentSize.height {
            self.paginationDelegate?.loadMore()
        }
    }
    
    func removeRfresshControl() {
        self.contentInset = .zero
    }
    
    func removeLoadMoreLoader() {
    }
}
