import Swinject

enum AppDI {
  static let assembler: Assembler = Assembler([
    DataAssembly(), DomainAssembly(), PresentationAssembly()
  ])
  static var resolver: Resolver { assembler.resolver }
}
