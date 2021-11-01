//
//  ProductListViewCoordinator.swift
//  ProductListsWithPullToRefresh
//
//  Created by Jageloo Yadav on 31/10/21.
//

import Foundation

protocol ProdcutListCoordinatorProtocol: class {
    func showDetail(detailViewModel: FeedDataViewModelProtocol)
}

class ProdcutListCoordinator: BaseCoordinator, ProdcutListCoordinatorProtocol {
    override func start() {
    }
    
    func showDetail(detailViewModel: FeedDataViewModelProtocol) {
    }
}

// To DO: Needs to replace actuall login service
class ProductServiceProviderMock: ProductServiceProvider {
    func fetch(fetchRequest: FetchRequest, completion: ((Result<[FeedData], Error>) -> Void)?) {
        guard let path = Bundle.main.path(forResource: "Modal", ofType: ".json") else { return }
        let responseString = try? String.init(contentsOf: URL.init(fileURLWithPath: path))
        guard let data = responseString?.data(using: .utf8) else { return }
        print("data === \(data)")
        guard let response = try? JSONDecoder().decode(Response<FeedDataResponse>.self, from: data), let feeds = response.data?.feeds else { return }
        completion?(Result.success(feeds))
    }
}



