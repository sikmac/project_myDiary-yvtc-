import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var db:OpaquePointer? = nil    //宣告資料庫連線變數

    func getDB() -> OpaquePointer? {
        return db
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //        let fileManager = FileManager.default    //取得檔案管理員
        ////        let sourceDB = Bundle.main.path(forResource: "MyDB", ofType: "db")    //取得資料庫來源路徑
                let destinationDB = NSHomeDirectory() + "/Documents/sqlite3.db"    //取得資料庫的目的地路徑
//                print("目的地路徑：\(destinationDB)")
        //        //檢查目的地的資料庫是否已經存在
                if !FileManager.default.fileExists(atPath: destinationDB) {    //如果不存在
                    let db = SQLiteConnect(file: "sqlite3.db")
//                    if sqlite3_open(destinationDB, &db) == SQLITE_OK {
//                        print("Success!")
//                    } else {
//                        print ("Failed!")
//                    }
                }

        
        // 建立資料表
//        let myUserDefaults = UserDefaults.standard
//        let dbInit = myUserDefaults.object(forKey: "dbInit") as? Int
//        if dbInit == nil {
            let dbFileName = "sqlite3.db"
        let db = SQLiteConnect(file: dbFileName)
        print("成功")
//        let myDB = db {
        if (db?.createTable("records", columnsInfo: [
            "Id INTERGER primary key autoincrement",
            "YearMonth TEXT",
            "CreateDate TEXT",
            "CreateWeek TEXT",
            "CreateTime DATETIME",
            "Photo BLOB",
            "TextView TEXT"
            ])) != nil
        
//                if result {
//                    myUserDefaults.set(1, forKey: "dbInit")
//                    myUserDefaults.set(dbFileName, forKey: "dbFileName")
//                    myUserDefaults.synchronize()
//                }
//            }
//        }
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
//        sqlite3_close(db)    //關閉資料庫
    }

}

