import UIKit

class PostViewController: UIViewController {
    
    weak var tableViewController: ViewController!    //記錄上一頁的執行實體
    var selectedRow  = 0  //記錄上一頁選定的資料索引值
    var postRecords = ""
    var db:OpaquePointer? = nil    //資料庫連線（從AppDelegate取得）
    
    @IBOutlet weak var txtDate: UITextField!    
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var txtView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(tableViewController.myRecords[postRecords]![selectedRow])
        //記錄選定列的字典
        let dicCurrentRow = tableViewController.myRecords[postRecords]![selectedRow]
        //顯示上一頁選定的資料
        print(dicCurrentRow["CreateDate"])
        txtDate.text = (dicCurrentRow["CreateDate"] as! String)
        txtView.text = (dicCurrentRow["TextView"] as! String)
        guard let aPic = dicCurrentRow["Photo"]! else {
            return
        }
        imgPicture.image = UIImage(data: aPic as! Data)
//        if let aPic = dicCurrentRow["Photo"]! {
//            imgPicture.image = UIImage(data: aPic as! Data)
//        } else {
//            imgPicture.image = nil
//        }
    }

    //MARK: -Buttons
    
}
