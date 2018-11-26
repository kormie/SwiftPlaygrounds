import UIKit
import PlaygroundSupport

let grey = UIColor(red:0.73, green:0.73, blue:0.73, alpha:1.00)

func boxBuilder() -> UIView {
    let view = UIView()
    view.backgroundColor = .lightGray
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 11
    view.widthAnchor.constraint(equalToConstant: 22).isActive = true
    view.heightAnchor.constraint(equalToConstant: 22).isActive = true
    return view
}

var box1: UIView = boxBuilder()
var box2: UIView = boxBuilder()
var box3: UIView = boxBuilder()
var stack: UIStackView = {
    let view = UIStackView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .horizontal
    view.alignment = .center
    view.distribution = .equalSpacing
    view.addArrangedSubview(box1)
    view.addArrangedSubview(box2)
    view.addArrangedSubview(box3)
    return view
}()


private func beginAnimating() {
    let initial1 = box1.transform
    let translated1 = initial1.translatedBy(x: 0, y: -22)
    let initial2 = box2.transform
    let translated2 = initial2.translatedBy(x: 0, y: -22)
    let initial3 = box3.transform
    let translated3 = initial3.translatedBy(x: 0, y: -22)
    UIView.animate(withDuration: 0.4, delay: 0.2, options: [], animations: {
        box1.transform = translated1
    }) { complete in
        UIView.animate(withDuration: 0.4, animations: {
            box1.transform = initial1
        })
    }
    UIView.animate(withDuration: 0.4, delay: 0.8, options: [], animations: {
        box2.transform = translated2
    }) { complete in
        UIView.animate(withDuration: 0.4, animations: {
            box2.transform = initial2
        })
    }
    UIView.animate(withDuration: 0.4, delay: 1.2, options: [], animations: {
        box3.transform = translated3
    }) { complete in
        UIView.animate(withDuration: 0.4, animations: {
            box3.transform = initial3
        }) { complete in
            beginAnimating()
        }
    }
}


let viewFrame = CGRect(x: 0, y: 0, width: 500, height: 500)
let view = UIView(frame: viewFrame)
view.backgroundColor = .white
view.addSubview(stack)
beginAnimating()
stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
PlaygroundPage.current.liveView = view
