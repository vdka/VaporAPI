
extension Optional {

  func ifPresent(closure: (Wrapped) -> Void) {
    guard let wrapped = self else { return }
    closure(wrapped)
  }
}
