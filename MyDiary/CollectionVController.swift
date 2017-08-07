import UIKit

class CollectionVController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: -collectionView in collectionViewController property
    @IBOutlet weak var collectionView: UICollectionView!    //先將collectionView建立屬性
    let myRefreshControl = UIRefreshControl()    //建立UIRefreshControl，存在常數myRefreshControl中
    var myRecords :[String:[[String:String]]]! = [:]
    
    var diaryArray = ["DOG","CAT","BAT"]    //建立顯示的資料，存在陣列裡面
    var diarySecondArray = ["Happy", "Sad", "Angry"]    //建立第二個類別陣列資料
    let diaryRefreshArray = ["One", "Two", "Three"]
    
    var db:OpaquePointer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //不使用"拉"的方法，得使用此
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.refreshControl = myRefreshControl
        self.myRefreshControl.addTarget(self, action: #selector(self.refreshList), for: .valueChanged)

    }
    //要顯示幾個Section(建立幾筆陣列資料這需更動)
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    //Section裡面要顯示的row數
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //此為顯示單一diaryArray的數量
        //        return diaryArray.count
        //多筆資料要顯示用if...let
        if section == 0 {
            return diaryArray.count
        } else {
            return diarySecondArray.count
        }
    }
    //每一列collectionView要顯示的資料
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVCell", for: indexPath)    //先產出cell
        let cellImageView = cell.contentView.subviews[0] as! UIImageView    //設定cell的縮圖與文字
        let cellText = cell.contentView.subviews[1] as! UILabel
        
        cellImageView.image = UIImage(named: "2105175_1")
        if indexPath.section == 0 {
            cellText.text = diaryArray[indexPath.row]
//            cell.textLabel?.text = diaryArray[indexPath.row]
        } else {
            cellText.text = diarySecondArray[indexPath.row]
//            cell.textLabel?.text = diarySecondArray[indexPath.row]
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected section: \(indexPath.section)")
        print("selected: \(indexPath.item)")
        if indexPath.section == 0 {
            print("selected name:\(diaryArray[indexPath.row])")
        } else {
            print("selected name:\(diarySecondArray[indexPath.row])")
        }
    }
    //MARK: -collectionView refresh
    //refreshList方法裡要把更新後的資料存進collectionDate裡
    //讓collectionView執行reloadData方法更新資料
    //使用UIRefresh的endRreshing方法，讓refreshController停止轉動並隱藏
    func refreshList() {
        diaryArray = diarySecondArray
        diarySecondArray = diaryRefreshArray
        collectionView.reloadData()
        myRefreshControl.endRefreshing()
    }
    //MARK: -Buttons
    @IBAction func btnBack(_ sender: UIButton) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        print("collection被釋放")
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
        self.navigationController?.pushViewController(addViewController, animated: true)
    }

}
