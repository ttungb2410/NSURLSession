//
//  AddNewContactVC.swift
//  NSURLSession
//
//  Created by Thanh Tung on 6/20/17.
//  Copyright © 2017 Thanh Tung. All rights reserved.
//
import UIKit

protocol AddNewContactDelegate{
    func dissmissAddNewContactController(addNewVC: AddNewContactVC)
}
//protocol FunctionName {
//    func functionName(funcName: String)
//    func idContact(id: String)
//}

class AddNewContactVC: UIViewController{

    
    @IBOutlet weak var bannerView: UIView!
    
    @IBOutlet weak var nameTextField: CustomTextField!
    
    @IBOutlet weak var phoneTextField: CustomTextField!
    
    @IBOutlet weak var cityTextField: CustomTextField!
    
    @IBOutlet weak var emailTextField: CustomTextField!
    
    @IBOutlet weak var navLabel: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    
    var delegate : AddNewContactDelegate?
    var functionName:String?
    var information = [Person]()
    var idContact: String?
    var contactListVC: ContactListVC?
    var baseU: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        phoneTextField.delegate = self
        cityTextField.delegate = self
        emailTextField.delegate = self
//        self.contactListVC = ContactListVC()
//        self.contactListVC?.delegate = self
        self.navLabel.text = functionNameTmp
        self.idContact = idContactTmp
        self.phoneTextField.text = phoneContactTmp
        self.nameTextField.text = nameContactTmp
        self.cityTextField.text = cityContactTmp
        self.emailTextField.text = emailContactTmp
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setMask(view, rectCorner: [.bottomLeft,.bottomRight, .topLeft, .topRight], radius: CGSize(width: 20.0, height: 20.0))
        setMask(bannerView, rectCorner: [.topLeft, .topRight], radius: CGSize(width: 20.0, height: 20.0))
        
    }
    
//    internal func functionName(funcName: String) {
//        navLabel.text = funcName
//    }
//    internal func idContact(id: String) {
//        self.idContact = id
//    }

    //MARK: Post Request
    
    func createNewContactRequest(name: String, numberPhone: Int, city: String?, email: String?){
        var param : [String : AnyObject] = ["Name" : name as AnyObject, "PhoneNumber" : numberPhone as AnyObject]
        
        if city != nil{
            param["City"] = city as AnyObject?
        }
        if email != nil{
            param["Email"] = email as AnyObject?
        }
        let urlRequest = NSMutableURLRequest(url: NSURL(string: baseURL)! as URL)
        urlRequest.httpMethod = "POST"
        
        let configureSession = URLSessionConfiguration.default
        
        configureSession.httpAdditionalHeaders = ["Content-Type" : "application/json"]
        let createContactSession = URLSession(configuration: configureSession)
        
        let dataPassing = try! JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
        createContactSession.uploadTask(with: urlRequest as URLRequest, from: dataPassing) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }else{
                if let responseHTTP = response as? HTTPURLResponse{
                    if responseHTTP.statusCode == 200{
                        print(data)
                        
                        DispatchQueue.main.async {
                            self.delegate?.dissmissAddNewContactController(addNewVC: self)
                        }
                    }else{
                        print(responseHTTP.statusCode)
                    }
                }
            }
            }.resume()
        
    }
    //MARK: Put Requset
    
    func editRequest(id: String, name: String, numberPhone: Int, city: String?, email: String?){
        var param : [String : AnyObject] = ["Name" : name as AnyObject, "PhoneNumber" : numberPhone as AnyObject]
        
        if city != nil{
            param["City"] = city as AnyObject?
        }
        if email != nil{
            param["Email"] = email as AnyObject?
        }
        let urlRequest = NSMutableURLRequest(url: NSURL(string: baseURL + id)! as URL)
        urlRequest.httpMethod = "PUT"
        
        let configureSession = URLSessionConfiguration.default
        
        configureSession.httpAdditionalHeaders = ["Content-Type" : "application/json"]
        let createContactSession = URLSession(configuration: configureSession)
        
        let dataPassing = try! JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
        createContactSession.uploadTask(with: urlRequest as URLRequest, from: dataPassing) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }else{
                if let responseHTTP = response as? HTTPURLResponse{
                    if responseHTTP.statusCode == 200{
                        print(data)
                        
                        DispatchQueue.main.async {
                            self.delegate?.dissmissAddNewContactController(addNewVC: self)
                        }
                    }else{
                        print(responseHTTP.statusCode)
                    }
                }
            }
            }.resume()
        
    }


    
    // MARK: Create corner roundrect.
    
    func setMask(_ view : UIView, rectCorner : UIRectCorner, radius : CGSize){
        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: rectCorner, cornerRadii: radius)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.borderWidth = 1.0
        maskLayer.borderColor = UIColor.black.cgColor
        
        view.layer.mask = maskLayer
        
    }
    
    @IBAction func addNewContactAction(_ sender: AnyObject) {

        
        if let name = nameTextField.text, let phone = Int(phoneTextField.text!){
            if self.navLabel.text == "ADD NEW CONTACT"{
               
            createNewContactRequest(name: name, numberPhone: phone, city: cityTextField.text, email: emailTextField.text )
            }
            else if self.navLabel.text == "EDIT CONTACT"{
                               editRequest(id: idContactTmp!, name: name, numberPhone: phone, city: cityTextField.text, email: emailTextField.text)
                idContactTmp = nil
                nameContactTmp = nil
                phoneContactTmp = nil
                cityContactTmp = nil
                emailContactTmp = nil
            }
            

            
        }else{
            print("no name no phone")
        }
        
    }
}


extension AddNewContactVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setValue(UIColor.clear, forKeyPath: "_placeholderLabel.textColor")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setValue(UIColor.black, forKeyPath: "_placeholderLabel.textColor")
    }
}
