import UIKit

public protocol ColorConverter {
    func fromRGBColor(color: UIColor) throws
    func toRGBColor() -> UIColor
}



