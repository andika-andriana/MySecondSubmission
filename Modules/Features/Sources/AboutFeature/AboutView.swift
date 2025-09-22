import Common
import SwiftUI

@available(iOS 16.0, *)
public struct AboutView: View {
  @StateObject private var viewModel: ProfileViewModel

  public init(viewModel: ProfileViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  public var body: some View {
    VStack(spacing: 16) {
      Image("MyAvatar")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 150, height: 150)
        .clipShape(Circle())

      Text(viewModel.profile.name)
        .font(.title)
        .fontWeight(.bold)

      VStack(spacing: 4) {
        Text(viewModel.profile.job)
        Text(viewModel.profile.email)
      }
      .font(.body)
      .multilineTextAlignment(.center)

      Text(viewModel.profile.interests)
        .font(.body)

      Spacer()
    }
    .padding()
    .toolbar {
      ToolbarItemGroup(placement: .topBarTrailing) {
        NavigationLink(CommonLocalization.string("about.edit")) {
          EditProfileView(viewModel: viewModel)
        }
      }
    }
  }
}
