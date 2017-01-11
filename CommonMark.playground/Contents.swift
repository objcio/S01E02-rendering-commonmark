//: Make sure to open this playground as part of the workspace and to build the project.

import CommonMark

let markdown = "# Heading **strong**\nHello **Markdown**!"


extension Array where Element: NSAttributedString {
    func join(separator: String = "") -> NSAttributedString {
        guard !isEmpty else { return NSAttributedString() }
        let result = self[0].mutableCopy() as! NSMutableAttributedString
        for element in suffix(from: 1) {
            result.append(NSAttributedString(string: separator))
            result.append(element)
        }
        return result
    }
}


extension UIFont {
    var bold: UIFont {
        let boldFontDescriptor = fontDescriptor.withSymbolicTraits(.traitBold)
        return UIFont(descriptor: boldFontDescriptor!, size: 0)
    }
}


extension NSAttributedString {
    func addingAttribute(attribute: String, value: AnyObject) -> NSAttributedString {
        let result = mutableCopy() as! NSMutableAttributedString
        result.addAttribute(attribute, value: value, range: NSRange(location: 0, length: result.length))
        return result
    }
}


extension Inline {
    func render(font: UIFont) -> NSAttributedString {
        switch self {
        case .text(let text):
            return NSAttributedString(string: text, attributes: [NSFontAttributeName: font])
        case .strong(let children):
            let result = children.map { $0.render(font: font) }.join() as! NSMutableAttributedString
            return result.addingAttribute(attribute: NSFontAttributeName, value: font.bold)
        default:
            fatalError()
        }
    }
}

extension Block {
    func render(font: UIFont) -> NSAttributedString {
        switch self {
        case .paragraph(let children):
            return children.map { $0.render(font: font) }.join()
        case .heading(let children, _):
            let headerFont = baseFont.withSize(48)
            return children.map { $0.render(font: headerFont) }.join()
        default:
            fatalError()
        }
    }
}


let baseFont = UIFont(name: "Helvetica", size: 24)!
let tree = Node(markdown: markdown)!.elements
let output = tree.map { $0.render(font: baseFont) }.join(separator: "\n")

output



