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
        // Override point for customization after application launch.
        
//        print("Папка бандла", Bundle.main.bundleURL)
//
//        // Песочница кладет данные туда
//        print("Адрес файлового менеджера для 0-его элемента, тут путь в url-формате", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
//       // Или сюда
//        print("Непосредственно путь до нужной папки, как в системе", NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
//
//        let atURL = Bundle.main.url(forResource: "Image", withExtension: "jpg")!
//        let toURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appending(path: "photo.jpg")
//
//        print("Куда будет перекладывать фото", toURL)
//
//        do {
//            try FileManager.default.copyItem(at: atURL, to: toURL)
//            //try FileManager.default.removeItem(at: toURL)
//        } catch {
//            print(error)
//        }
//
//        // получить содержимое папки
//        let content = try? FileManager.default.contentsOfDirectory(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path)
//        print(content)
        
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

