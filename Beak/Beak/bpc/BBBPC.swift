//
//  BBBPC.swift
//  Beak
//
//  Created by 马进 on 2016/12/6.
//  Copyright © 2016年 马进. All rights reserved.
//

import Foundation

import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import XCGLogger


open class BPCRequest: Mappable {
    var bpc: String?
    var id: String?
    var meta: BPCRequestMeta?
    var device: BPCDeviceInfo = BPCDeviceInfo()
    var method: String?
    var api: String?
    var params: BPCParams?
    
    public init(){
        
    }
    
    required public init?(map: Map) {
        
    }
    
    // Mappable
    open func mapping(map: Map) {
        bpc    <- map["bpc"]
        id     <- map["id"]
        method <- map["method"]
        meta   <- map["meta"]
        device <- map["device"]
        api    <- map["api"]
        params <- map["params"]
    }
}

open class BPCRequestMeta: Mappable{
    var userid: Int?
    var token: String?
    
    public init(){
        
    }
    
    required public init?(map: Map) {
        
    }
    
    // Mappable
    open func mapping(map: Map) {
        userid <- map["userid"]
        token  <- map["token"]
    }
}

open class BPCDeviceInfo: BPCParams{
    var deviceName: String?
    var systemName: String?
    var systemVersion: String?
    var deviceModel: String?
    var deviceId: String?
    var appVersion: String?
    
    public override init() {
        super.init()
        self.initDefualtData()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
        self.initDefualtData()
    }
    
    func initDefualtData(){
        self.deviceName = UIDevice.current.name
        self.deviceModel = UIDevice.current.model
        self.deviceId = UIDevice.current.identifierForVendor!.uuidString
        self.systemName = UIDevice.current.systemName
        self.systemVersion = UIDevice.current.systemVersion
        self.appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
    }
    
    open override func mapping(map: Map) {
        deviceName      <- map["deviceName"]
        deviceModel     <- map["deviceModel"]
        deviceId        <- map["deviceId"]
        systemName      <- map["systemName"]
        systemVersion   <- map["systemVersion"]
        appVersion      <- map["appVersion"]
    }
}

open class BPCParams: Mappable{
    public init(){
        
    }
    
    required public init?(map: Map) {
        
    }
    
    // Mappable
    open func mapping(map: Map) {
    }
}

open class BPCPageSearchParams: BPCParams{
    open var pageNum: Int?
    open var pageSize: Int?
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        pageNum    <- map["pageNum"]
        pageSize   <- map["pageSize"]
    }
}

open class BPCKeywordSearchParams: BPCPageSearchParams{
    open var keyword: String?
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        keyword   <- map["keyword"]
    }
}

open class BPCResponse<T : Mappable>: Mappable {
    var bpc: String?
    var id: String?
    var result: T?
    var error: BPCError?
    
    public init(){
        
    }
    
    required public init?(map: Map) {
        
    }
    
    // Mappable
    open func mapping(map: Map) {
        bpc    <- map["bpc"]
        id     <- map["id"]
        result <- map["result"]
        error  <- map["error"]
    }
}


open class BPCBaseResult: Mappable{
    
    public init(){
        
    }
    
    required public init?(map: Map) {
    }
    
    // Mappable
    open func mapping(map: Map) {
    }
}

open class BPCError: Mappable {
    open var status: Int?
    open var msg: String?
    open var errorName: String?
    open var originError: Error?
    
    public init(){
        
    }
    
    required public init?(map: Map) {
    }
    
    // Mappable
    open func mapping(map: Map) {
        status     <- map["status"]
        msg        <- map["msg"]
        errorName  <- map["errorName"]
    }
}


/// 用于内部，主要是result的延迟解析
fileprivate class BPCInnerResponse: Mappable{
    var bpc: String?
    var id: String?
    var result: AnyObject?
    var error: BPCError?
    
    public init(){
        
    }
    
    required public init?(map: Map) {
        
    }
    
    // Mappable
    open func mapping(map: Map) {
        bpc    <- map["bpc"]
        id     <- map["id"]
        result <- map["result"]
        error  <- map["error"]
    }
}


/// BPC util
open class BBBPCClient{
    
    /**
     * 如果设置了server, 调用的url 将会被视为 path, 最后请求地址是 server + path
     **/
    open var server: String?
    
    open var urlPath: String?
    
    open var userid: Int?
    
    open var token: String?
    
    open var timeout: TimeInterval = 10
    
    fileprivate var errorHandlers = Array<BBBPCErrorHandler>()
    
    public init(){
        
    }
    
    open func reset(){
        self.userid = nil
        self.token = nil
    }
    
    open func addErrorHandler(_ handler: BBBPCErrorHandler){
        self.errorHandlers.append(handler)
    }
    
    open func request<T: Mappable>(_ method: BBBPCMethod<T>, params: BPCParams, success: ((_ result: T?, _ error: BPCError?) -> Void)?){
        self.baseRequest(method.method, params: params, success: {response in
            var result: T?
            if let resultJson = response?.result{
                result = Mapper<T>().map(JSONObject: resultJson)
            }
            
            if let success = success{
                success(result, response?.error)
                self.processError(response?.error, for: method.method, isIgnoreErrorHandler: method.isIgnoreErrorHandler)
            }
            
            
        })
    }
    
    open func requestArray<T: Mappable>(_ method: BBBPCMethodForArray<T>, params: BPCParams, success: ((_ results: [T]?, _ error: BPCError?) -> Void)?){
        self.baseRequest(method.method, params: params, success: {response in
            var results: [T]?
            if let resultsJson = response?.result{
                results = Mapper<T>().mapArray(JSONObject: resultsJson)
            }
            
            if let success = success{
                success(results, response?.error)
                self.processError(response?.error, for: method.method, isIgnoreErrorHandler: method.isIgnoreErrorHandler)
            }
        })
    }
    
    fileprivate func baseRequest(_ method: String, params: BPCParams, success: @escaping (_ response: BPCInnerResponse?) -> Void){
        
        let requestBody = self.buildBPCRequestBody()
        requestBody.method = method
        requestBody.params = params
        let requestBodyJsonString = Mapper().toJSONString(requestBody)
        let urlString = self.buildUrl(self.urlPath!, bpcMethod: method)
        
        XCGLogger.info("request url: \(urlString) -> params request body is :\(requestBodyJsonString ?? "")")
        
        let url = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = requestBodyJsonString?.data(using: .utf8)
        urlRequest.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.timeoutInterval = self.timeout
        
        
        Alamofire.request(urlRequest).responseObject{ (response: DataResponse<BPCInnerResponse>) in
            
            guard let bpcInnerResponse = response.result.value else{
                let error = response.result.error
                XCGLogger.error(error)
                
                let errorResponse = BPCInnerResponse()
                errorResponse.error = BPCError()
                errorResponse.error?.msg = error?.localizedDescription
                errorResponse.error?.originError = error
                
                success(errorResponse)
                return
            }
            
            success(bpcInnerResponse)
        }
        
    }
    
    
    fileprivate func processError(_ error: BPCError?, for method: String, isIgnoreErrorHandler: Bool = false){
        guard let error = error else{
            return
        }
        
        if !isIgnoreErrorHandler{
            for handler in self.errorHandlers {
                handler.handler(error, for: method)
            }
        }
    }
    
    fileprivate func buildMethod(_ method: String){
        
    }
    
    fileprivate func getBaseRequestUrlParams() -> Dictionary<String, String>{
        var params = Dictionary<String, String>()
        params["timestamp"] = Date().timeIntervalSince1970.description
        return params
    }
    
    fileprivate func buildBPCRequestBody() -> BPCRequest{
        let result = BPCRequest()
        result.bpc = "1.0.0"
        result.id = UUID().uuidString
        let meta = BPCRequestMeta()
        meta.userid = userid
        meta.token = token
        result.meta = meta
        result.api = "1.0"
        return result
    }
    
    /**
     * 如果设置了server, 调用的url 将会被视为 path, 最后请求地址是 server + path
     **/
    fileprivate func buildUrl(_ url: String, bpcMethod: String) -> String{
        var finally = url
        if self.server != nil {
            finally = self.server! + finally
        }
        if finally.last != "/" {
            finally += "/"
        }
        
        finally += bpcMethod.replacingOccurrences(of: ".", with: "/")
        
        return finally
    }
    
    
}

public protocol BBBPCErrorHandler{
    func handler(_ error: BPCError, for method: String)
}

open class BBBPCMethodGroup{
    open var client: BBBPCClient
    
    public init(client: BBBPCClient){
        self.client = client
    }
}

public protocol BBBPCMethodProtocol{
    associatedtype ResultType
    
    func callback(_ callback: @escaping (_ result: ResultType?, _ error: BPCError?) -> Void)
    
    func request(_ params: BPCParams)
    
    func beforeRequest()
    
    func afterRequest(_ result: ResultType?, error: BPCError?)
    
    func afterCallBack(_ result: ResultType?, error: BPCError?)
    
    func with(isIgnoreErrorHandler: Bool) -> Self
    
    var isIgnoreErrorHandler: Bool {get set}
    
    var method: String {get set}
}

open class BBBPCMethod<R: Mappable> : BBBPCMethodProtocol{
    public typealias ResultType = R
    
    public var method: String
    public var client: BBBPCClient
    fileprivate var callback: ((R?, BPCError?) -> Void)?
    fileprivate var otherCompletion: [() -> Void] = []
    
    public var isIgnoreErrorHandler: Bool = false
    
    public init(method: String, client: BBBPCClient){
        self.method = method
        self.client = client
    }
    
    public func with(isIgnoreErrorHandler: Bool) -> Self{
        self.isIgnoreErrorHandler = isIgnoreErrorHandler
        return self
    }
    
    open func addOtherCompletion(_ completion: (() -> Void)?){
        if let completion = completion{
            self.otherCompletion.append(completion)
        }
    }
    
    public func callback(_ callback: @escaping (R?, BPCError?) -> Void) {
        self.callback = callback
    }
    
    public final func request(_ params: BPCParams) {
        self.beforeRequest()
        
        self.client.request(self, params: params, success: {(result: ResultType?, error) -> Void in
            self.afterRequest(result, error: error)
            if let callback = self.callback{
                callback(result, error)
            }
            self.afterCallBack(result, error: error)
            
            for completion in self.otherCompletion{
                completion()
            }
        })
    }
    
    open func buildRequester<T: BBBPCMethodProtocol>(_ method: T, params: BPCParams) -> BBBPCRequester<T>{
        return BBBPCRequester<T>(method: method, params: params)
    }
    
    open func beforeRequest(){}
    
    open func afterRequest(_ result: ResultType?, error: BPCError?){}
    
    open func afterCallBack(_ result: ResultType?, error: BPCError?){}
}

open class BBBPCMethodForArray<R: Mappable>: BBBPCMethodProtocol{
    public typealias ResultType = [R]
    
    open var method: String
    open var client: BBBPCClient
    fileprivate var callback: ((_ result: Array<R>?, _ error: BPCError?) -> Void)?
    fileprivate var otherCompletion: [() -> Void] = []
    
    public var isIgnoreErrorHandler: Bool = false
    
    public init(method: String, client: BBBPCClient){
        self.method = method
        self.client = client
    }
    
    public func with(isIgnoreErrorHandler: Bool) -> Self{
        self.isIgnoreErrorHandler = isIgnoreErrorHandler
        return self
    }
    
    open func addOtherCompletion(_ completion: (() -> Void)?){
        if let completion = completion{
            self.otherCompletion.append(completion)
        }
    }
    
    public func callback(_ callback: @escaping ([R]?, BPCError?) -> Void) {
        self.callback = callback
    }
    
    public final func request(_ params: BPCParams) {
        self.beforeRequest()
        
        self.client.requestArray(self, params: params, success: {(result: ResultType?, error) -> Void in
            self.afterRequest(result, error: error)
            if let callback = self.callback{
                callback(result, error)
            }
            self.afterCallBack(result, error: error)
            
            for completion in self.otherCompletion{
                completion()
            }
        })
    }
    
    open func buildRequester<T: BBBPCMethodProtocol>(_ method: T, params: BPCParams) -> BBBPCRequester<T>{
        return BBBPCRequester<T>(method: method, params: params)
    }
    
    open func beforeRequest(){}
    
    open func afterRequest(_ result: ResultType?, error: BPCError?){}
    
    open func afterCallBack(_ result: ResultType?, error: BPCError?){}
}

open class BBBPCRequester<T: BBBPCMethodProtocol>{
    open var method: T
    open var params: BPCParams
    
    public init(method: T, params: BPCParams){
        self.method = method
        self.params = params
    }
    
    open func callback(_ callback: @escaping (_ result: T.ResultType?, _ error: BPCError?) -> Void){
        self.method.callback(callback)
        self.method.request(self.params)
    }
}


open class BPCDateTransform: DateTransform {
    public static let share: BPCDateTransform = BPCDateTransform()
    
    open override func transformFromJSON(_ value: Any?) -> Date? {
        if let timeInt = value as? Double {
            let date = Date(timeIntervalSince1970: TimeInterval(timeInt / 1000.0))
//            let zone = TimeZone.current
//            let interval = TimeInterval(zone.secondsFromGMT(for: date))
//            return date.addingTimeInterval(interval)
            return date
        }
        return nil
    }
    
    open override func transformToJSON(_ value: Date?) -> Double? {
        if let date = value {
            return Double(date.timeIntervalSince1970) * 1000.0
        }
        return nil
    }
}

public class BPCTestScenic: Mappable{
    var address: String?
    
    required public init?(map: Map){}
    
    public func mapping(map: Map){
        address <- map["address"]
    }
}


public class BPCTestMethod: BBBPCMethodForArray<BPCTestScenic>{
    
    public func send() -> BBBPCRequester<BPCTestMethod>{
        
        return self.buildRequester(self, params: BPCParams())
    }
    
    
}








