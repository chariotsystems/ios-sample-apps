import UIKit
import CoreData

var requestCount = 0

@objc class MyURLProtocol: URLProtocol {
  
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
  
  override class func requestIsCacheEquivalent(_ a: URLRequest,
    to b: URLRequest) -> Bool {
    return super.requestIsCacheEquivalent(_:a, to:b)
  }
  
  override func startLoading() {
    let possibleCachedResponse = self.cachedResponseForCurrentRequest()
    if let cachedResponse = possibleCachedResponse {

      let data = cachedResponse.value(forKey: "data") as! NSData!
      let mimeType = cachedResponse.value(forKey: "mimeType") as! String!
      let encoding = cachedResponse.value(forKey: "encoding") as! String!
      
      let response = URLResponse(URL: self.request.URL, MIMEType: mimeType, expectedContentLength: data.length, textEncodingName: encoding)
      
      self.client!.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: .NotAllowed)
      self.client!.URLProtocol(self, didLoadData: data)
      self.client!.URLProtocolDidFinishLoading(self)
    } else {
      
      var newRequest = self.request.mutableCopy() as NSMutableURLRequest
      URLProtocol.setProperty(true, forKey: "MyURLProtocolHandledKey", inRequest: newRequest)
      self.connection = NSURLConnection(request: newRequest, delegate: self)
    }
  }
  
  override func stopLoading() {
    if self.connection != nil {
      self.connection.cancel()
    }
    self.connection = nil
  }
  
  func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
    self.client!.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: .NotAllowed)
    
    self.response = response
    self.mutableData = NSMutableData()
  }
  
  func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
    self.client!.URLProtocol(self, didLoadData: data)
    self.mutableData.appendData(data)
  }
  
  func connectionDidFinishLoading(connection: NSURLConnection!) {
    self.client!.URLProtocolDidFinishLoading(self)
    self.saveCachedResponse()
  }
  
  func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
    self.client!.URLProtocol(self, didFailWithError: error)
  }
  
  func saveCachedResponse () {
    println("Saving cached response")
    
    // 1
    let delegate = UIApplication.sharedApplication().delegate as AppDelegate
    let context = delegate.managedObjectContext!
    
    // 2
    let cachedResponse = NSEntityDescription.insertNewObjectForEntityForName("CachedURLResponse", inManagedObjectContext: context) as NSManagedObject
    
    cachedResponse.setValue(self.mutableData, forKey: "data")
    cachedResponse.setValue(self.request.URL.absoluteString, forKey: "url")
    cachedResponse.setValue(NSDate(), forKey: "timestamp")
    cachedResponse.setValue(self.response.MIMEType, forKey: "mimeType")
    cachedResponse.setValue(self.response.textEncodingName, forKey: "encoding")
    
    // 3
    var error: NSError?
    let success = context.save(&error)
    if !success {
      println("Could not cache the response")
    }
  }
  
  func cachedResponseForCurrentRequest() -> NSManagedObject? {
    // 1
    let delegate = UIApplication.sharedApplication().delegate as AppDelegate
    let context = delegate.managedObjectContext!
    
    // 2
    let fetchRequest = NSFetchRequest()
    let entity = NSEntityDescription.entityForName("CachedURLResponse", inManagedObjectContext: context)
    fetchRequest.entity = entity
    
    // 3
    let predicate = NSPredicate(format:"url == %@", self.request.URL.absoluteString!)
    fetchRequest.predicate = predicate
    
    // 4
    var error: NSError?
    let possibleResult = context.executeFetchRequest(fetchRequest, error: &error) as Array<NSManagedObject>?
    
    // 5
    if let result = possibleResult {
      if !result.isEmpty {
        return result[0]
      }
    }
    
    return nil
  }
}
