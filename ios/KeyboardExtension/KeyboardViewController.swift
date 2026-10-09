import UIKit

final class KeyboardViewController: UIInputViewController {
  private let categories: [(String, [String])] = [
    ("Happy", ["(˶ᵔ ᵕ ᵔ˶)", "(ﾉ◕ヮ◕)ﾉ*:･ﾟ✧", "٩(ˊᗜˋ*)و", "(๑˃ᴗ˂)ﻭ", "ヽ(・∀・)ﾉ", "(*≧ω≦)", "ദ്ദി(˵ •̀ ᴗ - ˵ ) ✧", "ꉂ(ˊᗜˋ*)", "ᕕ( ᐛ )ᕗ"]),
    ("Love", ["(˘͈ᵕ ˘͈♡)", "(っ˘з(˘⌣˘ )", "♡(｡- ω -)", "( ˘ ³˘)♥", "(´｡• ᵕ •｡`) ♡", "(*♡∀♡)", "ღゝ◡╹)ノ♡", "(♡μ_μ)", "♡(˃͈ દ ˂͈ ༶ )"]),
    ("Cute", ["૮₍ ˶ᵔ ᵕ ᵔ˶ ₎ა", "૮₍ ˃ ⤙ ˂ ₎ა", "ʕ•ᴥ•ʔ", "(ᵕ—ᴗ—)", "ฅ^•ﻌ•^ฅ", "૮꒰ ˶• ༝ •˶꒱ა", "(｡•́‿•̀｡)", "ʕっ•ᴥ•ʔっ", "₍^. .^₎⟆"]),
    ("Sad", ["(╥﹏╥)", "(っ- ‸ - ς)", "(｡•́︿•̀｡)", "(ಥ﹏ಥ)", "(つ﹏<。)", "(╯︵╰,)", "(っ˕ -｡)", "｡°(°.◜ᯅ◝°)°｡", "(ノ_<。)"]),
    ("Fun", ["(¬‿¬)", "¯\\_(ツ)_/¯", "(ง'̀-'́)ง", "( •̀ᴗ•́ )و", "(☞ﾟヮﾟ)☞", "(ﾉಥ益ಥ)ﾉ", "┬─┬ノ( º _ ºノ)", "ಠ_ಠ", "ᕙ(⇀‸↼‶)ᕗ"])
  ]

  private var selectedCategory = 0
  private let categoryBar = UIStackView()
  private let kaomojiGrid = UIStackView()
  private let gridScrollView = UIScrollView()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(red: 0.12, green: 0.11, blue: 0.20, alpha: 1)
    view.heightAnchor.constraint(equalToConstant: 270).isActive = true
    buildKeyboard()
    showCategory(0)
  }

  private func buildKeyboard() {
    let root = UIStackView()
    root.axis = .vertical
    root.spacing = 10
    root.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(root)
    NSLayoutConstraint.activate([
      root.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
      root.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
      root.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
      root.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
    ])

    let title = UILabel()
    title.text = "little quest  ✦  kaomojis"
    title.textColor = UIColor(red: 0.78, green: 0.66, blue: 1, alpha: 1)
    title.font = .systemFont(ofSize: 13, weight: .bold)
    title.textAlignment = .center
    root.addArrangedSubview(title)

    categoryBar.axis = .horizontal
    categoryBar.spacing = 6
    categoryBar.distribution = .fillEqually
    root.addArrangedSubview(categoryBar)
    for (index, category) in categories.enumerated() {
      let button = UIButton(type: .system)
      button.setTitle(category.0, for: .normal)
      button.titleLabel?.font = .systemFont(ofSize: 11, weight: .semibold)
      button.tag = index
      button.addTarget(self, action: #selector(selectCategory(_:)), for: .touchUpInside)
      categoryBar.addArrangedSubview(button)
    }

    gridScrollView.showsVerticalScrollIndicator = false
    root.addArrangedSubview(gridScrollView)
    kaomojiGrid.axis = .vertical
    kaomojiGrid.spacing = 7
    kaomojiGrid.translatesAutoresizingMaskIntoConstraints = false
    gridScrollView.addSubview(kaomojiGrid)
    NSLayoutConstraint.activate([
      kaomojiGrid.leadingAnchor.constraint(equalTo: gridScrollView.contentLayoutGuide.leadingAnchor),
      kaomojiGrid.trailingAnchor.constraint(equalTo: gridScrollView.contentLayoutGuide.trailingAnchor),
      kaomojiGrid.topAnchor.constraint(equalTo: gridScrollView.contentLayoutGuide.topAnchor),
      kaomojiGrid.bottomAnchor.constraint(equalTo: gridScrollView.contentLayoutGuide.bottomAnchor),
      kaomojiGrid.widthAnchor.constraint(equalTo: gridScrollView.frameLayoutGuide.widthAnchor)
    ])

    let bottom = UIStackView()
    bottom.axis = .horizontal
    bottom.spacing = 7
    root.addArrangedSubview(bottom)
    bottom.addArrangedSubview(actionButton(title: "🌐", action: #selector(switchKeyboard), width: 48))
    bottom.addArrangedSubview(actionButton(title: "space", action: #selector(insertSpace), width: nil))
    bottom.addArrangedSubview(actionButton(title: "⌫", action: #selector(deleteCurrentCharacter), width: 48))
    bottom.addArrangedSubview(actionButton(title: "return", action: #selector(insertReturn), width: 68))
    bottom.heightAnchor.constraint(equalToConstant: 38).isActive = true
  }

  private func actionButton(title: String, action: Selector, width: CGFloat?) -> UIButton {
    let button = UIButton(type: .system)
    button.setTitle(title, for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = UIColor.white.withAlphaComponent(0.12)
    button.layer.cornerRadius = 9
    button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
    button.addTarget(self, action: action, for: .touchUpInside)
    if let width {
      button.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    return button
  }

  @objc private func selectCategory(_ sender: UIButton) {
    showCategory(sender.tag)
  }

  private func showCategory(_ index: Int) {
    selectedCategory = index
    for (buttonIndex, view) in categoryBar.arrangedSubviews.enumerated() {
      guard let button = view as? UIButton else { continue }
      button.setTitleColor(
        buttonIndex == selectedCategory ? UIColor(red: 0.78, green: 0.66, blue: 1, alpha: 1) : .lightGray,
        for: .normal
      )
    }
    kaomojiGrid.arrangedSubviews.forEach {
      kaomojiGrid.removeArrangedSubview($0)
      $0.removeFromSuperview()
    }
    let items = categories[index].1
    for start in stride(from: 0, to: items.count, by: 3) {
      let row = UIStackView()
      row.axis = .horizontal
      row.spacing = 7
      row.distribution = .fillEqually
      for itemIndex in start..<min(start + 3, items.count) {
        let key = UIButton(type: .system)
        key.setTitle(items[itemIndex], for: .normal)
        key.titleLabel?.font = .systemFont(ofSize: 14)
        key.titleLabel?.adjustsFontSizeToFitWidth = true
        key.titleLabel?.minimumScaleFactor = 0.65
        key.setTitleColor(.white, for: .normal)
        key.backgroundColor = UIColor.white.withAlphaComponent(0.09)
        key.layer.cornerRadius = 9
        key.tag = itemIndex
        key.addTarget(self, action: #selector(insertKaomoji(_:)), for: .touchUpInside)
        row.addArrangedSubview(key)
      }
      while row.arrangedSubviews.count < 3 {
        row.addArrangedSubview(UIView())
      }
      row.heightAnchor.constraint(equalToConstant: 43).isActive = true
      kaomojiGrid.addArrangedSubview(row)
    }
  }

  @objc private func switchKeyboard() {
    advanceToNextInputMode()
  }

  @objc private func insertKaomoji(_ sender: UIButton) {
    let items = categories[selectedCategory].1
    guard items.indices.contains(sender.tag) else { return }
    textDocumentProxy.insertText(items[sender.tag])
  }

  @objc private func deleteCurrentCharacter() {
    textDocumentProxy.deleteBackward()
  }

  @objc private func insertSpace() {
    textDocumentProxy.insertText(" ")
  }

  @objc private func insertReturn() {
    textDocumentProxy.insertText("\n")
  }
}
