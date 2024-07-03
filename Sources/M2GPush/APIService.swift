//
//  File.swift
//  
//
//  Created by platib on 7/3/24.
//

import Foundation

class APIService {
    static let baseUrl = "https://dev-api.message.to-go.io"
    
    static func registerFCMToken(token: String, appKey: String, userKey: String, completion: @escaping (Error?) -> Void) {
        let url = URL(string: "\(baseUrl)/user/push/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "token": token,
            "appKey": appKey,
            "phoneNumber": userKey
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                let error = NSError(domain: "APIService", code: statusCode, userInfo: nil)
                completion(error)
                return
            }
            
            completion(nil)
        }
        
        task.resume()
    }
    
    
    static func subscribeTopic(token: String, appKey: String, topic: String, completion: @escaping (Error?) -> Void) {
        let url = URL(string: "\(baseUrl)/user/push/topic/subscribe")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "token": token,
            "appKey": appKey,
            "topic": topic
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                let error = NSError(domain: "APIService", code: statusCode, userInfo: nil)
                completion(error)
                return
            }
            
            completion(nil)
        }
        
        task.resume()
    }
    
    static func unSubscribeTopic(token: String, appKey: String, topic: String, completion: @escaping (Error?) -> Void) {
        let url = URL(string: "\(baseUrl)/user/push/topic/unsubscribe")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "token": token,
            "appKey": appKey,
            "topic": topic
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                let error = NSError(domain: "APIService", code: statusCode, userInfo: nil)
                completion(error)
                return
            }
            
            completion(nil)
        }
        
        task.resume()
    }
}
