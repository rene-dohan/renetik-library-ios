//
// Created by Rene Dohan on 9/9/19.
//

import Foundation

extension NSMutableParagraphStyle {
    public class func with(lineBreak: NSLineBreakMode = .byWordWrapping,
                           alignment: NSTextAlignment = .left) -> NSMutableParagraphStyle {
        var paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = lineBreak
        paragraph.alignment = alignment
        return paragraph
    }
}