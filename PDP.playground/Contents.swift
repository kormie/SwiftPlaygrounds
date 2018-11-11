import UIKit
import PlaygroundSupport

class PDPViewController: UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .red
        self.view = view
    }
}
PlaygroundPage.current.liveView = PDPViewController()
