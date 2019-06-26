//
//  ProviderError.swift
//  FJCommon_detection
//
//  Created by peng on 2019/6/25.
//  Copyright © 2019 peng. All rights reserved.
//

import Foundation
import Moya
import Result
import SwiftyJSON

enum ProviderError: LocalizedError {
    case server
    case data
    case message(msg: String)
    
    var description: String {
        switch self {
        case .server:
            return "Failed to connect to server"
        case .data:
            return "Failed to get data"
        case .message(let msg):
            return msg
        }
    }
}

let networkPlugin = NetworkActivityPlugin { (change, _) in
    switch(change){
    case .ended:
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    case .began:
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
}

let scanClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<HttpManager>.RequestResultClosure) in
    do {
        var request: URLRequest = try endpoint.urlRequest()
        request.timeoutInterval = 30
        done(.success(request))
    } catch  {
        print("\(error)")
    }
}

class ScanProvider {
    
    static let shared = ScanProvider()
    
    let provider = MoyaProvider<HttpManager>(requestClosure: scanClosure, plugins: [networkPlugin])
    
    private func failureAction(error: ProviderError) {
//        if NetworkingManager.status == .none || NetworkingManager.status == .unknown {
//            Toast.showMessage(message: NetworkingManager.status.description)
//        } else {
//            Toast.showMessage(message: error.description)
//        }
    }
    
    func qrLogin(appname: String,
                 nonce: String,
                 address: String,
                 completion: @escaping (Result<Bool, ProviderError>) -> Void) {
        provider.request(.qrLogin(
            appname: appname,
            nonce: nonce,
            address: address)) { result in
                switch result {
                case .success(let responseData):
                    if let response = self.JSONResponseFormatter(data: responseData.data) {
                        print(response)
                        if let status = response["state"] as? Int {
                            completion(.success(status == 1 ? true : false))
                        }
                    }
                case .failure(_):
                    self.failureAction(error: .server)
                    completion(.failure(.server))
                }
        }
    }
    
    
    func JSONResponseFormatter(data:Data) -> Dictionary<String, Any>? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let dic = json as! Dictionary<String, Any>
            return dic
        } catch _ {
            return nil
        }
    }
    
    func qrLoginConfirm(appname: String,
                        nonce: String,
                        address: String,
                        confirm: String,
                        completion: @escaping (Result<Bool, ProviderError>) -> Void) {
        provider.request(.qrLoginConfirm(
            appname: appname,
            nonce: nonce,
            address: address,
            confirm: confirm)) { result in
                switch result {
                case .success(let responseData):
                    if let response = self.JSONResponseFormatter(data: responseData.data) {
                        print(response)
                        if let status = response["state"] as? Int {
                            completion(.success(status == 1 ? true : false))
                        }
                    }
                case .failure(_):
                    self.failureAction(error: .server)
                    completion(.failure(.server))
                }
        }
    }
    
    
    func getExperimentList(completion: @escaping (Result<Bool, ProviderError>) -> Void) {
        provider.request(.getExperimentList) { (result) in
            switch result{
            case .success(let responseData):
                if let response = self.JSONResponseFormatter(data: responseData.data) {
                    print(response)
                    //completion(.success(status == 1 ? true : false))
                    completion(.success(true))
                }
            case .failure(_):
                self.failureAction(error: .server)
                completion(.failure(.server))
            }
        }
    }
}

