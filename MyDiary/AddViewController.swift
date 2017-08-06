import UIKit

class AddViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let myFormatter = DateFormatter()
    
    var myDatePicker :UIDatePicker!
    
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var txtDate: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "新增"
        // 日期輸入框
//        txtDate = UITextField(frame: CGRect(x: 0.0, y: height * 2.9, width: fullsize.width, height: height))
//        txtDate.backgroundColor = UIColor.init(red: 0.05, green: 0.05, blue: 0.05, alpha: 1)
//        txtDate.textAlignment = .center
//        txtDate.textColor = UIColor.white
//        txtDate.font = UIFont(name: "Helvetica Light", size: 32.0)
//        txtDate.text = record.createTime
//        txtDate.tag = 503
//        self.view.addSubview(txtDate)
        
        
        
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
        // UIDatePicker
        myDatePicker = UIDatePicker()
        myDatePicker.datePickerMode = .dateAndTime
        myDatePicker.locale = Locale(identifier: "zh_TW")
//                myDatePicker.date = myFormatter.date(from: record.createTime!)!
        txtDate.inputView = myDatePicker
        // 導覽列右邊儲存按鈕
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "儲存", style:.plain, target: self, action: #selector(btnSaveAction))

    }

    // 選取日期時 按下完成
    func doneTouched(_ sender:UIBarButtonItem) {
        let labelDate = self.view.viewWithTag(503) as! UITextField
        let date = myFormatter.string(from: myDatePicker.date)
        labelDate.text = date
//        record.createTime = date
        
        hideKeyboard(nil)
    }
    
    // 選取日期時 按下取消
    func cancelTouched(_ sender:UIBarButtonItem) {
        hideKeyboard(nil)
    }
    // MARK: UITextField Delegate Methods
    
    // 按下 return 鍵
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 事由欄位輸入時 點擊鍵盤[下一個]按鈕會跳往選取時間
//        let title = self.view.viewWithTag(502) as! UITextField
        let date = self.view.viewWithTag(503) as! UITextField
        
//        title.resignFirstResponder()
        date.becomeFirstResponder()
        
        return true
    }
    // 按空白處會隱藏編輯狀態
    func hideKeyboard(_ tapG:UITapGestureRecognizer?){
        self.view.endEditing(true)
    }
    // 儲存功能
    func btnSaveAction() {
        
    }
    
    //MARK: -Buttons
    @IBAction func btnDatePicker(_ sender: UIButton) {
        // UIDatePicker
        myDatePicker = UIDatePicker()
        myDatePicker.datePickerMode = .dateAndTime
        myDatePicker.locale = Locale(identifier: "zh_TW")
//                myDatePicker.date = myFormatter.date(from: record.createTime!)!
                txtDate.inputView = myDatePicker
    }
    //相機按鈕
    @IBAction func btnTakePicture(_ sender: UIButton) {
        //檢查裝置是否配備相機
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //初始化影像挑選控制器
            let imagePickerController = UIImagePickerController()
            //指定影像挑選控制器為相機
            imagePickerController.sourceType = .camera
            //指定影像挑選控制器的代理人
            imagePickerController.delegate = self
            //顯示影像挑選控制器（現在為相機）
            show(imagePickerController, sender: self)
        } else {
            print("找不到相機！")
        }
    }
    //相簿按鈕
    @IBAction func btnPhotoAlbum(_ sender: UIButton) {
        //檢查裝置是否有相簿
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            //初始化影像挑選控制器
            let imagePickerController = UIImagePickerController()
            //指定影像挑選控制器為相簿
            imagePickerController.sourceType = .photoLibrary
            //指定影像挑選控制器的代理人
            imagePickerController.delegate = self
            //顯示影像挑選控制器（現在為相機）
            show(imagePickerController, sender: self)
        } else {
            print("找不到相簿！")
        }
    }
    
}
