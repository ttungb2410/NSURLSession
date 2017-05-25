//
//  ContactListVC.swift
//  NSURLSession
//
//  Created by Thanh Tung on 6/20/17.
//  Copyright © 2017 Thanh Tung. All rights reserved.
//

import UIKit

let baseURL: String! = "http://localhost:2403/information/"
var functionNameTmp: String!
var idContactTmp: String? = nil
var nameContactTmp: String? = nil
var phoneContactTmp: String? = nil
var cityContactTmp: String? = nil
var emailContactTmp: String? = nil

class ContactListVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var myTableView: UITableView!
//    var delegate: FunctionName!
    var information = [Person]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        navigationItem.title = "Contact List"
        navigationItem.rightBarButtonItem = addBarButton()
        
        getInformationRequest()
    
    }
    
    // MARK: TableView configuration
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return information.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") as! DetailContactCell
        
        let person = information[indexPath.row]
        
        cell.updateUI(person: person)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "DELETE") { (rowAction, indexPath) in
                self.deleteRequest(indexPath: indexPath as NSIndexPath)
        }
        
        delete.backgroundColor = UIColor(red: 244/255, green: 117/255, blue: 100/255, alpha: 1.0)
        
        let edit = UITableViewRowAction(style: .normal, title: "EDIT") { (rowAction, indexPath) in
            let addNewContact = self.storyboard?.instantiateViewController(withIdentifier: "AddNewContactVC") as! AddNewContactVC
            let id = self.information[indexPath.row].id
            let name = self.information[indexPath.row].name
            let phone = self.information[indexPath.row].phoneNumber
            let city = self.information[indexPath.row].city
            let email = self.information[indexPath.row].email

            functionNameTmp = "EDIT CONTACT"
            idContactTmp = id
            nameContactTmp = name
            phoneContactTmp = String(phone!)
            cityContactTmp = city
            emailContactTmp = email
            
            addNewContact.delegate = self
            self.displayContentController(addNewContact)
//            self.delegate?.functionName(funcName: "EDIT CONTACT")
//            self.delegate?.idContact(id: id!)
        }
        return[delete,edit]
    }
    
    func deleteRequest(indexPath: NSIndexPath){
        let id = information[indexPath.row].id
        
        var urlRequest = URLRequest(url: NSURL(string: baseURL + id!)! as URL)
        
        urlRequest.httpMethod = "DELETE"
        let configureSession = URLSessionConfiguration.default
        let session = URLSession(configuration: configureSession)
        
        let task =  session.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
            if let error = error{
                print(error.localizedDescription)
            }else{
                if let httpResponse = response as? HTTPURLResponse{
                    if httpResponse.statusCode == 200{
                        self.information.remove(at: indexPath.row)
                        
                        DispatchQueue.main.async {
                            self.myTableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
                        }
                    }else{
                        print(httpResponse.statusCode)
                    }
                }
            }
        })
        task.resume()
    }
    
    
    //MARK: Get Data Request
    
    func getInformationRequest()  {
        let urlRequest =  URLRequest(url: NSURL(string: baseURL) as! URL)
        
        let session = URLSession.shared
        
       let task =  session.dataTask(with: urlRequest) {(data , response, error )  in
            
            if let error = error {
                print(error.localizedDescription)
            }else{
                if let responseHTTP = response as? HTTPURLResponse{
                   if responseHTTP.statusCode == 200 {
                    guard let information = data else {return}
                    
                    do{
                        let result = try JSONSerialization.jsonObject(with: information, options: JSONSerialization.ReadingOptions.allowFragments)
                        
                        if let arrayResult : AnyObject = result as AnyObject? {
                            for infoDict in arrayResult as! [AnyObject]{
                                if let infoDict = infoDict as? [String : AnyObject]{
                                    print(infoDict)
                                    
                                    self.information.append(Person(information: infoDict))
                                    DispatchQueue.main.async {
                                        self.myTableView.reloadData()
                                    }
                                }
                            }
                        }
                        
                    }catch let error as NSError{
                        print(error.description)
                    }
                   }else{
                    print(responseHTTP.statusCode)
                    }
                }
            }
        }
        task.resume()
    }
       
    //MARK: Create BarButton
    
    func addBarButton() -> UIBarButtonItem{
        
        let addNewContactBarButton = UIBarButtonItem(image: UIImage(named: "Add New Bar Button")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(addNewContact(_:)))
        
        return addNewContactBarButton
    }
    
    func addNewContact(_ sender : AnyObject) {
        functionNameTmp = "ADD NEW CONTACT"
        let addNewContact = storyboard?.instantiateViewController(withIdentifier: "AddNewContactVC") as! AddNewContactVC
        
        addNewContact.delegate = self
        displayContentController(addNewContact)
//        self.delegate?.functionName(funcName: "ADD NEW CONTACT")

    }
    
// MARK: Create Popup
    
    var blurView : UIView?
    var popUpVC : AddNewContactVC?
    
    func createBlurView() -> UIView {
        let blurView = UIView(frame: view.bounds)
        blurView.backgroundColor = UIColor.black
        blurView.alpha = 0.5
        
        return blurView
    }
    
    func displayContentController(_ content : AddNewContactVC) {
        
        popUpVC = content
        
        blurView = createBlurView()
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapDismissGesture(_:)))
        blurView?.addGestureRecognizer(dismissTapGesture)
        
        view.addSubview(blurView!)
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        addChildViewController(content)
        content.view.bounds = CGRect(x: 0, y: 0, width: view.bounds.width / 1.2, height: view.bounds.height / 1.3)
        content.view.alpha = 0.5
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.transitionFlipFromBottom, animations: {
            
            content.view.alpha = 1.0
            content.view.center = CGPoint(x: self.view.bounds.width / 2.0, y: self.view.bounds.height / 2.0)
            self.view.addSubview(content.view)
            content.didMove(toParentViewController: self)
            
            }, completion: nil)
        
    }
    
    
    
    func animateDismissAddNewContactView(_ addNewVC : AddNewContactVC) {
        let bounds = addNewVC.view.bounds
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions(), animations: {
            
            addNewVC.view.alpha = 0.5
            addNewVC.view.center = CGPoint(x: self.view.bounds.width / 2.0, y: -bounds.height)
            self.blurView?.alpha = 0.0
            
        }){(Bool) in
            addNewVC.view.removeFromSuperview()
            addNewVC.removeFromParentViewController()
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.blurView?.removeFromSuperview()
            idContactTmp = nil
            nameContactTmp = nil
            phoneContactTmp = nil
            cityContactTmp = nil
            emailContactTmp = nil

        }
        
    }
    
    func tapDismissGesture(_ tapGesture : UITapGestureRecognizer) {
        animateDismissAddNewContactView(popUpVC!)
    }
}

extension ContactListVC : AddNewContactDelegate{
    func dissmissAddNewContactController(addNewVC: AddNewContactVC) {
        animateDismissAddNewContactView(addNewVC)
        
        information.removeAll()
        
        getInformationRequest()
    }
}



