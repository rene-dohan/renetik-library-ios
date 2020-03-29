//
//  CSDTAttributeLabel.swift
//  Motorkari
//
//  Created by Rene Dohan on 2/7/19.
//  Copyright © 2019 Renetik Software. All rights reserved.
//

import Foundation
import UIKit
import DTCoreText
import DTCoreText.DTAttributedTextView
import DTCoreText.DTCoreTextLayoutFrame
import IDMPhotoBrowser
import RenetikObjc
import TUSafariActivity
import ARChromeActivity

//TODO: Move to extra library
public class CSHtmlTextView: DTAttributedTextView, DTAttributedTextContentViewDelegate {
    public var font = UIFont.preferredFont(forTextStyle: .body)
    public var textColor: UIColor = .darkText
    public var encoding: String.Encoding = .utf8
    public var linkColor: UIColor = .blue
    public var linkHighlightedColor: UIColor = .purple
    public var linksActive = true {
        didSet {
            shouldDrawLinks = !linksActive
        }
    }
    private var imageUrls = [URL]()
    private var numberOfImages = 0
    private var lineBreakMode: NSLineBreakMode = .byWordWrapping

    public override func construct() -> Self {
        super.construct()
        shouldDrawLinks = !linksActive // We are drawing links to make them clickable and styled right
        textDelegate = self
        scrollable(false)
        attributedTextContentView.matchParentWidth()
        return self
    }

    @discardableResult
    public func textColor(_ color: UIColor) -> Self { invoke { self.textColor = color } }

    @discardableResult
    public func link(color: UIColor) -> Self { invoke { self.linkColor = color } }

    @discardableResult
    public func linkHighlighted(color: UIColor) -> Self { invoke { self.linkHighlightedColor = color } }

    @discardableResult
    public func encoding(_ encoding: String.Encoding) -> Self { invoke { self.encoding = encoding } }

    @discardableResult
    public func html(_ html: String) -> Self { invoke { self.html = html } }

    @discardableResult
    public func fontStyle(_ fontStyle: UIFont.TextStyle) -> Self {
        font = UIFont.preferredFont(forTextStyle: fontStyle)
        return self
    }

    @discardableResult
    public func withBoldFont(if condition: Bool = true) -> Self {
        font = condition ? font.bold() : font.normal()
        return self
    }

    @discardableResult
    public func lineBreak(mode: NSLineBreakMode) -> Self { lineBreakMode = mode; return self }

    @discardableResult
    public func heightToFit(lines: Int) -> Self {
        height(UILabel.construct().width(width).font(font).heightToFit(lines: lines).height)
        lineBreakMode = .byTruncatingTail
        return self
    }

    public var html = "" {
        didSet {
            imageUrls.clear()
            numberOfImages = html.countHtmlImageTagsWithoutSize()
            attributedString = NSAttributedString(htmlData: html.data(using: encoding),
                    options: attributedOptions, documentAttributes: nil)
        }
    }

    private var attributedOptions: [AnyHashable: Any] {
        [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.paragraphStyle: NSMutableParagraphStyle().also {
                $0.lineBreakMode = lineBreakMode
            },
            DTUseiOS6Attributes: true,
            DTDefaultFontName: font.fontName,
            DTDefaultFontFamily: font.familyName,
            DTDefaultFontSize: font.pointSize,
            DTDefaultTextColor: textColor,
            DTDefaultLinkColor: linkColor,
            DTDefaultLinkHighlightColor: linkHighlightedColor,
            DTDefaultLinkDecoration: false
        ]
    }

    public func attributedTextContentView(_ attributedTextContentView: DTAttributedTextContentView!, viewFor string: NSAttributedString!, frame: CGRect) -> UIView! {
        if !linksActive { return nil }

        let attributes = string.attributes(at: 0, effectiveRange: nil)
        let url = attributes[NSAttributedString.Key("NSLink")].asString
        let identifier = attributes[NSAttributedString.Key("DTGUID")].asString
        let button = DTLinkButton(frame: frame)
        button.url = URL(url)
        button.minimumHitSize = CGSize(width: 25, height: 25) // adjusts it's bounds so that button is always large enough
        button.guid = identifier

        let DTCoreTextLayoutFrameDrawingDefault = DTCoreTextLayoutFrameDrawingOptions(rawValue: 1 << 0)!
        let normalImage = attributedTextContentView.contentImage(withBounds: frame,
                options: DTCoreTextLayoutFrameDrawingDefault)
        button.setImage(normalImage, for: .normal)

        let DTCoreTextLayoutFrameDrawingDrawLinksHighlighted = DTCoreTextLayoutFrameDrawingOptions(rawValue: 1 << 3)!
        let highlightImage = attributedTextContentView.contentImage(withBounds: frame,
                options: DTCoreTextLayoutFrameDrawingDrawLinksHighlighted)
        button.setImage(highlightImage, for: .highlighted)
        handleExternalUrl(view: button, url: url)
        return button
    }

    private func handleExternalUrl(view: UIView, url: String) {
        view.onClick { UIApplication.open(url: url) }
        view.onLongPress {
            let controller = UIActivityViewController(activityItems: [url],
                    applicationActivities: [TUSafariActivity(), ARChromeActivity()])
            controller.popoverPresentationController?.sourceView = view
            navigation.last!.present(controller, animated: true, completion: nil)
        }
    }

    public func attributedTextContentView(_ contentView: DTAttributedTextContentView!,
                                          viewFor attachment: DTTextAttachment!, frame: CGRect) -> UIView! {
        if attachment is DTImageTextAttachment {
            if attachment.displaySize.width == 0 {
                attachment.displaySize = CGSize(width: width, height: width / 2)
                self.relayoutText()
            }
            let imageView = UIImageView.construct().position(frame.origin).size(attachment.displaySize)
            if attachment.hyperLinkURL.notNil &&
                       attachment.hyperLinkURL != attachment.contentURL {
                imageView.image(url: attachment.contentURL)
                handleExternalUrl(view: imageView, url: attachment.hyperLinkURL.path)
            } else if attachment.displaySize.width > 50 {
                imageUrls.add(attachment.contentURL)
                imageView.image(url: attachment.contentURL).onClick {
                    let photoBrowser = IDMPhotoBrowser(photoURLs: self.imageUrls)!
                    photoBrowser.navigationItem.title = navigation.last?.navigationItem.title
                    photoBrowser.disableVerticalSwipe = true
                    navigation.push(fromTop: photoBrowser)
                }
            } else {
                imageView.image(url: attachment.contentURL)
            }
            return imageView
        }
        return nil
    }

    public override func calculateHeightToFit() -> CGFloat {
        (html.isSet ? attributedTextContentView.calculateHeightToFit() : 0)
                + (CGFloat(numberOfImages) * width / 2)
    }
}

private extension String {
    public func countHtmlImageTagsWithoutSize() -> Int {
        var endTagsToAddSize: Array<Int> = []
        let string = NSMutableString(string: self)
        var startTagIndex = -1
        repeat {
            startTagIndex = string.index(of: "<img ", from: startTagIndex + 1)
            if startTagIndex != NSString.notFound {
                let endTagIndex = string.index(of: "/>", from: startTagIndex + 1)
                let tagSubString = string.substring(from: startTagIndex, to: endTagIndex)
                if !tagSubString.contains("width=") {
                    endTagsToAddSize.append(endTagIndex)
                }
            }
        } while startTagIndex != NSString.notFound
        return endTagsToAddSize.count
    }
}
