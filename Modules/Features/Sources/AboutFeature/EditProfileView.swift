import Common
import SwiftUI

public struct EditProfileView: View {
  @ObservedObject private var viewModel: ProfileViewModel
  @Environment(\.dismiss) private var dismiss

  public init(viewModel: ProfileViewModel) {
    self.viewModel = viewModel
  }

  public var body: some View {
    Form {
      Section(header: CommonLocalization.text("about.name.placeholder")) {
        TextField("", text: $viewModel.profile.name)
          .textInputAutocapitalization(.words)
      }
      Section(header: CommonLocalization.text("about.job.placeholder")) {
        TextField("", text: $viewModel.profile.job)
          .textInputAutocapitalization(.words)
      }
      Section(header: CommonLocalization.text("about.email.placeholder")) {
        TextField("", text: $viewModel.profile.email)
          .keyboardType(.emailAddress)
          .textInputAutocapitalization(.never)
          .autocorrectionDisabled(true)
      }
      Section(header: CommonLocalization.text("about.interests.placeholder")) {
        TextField("", text: $viewModel.profile.interests)
      }
    }
    .navigationTitle(CommonLocalization.text("about.edit"))
    .toolbar {
      ToolbarItemGroup(placement: .topBarTrailing) {
        Button(CommonLocalization.string("action.save")) {
          viewModel.save()
          if !viewModel.showValidationError {
            dismiss()
          }
        }
        .disabled(!viewModel.isValid)
      }
    }
    .alert(
      CommonLocalization.string("about.validation.title"),
      isPresented: $viewModel.showValidationError
    ) {
      Button(CommonLocalization.string("action.ok"), role: .cancel) {}
    } message: {
      Text(CommonLocalization.string("about.validation.message"))
    }
  }
}
