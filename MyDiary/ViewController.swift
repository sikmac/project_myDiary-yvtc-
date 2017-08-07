import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
//    let fullsize = UIScreen.main.bounds.size
    let myFormatter = DateFormatter()
    let myRefreshControl = UIRefreshControl()    //建立UIRefreshControl，存在常數myRefreshControl中
    
    var dicRow = [String:Any?]()    //記錄單一資料行
    var currentDate :Date = Date()
    var myRecords = [[String:Any?]]()
    var db:OpaquePointer? = nil
    
    // MARK: -tableView in viewController property
    @IBOutlet weak var lblCurrentYearMonth: UILabel!
    @IBOutlet weak var tableView: UITableView!    //先將tableView建立屬性
    
    var diaryArray = ["DOG","CAT","BAT"]    //建立顯示的資料，存在陣列裡面
    var diarySecondArray = ["Happy", "Sad", "Angry"]    //建立第二個類別陣列資料
    let diaryRefreshArray = ["One", "Two", "Three"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {    //從AppDelegate取得資料庫連線
            db = appDelegate.getDB()
        }
        getDataFromDB()    //準備離線資料集(呼叫讀取資料庫資料的函式)
        
        // 目前年月
//        lblCurrentYearMonth = UILabel(frame: CGRect(x: 0, y: 0, width: fullsize.width * 0.7, height: 50))
//        lblCurrentYearMonth.center = CGPoint(x: fullsize.width * 0.5, y: 35)
        lblCurrentYearMonth.textColor = UIColor.white
        myFormatter.dateFormat = "yyyy 年 MM 月"
        lblCurrentYearMonth.text = myFormatter.string(from: currentDate)
        lblCurrentYearMonth.textAlignment = .center
//        lblCurrentYearMonth.font = UIFont(name: "Helvetica Light", size: 32.0)
//        lblCurrentYearMonth.tag = 701
//        self.view.addSubview(lblCurrentYearMonth)
        
        //不使用"拉"的方法，得使用此
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.refreshControl = myRefreshControl
        self.myRefreshControl.addTarget(self, action: #selector(self.refreshList), for: .valueChanged)
    }
    //由導覽線換頁時
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue1" {
            let detailVC = segue.destination as! PostViewController
            //傳遞第一頁的執行實體給第二頁（引用型別傳遞）
            detailVC.tableViewController = self
            //傳遞目前選定列的索引給下一頁（值型別傳遞）
            if let rowIndex = self.tableView.indexPathForSelectedRow?.row {
                detailVC.selectedRow = rowIndex
            }
        }
    }
    // MARK: Table view data source
    //要顯示幾個Section(建立幾筆陣列資料這需更動)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    //Section裡面要顯示的row數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //此為顯示單一diaryArray的數量
//        return diaryArray.count
        //多筆資料要顯示用if...let
        if section == 0 {
            return diaryArray.count
        } else {
            return diarySecondArray.count
        }
    }
    //每一列TableViewCell要顯示的資料
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)    //先產出cell
//        print(cell.contentView.subviews)
        let cellImageView = cell.contentView.subviews[0] as! UIImageView    //設定cell的縮圖與文字
        let cellText = cell.contentView.subviews[1] as! UILabel
        
        cellImageView.image = UIImage(named: "2105175_1")
//        cellText.text = diaryArray[indexPath.row]
        if indexPath.section == 0 {
            cellText.text = diaryArray[indexPath.row]
        } else {
            cellText.text = diarySecondArray[indexPath.row]
        }
        return cell
    }
    //為多個section增加title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "動物"
        } else {
            return "情緒"
        }
    }
    //設定section title(header)的高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    //得知選擇了哪個row, section
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected section: \(indexPath.section)")
        print("selected row: \(indexPath.row)")
        if indexPath.section == 0 {
            print("selected 動物 name:\(diaryArray[indexPath.row])")
        } else {
            print("selected 情緒 name:\(diarySecondArray[indexPath.row])")
        }
        //選擇(點擊)後會變灰色，得取消選擇才復原
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
            diaryArray.remove(at: indexPath.row)
            tableView.reloadData()
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
    }
    // MARK: Functional Methods
    func getDataFromDB() {
        //清除所有的陣列元素
//        arrTable.removeAll()        //arrTable = [[String:Any?]]()
        let sql = "select stu_no,name,gender,picture,phone,address,email,class from student order by stu_no"    //準備查詢指令
        let cSql = sql.cString(using: .utf8)    //將查詢指令轉成c語言的字串
        //宣告查詢結果的變數（連線資料集）
        var statement:OpaquePointer? = nil
        //執行查詢指令（-1代表不限定sql指令的長度，最後一個參數為預留參數，目前沒有作用）
        sqlite3_prepare(db, cSql!, -1, &statement, nil)
        //往下讀一筆，如果讀到資料時
        while sqlite3_step(statement) == SQLITE_ROW {
            let stu_no = sqlite3_column_text(statement, 0)    //取得第一個欄位（C語言字串）
            let no = String(cString: stu_no!)    //轉換第一個欄位（swift字串）
            print("\(no)")
            
            
            let stu_name = sqlite3_column_text(statement, 1)    //取得第二個欄位（C語言字串）
            let name = String(cString: stu_name!)    //轉換第二個欄位（swift字串）
            print("\(name)")
            
            //取得第三個欄位(注意：此處要先轉Int，否則從陣列取出時，optional會包兩層！會造成pkvGender.selectRow當掉)
            let intGender = Int(sqlite3_column_int(statement, 2))
            
            //取得第四個欄位（照片）
            var imgData:Data?                                   //用於記載檔案的每一個位元資料
            if let totalBytes = sqlite3_column_blob(statement, 3) {    //讀取檔案每一個位元的資料
                let length = sqlite3_column_bytes(statement, 3)     //讀取檔案長度
                imgData = Data(bytes: totalBytes, count: Int(length))    //將數位圖檔資訊，初始化成為Data物件
            }
            
            
            let stu_phone = sqlite3_column_text(statement, 4)    //取得第五個欄位（C語言字串）
            let phone = String(cString: stu_phone!)    //轉換第五個欄位（swift字串）
            
            
            let stu_address = sqlite3_column_text(statement, 5)    //取得第六個欄位（C語言字串）
            let address = String(cString: stu_address!)    //轉換第六個欄位（swift字串）
            
            
            let stu_email = sqlite3_column_text(statement, 6)    //取得第七個欄位（C語言字串）
            let email = String(cString: stu_email!)    //轉換第七個欄位（swift字串）
            
            
            let stu_class = sqlite3_column_text(statement, 7)    //取得第八個欄位（C語言字串）
            let myClass = String(cString: stu_class!)    //轉換第八個欄位（swift字串）
            
            //根據查詢到的每一個欄位來準備字典
            dicRow = ["no":no,"name":name,"gender":intGender,"picture":imgData,"phone":phone,"address":address,"email":email,"class":myClass]
            
//            arrTable.append(dicRow)    //將字典加入陣列（離線資料集）
        }
        //關閉連線資料集
        sqlite3_finalize(statement)
        
//        print("離線資料集陣列：\(arrTable)")
    }
    
    //MARK: Target Action
    //查詢按鈕
//    @IBAction func btnQuery(_ sender: UIButton) {
//        let sql = "select stu_no,name,gender,picture,phone,address,email,class from student order by stu_no"    //準備查詢指令
//        let cSql = sql.cString(using: .utf8)    //將查詢指令轉成c語言的字串
//        var statement:OpaquePointer? = nil    //宣告查詢結果的變數（連線資料集）
//        sqlite3_prepare(db, cSql!, -1, &statement, nil)    //執行查詢指令（-1代表不限定sql指令的長度，最後一個參數為預留參數，目前沒有作用）
    
//        while sqlite3_step(statement) == SQLITE_ROW {    //往下讀一筆，如果讀到資料時
//            let stu_no = sqlite3_column_text(statement, 0)    //取得第一個欄位（C語言字串）
//            let no = String(cString: stu_no!)    //轉換第一個欄位（swift字串）
//            print("\(no)")
//            let stu_name = sqlite3_column_text(statement, 1)    //取得第二個欄位（C語言字串）
//            let name = String(cString: stu_name!)    //轉換第二個欄位（swift字串）
//            print("\(name)")
//            let intGender = Int(sqlite3_column_int(statement, 2))    //取得第三個欄位(注意：此處要先轉Int，否則從陣列取出時，optional會包兩層！會造成pkvGender.selectRow當掉)
//            //取得第四個欄位（照片）
//            let length = sqlite3_column_bytes(statement, 3)     //讀取檔案長度
//            var imgData:Data?                                   //用於記載檔案的每一個位元資料
//            if let totalBytes = sqlite3_column_blob(statement, 3) {    //讀取檔案每一個位元的資料
//                imgData = Data(bytes: totalBytes, count: Int(length))    //將數位圖檔資訊，初始化成為Data物件
//            }
//            dicRow = ["no":no,"name":name,"gender":intGender,"picture":imgData]    //根據查詢到的每一個欄位來準備字典
//            arrTable.append(dicRow)    //將字典加入陣列
//        }
    //MARK: -tableView refresh
    //refreshList方法裡要把更新後的資料存進tableDate裡
    //讓tableView執行reloadData方法更新資料
    //使用UIRefresh的endRreshing方法，讓refreshController停止轉動並隱藏
    func refreshList() {
        diaryArray = diarySecondArray
        diarySecondArray = diaryRefreshArray
//        getDataFromDB()
        tableView.reloadData()
        myRefreshControl.endRefreshing()
    }
    //MARK: -Buttons
    @IBAction func btnChange(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        print("tableView被釋放")
    }
    @IBAction func btnCalender(_ sender: UIBarButtonItem) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let calenderViewController = mainStoryboard.instantiateViewController(withIdentifier: "CalenderView")
        self.navigationController?.pushViewController(calenderViewController, animated: true)
    }
    
    @IBAction func btnSettings(_ sender: UIBarButtonItem) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let settingsViewController = mainStoryboard.instantiateViewController(withIdentifier: "SettingsView")
        self.navigationController?.pushViewController(settingsViewController, animated: true)
    }
    @IBAction func btnAdd(_ sender: UIButton) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let addViewController = mainStoryboard.instantiateViewController(withIdentifier: "AddView")
//        self.navigationController?.pushViewController(addViewController, animated: true)
        show(addViewController, sender: nil)
    }
    
    
    
}

