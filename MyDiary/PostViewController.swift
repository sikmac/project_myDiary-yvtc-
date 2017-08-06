import UIKit

class PostViewController: UIViewController {
    
    weak var tableViewController: ViewController!    //記錄上一頁的執行實體
    var selectedRow  = 0  //記錄上一頁選定的資料索引值
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("上一頁選定：\(tableViewController.myRecords[selectedRow])")
        //記錄選定列的字典
        let dicCurrentRow = tableViewController.myRecords[selectedRow]
        //顯示上一頁選定的資料
//        lblNo.text = dicCurrentRow["no"] as? String
//        txtName.text = dicCurrentRow["name"] as? String
//        pkvGender.selectRow(dicCurrentRow["gender"] as! Int, inComponent: 0, animated: true)
//        imgPicture.image = dicCurrentRow["picture"] as? UIImage
//        txtAddress.text = dicCurrentRow["address"] as? String
//        txtPhone.text = dicCurrentRow["phone"] as? String
//        txtEmail.text = dicCurrentRow["email"] as? String

    }

    //MARK: -Buttons
    
}
