import UIKit

class AddViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {
    
    let myFormatter = DateFormatter()
    
    weak var tableViewController: ViewController!    //記錄上一頁的執行實體
    var currentTextObjectYPosition:CGFloat = 0    //記錄目前輸入元件的Y軸底緣位置
    var myDatePicker :UIDatePicker!
    var db:OpaquePointer? = nil
    
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var txtDate: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        //從AppDelegate取得資料庫連線
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            db = appDelegate.getDB()
            print("連線成功")
        }
        
        txtDate.delegate = self
        
        self.title = "新增"
        myFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        // 日期輸入框
//        txtDate = UITextField(frame: CGRect(x: 0.0, y: height * 2.9, width: fullsize.width, height: height))
//        txtDate.backgroundColor = UIColor.init(red: 0.05, green: 0.05, blue: 0.05, alpha: 1)
//        txtDate.textAlignment = .center
//        txtDate.textColor = UIColor.white
//        txtDate.font = UIFont(name: "Helvetica Light", size: 32.0)
//        txtDate.text = record.createTime
//        txtDate.tag = 503
//        self.view.addSubview(txtDate)
        
        // UIDatePicker
        myDatePicker = UIDatePicker()
        myDatePicker.datePickerMode = .dateAndTime
        myDatePicker.locale = Locale(identifier: "zh_TW")
//                myDatePicker.date = myFormatter.date(from: record.createTime!)!
        txtDate.inputView = myDatePicker
        
        // UIDatePicker 取消及完成按鈕
        let toolBar = UIToolbar()
        toolBar.barTintColor = UIColor.clear
        toolBar.sizeToFit()
        toolBar.barStyle = .default
        toolBar.tintColor = UIColor.white
        let cancelBtn = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(AddViewController.cancelTouched(_:)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneBtn = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(AddViewController.doneTouched(_:)))
        toolBar.items = [cancelBtn, space, doneBtn]
        txtDate.inputAccessoryView = toolBar

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyBoard))    //宣告點按手勢，並且指定對應呼叫的方法
        self.view.addGestureRecognizer(tapGesture)    //把點按手勢加到底面上
        
        // 導覽列右邊儲存按鈕
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "儲存", style:.plain, target: self, action: #selector(btnSaveAction))
        //註冊鍵盤彈出的通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        //註冊鍵盤收起的通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

    // 選取日期時 按下完成
    func doneTouched(_ sender:UIBarButtonItem) {
        txtDate.text = myFormatter.string(from: myDatePicker.date)
//        record.createTime = date
        closeKeyBoard()
    }
    
    // 選取日期時 按下取消
    func cancelTouched(_ sender:UIBarButtonItem) {
        closeKeyBoard()
    }
    // MARK: UITextField Delegate Methods
    // 按下 return 鍵
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        // 事由欄位輸入時 點擊鍵盤[下一個]按鈕會跳往選取時間
//        let title = self.view.viewWithTag(502) as! UITextField
//        let date = self.view.viewWithTag(503) as! UITextField
//        
//        title.resignFirstResponder()
//        date.becomeFirstResponder()
//        
//        return true
//    }
    // 按空白處會隱藏編輯狀態
//    func hideKeyboard(_ tapG:UITapGestureRecognizer?) {
//        self.view.endEditing(true)
//    }
    // 儲存功能
    func btnSaveAction() {
        //進行輸入資料檢查
        if txtDate.text == "" || txtView.text == "" || imgPicture.image == nil {
            let alert = UIAlertController(title: "輸入訊息錯誤", message: "資料輸入不完整，無法新增資料！", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return  //直接離開函式
        }
        //檢查資料庫連線
        if db != nil {
            let imageData = UIImageJPEGRepresentation(imgPicture.image!, 0.8)! as NSData    //準備要存入的圖片
            let sql = String(format: "insert into records(CreateDate,photo,TextView) values('%@',?,'%@')", txtDate.text!, txtView.text!)    //準備SQL的插入指令
            print("新增指令：\(sql)")
            let cSql = sql.cString(using: .utf8)    //把SQL指令轉成C語言字串
            var statement:OpaquePointer? = nil    //宣告儲存執行結果的變數            
            sqlite3_prepare(db, cSql, -1, &statement, nil)    //準備執行SQL指令
            //將照片存入資料庫欄位（第二個參數1，指的是SQL指令?所在的位置，此位置從1起算）
            sqlite3_bind_blob(statement, 1, imageData.bytes, Int32(imageData.length), nil)
            //執行SQL指令
            if sqlite3_step(statement) == SQLITE_DONE {
                print("資料新增成功！")
                let alert = UIAlertController(title: "資料庫訊息", message: "資料新增成功！", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                //直接更改上一頁的離線資料集arrTable
                //新加一筆上一頁的離線資料
                let newDicRow:[String: Any?] = [
                    "CreateDate":txtDate.text,
                    "photo":UIImageJPEGRepresentation(imgPicture.image!, 0.7),
                    "TextView":txtView.text
//                    "address":txtAdress.text,
//                    "phone":txtPhone.text,
//                    "email":txtEmail.text,
//                    "gender":pkvGender.selectedRow(inComponent: 0),
//                    "class":arrClass[pkvClass.selectedRow(inComponent: 0)],
//                    "name":txtDate.text
                    ]
                tableViewController.myRecords.append(newDicRow)
            } else {
                print("資料新增失敗！")
                let alert = UIAlertController(title: "資料庫訊息", message: "資料新增失敗！", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "確定", style: .destructive, handler: nil))
                present(alert, animated: true, completion: nil)
            }
            //關閉連線指令
            sqlite3_finalize(statement)
        }
    }
    //MARK: UIImagePickerControllerDelegate
    //影像挑選控制器完成影像挑選時
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("info=\(info)")
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage    //取得拍照或相簿中的相片
        imgPicture.image = image    //將取得的照片，顯示於照片欄位
        picker.dismiss(animated: true, completion: nil)    //移除影像挑選控制器
    }
    
    // UIDatePicker
//    @IBAction func btnDatePicker(_ sender: UIButton) {
//        myDatePicker = UIDatePicker()
//        myDatePicker.datePickerMode = .dateAndTime
//        myDatePicker.locale = Locale(identifier: "zh_TW")
////                myDatePicker.date = myFormatter.date(from: record.createTime!)!
//        txtDate.inputView = myDatePicker
//    }
    //由鍵盤彈出通知呼叫的函式
    func keyboardWillShow(_ sender:Notification) {
        print("鍵盤彈出")
        print("userInfo=\(String(describing: sender.userInfo))")
        if let keyboardHeight = (sender.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? NSValue)?.cgRectValue.size.height {
            print("鍵盤高度：\(keyboardHeight)")
            let visiableHeight = self.view.frame.size.height - keyboardHeight    //計算可視高度
            //如果輸入元件的Y軸底緣位置，比可視高度還大，代表輸入元件被鍵盤遮住
            if currentTextObjectYPosition > visiableHeight {
                self.view.frame.origin.y = -(self.currentTextObjectYPosition-visiableHeight+10)    //往上移動Y軸底緣位置和可視高度之間的差值(並拉開10點的差距)
            }
        }
    }
    //由鍵盤收合通知呼叫的函式
    func keyboardWillHide() {
        print("鍵盤收合")
        self.view.frame.origin.y = 0    //Y軸移回原點
    }
    //由點按手勢呼叫
    func closeKeyBoard() {
        print("感應到點按手勢")
        //掃描self.view底下所有的可視元件，收起鍵盤
        for subView in self.view.subviews {
            if subView is UITextField || subView is UITextView {
                subView.resignFirstResponder()    //只要是可以彈出鍵盤的元件，就請它收起鍵盤
            }
        }
    }
    //MARK: -Buttons
    //相機按鈕
    @IBAction func btnTakePicture(_ sender: UIButton) {
        //檢查裝置是否配備相機
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()    //初始化影像挑選控制器
            imagePickerController.sourceType = .camera    //指定影像挑選控制器為相機
            imagePickerController.delegate = self    //指定影像挑選控制器的代理人
            show(imagePickerController, sender: self)    //顯示影像挑選控制器（現在為相機）
        } else {
            print("找不到相機！")
        }
    }
    //相簿按鈕
    @IBAction func btnPhotoAlbum(_ sender: UIButton) {
        //檢查裝置是否有相簿
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let imagePickerController = UIImagePickerController()    //初始化影像挑選控制器
            imagePickerController.sourceType = .photoLibrary    //指定影像挑選控制器為相簿
            imagePickerController.delegate = self    //指定影像挑選控制器的代理人
            show(imagePickerController, sender: self)    //顯示影像挑選控制器（現在為相機）
        } else {
            print("找不到相簿！")
        }
    }
    
}
