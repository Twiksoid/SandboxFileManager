//
//  FolderController.swift
//  SandboxFileManager
//
//  Created by Nikita Byzov on 07.11.2022.
//

import UIKit

class FolderController: UITableViewController {
    
    var folderVCDelegate: SettingsViewController?
    
    var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    static func openFolderVC(in viewController: UIViewController, with path: String) {
        if let fc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FolderVC") as? FolderController {
            fc.path = path
            viewController.navigationController?.pushViewController(fc, animated: true)
        }
    }
    
    @IBAction func addNewFolder(_ sender: Any) {
        TextPicker.defaultPicker.getText(in: self) { text in
            let pathForNewFolder = self.path + "/" + text
            try? FileManager.default.createDirectory(atPath: pathForNewFolder, withIntermediateDirectories: false)
            self.tableView.reloadData()
        }
    }
    
    private func isSortData() -> [String] {
        
        if UserDefaults.standard.bool(forKey: "sortValues") {
            
            let sortedContent = content.sorted(by: {$0 < $1})
            return sortedContent
        } else {
            let nonSortedContent = content
            return nonSortedContent}
    }
    
    
    @IBAction func addNewItem(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    
    @IBOutlet weak var addNewImage: UIBarButtonItem!
    
    func getDefaultDirectoryURL() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return path
    }
    
    var content: [String] {
        do {
            return try FileManager.default.contentsOfDirectory(atPath: path)
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
    }
    
    @objc func refresh(sender:AnyObject)
    {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSString(string: path).lastPathComponent
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let isSortData = isSortData()
        
        cell.textLabel?.text = isSortData[indexPath.row]
        
        let fullPath = path + "/" + isSortData[indexPath.row]
        
        var isDirect: ObjCBool = false
        FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDirect)
        
        if isDirect.boolValue == true {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let isSortData = isSortData()
            let pathForDel = path + "/" + isSortData[indexPath.row]
            try? FileManager.default.removeItem(at: URL(fileURLWithPath: pathForDel))
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let isSortData = isSortData()
        let fullPath = path + "/" + isSortData[indexPath.row]
        var isDirect: ObjCBool = false
        FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDirect)
        if isDirect.boolValue == true {
            FolderController.openFolderVC(in: self, with: fullPath)
            tableView.reloadData()
        }
    }
}


extension FolderController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            
            let imageName = UUID().uuidString
            let imagePath = URL(fileURLWithPath: path).appendingPathComponent(imageName + ".jpg")
            print("path URL", URL(fileURLWithPath: path))
            print("imagePath URL ", imagePath)
            
            if let jpegData = image.jpegData(compressionQuality: 1.0) {
                do {
                    try jpegData.write(to: imagePath)
                } catch {
                    let alert = UIAlertController(title: "Ошибка создания файла", message: error.localizedDescription, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Понятно", style: .default)
                    alert.addAction(alertAction)
                    present(alert, animated: true)
                }
            }
            
            tableView.reloadData()
            picker.dismiss(animated: true, completion: nil)
        } else {
            print("Не могу преобразовать выбранное в библиотеке изображение")
        }
    }
}
