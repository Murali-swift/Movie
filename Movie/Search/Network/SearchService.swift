//
//  SearchService.swift
//  GithubUser
//
//  Created by Murali Nallusamy on 06/08/22.
//
import Foundation
import Combine
import SwiftUI

protocol Searchable: Handler {
    func search(_ name: String,completion: @escaping (_ movies: [Movie]?,_ error:String?) -> Void) -> AnyCancellable
}


class SearchService:ObservableObject, Searchable {
    func search(_ name: String, completion: @escaping (_ movies: [Movie]?,_ error:String?) -> Void) -> AnyCancellable {
        var urlComponents = URLComponents(string: BASEURL)!
        urlComponents.queryItems = [
            URLQueryItem(name: "apikey", value: APIKEY),
            URLQueryItem(name: "s", value: name)
        ]

        var request = URLRequest(url: urlComponents.url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: SearchMovieResponse.self, decoder: JSONDecoder())
            .map { $0.search }
            .receive(on: RunLoop.main)
            .sink( receiveCompletion: { handler in
                self.handleCompletionHandler(completionHandler: handler, completion: completion)
            }, receiveValue: { (movies) in
                completion(movies, nil)
            })
    }
}
