import Common
import Foundation

@MainActor
public final class ProfileViewModel: ObservableObject {
  @Published public var profile: Profile
  @Published public var showValidationError = false

  private let manager: ProfileManager

  public init(manager: ProfileManager = .shared) {
    self.manager = manager
    self.profile = manager.load()
  }

  public var isValid: Bool {
    profile.name.isNotBlank && profile.job.isNotBlank
      && profile.interests.isNotBlank && profile.email.isValidEmail
  }

  public func save() {
    if isValid {
      manager.save(profile)
    } else {
      showValidationError = true
    }
  }
}

extension String {
  fileprivate var isNotBlank: Bool {
    !trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  fileprivate var isValidEmail: Bool {
    range(of: #"^\S+@\S+\.\S+$"#, options: .regularExpression) != nil
  }
}
