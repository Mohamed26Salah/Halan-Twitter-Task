//
//  Halan_Twitter_TaskApp.swift
//  Halan-Twitter-Task
//
//  Created by Mohamed Salah on 18/12/2025.
//

import SwiftUI
import Factory
import HalanTwitterFeature
@main
struct Halan_Twitter_TaskApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            HalanTwitterView()
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        Container.registerAppLayerDependencies()
        return true
    }
}
