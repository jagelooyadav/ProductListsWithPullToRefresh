//
//  ProdcutListViewModel.swift
//  ProductListsWithPullToRefresh
//
//  Created by Jageloo Yadav on 30/10/21.
//

import Foundation

struct FetchRequest {
    let categoryId: String
    let location: String
}

struct Response<T: Decodable>: Decodable {
    let status: Bool?
    let serverErrorMessage: String?
    let data: T?
}

struct FeedData: Decodable {
    let categoryId: String
    let displayName: String
    let detailText: String
    let imageURLString: String
}

struct FeedDataResponse: Decodable {
    let feeds: [FeedData]
}

protocol ProductServiceProvider {
    func fetch(fetchRequest: FetchRequest, completion: ((Result<[FeedData], Error>) -> Void)?)
}

protocol ProdcutListViewModelProtocol {
    var feeds: [FeedDataViewModelProtocol] { get }
    var coordinator: ProdcutListCoordinatorProtocol? { get }
    func fetchFeeds()
    func showDetail(detailVM: FeedDataViewModelProtocol)
    var notify: (() -> Void)? { get set }
}

protocol FeedDataViewModelProtocol {
    var categoryId: String { get }
    var displayName: String { get }
    var detailText: String { get }
    var imageURLString: String { get }
}

class FeedDataViewModel: FeedDataViewModelProtocol {
    var categoryId: String
    var displayName: String
    var detailText: String
    var imageURLString: String
    
    init(feedData: FeedData) {
        self.categoryId = feedData.categoryId
        self.displayName = feedData.displayName
        self.detailText = feedData.detailText
        self.imageURLString = feedData.imageURLString
    }
}

class ProdcutListViewModel: ProdcutListViewModelProtocol {
    
    weak var coordinator: ProdcutListCoordinatorProtocol?
    var notify: (() -> Void)?
    
    var feeds: [FeedDataViewModelProtocol] = [] {
        didSet {
            self.notify?()
        }
    }
    
    private let service: ProductServiceProvider
    
    init(service: ProductServiceProvider) {
        self.service = service
    }
    
    func fetchFeeds() {
        let request = FetchRequest(categoryId: "1", location: "India")
        self.service.fetch(fetchRequest: request) { [weak self] result in
            switch result {
                case .success(let data):
                    self?.feeds = data.compactMap({ FeedDataViewModel(feedData: $0)})
                case .failure(_):
                    self?.feeds = []
                    break
            }
        }
    }
    
    func showDetail(detailVM: FeedDataViewModelProtocol) {
        self.coordinator?.showDetail(detailViewModel: detailVM)
    }
}

enum GatewayError: Error {
    case genericError
    case intrnetError
    case error(String, String)
    
    var errorMessage: String {
        switch self {
            case .genericError:
                return "Something went wrong"
            case .intrnetError:
                return "Please check your connection"
                
            case .error(_, let errorMessage):
                return errorMessage
        }
    }
}
