//
//  DetailService.swift
//  Movie
//
//  Created by Murali Nallusamy on 06/08/22.
//

import Foundation
import Combine
import SwiftUI

protocol Handler {
    func handleCompletionHandler<T:Any>(completionHandler:((Subscribers.Completion<Error>)), completion:@escaping(_ object:T?, _ error:String?) -> Void)
}

extension Handler {
    func handleCompletionHandler<T:Any>(completionHandler:((Subscribers.Completion<Error>)), completion:@escaping(_ object:T?, _ error:String?) -> Void){
        switch completionHandler {
        case .failure(let error):
            completion(nil, error.localizedDescription)
            break
        case .finished:
            break
        }
    }
}

protocol FullDetailRequestable: Handler {
    func movieDetail(for movieId: String, completion: @escaping (_ movies: [Movie]?,_ error:String?) -> Void) -> AnyCancellable
}


class DetailService:ObservableObject, FullDetailRequestable {
    func movieDetail(for movieId: String, completion: @escaping (_ movies: [Movie]?,_ error:String?) -> Void) -> AnyCancellable {
        var urlComponents = URLComponents(string: BASEURL)!
        urlComponents.queryItems = [
            URLQueryItem(name: "apikey", value: APIKEY),
            URLQueryItem(name: "i", value: movieId),
            URLQueryItem(name: "plot", value: DETAILTYPE),
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
