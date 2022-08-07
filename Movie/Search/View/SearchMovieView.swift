import SwiftUI

struct SearchMovieView: View {
    @ObservedObject var viewModel = SearchMovieViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchUserBar(text: $viewModel.name) {
                    self.viewModel.search()
                }
                
                List(viewModel.users) { user in
                    NavigationLink(destination: UserDetailView(userID: user.id)) {
                        SearchUserRow(viewModel: self.viewModel, user: user)
                    }
                }
            }
            .navigationBarTitle(Text("Users"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
