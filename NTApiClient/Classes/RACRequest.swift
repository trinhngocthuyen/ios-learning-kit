//
//  RAC_Request.swift
//  NTKit
//
//  Created by Thuyen Trinh on 03/31/2017.
//  Copyright (c) 2017 Thuyen Trinh. All rights reserved.
//

import ReactiveSwift
import Alamofire
import NTExtensions
import NTReactive
import SwiftyJSON

// MARK: - RAC Request
public enum RACRequestError: Error {
    case failedParsing
    
}

/// Request to get a JSON
public func rac_requestJSON(
    _ url: URLConvertible,
    method: HTTPMethod = .get,
    params: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: HTTPHeaders? = nil
    ) -> SignalProducer<JSON, NSError>
{
    return SignalProducer { observer, disposable in
        Alamofire.request(url, method: method, parameters: params, encoding: encoding, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    observer.send(value: JSON(value))
                    observer.sendCompleted()
                case .failure(let error):
                    observer.send(error: error as NSError)
                }
        }
    }
}

/// Request to get a JSONDecodable object
public func rac_request<T: NTJSONDecodable>(
    _ url: URLConvertible,
    method: HTTPMethod = .get,
    params: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: HTTPHeaders? = nil,
    toObject: @escaping (JSON) -> T? = { T.from(json: $0) }
    ) -> SignalProducer<T, NSError>
{
    return rac_requestJSON(url, method: method, params: params, encoding: encoding, headers: headers)
        .flatMap(.latest) { json -> SignalProducer<T, NSError> in
            if let object = toObject(json) {
                return SignalProducer(value: object)
            }
            return SignalProducer(error: RACRequestError.failedParsing as NSError)
    }
}

/// Request to get a list of JSONDecodable objects
public func rac_request<T: NTJSONDecodable>(
    _ url: URLConvertible,
    method: HTTPMethod = .get,
    params: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: HTTPHeaders? = nil,
    toArrayJSON: @escaping (JSON) -> JSON = { $0 }
    ) -> SignalProducer<[T], NSError>
{
    return rac_requestJSON(url, method: method, params: params, encoding: encoding, headers: headers)
        .flatMap(.latest) { json -> SignalProducer<[T], NSError> in
            if let jsonArrays = toArrayJSON(json).array {
                let objects = jsonArrays.flatMap { T.from(json: $0) }
                return SignalProducer(value: objects)
            }
            return SignalProducer(error: RACRequestError.failedParsing as NSError)
    }
}

// MARK: - RAC Paging Request
public struct PagingConfig {
    var initialParams: Parameters? = nil
    var nextPageParamsMaker: ((Parameters) -> Parameters?)?  = nil
    public init(initial initialParams: Parameters?, nextPageParamsMaker: ((Parameters) -> Parameters?)?  = nil) {
        self.initialParams = initialParams
        self.nextPageParamsMaker = nextPageParamsMaker
    }
    
    func nextPagingConfig() -> PagingConfig {
        var nextInitialParams: Parameters?
        if let maker = nextPageParamsMaker {
            nextInitialParams = initialParams.flatMap { maker($0) }
        }
        
        return PagingConfig(initial: nextInitialParams, nextPageParamsMaker: nextPageParamsMaker)
    }
}

private func rac_pagingRequestRecursively<T: NTJSONDecodable>(
    _ url: URLConvertible,
    method: HTTPMethod = .get,
    params: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: HTTPHeaders? = nil,
    toArrayJSON: @escaping (JSON) -> JSON = { $0 },
    objectsSoFar: [T],
    pagingConfig: PagingConfig,     // (skip, offset), (page, per_page)...
    exitCondition: @escaping ([T], [T]) -> Bool
    ) -> SignalProducer<[T], NSError> {
    
    let paramsWithPaging = params?.mergedChooseMine(with: pagingConfig.initialParams)
    
    let onePageProducer: SignalProducer<[T], NSError> = rac_request(
        url, method: method,
        params: paramsWithPaging, encoding: encoding, headers: headers,
        toArrayJSON: toArrayJSON
    )
    
    return onePageProducer
        .flatMap(.latest) { objects -> SignalProducer<[T], NSError> in
            if exitCondition(objectsSoFar, objects) {
                return SignalProducer(value: objectsSoFar + objects)
            }
            
            return rac_pagingRequestRecursively(
                url, method: method,
                params: params,
                encoding: encoding, headers: headers,
                toArrayJSON: toArrayJSON,
                objectsSoFar: objectsSoFar + objects,
                pagingConfig: pagingConfig.nextPagingConfig(),
                exitCondition: exitCondition
            )
        }
}

public func rac_pagingRequest<T: NTJSONDecodable>(
    _ url: URLConvertible,
    method: HTTPMethod = .get,
    params: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: HTTPHeaders? = nil,
    toArrayJSON: @escaping (JSON) -> JSON = { $0 },
    pagingConfig: PagingConfig,     // (skip, offset), (page, per_page)...
    exitCondition: @escaping ([T], [T]) -> Bool
    ) -> SignalProducer<[T], NSError> {
    
    return rac_pagingRequestRecursively(
        url, method: method,
        params: params,
        encoding: encoding, headers: headers,
        toArrayJSON: toArrayJSON,
        objectsSoFar: [],
        pagingConfig: pagingConfig,
        exitCondition: exitCondition
        )
        .take(first: 1)
}

