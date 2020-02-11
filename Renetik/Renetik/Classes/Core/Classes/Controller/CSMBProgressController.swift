//
// Created by Rene Dohan on 1/11/20.
//

import Foundation
import MBProgressHUD
import ChameleonFramework

public class CSMBProgressController: CSObject, CSHasProgress, CSHasDialogVisible {

    public var backgroundColor = UIColor.flatBlack()!.lighten(byPercentage: 0.03)!.add(alpha: 0.7)
    public var foregroundColor = UIColor.white
    private let view: UIView
    private var hud: MBProgressHUD?

    public init(in controller: UIViewController) {
        self.view = controller.view
    }

    public init(in view: UIView) {
        self.view = view
    }

    public var isVisible: Bool { hud.notNil }

    public func hide(animated: Bool = true) { hud?.hide(animated: animated) }

    public func show(progress title: String, cancel: CSDialogAction?) -> CSHasDialogVisible {
        MBProgressHUD.hide(for: view, animated: true)
        hud = MBProgressHUD.showAdded(to: view, animated: true).also { hud in
            hud.removeFromSuperViewOnHide = true
            hud.animationType = .zoom
            hud.contentColor = foregroundColor
            hud.bezelView.style = .solidColor
            hud.bezelView.backgroundColor = backgroundColor
            hud.dimBackground = true

            cancel.notNil { cancel in
                hud.detailsLabel.text = title.isSet ? "\n" + title + "\n" : "\n"
                hud.button.text(cancel.title ?? CSStrings.dialogCancel).onClick {
                    cancel.action()
                    hud.hide(animated: true)
                }
            }.elseDo {
                hud.detailsLabel.text = "\n" + title.asString
            }
            hud.activityIndicatorColor = foregroundColor
        }
        return self
    }
}