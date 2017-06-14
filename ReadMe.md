 
 **Eg:**
 
 **//MARK: Post Request**
 
 ```sh
    
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
```

**NSURLSession written by TTung**


