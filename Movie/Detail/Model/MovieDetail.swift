import Foundation
import SwiftUI

struct MovieDetail: Hashable, Identifiable, Decodable {
    var id: Int64
    var login: String
    var avatar_url: URL
    var type: String?
    var name: String?
    var company: String?
    var blog: String?
    var location: String?
    var email: String?
    var bio: String?
    var twitter_username: String?
    var public_repos: Int
    var public_gists: Int
    var followers: Int
    var following: Int
}
