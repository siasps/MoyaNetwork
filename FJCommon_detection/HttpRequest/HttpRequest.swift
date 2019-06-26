//
//  HttpRequest.swift
//  FJCommon_detection
//
//  Created by peng on 2019/6/26.
//  Copyright © 2019 peng. All rights reserved.
//

import Foundation
import Moya

enum HttpRequest {
    case shujuList(channnel:String , pn:Int , ps:Int) //列表数据请求,带有相关值的枚举，
    case othetRequest(str:String) //带一个参数的请求
    case getExperimentList
    case otherRequest2 //不带参数的请求
}

extension HttpRequest : TargetType{
    
    //服务器地址
    var baseURL: URL {
        return URL(string:"http://localhost:8081")!
    }
    
    //各个请求的具体路径
    var path: String {
        switch self {
        case .shujuList:
            return "ArticleList"
        case .othetRequest:
            return "someOtherPath"
        case .getExperimentList:
            return "/suite/get/experiment_list"
        default:
            return ""
        }
    }
    
    //请求方式
    var method: Moya.Method {
        return .get
    }
    
    //请求任务事件（这里附带上参数）
    var task: Task {
        var param:[String:Any] = [:]
        
        switch self {
        case let .shujuList(channel , pn , ps):
            param["Type"] = channel
            param["pageNo"] = pn
            param["pageSize"] = ps
        case let .othetRequest(str):
            param["str"] = str
        default:
            //不需要传参数的走这里
            return .requestPlain
        }
        return .requestParameters(parameters: param, encoding: URLEncoding.default)
        
    }
    
    //是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
    
    //这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    //设置请求头
    public var headers: [String: String]? {
        return nil
    }
}

