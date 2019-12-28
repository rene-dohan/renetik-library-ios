//
// Created by Rene Dohan on 12/22/19.
//

import Foundation
import UIKit
import RenetikObjc

public protocol CSImagePickerListener {
    func imagePicker(controller: CSImagePickerController, didFinishPickingMedia data: [UIImagePickerController.InfoKey: Any])
}

public class CSImagePickerController: NSObject, UIPopoverControllerDelegate,
        UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    private let parent: (UIViewController & CSViewControllerProtocol & CSImagePickerListener)!
    private lazy var dialog: CSAlertController = { parent.dialog() }()
    private var popover: UIPopoverController?

    public init(parent: (UIViewController & CSImagePickerListener & CSViewControllerProtocol)!) {
        self.parent = parent
    }

    public func showFrom(view: UIView? = nil, item: UIBarButtonItem? = nil) {
        if dialog.isVisible {
            dialog.hide()
        }
        else {
            dialog.add(title: "Choose Photo") { self.onGalleryClick(from: view, from: item) }
            dialog.add(title: "Take Picture") { self.onCaptureClick() }
            dialog.showSheetFrom(view: view, item: item)
        }
    }

    private func onGalleryClick(from view: UIView? = nil, from item: UIBarButtonItem? = nil) {
        popover = nil
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            parent.present(picker.popoverFrom(view: view, item: item))
        }
        else {
            parent.show(message: "Gallery not available")
        }
    }

    private func onCaptureClick() {
        popover = nil
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .camera
            parent.present(picker)
        }
        else {
            parent.show(message: "Camera not available")
        }
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo data: [UIImagePickerController.InfoKey: Any]) {
        dismiss()
        parent.imagePicker(controller: self, didFinishPickingMedia: data)
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { dismiss() }

    private func dismiss() { popover?.dismiss(animated: true) ?? parent.dismiss() }
}