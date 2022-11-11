//
//  AppDelegate.swift
//  SandboxFileManager
//
//  Created by Nikita Byzov on 07.11.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // создаем ключ для отслеживания ввода пароля
        // по умолчанию задаем ему значение false тк на старте еще ничего не трогали
        
        if UserDefaults.standard.bool(forKey: "passwordSet") {
            print("Ключ passwordSet уже был, не трогаем ключ")
        } else {
            UserDefaults.standard.set(false, forKey: "passwordSet")
        }
        
        // По умолчанию сортирвока включена, создаем сразу ключ и присваиваем ему значение
        if UserDefaults.standard.bool(forKey: "sortValues") {
            print("Ключ sortValues уже был, не трогаем ключ")
        } else {
            UserDefaults.standard.set(true, forKey: "sortValues")
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

