//
//  UserDetailViewModel.swift
//  GithubUser
//

import SwiftUI
import Combine

final class MovieDetailViewModel: ObservableObject {
    @Published var detail: MovieDetail?
    @Published var isLoaded: Bool = false
    
    private var detailsCancellable: Cancellable? {
        didSet { oldValue?.cancel() }
    }

    deinit {
        detailsCancellable?.cancel()
    }
    
    func loadUserAsync(for id: Int64) async throws {
        isLoaded = false
        let urlComponents = URLComponents(string: "https://api.github.com/user/\(id)")!
        
        guard let url = urlComponents.url else { fatalError("Missing URL") }
        let urlRequest = URLRequest(url: url)
        async let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard try await (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error while fetching data")
        }
        let userDetails = try await JSONDecoder().decode(MovieDetail.self, from: data)

        DispatchQueue.main.async { [weak self, userDetails] in
            self?.isLoaded = true
            self?.detail = userDetails
            print("Async decodedUser", userDetails)
        }
    }
}
