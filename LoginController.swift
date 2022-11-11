//
//  LoginController.swift
//  SandboxFileManager
//
//  Created by Nikita Byzov on 11.11.2022.
//

import UIKit

class LoginController: UIViewController {
    
    private var triesOfEnterPassword: Int = 0
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue", let folderVC = segue.destination as? FolderController {
            navigationController?.pushViewController(folderVC, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setTitle()
        
        // тут пароль будем хранить
        // по умолчанию ничего не кладем, только создаем
        let keyChainSwift = KeychainSwift()
        print("Пароль на этапе запуска приложения", keyChainSwift.get("password"))
    }
    
    private func setTitle(){
        if UserDefaults.standard.bool(forKey: "passwordSet") {
            makePasswordTitle.setTitle("Создайте пароль", for: .normal)
        } else {
            makePasswordTitle.setTitle("Введите пароль", for: .normal)
        }
    }
    
    private func alarmForIncorrectPassword(){
        let alarm = UIAlertController(title: "Пароль не совпадает", message: "Попробуйте снова ввести пароль", preferredStyle: .alert)
        let alarmAction = UIAlertAction(title: "Ок", style: .default)
        alarm.addAction(alarmAction)
        present(alarm, animated: true)
    }
    
    @IBOutlet weak var makePasswordTitle: UIButton!
    
    @IBAction func makePasswordButton(_ sender: Any) {
        view.endEditing(true)
        
        if enterPasswordField.text != "" {
            if enterPasswordField.text!.count < 4 {
                let alarm = UIAlertController(title: "Неверное количество символов", message: "Для продолжения длина пароля должна быть больше 4 символов", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .default)
                alarm.addAction(alertAction)
                present(alarm, animated: true)
            } else {
                // У нас больше 4 символов, поэтому можно пойти искать пароль
                // создаем объект
                
                // увеличили счетчик тк зашли в попытку пароля
                triesOfEnterPassword += 1
                
                let keyChainSwift = KeychainSwift()
                
                // проверяем существовавание ключа
                // если его нет, то создаем сразу с тем значением, которое ввел пользоавтель
                // и дальше уходим на следующий контроллер
                
                if keyChainSwift.get("password") == nil {
                    keyChainSwift.set(enterPasswordField.text!, forKey: "password")
                    
                    // если пароля не было, то сразу идем на экран дальше
                    
                    //                    if let folderVC = self.storyboard?.instantiateViewController(withIdentifier: "FolderVC") {
                    //                        self.navigationController!.pushViewController(folderVC, animated: true)}
                    //performSegue(withIdentifier: "loginSegue", sender: self)
                    //navigationController?.pushViewController(FolderController(), animated: true)
                } else {
                    let password = keyChainSwift.get("password")!
                    print("Пароль на этапе проверки", password)
                    // тут у нас уже есть ключ, поэтому нужно проверить его с тем, что ввели
                    
                    if enterPasswordField.text! == password {
                        // пароль совпал, кнопки не меняем, сразу идем
                        // счетчик обнулить должны тк успешный вход
                        triesOfEnterPassword = 0
                        let goToFolderVC = FolderController()
                        goToFolderVC.modalPresentationStyle = .currentContext
                        navigationController?.pushViewController(goToFolderVC, animated: true)
                        
                    } else {
                        // пароль не совпал, начинаем перебор
                        switch triesOfEnterPassword {
                        case 1:
                            makePasswordTitle.setTitle("Повторите пароль", for: .normal)
                            alarmForIncorrectPassword()
                        case 2:
                            alarmForIncorrectPassword()
                            triesOfEnterPassword = 0
                        default:
                            print("Alarm there is more than 2 tries")
                        }
                    }
                }
            }
            
        } else {
            // тут когда поле вообще пустое
            let alarm = UIAlertController(title: "Пустое поле", message: "Для продолжения необходимо ввести пароль от 4 символов", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default)
            alarm.addAction(alertAction)
            present(alarm, animated: true)
        }
    }
    @IBOutlet weak var enterPasswordField: UITextField!
}
