import Combine
import ComposableArchitecture
import UIKit

final class CounterViewController: UIViewController {
  init(store: Store<CounterState, CounterAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    nil
  }

  let store: Store<CounterState, CounterAction>
  let viewStore: ViewStore<CounterState, CounterAction>
  var cancellables = Set<AnyCancellable>()

  override func viewDidLoad() {
    super.viewDidLoad()

    let countLabel = UILabel()
    countLabel.font = .preferredFont(forTextStyle: .largeTitle)

    let incrementButton = UIButton()
    incrementButton.setTitle("Increment", for: .normal)
    incrementButton.setTitleColor(view.tintColor, for: .normal)
    incrementButton.addTarget(self, action: #selector(incrementButtonAction), for: .touchUpInside)

    let decrementButton = UIButton()
    decrementButton.setTitle("Decrement", for: .normal)
    decrementButton.setTitleColor(view.tintColor, for: .normal)
    decrementButton.addTarget(self, action: #selector(decrementButtonAction), for: .touchUpInside)

    let resetButton = UIButton()
    resetButton.setTitle("Reset", for: .normal)
    resetButton.setTitleColor(view.tintColor, for: .normal)
    resetButton.addTarget(self, action: #selector(resetButtonAction), for: .touchUpInside)

    let stack = UIStackView(arrangedSubviews: [
      countLabel,
      incrementButton,
      decrementButton,
      resetButton
    ])
    stack.axis = .vertical
    stack.alignment = .center
    stack.spacing = 16
    view.addSubview(stack)
    stack.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      stack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
    ])

    viewStore.publisher
      .map(\.count)
      .map(String.init)
      .sink(receiveValue: { countLabel.text = $0 })
      .store(in: &cancellables)
  }

  @objc func incrementButtonAction() {
    viewStore.send(.increment)
  }

  @objc func decrementButtonAction() {
    viewStore.send(.decrement)
  }

  @objc func resetButtonAction() {
    viewStore.send(.reset)
  }
}
