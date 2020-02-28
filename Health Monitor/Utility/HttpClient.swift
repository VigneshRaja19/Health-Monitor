//
//  HttpClient.swift
//  Health Monitor
//
//  Created by Prabhakar Annavi on 26/02/20.
//  Copyright © 2020 Prabhakar Annavi. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias HTTPHeaders = [String: String]
typealias Parameters = [String: Any]

public enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}

class HttpClient {

    let session = URLSession.shared

    ///Post request
    func postRequest(url: String, headers: HTTPHeaders?, parameters: Parameters?, body: Data?, sucCompletionHandler: @escaping (JSON) -> (), error: @escaping (String) -> ()) {


        var urlComponents = URLComponents(string: url)

        var queryItems = [URLQueryItem]()

        urlComponents?.queryItems = nil

        if let param = parameters, !param.isEmpty {

            for (key, value) in param {
                queryItems.append(URLQueryItem(name: key, value: value as? String))
            }

            urlComponents?.queryItems = queryItems

        }


        guard let url_comp_url = urlComponents?.url else { return }

        print("***Post Request with Body URL ***",url_comp_url)

        var urlReq = URLRequest.init(url: url_comp_url)
        urlReq.allHTTPHeaderFields = headers
        urlReq.httpMethod = HTTPMethod.post.rawValue
        urlReq.httpBody = body
        urlReq.cachePolicy = .reloadIgnoringLocalCacheData
        urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")

        session.dataTask(with: urlReq) { (data, response, e) in
            do {
                if let d = data {
                    let jsonObj = try JSON(data: d)
                    print("jsonObj", jsonObj)
                    sucCompletionHandler(jsonObj)
                } else {
                    //show alert - no repsonse
                    error("No data found")
                }

            } catch let err {
                error(err.localizedDescription)

                print("caoughtException", err.localizedDescription)
            }

            if let e = e {

                print("Error Response", e.localizedDescription)

                error(e.localizedDescription)

            }


            }.resume()

    }


    ///Get request
    func getRequest(url: String, headers: HTTPHeaders?, parameters: Parameters?, sucCompletionHandler: @escaping (JSON) -> (), error: @escaping (String) -> ()) {

        var urlComponents = URLComponents(string: url)

        var queryItems = [URLQueryItem]()

        urlComponents?.queryItems = nil

        if let param = parameters, !param.isEmpty {
            for (key, value) in param {
                queryItems.append(URLQueryItem(name: key, value: value as? String))

            }

            urlComponents?.queryItems = queryItems

        }


        guard let url_comp_url = urlComponents?.url else { return }
        //        print("createdURL",url_comp_url)

        var urlReq = URLRequest.init(url: url_comp_url)
        urlReq.allHTTPHeaderFields = headers
        urlReq.httpMethod = HTTPMethod.get.rawValue
        urlReq.httpBody = nil             // Get request no need of body
        urlReq.cachePolicy = .reloadIgnoringLocalCacheData

        print("***GetRequestURL***",urlReq)

        session.dataTask(with: urlReq) { (data, response, e) in
            do {
                if let d = data {
                    let jsonObj = try JSON(data: d)
                    print("jsonObj", jsonObj)
                    sucCompletionHandler(jsonObj)
                } else {
                    //show alert - no repsonse
                    print("NO response data found")
                    error("No data found")
                }

            } catch let err {
                error(err.localizedDescription)

                print("caoughtException", err.localizedDescription)
            }

            if let e = e {

                print("Error Response", e.localizedDescription)

                error(e.localizedDescription)

            }


        }.resume()

    }


    ///Downloads images from URL
    func downloadImage(fromURL: String, responseHandler: @escaping (Data?) -> ()) {

        let urlComponents = URLComponents(string: fromURL)
        guard let url = urlComponents?.url else { return }

        print("image_url-->", fromURL)

        session.dataTask(with: url) { (data, resp, error) in
            print("data", data)
            responseHandler(data)
        }.resume()

    }


}
