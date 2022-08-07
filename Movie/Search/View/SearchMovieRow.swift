import SwiftUI

struct SearchMovieRow: View {
    @ObservedObject var viewModel: SearchMovieViewModel
    @State var user: User

    var body: some View {
        HStack {
            AsyncImage(url: user.avatar_url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 50, maxHeight: 50)
                case .failure:
                    Image(systemName: "photo")
                @unknown default:
                    EmptyView()
                }
            }
            Text(user.login)
                .font(Font.system(size: 18).bold())
            
            Spacer()
        }
        .frame(height: 60)
    }
}
