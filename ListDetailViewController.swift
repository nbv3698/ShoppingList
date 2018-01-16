//
//  ListDetailViewController.swift
//  List
//
//  Created by Len on 2017/6/11.
//  Copyright © 2017年 Len. All rights reserved.
//

import UIKit

class ListDetailViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate{

    var listDic:[String:String]!
    var selectImage: UIImage!
    var pickOption = ["想買", "很想買", "超級想買", "宇宙無敵想買"]
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var levelTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var urlTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        navigationItem.title = listDic["name"]
        nameTextField.text = listDic["name"]
        urlTextField.text = listDic["url"]
        levelTextField.text = listDic["level"]
        
        //讀相片
        let filePath = NSTemporaryDirectory() + listDic["fileName"]! + ".png"
        let image = UIImage(contentsOfFile: filePath)
        selectImage = image
        //顯示相片
        imageView.image = image
        
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nothing(){
    }
    
    @IBAction func saveButtonAction(_ sender: UIBarButtonItem){
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
        else if (urlTextField.text?.isEmpty)! {
            alert.message = "請輸入網址"
            self.present(alert, animated: true, completion: nil)
        }
        else{
            saveDate()
            //存相片
            if let dataToSave = UIImagePNGRepresentation(selectImage){
                // 產生路徑
                let filePath = NSTemporaryDirectory() + listDic["fileName"]! + ".png"
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
        
            let notificationName = Notification.Name("saveNotification")
            NotificationCenter.default.post(
                name: notificationName, object: nil, userInfo: listDic)
        
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func saveDate(){
        if (listDic["fileName"]!.isEmpty){
            let fileName = Date().timeIntervalSinceReferenceDate
            
            listDic = ["name":nameTextField.text!,
                       "url":urlTextField.text!,
                       "level":levelTextField.text!,
                       "fileName":"\(fileName)"
                        ]
            //print("檔名為空")
        }

        else{
            listDic = ["name":nameTextField.text!,
                       "url":urlTextField.text!,
                       "level":levelTextField.text!,
                       "fileName":listDic["fileName"]!
                        ]
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
        }
        else{
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
        selectImage = info[UIImagePickerControllerEditedImage] as! UIImage
        imageView?.image = image
        //图片控制器退出
        picker.dismiss(animated: true, completion: {
            () -> Void in
        })
    }
    
    @objc func doneClick(_ textField : UITextField) {
        if(levelTextField.text?.isEmpty)! {
            levelTextField.text = "one"
        }
        print("levelTextField.text:"+levelTextField.text!)
        levelTextField.resignFirstResponder()
    }
    
    @objc func cancelClick() {
        if levelTextField.isFirstResponder{
            levelTextField.resignFirstResponder()
        }
    }
    
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
    //點擊螢幕後隱藏鍵盤
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
