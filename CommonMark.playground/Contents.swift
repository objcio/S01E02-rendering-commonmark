//: Make sure to open this playground as part of the workspace and to build the project.

import CommonMark

let markdown = "# Heading **strong**\nHello **Markdown**!"


extension Array where Element: NSAttributedString {
    func join(separator separator: String = "") -> NSAttributedString {
        guard !isEmpty else { return NSAttributedString() }
        let result = self[0].mutableCopy() as! NSMutableAttributedString
        for element in suffixFrom(1) {
            result.appendAttributedString(NSAttributedString(string: separator))
            result.appendAttributedString(element)
        }
        return result
    }
}


extension UIFont {
    var bold: UIFont {
        let boldFontDescriptor = fontDescriptor().fontDescriptorWithSymbolicTraits(.TraitBold)
        return UIFont(descriptor: boldFontDescriptor, size: 0)
    }
}


extension NSAttributedString {
    func addingAttribute(attribute: String, value: AnyObject) -> NSAttributedString {
        let result = mutableCopy() as! NSMutableAttributedString
        result.addAttribute(attribute, value: value, range: NSRange(location: 0, length: result.length))
        return result
    }
}


extension InlineElement {
    func render(font: UIFont) -> NSAttributedString {
        switch self {
        case .Text(let text):
            return NSAttributedString(string: text, attributes: [NSFontAttributeName: font])
        case .Strong(let children):
            let result = children.map { $0.render(font) }.join() as! NSMutableAttributedString
            return result.addingAttribute(NSFontAttributeName, value: font.bold)
        default:
            fatalError()
        }
    }
}

extension Block {
    func render(font: UIFont) -> NSAttributedString {
        switch self {
        case .Paragraph(let children):
            return children.map { $0.render(font) }.join()
        case .Heading(let children, _):
            let headerFont = baseFont.fontWithSize(48)
            return children.map { $0.render(headerFont) }.join()
        default:
            fatalError()
        }
    }
}


let baseFont = UIFont(name: "Helvetica", size: 24)!
let tree = Node(markdown: markdown)!.elements
let output = tree.map { $0.render(baseFont) }.join(separator: "\n")

output



