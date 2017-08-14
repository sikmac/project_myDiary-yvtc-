import UIKit

class SettingsViewController: UIViewController {
    
    /// 阅读最小阅读字体大小
    let DZMReadMinFontSize:NSInteger = 12
    
    /// 阅读最大阅读字体大小
    let DZMReadMaxFontSize:NSInteger = 25
    
    /// 阅读当前默认字体大小
    let DZMReadDefaultFontSize:NSInteger = 14
    
    @IBOutlet weak var changeView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func changeFont1(_ sender: UIButton) {
        return UIFont.systemFont(ofSize: CGFloat(fontSize))
    }
    @IBAction func changeFont2(_ sender: UIButton) {
        return UIFont(name: "EuphemiaUCAS-Italic", size: CGFloat(fontSize))!
    }
    @IBAction func changeFont3(_ sender: UIButton) {
        return UIFont(name: "AmericanTypewriter-Light", size: CGFloat(fontSize))!
    }
    @IBAction func changeFont4(_ sender: UIButton) {
        return UIFont(name: "Papyrus", size: CGFloat(fontSize))!
    }
    
}
