//
// Created by Rene on 11/25/18.
//

#import "UIView+CSLayout.h"
#import "UIView+CSLayoutGetters.h"
#import "UIView+CSPosition.h"
#import "UIView+CSDimension.h"
#import "UIView+CSAutoResizing.h"
#import "CSLang.h"

@implementation UIView (CSLayout)

- (instancetype)left:(CGFloat)value {
    self.left = value;
    [self fixedLeft];
    return self;
}

- (instancetype)top:(CGFloat)value {
    self.top = value;
    [self fixedTop];
    return self;
}

- (instancetype)right:(CGFloat)value {
    self.right = value;
    [self fixedRight];
    return self;
}

- (instancetype)bottom:(CGFloat)value {
    self.bottom = value;
    [self fixedBottom];
    return self;
}

- (instancetype)left:(CGFloat)left top:(CGFloat)top {
    [self left:left];
    [self top:top];
    return self;
}

- (instancetype)position:(CGPoint)position {
    return [self left:position.x top:position.y];
}

- (instancetype)left:(CGFloat)left top:(CGFloat)top width:(CGFloat)width height:(CGFloat)height {
    [self left:left top:top];
    [self width:width height:height];
    return self;
}

- (instancetype)leftToWidth:(CGFloat)left {
    self.width = self.right - left;
    [self left:left];
    return self;
}

- (instancetype)rightToWidth:(CGFloat)right {
    self.width = right - self.left;
    [self fixedRight];
    return self;
}

- (instancetype)topToHeight:(CGFloat)top {
    self.height = self.bottom - top;
    [self top:top];
    return self;
}

- (instancetype)bottomToHeight:(CGFloat)bottom {
    self.height = bottom - self.top;
    [self fixedBottom];
    return self;
}

- (instancetype)fromRight:(CGFloat)value {
    self.fromRight = value;
    [self fixedRight];
    return self;
}

- (instancetype)fromBottom:(CGFloat)bottom {
    self.fromBottom = bottom;
    [self fixedBottom];
    return self;
}

- (instancetype)fromRightToWidth:(CGFloat)lengthFromRight {
    val right = self.superview.width - lengthFromRight;
    return [self rightToWidth:right];
}

- (instancetype)fromBottomToHeight:(CGFloat)lengthFromBottom {
    val bottom = self.superview.height - lengthFromBottom;
    return [self bottomToHeight:bottom];
}

- (instancetype)widthFromRight:(CGFloat)width {
    CGFloat right = self.fromRight;
    self.width = width;
    self.fromRight = right;
    [self fixedRight];
    return self;
}

- (instancetype)heightFromBottom:(CGFloat)value {
    CGFloat bottom = self.fromBottom;
    self.height = value;
    self.fromBottom = bottom;
    [self fixedBottom];
    return self;
}

- (instancetype)matchParent {
    [self matchParentWidth];
    [self matchParentHeight];
    return self;
}

- (instancetype)matchParentWithMargin:(CGFloat)margin {
    return [[self matchParentWidthWithMargin:margin] matchParentHeightWithMargin:margin];
}

- (instancetype)matchParentWidth {
    return [self width:self.superview.width].centerInParentHorizontal.flexibleWidth.fixedLeft.fixedRight;
}

- (instancetype)matchParentWidthWithMargin:(CGFloat)margin {
    return [[self.matchParentWidth left:margin] fromRightToWidth:margin];
}

- (instancetype)matchParentHeightWithMargin:(CGFloat)margin {
    return [[self.matchParentHeight top:margin] fromBottomToHeight:margin];
}

- (instancetype)matchParentHeight {
    return [self height:self.superview.height].centerInParentVertical.flexibleHeight.fixedTop.fixedBottom;
}


@end