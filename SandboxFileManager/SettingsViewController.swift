//
//  SettingsViewController.swift
//  SandboxFileManager
//
//  Created by Nikita Byzov on 11.11.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // нужен делегат, чтобы обновить таблицу после смены настроек
    var folderVCDelegate: FolderController?
    
    
    @IBOutlet weak var switcherValue: UISwitch!
    
    
    @IBAction func setNewPasswordButton(_ sender: Any) {
        
        let keychainSwift = KeychainSwift()
        
        if keychainSwift.get("password") != nil {
            
            // если у нас есть такой ключ, то
            // выводим аларм, чтобы предложить указать новый пароль
            
            let alarm = UIAlertController(title: "Смена пароля", message: "Необходимо ввести новый пароль", preferredStyle: .alert)
            
            let actionSave = UIAlertAction(title: "Сохранить", style: .default){
                [weak alarm] _ in
                if let textField = alarm?.textFields {
                    if let newPassword = textField[0].text {
                        // тут еще проверить не пустое поле и 4+ символа
                        if textField[0].text != "", textField[0].text!.count >= 4 {
                            keychainSwift.set(newPassword, forKey: "password")
                            // уведомляю, что обновил
                            let alarm = UIAlertController(title: "Обновление успешно", message: "Установлен новый пароль", preferredStyle: .alert)
                            let actionOk = UIAlertAction(title: "Ok", style: .default)
                            alarm.addAction(actionOk)
                            self.present(alarm, animated: true)
                        } else {
                            // чет пошло не так, не сохраняем, другой алерт
                            let alarmForNotSaved = UIAlertController(title: "Новый пароль не сохранен", message: "Для сохранения данных длина пароля должна быть от 4х символов", preferredStyle: .alert)
                            let actionOk = UIAlertAction(title: "Ok", style: .default)
                            alarmForNotSaved.addAction(actionOk)
                            self.present(alarmForNotSaved, animated: true)
                        }
                    }
                }
            }
            let actionCansel = UIAlertAction(title: "Отменить", style: .cancel)
            
            alarm.addTextField { textField in
                textField.placeholder = "Пароль от 4х символов"
                textField.isSecureTextEntry = true
            }
            
            alarm.addAction(actionSave)
            alarm.addAction(actionCansel)
            present(alarm, animated: true)
        } else {
            let alert = UIAlertController(title: "Не задан пароль", message: "В связке ключей отсутствует начальный пароль. Необходимо обратиться к разработчику", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(actionOk)
            present(alert, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Первоначальное открытие окна, чтобы подтянули настройку
        if UserDefaults.standard.bool(forKey: "sortValues") {
            switcherValue.setOn(true, animated: false)
        } else {
            switcherValue.setOn(false, animated: false)
        }
        
        // чтобы по нажатию на свитчер обновилось значение
        switcherValue.addTarget(self, action: #selector(changeValue), for: .valueChanged)
    }
    
    @objc private func changeValue(){
        print("Current state is ", switcherValue.isOn)
        if switcherValue.isOn {
            switcherValue.setOn(true, animated: true)
            UserDefaults.standard.set(true, forKey: "sortValues")
        } else if switcherValue.isOn == false {
            switcherValue.setOn(false, animated: true)
            UserDefaults.standard.set(false, forKey: "sortValues")
        }
        
        folderVCDelegate?.tableView.reloadData()
    }
    
}
