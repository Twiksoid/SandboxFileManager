//
//  FolderController.swift
//  SandboxFileManager
//
//  Created by Nikita Byzov on 07.11.2022.
//

import UIKit

class FolderController: UITableViewController {
    
    var pathForImage = ""
    var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    static func openFolderVC(in viewController: UIViewController, with path: String) {
        if let fc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FolderVC") as? FolderController {
            fc.path = path
            fc.pathForImage = path
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
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSString(string: path).lastPathComponent
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return content.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = content[indexPath.row]
        
        let fullPath = path + "/" + content[indexPath.row]
        
        var isDirect: ObjCBool = false
        FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDirect)
        
        if isDirect.boolValue == true {
            cell.detailTextLabel?.text = "Folder"
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.detailTextLabel?.text = "File"
            cell.accessoryType = .none
        }
        return cell
    }
    
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let pathForDel = path + "/" + content[indexPath.row]
            try? FileManager.default.removeItem(at: URL(fileURLWithPath: pathForDel))
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let fullPath = path + "/" + content[indexPath.row]
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
            
            let currentFolder = FileManager.default.temporaryDirectory
            
            // NSString(string: path).lastPathComponent
            
            let imageName = UUID().uuidString
            let imagePath = currentFolder.appendingPathComponent(imageName + ".jpg")
            //getDefaultDirectoryURL().appendingPathComponent(imageName + ".jpg")
            
            print(try? FileManager.default.fileExists(atPath: imageName))
            
            
            print("Image Path",imagePath)
//            let fileData = Data()
//            try FileManager.default.createFile(atPath: imagePath.path, contents: fileData)
//            if let jpegData = image.jpegData(compressionQuality: 1.0) {
//                try? jpegData.write(to: imagePath)
//            }
            
            print("pathForImage ", pathForImage)
            
            // была мысль, что. Если у меня пустая строка, то я в корне и перекладываю туда, иначе - я в какой-то новой папке, поэтому перекладываю в другой путь
            // но файлы все равно только в темпе остаются
            if pathForImage == "" {
                try? FileManager.default.moveItem(at: imagePath, to: URL(string: path)!)
            } else {
                try? FileManager.default.moveItem(at: imagePath, to: URL(string: pathForImage)!)
            }

            tableView.reloadData()
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
