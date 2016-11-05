import UIKit
import CoreData

var requestCount = 0

class MyURLProtocol: URLProtocol {
    
    var connection: NSURLConnection!
    var mutableData: NSMutableData!
    var response: URLResponse!
    
    override class func canInit(with request: URLRequest) -> Bool {
        
        if URLProtocol.property(forKey: "MyURLProtocolHandledKey", in: request) != nil {
            return false
        }
        
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override class func requestIsCacheEquivalent(_ aRequest: URLRequest,
                                                 to bRequest: URLRequest) -> Bool {
        return super.requestIsCacheEquivalent(aRequest, to:bRequest)
    }
    
    override func startLoading() {
        // 1
        let possibleCachedResponse = self.cachedResponseForCurrentRequest()
        if let cachedResponse = possibleCachedResponse {
            
            // 2
            let data = cachedResponse.value(forKey: "data") as! Data!
            let mimeType = cachedResponse.value(forKey: "mimeType") as! String!
            let encoding = cachedResponse.value(forKey: "encoding") as! String!
            
            // 3
            let response = URLResponse(url: self.request.url!, mimeType: mimeType, expectedContentLength: data!.count, textEncodingName: encoding)
            
            // 4
            self.client!.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            self.client!.urlProtocol(self, didLoad: data!)
            self.client!.urlProtocolDidFinishLoading(self)
        } else {
            // 5
            println("Serving response from NSURLConnection")
            
            let newRequest = NSMutableURLRequest(url: self.request.url!);
            URLProtocol.setProperty(true, forKey: "MyURLProtocolHandledKey", in: newRequest)
            self.connection = NSURLConnection(request: newRequest as URLRequest, delegate: self)
        }
    }
    
    override func stopLoading() {
        if self.connection != nil {
            self.connection.cancel()
        }
        self.connection = nil
    }
    
    func connection(_ connection: NSURLConnection!, didReceiveResponse response: URLResponse!) {
        self.client!.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        
        self.response = response
        self.mutableData = NSMutableData()
    }
    
    func connection(_ connection: NSURLConnection!, didReceiveData data: Data!) {
        self.client!.urlProtocol(self, didLoad: data)
        self.mutableData.append(data)
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection!) {
        self.client!.urlProtocolDidFinishLoading(self)
        self.saveCachedResponse()
    }
    
    func connection(_ connection: NSURLConnection!, didFailWithError error: NSError!) {
        self.client!.urlProtocol(self, didFailWithError: error)
    }
    
    func saveCachedResponse () {
        println("Saving cached response")
        
        // 1
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.managedObjectContext!
        
        // 2
        let cachedResponse = NSEntityDescription.insertNewObject(forEntityName: "CachedURLResponse", into: context) as NSManagedObject
        
        cachedResponse.setValue(self.mutableData, forKey: "data")
        cachedResponse.setValue(self.request.url!.absoluteString, forKey: "url")
        cachedResponse.setValue(Date(), forKey: "timestamp")
        cachedResponse.setValue(self.response.mimeType, forKey: "mimeType")
        cachedResponse.setValue(self.response.textEncodingName, forKey: "encoding")
        
        
        do {
            try context.save()
        } catch {
           // fatalError("Failure to save context: \(error)")
        }
        
    }
    
    func cachedResponseForCurrentRequest() -> NSManagedObject? {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription.entity(forEntityName: "CachedURLResponse", in: context)
        fetchRequest.entity = entity
        
        let predicate = NSPredicate(format:"url == %@", self.request.url!.absoluteString)
        fetchRequest.predicate = predicate
        
        do {
            let result = try context.fetch(fetchRequest)
                as! [NSManagedObject]
            
            
            
                if !result.isEmpty {
                    return result[0]
                }
            
        } catch {
           
        }
        
        
        return nil
    }
    func println(_ arg:String){
        
    }
}
