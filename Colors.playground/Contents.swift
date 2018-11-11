import UIKit
import PlaygroundSupport

extension UIView {

    func addBorder(color: UIColor = .red, width: CGFloat = 1) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }

    func removeBorder() {
        layer.borderWidth = 0
        layer.borderColor = UIColor.clear.cgColor
    }
}

let viewFrame = CGRect(x: 0, y: 0, width: 500, height: 500)
let vc = UIViewController()

let wrapperView = UIScrollView()
wrapperView.backgroundColor = .white

let outerStackView = UIStackView()

outerStackView.translatesAutoresizingMaskIntoConstraints = false
wrapperView.addSubview(outerStackView)
outerStackView.topAnchor.constraint(equalTo: wrapperView.topAnchor).isActive = true
outerStackView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor).isActive = true
outerStackView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor).isActive = true
outerStackView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor).isActive = true
outerStackView.widthAnchor.constraint(equalTo: wrapperView.widthAnchor).isActive = true
outerStackView.axis = .vertical
outerStackView.alignment = .fill
outerStackView.distribution = .fill
outerStackView.spacing = 0


extension UIColor {
    static let maxContrastRatio: CGFloat = 5.5 // 4.5:1 [As recomended by w3c for readability](https://www.w3.org/WAI/ER/WD-AERT/#color-contrast)
    static let minContrastRatio: CGFloat = 1.0

    func compose(with compositeColor: UIColor) -> UIColor {
        var (r1, g1, b1, a1) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        var (r2, g2, b2, a2) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))

        getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        guard a1 < 1 else { return self }
        compositeColor.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        return UIColor(
            red: min(r1 * a1 + (r2 * (1-a1)), 1),
            green: min(g1 * a1 + (g2 * (1-a1)), 1),
            blue: min(b1 * a1 + (b2 * (1-a1)), 1),
            alpha: min((a1 + a2)/2, 1)
        )

    }
    func contrast(with comparisonColor: UIColor) -> CGFloat {
        var selfLuminance: CGFloat = 0
        var comparisonColorLuminance: CGFloat = 0

        var selfAlpha: CGFloat = 0

        getWhite(&selfLuminance, alpha: &selfAlpha)
        comparisonColor.getWhite(&comparisonColorLuminance, alpha: nil)

        selfLuminance *= selfAlpha
        let darkLuminance = selfLuminance > comparisonColorLuminance ? comparisonColorLuminance : selfLuminance
        let lightLuminance = selfLuminance < comparisonColorLuminance ? comparisonColorLuminance : selfLuminance
        let ratioScale = 1 / (UIColor.maxContrastRatio - UIColor.minContrastRatio)

        let contrast = (lightLuminance + ratioScale) / (darkLuminance + ratioScale)
        return contrast
    }

    func maxContrast(with color1: UIColor, or color2: UIColor) -> UIColor {
        return contrast(with: color1) > contrast(with: color2) ? color1 : color2
    }

    func toHexString() -> (String, Bool) {
        var (r, g, b, a) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

        let rgba:Int = rgb<<8 | (Int)(a*255)<<0

        switch a == 1.0 {
        case true:
            return (String(format:"#%06x", rgb), false)
        case false:
            return (String(format:"#%08x", rgba), true)

        }
    }

    static func randomColor(randomAlpha: Bool = false) -> UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: randomAlpha ? .random(in: 0...1) : 1
        )
    }
}
struct LTColor {
    var color: UIColor
    let name: String
    
    func maxContrast(with: UIColor, or: UIColor) -> UIColor {
        return color.maxContrast(with:with,or:or)
    }
    func compose(_ compositeColor: UIColor) -> LTColor {
        let color = self.color.compose(with: compositeColor)
        return LTColor(color: color, name: self.name)
    }
}
//MARK: Greys
let faintGray = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.00)
let lightGray = UIColor(red:0.76, green:0.76, blue:0.78, alpha:1.00)
let darkGray = UIColor(red:0.40, green:0.41, blue:0.44, alpha:1.00)
let charcoal = UIColor(red:0.18, green:0.18, blue:0.19, alpha:1.00)
let veryTransparentblack = UIColor(red: 1, green: 1, blue: 1, alpha: 0.01)
let test = UIColor(red:0.69, green:0.408, blue:0.478, alpha:0.067)

let random = UIColor.randomColor()
let randomWithAlpha = UIColor.randomColor(randomAlpha: true)
let veryLightTurqouise = UIColor(red:0.06, green:0.89, blue:0.67, alpha: 0.196078431)
let veryLightPink = UIColor(red:0.95, green:0.67, blue:0.63, alpha:0.07)

let colors: [LTColor] = [
    LTColor(color: UIColor.black.withAlphaComponent(0.9), name: "Black"),
    LTColor(color: UIColor.black.withAlphaComponent(0.06), name: "Transparent Black"),
    LTColor(color: .white, name: "White"),
    LTColor(color: faintGray, name: "Faint Gray"),
    LTColor(color: lightGray, name: "Light Gray"),
    LTColor(color: darkGray, name: "Dark Gray"),
    LTColor(color: charcoal, name: "Charcoal"),
    LTColor(color: random, name: "Random Color"),
    LTColor(color: randomWithAlpha, name: "Random with Alpha"),
    LTColor(color: veryLightPink, name: "Very light pink"),
    LTColor(color: veryLightTurqouise, name: "Very light turqouise"),
]

func name(color: LTColor) -> UILabel {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    let labelColor = color.maxContrast(with: .black, or: .white)
    label.textColor = labelColor
    label.text = color.name

    label.textAlignment = .center
    return label
}

func hex(color: LTColor) -> UILabel {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    let labelColor = color.maxContrast(with: .black, or: .white)
    label.textColor = labelColor
    let labelText = color.color.toHexString().1 ? "RGBA Hex" : "RGB Hex"
    label.text = "\(labelText): \(color.color.toHexString().0)"
    label.textAlignment = .center
    return label
}

for color in colors {
    let newColor = color.compose(wrapperView.backgroundColor!)
    let subview = UIView()
    outerStackView.addArrangedSubview(subview)
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.distribution = .fillEqually
    subview.backgroundColor = color.color
    subview.addSubview(stack)
    stack.topAnchor.constraint(equalTo: subview.topAnchor, constant: 16).isActive = true
    stack.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: -16).isActive = true

    stack.leadingAnchor.constraint(equalTo: subview.leadingAnchor).isActive = true
    stack.trailingAnchor.constraint(equalTo: subview.trailingAnchor).isActive = true
    subview.heightAnchor.constraint(greaterThanOrEqualToConstant: 150)
    let nameLabel = name(color: newColor)
    let hexLabel = hex(color: newColor)
    stack.addArrangedSubview(nameLabel)
    stack.addArrangedSubview(hexLabel)

    outerStackView.addArrangedSubview(subview)
}
vc.view = wrapperView
PlaygroundPage.current.liveView = vc
