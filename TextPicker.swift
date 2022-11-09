//
//  TextPicker.swift
//  SandboxFileManager
//
//  Created by Nikita Byzov on 08.11.2022.
//

import UIKit


class TextPicker {
    
    static let defaultPicker = TextPicker()
    
    func getText(in viewController: UIViewController, completion: ((_ text: String)->Void)? )  {
        
        let alertController = UIAlertController(title: "Enter text", message: nil, preferredStyle: .alert)
        
        alertController.addTextField {
            textFiel in textFiel.placeholder = "Enter text"
        }
        
        let actionOK = UIAlertAction(title: "Ok", style: .default) { alert in
            if let text = alertController.textFields?[0].text, text != "" {
            completion?(text)
        }
            
        }
        let actionCansel = UIAlertAction(title: "Cansel", style: .cancel)
        
        alertController.addAction(actionOK)
        alertController.addAction(actionCansel)
        
        viewController.present(alertController, animated: true)
        
    }
}
