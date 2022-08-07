import SwiftUI

struct MovieDetailView: View {
    @State var userID: Int64
    @StateObject var viewModel = MovieDetailViewModel()

    var body: some View {
        if !viewModel.isLoaded {
            Text("Loading..")
                .task {
                    do {
                        try await viewModel.loadUserAsync(for: userID)
                    } catch {
                            print("Error", error)
                    }
                }
        } else {
            UserDetailsScreen(viewModel: viewModel)

        }
            
    }
}


struct UserDetailsScreen: View {
    var viewModel: MovieDetailViewModel
    
    var body: some View {
        VStack {
            HStack {
                AsyncImage(url: viewModel.detail!.avatar_url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 150, maxHeight: 150)
                    case .failure:
                        Image(systemName: "photo")
                    @unknown default:
                        EmptyView()
                    }
                }
                Spacer()
                VStack {
                    createView(for: "Login:", description: viewModel.detail!.login)
                    createView(for: "Name:", description: viewModel.detail!.name ?? "-")
                }
                
                Spacer()
            }

            createView(for: "Company:", description: viewModel.detail!.company ?? "-")
            createView(for: "Blog:", description: viewModel.detail!.blog ?? "-")
            createView(for: "Number of Followers:", description: "\(viewModel.detail!.followers)")
            createView(for: "Number of Following:", description: "\(viewModel.detail!.following)")
            createView(for: "Number of Public Repo:", description: "\(viewModel.detail!.public_repos)")

            Spacer()
        }
        
    }
    
    func createView(for title:String, description:String) -> some View {
        HStack {
            Text(title)
            Text(description)
                .font(Font.system(size: 18).bold())
            Spacer()
        }
    }
}
