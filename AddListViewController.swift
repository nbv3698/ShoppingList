//
//  AddListTableViewController.swift
//  List
//
//  Created by Len on 2017/6/11.
//  Copyright © 2017年 Len. All rights reserved.
//

import UIKit
import AVFoundation

class AddListViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    
    var selectImage: UIImage!
    var myPlayer :AVAudioPlayer!
    var pickOption = ["想買", "很想買", "超級想買", "宇宙無敵想買"]

    @IBOutlet weak var urlTextField: UITextField!   //網址
    @IBOutlet weak var levelTextField: UITextField! //想買程度
    @IBOutlet weak var nameTextField: UITextField!  //商品名稱
    @IBOutlet weak var imageView: UIImageView!  //圖片
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        levelTextField.text = pickOption[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.text = nil
        nameTextField.placeholder = "請輸入商品名稱"
        levelTextField.text = nil
        levelTextField.placeholder = "想買程度"
        urlTextField.text = nil
        urlTextField.placeholder = "請輸入商品網址"
        
        //UIPickerView
        let picker = UIPickerView()
        picker.delegate = self
        levelTextField.inputView = picker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        levelTextField.inputAccessoryView = toolBar
        
        // 建立播放器
        let soundPath = Bundle.main.path(
            forResource: "coin_effect", ofType: "mp3")
        do {
            myPlayer = try AVAudioPlayer(
                contentsOf: NSURL.fileURL(withPath: soundPath!))
            
            // 重複播放次數 設為 0 則是只播放一次 不重複
            myPlayer.numberOfLoops = 0
            
        } catch {
            print("error")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nothing(){
    }
    
    @IBAction func done(_ sender: Any) {
        let alert = UIAlertController(title: "提示", message: "This is an alert.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            self.nothing()
        }
        alert.addAction(action)
        
        //檢查輸入
        if (nameTextField.text?.isEmpty)! {
            alert.message = "請輸入名稱"
            self.present(alert, animated: true, completion: nil)

        }
        else if(levelTextField.text?.isEmpty)! {
            alert.message = "請選擇想買程度"
            self.present(alert, animated: true, completion: nil)

        }
        else if (urlTextField.text?.isEmpty)! {
            alert.message = "請輸入網址"
            self.present(alert, animated: true, completion: nil)

        }
        else if selectImage == nil{
            alert.message = "請選擇相片"
            self.present(alert, animated: true, completion: nil)

        }
        else{
            myPlayer.play()
            
            let fileName = Date().timeIntervalSinceReferenceDate
            //print("fileName:")
            //print(fileName)
            
            let dic:[String:String] = ["name":nameTextField.text!,
                                       "url":urlTextField.text!,
                                       "level":levelTextField.text!,
                                       "fileName":"\(fileName)"]
            
            
            if let dataToSave = UIImagePNGRepresentation(selectImage){
                // 產生路徑
                let filePath = NSTemporaryDirectory() + "\(fileName)" + ".png"
                let fileURL = URL(fileURLWithPath: filePath)
                // 寫入
                do{
                    try dataToSave.write(to: fileURL)
                }
                catch{
                    print("Can not save Image")
                }
                //print("圖片路徑：")
                //print(filePath)
            }
        
            let notiName = Notification.Name("addNotification")
            NotificationCenter.default.post(name: notiName, object: nil, userInfo: dic)
        
            navigationController?.popViewController(animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //選擇想買程度
    @objc func doneClick(_ textField : UITextField) {
        if(levelTextField.text?.isEmpty)! {
            levelTextField.text = "想買"
        }
        levelTextField.resignFirstResponder()
    }
    
    @objc func cancelClick() {
        if levelTextField.isFirstResponder{
            levelTextField.resignFirstResponder()
        }
    }

    //选取相册
    @IBAction func fromAlbum(_ sender: AnyObject) {
        //判断设置是否支持图片库
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //设置是否允许编辑
            picker.allowsEditing = true
            //弹出控制器，显示界面
            self.present(picker, animated: true, completion: {
                () -> Void in
            })
        }else{
            print("读取相册错误")
        }
    }
    
    //选择图片成功后代理
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        //查看info对象
        //print(info)
        
        //显示的图片
        let image:UIImage!
        
        //获取编辑后的图片
        image = info[UIImagePickerControllerEditedImage] as! UIImage
        //socialMedia?.image = info[UIImagePickerControllerEditedImage] as! UIImage
        selectImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        imageView?.image = image
        //图片控制器退出
        picker.dismiss(animated: true, completion: {
            () -> Void in
        })
    }

    
    
    // MARK: - Table view data source
    
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
