//
//  Utility.swift
//
//
//  Created by FAraz Zafar on 2/29/16.
//

//import Localize_Swift
import UIKit
//import SVProgressHUD

struct GlobalConstants {
    //  COLOR CONSTANT
    
    static let kColor_AppDefaultGreen: UIColor = UIColor(red: 1/255, green: 170/255, blue: 100/255, alpha: 1)
    static let kColor_AppYellowishGreen: UIColor = UIColor(red: 183/255.0, green: 233/255.0, blue: 135/255.0, alpha: 1)
    static let kColor_BorderLightGrey: UIColor = UIColor(red: 201/255.0, green: 201/255.0, blue: 201/255.0, alpha: 1)
}

enum UIUserInterfaceIdiom: Int{
    case Unspecified
    case phone
    case pad
}

enum FontType{
    case Bold
    case Regular
    case Light
}

class Utility: NSObject {
    
    static func getScreenSize () -> CGRect{
        return UIScreen.main.bounds
    }
    
    static func isPad () -> Bool{
        var isPad : Bool = false
        switch UIDevice.current.userInterfaceIdiom {
            
        case .phone:
            print("Phone")
            isPad = false
        case .pad:
            print("Pad")
            isPad = true
        case.unspecified:
            print("Un-specified")
            isPad = false
        default: break
            
        }
        return isPad
    }
    
//    static func isEnglish () -> Bool{
//        
//        return Localize.currentLanguage() == "en"
//    }
//    
//    static func ChangeCurrentLanguage (){
//        if Utility.isEnglish() {
//            Localize.setCurrentLanguage("ar")
//        }else{
//            Localize.setCurrentLanguage("en")
//        }
//    }
    
    static func color (color: UIColor) -> UIImage {
        let ect: CGRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0) 
        UIGraphicsBeginImageContext(ect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(ect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

//    static func ShowProgressHUD(){
//        SVProgressHUD.show()
//        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.Flat)
//        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Gradient)
//    }
//    
//    static func DismissProgressHUD(){
//        SVProgressHUD.dismiss()
//    }
    
    static func ConvertDateFormater(date: String, fromFormat: String, toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.dateFormat = fromFormat//"yyMMdd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        
        guard let date = dateFormatter.date(from: date) else {
            assert(false, "no date from string")
            return ""
        }        
        //        dateFormatter.dateFormat = "yyyy MMM EEEE HH:mm"
        dateFormatter.dateFormat = toFormat// "dd MMM yyyy"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
    }
    
    static func TrimSpecialCharacter(text: String, character: String) ->String{
//        let str = text.stringByReplacingOccurrencesOfString(character, withString: "", options: NSString.CompareOptions.LiteralSearch, range: nil)
        let str = text.replacingOccurrences(of: character, with: "", options: String.CompareOptions.literal, range: nil)
        return str
    }
    
    static func GetDateStringFromNSDate(selectedDate: NSDate ) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
//        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        return dateFormatter.string(from: selectedDate as Date)
    }
    
    static func CustomizeButtonFillHighlightedColor(btnStep:UIButton) -> UIButton {
        btnStep.layer.cornerRadius = btnStep.frame.size.width/2
        btnStep.layer.borderWidth = 1
        btnStep.layer.borderColor = GlobalConstants.kColor_AppDefaultGreen.cgColor
        btnStep.backgroundColor = GlobalConstants.kColor_AppYellowishGreen
        btnStep.setTitleColor(GlobalConstants.kColor_AppDefaultGreen, for: .normal)
        return btnStep
    }
    static func CustomizeButtonFillColor(btnStep:UIButton) -> UIButton {
        btnStep.layer.cornerRadius = btnStep.frame.size.width/2
        btnStep.layer.borderWidth = 1
        btnStep.layer.borderColor = GlobalConstants.kColor_AppDefaultGreen.cgColor
        btnStep.backgroundColor = GlobalConstants.kColor_AppDefaultGreen
        btnStep.setTitleColor(UIColor.white, for: .normal)
        return btnStep
    }
    static func CustomizeButtonNotFillColor(btnStep:UIButton) -> UIButton {
        btnStep.layer.cornerRadius = btnStep.frame.size.width/2
        btnStep.layer.borderWidth = 1
        btnStep.layer.borderColor = GlobalConstants.kColor_AppDefaultGreen.cgColor
        btnStep.backgroundColor = UIColor.white
        
        btnStep.setTitleColor(GlobalConstants.kColor_AppDefaultGreen, for: .normal)
        return btnStep
    }
    static func GetDateStringFromDate(date:NSDate)->String{
        
        let strDate = Utility.GetDateStringFromNSDate(selectedDate: date)
        return Utility.ConvertDateFormater(date: strDate, fromFormat: "MM/dd/yy", toFormat: "dd MMM yyyy")
    }
//    static func isLandscape() -> Bool{
////        let appDelegate : AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
//        let appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
//
//        return appDelegate.isLandscape!
////        return true;
//    }
    
    static func setButtonsBorder(btnBorder : UIButton) -> UIButton{
        btnBorder.layer.borderWidth = 1.0
        btnBorder.layer.borderColor = GlobalConstants.kColor_AppDefaultGreen.cgColor
        return btnBorder
    }

    static func setButtonsBorderLightGreen(btnBorder : UIButton) -> UIButton{
        btnBorder.layer.borderWidth = 1.0
        btnBorder.layer.borderColor = GlobalConstants.kColor_AppYellowishGreen.cgColor
        return btnBorder
    }
    
//    static func SetTextViewBorder(txtView: UITextView) -> UITextView{
//        txtView.layer.borderColor = GlobalConstants.kColor_BorderLightGrey.CGColor
//        txtView.layer.borderWidth = 0.6
//        txtView.layer.cornerRadius = 5
//        
//        return txtView
//    }
//    static func SetCardView(view: UIView) -> UIView{
//        view.layer.shadowOffset = CGSizeMake(0, 1)
//        view.layer.shadowRadius = 2
//        view.layer.shadowOpacity = 0.4
//        return view
//        
//    }
    
    static func SetCardButton(btn: UIButton) -> UIButton{
        btn.layer.shadowOffset = CGSize(width: 0, height: 1)
        btn.layer.shadowRadius = 2
        btn.layer.shadowOpacity = 0.4
        return btn
    }
    static func SetFontSegoe(fontType:FontType, size:Int) -> UIFont{
        
        var fontStyle :String
        
        switch fontType {
        case .Bold:
            fontStyle = "SegoeUI-Semibold"
        case .Regular:
            fontStyle = "SegoeUI"
        case .Light:
            fontStyle = "SegoeUI-Light"
        default:
            fontStyle = "SegoeUI"
        }
        return UIFont(name: fontStyle, size: CGFloat(size))!
    }
}
extension UIView{
    func SetCardView() {
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.4
    }
}
extension UITextView{
    func SetTextViewBorder(){
        self.layer.borderColor = GlobalConstants.kColor_BorderLightGrey.cgColor
        self.layer.borderWidth = 0.6
        self.layer.cornerRadius = 5        
    }
}
