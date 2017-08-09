import UIKit

class PostViewController: UIViewController {
    
    weak var tableViewController: ViewController!    //記錄上一頁的執行實體
    var selectedRow  = 0  //記錄上一頁選定的資料索引值
    var db:OpaquePointer? = nil    //資料庫連線（從AppDelegate取得）
    
    @IBOutlet weak var txtDate: UITextField!    
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var txtView: UITextView!   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("上一頁選定：\(tableViewController.myRecords[selectedRow])")
        //記錄選定列的字典
//        let dicCurrentRow = tableViewController.myRecords[selectedRow]
        //顯示上一頁選定的資料
//        txtDate.text = dicCurrentRow["CreateDate"] as? String
//        if let aPic = dicCurrentRow["photo"]! {
//            imgPicture.image = UIImage(data: aPic as! Data)
//        } else {
//            imgPicture.image = nil
//        }
//        txtView.text = dicCurrentRow["TextView"] as? String
    }

    //MARK: -Buttons
    
}
