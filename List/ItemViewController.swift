//
//  ItemViewController.swift
//  List
//
//  Created by Len on 2017/6/15.
//  Copyright © 2017年 Len. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemLevelLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemUrlTextView: UITextView!
    var listDic:[String:String]!
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationName = Notification.Name("saveNotification")
        NotificationCenter.default.addObserver(self, selector: #selector(self.saveNotification(noti:)), name: notificationName, object: nil)
        
        loadData()
    }
    
    @objc func saveNotification(noti:Notification) {
        self.listDic = noti.userInfo as? [String:String]
        loadData()
    }
    
    func loadData(){
        navigationItem.title = listDic["name"]
        
        itemNameLabel.text = listDic["name"]
        itemUrlTextView.text = listDic["url"]
        itemLevelLabel.text = listDic["level"]
        
        //讀相片
        let filePath = NSTemporaryDirectory() + listDic["fileName"]! + ".png"
        let image = UIImage(contentsOfFile: filePath)
        //顯示相片
        itemImageView.image = image
    }
    //點擊前往商品頁面
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:])
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ListDetailViewController {
            let controller = segue.destination as? ListDetailViewController
            controller?.listDic = self.listDic
        }
    }
    

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
