import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        boxBuilder(view) { box1 in
            box1.pinCenter()

            boxBuilder(view) { box2 in
                box2.pin(\UIView.topAnchor, to: \.bottomAnchor, of: box1, withConstant: 10)
                box2.pin(to: \.centerXAnchor, of: box1)
            }
        }
        self.view = view
    }
}

// Stupid func for creating nonsense views to test layout functions
@discardableResult fileprivate func boxBuilder<T: UIView>(_ superView: T, setup: (UILabel) -> ()) -> UILabel {
    let view = UILabel()
    view.layer.cornerRadius = 20
    view.backgroundColor = UIColor(
        red: .random(in: 0...1),
        green: .random(in: 0...1),
        blue: .random(in: 0...1),
        alpha: 1
    )
    view.translatesAutoresizingMaskIntoConstraints = false
    superView.addSubview(view)
    let viewCount = superView.subviews.count
    view.text = "Box \(viewCount)"
    setup(view)
    return view
}

extension UIView {
    /// A Keypath for UIView Layout Constraints with sameness of axis enforced
    typealias UIViewPath<Axis, Path: NSLayoutAnchor<Axis>> = KeyPath<UIView, Path>
    
    /**
     Convenience function that constrains an view to it's superview based on the given anchors
     
     - Parameters:
     - from: a `UIView` `KeyPath` for a given anchor (eg: `\UIView.topAnchor`)
     - to: a `UIView` `KeyPath` for a given anchor (eg: `\UIView.topAnchor`)
     - constant: an optional `CGFloat` value to add to the constraint (default: 0)
     - Returns: The **Activated** layout constraint
     
     - Example: *Pinning a view's leadingAnchor to the parent view's leftAnchor*:
     
     view.pin(\UIView.leadingAnchor, \UIView.leftAnchor)
     
     
     + Since: First Available: October 12, 2018
     */
    @discardableResult
    func pin<AnchorType, Axis>(_ anchor: UIViewPath<Axis, AnchorType>, toParent superviewAnchor: UIViewPath<Axis, AnchorType>, withConstant constant: CGFloat = 0) -> NSLayoutConstraint {
        guard let parent = superview else { fatalError("You must add this view before adding constraints") }
        return pin(anchor, to: anchor, of: parent, withConstant: constant)
    }
    
    @discardableResult
    func pin<AnchorType, Axis>(_ anchor: UIViewPath<Axis, AnchorType>, withConstant constant: CGFloat = 0) -> NSLayoutConstraint {
        return pin(anchor, toParent: anchor, withConstant: constant)
    }
    
    @discardableResult
    func pinCenter(withX constantX: CGFloat = 0, andY constantY: CGFloat = 0) -> [NSLayoutConstraint] {
        return [
            pin(\UIView.centerXAnchor, withConstant: constantX),
            pin(\UIView.centerYAnchor, withConstant: constantY)
        ]
    }
    
    @discardableResult
    func pin<AnchorType, Axis>(to anchor: UIViewPath<Axis, AnchorType>, of otherView: UIView, withConstant constant: CGFloat = 0) -> NSLayoutConstraint {
        return pin(anchor, to: anchor, of: otherView, withConstant: constant)
    }
    
    @discardableResult
    func pin<AnchorType, Axis>(_ anchor: UIViewPath<Axis, AnchorType>, to otherViewAnchor: UIViewPath<Axis, AnchorType>, of otherView: UIView, withConstant constant: CGFloat = 0) -> NSLayoutConstraint {
        
        let source = self[keyPath: anchor]
        let target = otherView[keyPath: otherViewAnchor]
        
        let constraint = source.constraint(equalTo: target, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func pin(_ layoutDimension: KeyPath<UIView, NSLayoutDimension>, withConstant constant: CGFloat) -> NSLayoutConstraint {
        let constraint = self[keyPath: layoutDimension].constraint(equalToConstant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func pin(to layoutDimension: KeyPath<UIView, NSLayoutDimension>, of otherView: UIView, withMultiplier multiplier: CGFloat = 1) -> NSLayoutConstraint {
        let constraint = self[keyPath: layoutDimension].constraint(equalTo: otherView[keyPath: layoutDimension], multiplier: multiplier)
        constraint.isActive = true
        return constraint
    }
}

PlaygroundPage.current.liveView = MyViewController()
