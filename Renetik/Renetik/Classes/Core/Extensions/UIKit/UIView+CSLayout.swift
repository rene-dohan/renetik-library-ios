//
// Created by Rene Dohan on 12/23/19.
//

import Foundation
import UIKit
import RenetikObjc

public extension UIView {

    @discardableResult
    func from(left: CGFloat) -> Self { invoke { self.left = left; fixedLeft() } }

    @discardableResult
    func from(_ view: UIView?, left: CGFloat) -> Self { from(left: view?.get { $0.right + left } ?? left) }

    @discardableResult
    func fromPrevious(left: CGFloat) -> Self {
        assert(superview.notNil, "Needs to have superview")
        superview!.subviews.previous(of: self).notNil { previous in from(previous, left: left) }.elseDo { from(left: 0) }
        return self
    }

    @discardableResult
    func from(top: CGFloat) -> Self { invoke { self.top = top; fixedTop() } }

    @discardableResult
    func from(_ view: UIView?, top: CGFloat) -> Self { from(top: view?.get { $0.bottom + top } ?? top) }

    @discardableResult
    func fromPrevious(top: CGFloat) -> Self {
        assert(superview.notNil, "Needs to have superview")
        superview!.subviews.previous(of: self).notNil { previous in
            from(previous, top: top)
        }.elseDo { from(top: 0) }
        return self
    }

    @discardableResult
    func from(right: CGFloat) -> Self { invoke { self.fromRight = right; fixedRight() } }

    @discardableResult
    func from(_ view: UIView?, right: CGFloat)
                    -> Self { from(right: view?.get { $0.leftFromRight + right } ?? right) }

    @discardableResult
    func from(bottom: CGFloat) -> Self { invoke { self.fromBottom = bottom; fixedBottom() } }

    @discardableResult
    func from(_ view: UIView?, bottom: CGFloat)
                    -> Self { from(bottom: view?.get { $0.topFromBottom + bottom } ?? bottom) }

    @discardableResult
    func from(bottomRight: CGFloat) -> Self { from(bottom: bottomRight, right: bottomRight) }

    @discardableResult
    func from(left: CGFloat, top: CGFloat) -> Self { from(left: left).from(top: top) }

    @discardableResult
    func from(topLeft: CGFloat) -> Self { from(top: topLeft).from(left: topLeft) }

    @discardableResult
    func from(topRight: CGFloat) -> Self { from(top: topRight).from(right: topRight) }

    @discardableResult
    func from(left: CGFloat, bottom: CGFloat) -> Self { from(left: left).from(bottom: bottom) }

    @discardableResult
    func from(bottom: CGFloat, left: CGFloat) -> Self { from(bottom: bottom).from(left: left) }

    @discardableResult
    func from(right: CGFloat, top: CGFloat) -> Self { from(right: right).from(top: top) }

    @discardableResult
    func from(top: CGFloat, right: CGFloat) -> Self { from(top: top).from(right: right) }

    @discardableResult
    func from(right: CGFloat, bottom: CGFloat) -> Self { from(right: right).from(bottom: bottom) }

    @discardableResult
    func from(bottom: CGFloat, right: CGFloat) -> Self { from(bottom: bottom).from(right: right) }

    @discardableResult
    func from(left: CGFloat, top: CGFloat, width: CGFloat, height: CGFloat) -> Self {
        from(left: left, top: top).width(width, height: height)
    }

    @discardableResult
    func matchParent(margin: CGFloat = 0) -> Self {
        matchParent(margin: (horizontal: margin, vertical: margin))
    }

    @discardableResult
    func matchParent(margin: (horizontal: CGFloat, vertical: CGFloat)) -> Self {
        matchParentWidth(margin: margin.horizontal).matchParentHeight(margin: margin.vertical)
    }

    @discardableResult
    func matchParentWidth(margin: CGFloat = 0) -> Self {
        from(left: margin).width(fromRight: margin, flexible: true)
    }

    @discardableResult
    func matchParentWidth(margin: (left: CGFloat, right: CGFloat)) -> Self {
        from(left: margin.left).width(fromRight: margin.right, flexible: true)
    }

    @discardableResult
    func matchParentHeight(margin: CGFloat = 0) -> Self {
        from(top: margin).height(fromBottom: margin, flexible: true)
    }

    @discardableResult
    func matchParentHeight(margin: (top: CGFloat, bottom: CGFloat)) -> Self {
        from(top: margin.top).height(fromBottom: margin.bottom, flexible: true)
    }

    @discardableResult
    func margin(horizontal margin: (left: CGFloat, right: CGFloat)) -> Self {
        from(left: margin.left).margin(right: margin.right)
    }

    func margin(vertical margin: (top: CGFloat, bottom: CGFloat)) -> Self {
        from(top: margin.top).margin(bottom: margin.bottom)
    }

    @discardableResult
    func margin(left: CGFloat) -> Self { width(fromLeft: left) }

    @discardableResult
    func margin(top: CGFloat) -> Self { height(fromTop: top) }

    @discardableResult
    func margin(right: CGFloat) -> Self { width(fromRight: right) }

    @discardableResult
    func margin(bottom: CGFloat) -> Self { height(fromBottom: bottom) }

    @discardableResult
    func width(fromRight: CGFloat, flexible: Bool = false) -> Self {
        assert(superview.notNil, "Needs to have superview")
        let right = superview!.width - fromRight
        widthBy(right: right.unsigned)
        if flexible { fixedLeft().flexibleWidth() }
        return self
    }

    @discardableResult
    func width(from view: UIView, right: CGFloat, flexible: Bool = false) -> Self {
        width(fromRight: view.leftFromRight + right, flexible: flexible)
    }

    @discardableResult
    func width(fromLeft: CGFloat, flexible: Bool = false) -> Self {
        width = (right - fromLeft).unsigned
        if flexible { fixedRight().flexibleWidth() }
        from(left: fromLeft)
        return self
    }

    @discardableResult
    func width(from view: UIView, left: CGFloat, flexible: Bool = false) -> Self {
        width(fromLeft: view.right + left, flexible: flexible)
    }

    @discardableResult
    func height(fromBottom: CGFloat, flexible: Bool = false) -> Self {
        assert(superview.notNil, "Needs to have superview")
        let bottom = superview!.height - fromBottom
        heightBy(bottom: bottom.unsigned)
        if flexible { fixedTop().flexibleHeight() }
        return self
    }

    @discardableResult
    func height(from view: UIView, bottom: CGFloat, flexible: Bool = false) -> Self {
        height(fromBottom: view.topFromBottom + bottom)
    }

    @discardableResult
    func height(fromTop: CGFloat, flexible: Bool = false) -> Self {
        assert(superview.notNil, "Needs to have superview")
        let bottomCorrected = bottom - fromTop > 0 ? bottom : superview!.height
        height = (bottomCorrected - fromTop).unsigned
        from(top: fromTop)
        if flexible { fixedBottom().flexibleHeight() }
        return self
    }

    @discardableResult
    func height(from view: UIView, top: CGFloat, flexible: Bool = false) -> Self {
        height(fromTop: view.bottom + top, flexible: flexible)
    }

    @discardableResult
    func widthBy(right: CGFloat) -> Self {
        width = (right - left).unsigned
        fixedRight()
        return self
    }

    @discardableResult
    func heightBy(bottom: CGFloat) -> Self {
        height = (bottom - top).unsigned
        fixedBottom()
        return self
    }

    @discardableResult
    func fixedBottom(height: CGFloat) -> Self {
        let bottom = fromBottom
        self.height = height
        fromBottom = bottom
        fixedBottom()
        return self
    }

    @discardableResult
    func fixedRight(width: CGFloat) -> Self {
        let right = fromRight
        self.width = width
        fromRight = right
        fixedRight()
        return self
    }

    @discardableResult
    func alignHorizontalLayout() -> Self {
        assert(superview.notNil, "Needs to have superview")
        let previous = superview!.findPreviousVisible(of: self)
        previous.notNil { previous in
            assert(previous.width == width && previous.height == height, "Needs to have same size as previous")
            if previous.right + width <= superview!.width {
                from(left: previous.right, top: previous.top)
            } else {
                from(left: 0, top: previous.bottom)
            }
        }.elseDo { from(left: 0, top: 0) }
        return self
    }

    @discardableResult
    func alignHorizontal() -> Self {
        assert(superview.notNil, "Needs to have superview")
        superview!.findPreviousVisible(of: self).notNil {
            from(left: $0.right, top: $0.top)
        }.elseDo { from(left: 0, top: 0) }
        return self
    }
}