//
//  ViewController.swift
//  BlinkDemo
//
//  Created by FAraz Zafar on 1/12/17.
//

import UIKit
import MicroBlink
import MobileCoreServices

class ViewController: UIViewController,PPScanningDelegate,PPCoordinatorDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var btnScanPassport: UIButton!
    @IBOutlet weak var btnBrowsePassport: UIButton!
    
    @IBOutlet weak var txtDateOfBirth : UITextField!
    @IBOutlet weak var txtDateOfExpiry  : UITextField!
    @IBOutlet weak var txtType  : UITextField!
    @IBOutlet weak var txtPassportNumber  : UITextField!
    @IBOutlet weak var txtNationality  : UITextField!
    @IBOutlet weak var txtCitizenshipNumber : UITextField!
    @IBOutlet weak var txtSurName  : UITextField!
    @IBOutlet weak var txtGivenName  : UITextField!
    @IBOutlet weak var txtCountryCode  : UITextField!
    @IBOutlet weak var txtGender  : UITextField!
    
    var coordinator : PPCameraCoordinator?
    var appDelegate : AppDelegate!
    let imagePicker = UIImagePickerController()
    var pickerView : UIPickerView = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        imagePicker.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ActionScan(sender:AnyObject){
        let error: NSErrorPointer = nil
        let coordinator = self.coordinatorWithErrorForScan(error: error)
        
        /** If scanning isn't supported, present an error */
        if coordinator == nil {
            let messageString: String = (error!.pointee?.localizedDescription) ?? ""
            let alerController = UIAlertController(title: "Warning", message: messageString, preferredStyle: .alert)
            let action=UIAlertAction(title: "Ok", style: .default, handler: nil)
            alerController.addAction(action);
            alerController.show(self, sender: nil)
            return
        }
        appDelegate.isCameraOrGallaryActive = true
        /** Allocate and present the scanning view controller */
        let scanningViewController: UIViewController = PPViewControllerFactory.cameraViewController(with: self, coordinator: coordinator!, error: nil)
        
        /** You can use other presentation methods as well */
        self.present(scanningViewController, animated: true, completion: nil)
    }
    
    @IBAction func ActionGallery(sender: AnyObject) {
        
        appDelegate.isCameraOrGallaryActive = false
        let cameraUI : UIImagePickerController = UIImagePickerController()
        cameraUI.sourceType =  .photoLibrary
        cameraUI.delegate = self
        self.present(cameraUI, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])  {
        if (appDelegate.isCameraOrGallaryActive == true)
        {
            return
        }
        let originalImage : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let error : NSErrorPointer = nil
        let coordinator = self.coordinatorWithErrorForGallery(error: error)
        appDelegate.isCameraOrGallaryActive = false
        coordinator!.processImage(PPImage(uiImage: originalImage))
        coordinator!.delegate = self
        
        self.dismiss(animated: true) {            
        }
    }
    //MARK: Blink Delegate
    
    func scanningViewControllerUnauthorizedCamera(_ scanningViewController: UIViewController) {
        // Add any logic which handles UI when app user doesn't allow usage of the phone's camera
    }
    
    func scanningViewController(scanningViewController: UIViewController, didFindError error: NSError) {
        // Can be ignored. See description of the method
    }
    
    public func scanningViewController(_ scanningViewController: UIViewController, didFindError error: Error) {
        // Can be ignored
    }
    
    func scanningViewControllerDidClose(_ scanningViewController: UIViewController) {
        // As scanning view controller is presented full screen and modally, dismiss it
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func scanningViewController(_ scanningViewController: UIViewController?, didOutputResults results: [PPRecognizerResult]) {
        
        let scanConroller = scanningViewController as! PPScanningViewController
        
        /**
         * Here you process scanning results. Scanning results are given in the array of PPRecognizerResult objects.
         * Each member of results array will represent one result for a single processed image
         * Usually there will be only one result. Multiple results are possible when there are 2 or more detected objects on a single image (i.e. pdf417 and QR code side by side)
         */
        
        // first, pause scanning until we process all the results
        scanConroller.pauseScanning()
        self.updateUiWithScanData(result2:results )
        
        self.dismiss(animated: true, completion: nil)
    }
    func updateUiWithScanData(result2: [PPRecognizerResult]){
        var message = ""
        var title = ""
        
        // Collect data from the result
        for result in result2 {
            if (result is PPMrtdRecognizerResult) {
                /** MRTD was detected */
                let mrtdResult = result as! PPMrtdRecognizerResult
                title = "MRTD"
                //message = mrtdResult.description
                
                let dateOfBirth = Utility.ConvertDateFormater(date: Utility.TrimSpecialCharacter(text: mrtdResult.rawDateOfBirth!, character: "<"), fromFormat: "yyMMdd", toFormat: "dd MMM yyyy")
                let dateOfExpiry = Utility.ConvertDateFormater(date: Utility.TrimSpecialCharacter(text: mrtdResult.rawDateOfExpiry!, character: "<"), fromFormat: "yyMMdd", toFormat: "dd MMM yyyy")
                
                let type = Utility.TrimSpecialCharacter(text: mrtdResult.documentCode!, character: "<")
                let passportNumber = Utility.TrimSpecialCharacter(text: mrtdResult.documentNumber!, character: "<")
                let nationality = Utility.TrimSpecialCharacter(text: mrtdResult.nationality!, character: "<")
                let citizenshipNumber = Utility.TrimSpecialCharacter(text: mrtdResult.opt1!, character: "<")
                print("opt2 :: \(mrtdResult.opt2!)")
                let surName = Utility.TrimSpecialCharacter(text: mrtdResult.primaryId!, character: "<")
                let givenName = Utility.TrimSpecialCharacter(text: mrtdResult.secondaryId!, character: "<")
                let countryCode = Utility.TrimSpecialCharacter(text: mrtdResult.issuer!, character: "<")
                let gender = Utility.TrimSpecialCharacter(text: mrtdResult.sex!, character: "<")
                
                txtDateOfBirth.text = dateOfBirth
                txtDateOfExpiry.text = dateOfExpiry
                txtType.text = type
                txtPassportNumber.text = passportNumber
                txtNationality.text = nationality
                txtCitizenshipNumber.text = citizenshipNumber
                txtSurName.text = surName
                txtGivenName.text = givenName
                txtCountryCode.text = countryCode
                txtGender.text = gender
            }
            if (result is PPUsdlRecognizerResult) {
                /** US drivers license was detected */
                let usdlResult = result as! PPUsdlRecognizerResult
                title = "USDL"
                message = usdlResult.description
            }
            if (result is PPEudlRecognizerResult) {
                /** EU drivers license was detected */
                let eudlResult = result as! PPEudlRecognizerResult
                title = "EUDL"
                message = eudlResult.description
            }
            if (result is PPMyKadBackRecognizerResult) {
                /** MyKad was detected */
                let myKadResult = result as! PPMyKadBackRecognizerResult
                title = "MyKad"
                message = myKadResult.description
            }
            if (result is PPMyKadFrontRecognizerResult){
                /** MyKad was detected */
                let myKadResult = result as! PPMyKadFrontRecognizerResult
                title = "MyKad"
                message = myKadResult.description
            }
        }
        
        // present the alert view with scanned results
        
//                let alertController: UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//        
//                let okAction: UIAlertAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default,
//                                                                 handler: { (action) -> Void in
//                                                                    self.dismiss(animated: true, completion: nil)
//                })
//                alertController.addAction(okAction)
    }
    func ResignKeyboards()  {
        txtDateOfBirth.resignFirstResponder()
        txtDateOfExpiry.resignFirstResponder()
        txtType.resignFirstResponder()
        txtPassportNumber.resignFirstResponder()
        txtNationality.resignFirstResponder()
        txtCitizenshipNumber.resignFirstResponder()
        txtSurName.resignFirstResponder()
        txtGivenName.resignFirstResponder()
        txtCountryCode.resignFirstResponder()
        txtGender.resignFirstResponder()
    }
    //////////////////////////////////////////////////////////////////////////////////////
    func coordinatorDidStartDetection(_ coordinator: PPCoordinator!) {
        
    }
    func coordinator(_ coordinator: PPCoordinator!, didOutputMetadata metadata: PPMetadata!) {
        
    }
    /**
     * Called when the recognition manager finds the element on the image and returns
     the coordinates of found element
     */
    func coordinator(_ coordinator: PPCoordinator!, didFinishDetectionWith result: PPDetectorResult!) {
        
        //print(result.code)
        
    }
    /**
     * Called when the recognition of a current image starts
     */
    func coordinatorDidFinishRecognition(_ coordinator: PPCoordinator!) {
        
    }
    func coordinator(_ coordinator: PPCoordinator!, didObtainOcrResult ocrResult: PPOcrLayout!, withResultName resultName: String!) {
        
        if (resultName == "MRTD")
        {
            
        }
        print(resultName);
        
    }
    func coordinator(_ coordinator: PPCoordinator!, didOutputResults results: [PPRecognizerResult]!) {
        // Collect data from the result
        self.updateUiWithScanData(result2: results)
    }
}
extension ViewController
{
    // MARK: PPCoordinatorDelegate
    func coordinatorWithErrorForScan(error: NSErrorPointer) -> PPCameraCoordinator? {
        /** 0. Check if scanning is supported */
        if (PPCameraCoordinator.isScanningUnsupported(for: PPCameraType.back, error: error)) {
            return nil;
        }
        
        /** 4. Initialize the Scanning Coordinator object */
        
        let coordinator: PPCameraCoordinator = PPCameraCoordinator(settings: getPPSettings()!, delegate: nil)
        
        return coordinator
    }
    func coordinatorWithErrorForGallery(error: NSErrorPointer) -> PPCoordinator? {
        
        /** 4. Initialize the Scanning Coordinator object */
        let coordinator: PPCoordinator = PPCoordinator(settings: getPPSettings()!, delegate: self as PPCoordinatorDelegate)
        
        return coordinator
    }
    func getPPSettings() -> PPSettings? {
        /** 1. Initialize the Scanning settings */
        
        // Initialize the scanner settings object. This initialize settings with all default values.
        let settings: PPSettings = PPSettings()
        
        /** 2. Setup the license key */
        
        // Visit www.microblink.com to get the license key for your app
        settings.licenseSettings.licenseKey = appDelegate.mrzLicenseKey
        
        /**
         * 3. Set up what is being scanned. See detailed guides for specific use cases.
         * Remove undesired recognizers (added below) for optimal performance.
         */
        
        do { // Remove this if you're not using MRTD recognition
            
            // To specify we want to perform MRTD (machine readable travel document) recognition, initialize the MRTD recognizer settings
            let mrtdRecognizerSettings = PPMrtdRecognizerSettings()
            
            /** You can modify the properties of mrtdRecognizerSettings to suit your use-case */
            
            // tell the library to get full image of the document. Setting this to YES makes sense just if
            // settings.metadataSettings.dewarpedImage = YES, otherwise it wastes CPU time.
            mrtdRecognizerSettings.dewarpFullDocument = false;
            
            // Add MRTD Recognizer setting to a list of used recognizer settings
            settings.scanSettings.add(mrtdRecognizerSettings)
        }
        return settings
    }
    
}

