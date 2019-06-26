//
//  HttpManager.swift
//  FJCommon_detection
//
//  Created by peng on 2019/6/25.
//  Copyright © 2019 peng. All rights reserved.
//

import Foundation
import Moya


enum HttpManager {
    case qrLogin(appname: String, nonce: String, address: String)
    case qrLoginConfirm(appname: String, nonce: String, address: String, confirm: String)
    case getExperimentList
}

extension HttpManager: TargetType {
    
    var headers: [String : String]? {
        return ["Content-type" : "application/json"]
    }
    
    var baseURL: URL {
        return URL(string: "http://192.168.0.115:8081")!
    }
    
    var path: String {
        switch self {
        case .qrLogin(_):
            return "/qrlogin"
        case .qrLoginConfirm(_):
            return "/qrconfirm"
            
        case .getExperimentList:
            return"/suite/get/experiment_list"
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .qrLogin(_):
            return .get
        case .getExperimentList:
            return .get
        default:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        var paramsDict: [String : Any] = [:]
        switch self {
        case .qrLogin(let appname, let nonce, let address):
            paramsDict["appname"] = appname
            paramsDict["nonce"] = nonce
            paramsDict["address"] = address
        case .qrLoginConfirm(let appname, let nonce, let address, let confirm):
            paramsDict["appname"] = appname
            paramsDict["nonce"] = nonce
            paramsDict["address"] = address
            paramsDict["confirm"] = confirm
            
        case .getExperimentList: break
            
        }
        return paramsDict
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .qrLogin(_):
            return .requestParameters(parameters: parameters ?? [:], encoding: URLEncoding.default)//get方式参数拼接成url
        case .getExperimentList:
            return .requestParameters(parameters: parameters ?? [:], encoding: URLEncoding.default)
        default:
            return .requestParameters(parameters: parameters ?? [:], encoding: JSONEncoding.default)//post方式参数是json格式
        }
    }
    
}

