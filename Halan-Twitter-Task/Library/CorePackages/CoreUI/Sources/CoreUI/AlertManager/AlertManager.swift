//
//  File.swift
//  CoreUI
//
//  Created by Mohamed Salah on 19/12/2025.
//

import Foundation
import Combine
import SwiftUI
import UIKit

public class AlertManager {
    public static func show(
        title: String = "error",
        message: String,
        primaryButtonTitle: String = "ok",
        primaryButtonColor: UIColor = .systemBlue,
        primaryButtonAction: @escaping () -> Void = {},
        secondaryButtonTitle: String? = nil,
        secondaryButtonColor: UIColor? = nil, 
        secondaryButtonAction: (() -> Void)? = nil
    ) {
        // Ensure the code runs on the main thread
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)

            // Add primary button
            let primaryAction = UIAlertAction(title: primaryButtonTitle, style: .default) { _ in
                primaryButtonAction()
            }
            alertVC.addAction(primaryAction)

            // Customize the color of the primary button
            primaryAction.setValue(primaryButtonColor, forKey: "titleTextColor")

            // Add secondary button if needed
            if let secondaryButtonTitle = secondaryButtonTitle {
                let secondaryAction = UIAlertAction(title: secondaryButtonTitle, style: .cancel) { _ in
                    secondaryButtonAction?()
                }
                alertVC.addAction(secondaryAction)

                // Customize the color of the secondary button if a color is provided
                if let secondaryButtonColor = secondaryButtonColor {
                    secondaryAction.setValue(secondaryButtonColor, forKey: "titleTextColor")
                }
            }

            // Get the topmost view controller to present the alert
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = scene.windows.first(where: { $0.isKeyWindow }),
               let rootViewController = window.rootViewController {
                var topController = rootViewController
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }

                // Check if an alert is already being presented
                if !(topController is UIAlertController) {
                    topController.present(alertVC, animated: true, completion: nil)
                }
            }
        }
    }
}
