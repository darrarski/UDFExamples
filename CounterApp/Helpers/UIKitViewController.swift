import SwiftUI

struct UIKitViewController<ViewController: UIViewController>: UIViewControllerRepresentable {
  let viewController: () -> ViewController

  func makeUIViewController(context: Context) -> ViewController {
    viewController()
  }

  func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}

