//
//  NetworkClient.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 24/02/2024.
//

import UIKit

public enum NetworkingError: Error, Equatable {
    case noInternet
    case timeout
    case internalServerError
    case notfound
    case codableError(Error)
    case cancelled
    case badURL
    case serverCertificateHasBadDate
    case clientError
    case unknowError
    case responseJSONError

    public static func == (lhs: NetworkingError, rhs: NetworkingError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}


class NetworkClient {
    func defaultHeader() -> [String: String] {
        let appInfo = NSDictionary(contentsOf: Bundle.main.url(forResource: "Info", withExtension: "plist")!)
        let appVersion = (appInfo?[kCFBundleVersionKey as String] as? String) ?? "Unknowned"
        return [
            "os": "ios",
            "os_version": UIDevice.current.systemVersion,
            "app_version": appVersion
        ]
    }

    // MARK: - Excuted
    func excuted<T: Decodable>(urlAPI: String, header: [String : String], type: T.Type, completionHandler: ((T?, Error?) -> Void)?) {
        let session = URLSession.shared
        guard let url = URL (string: urlAPI) else {
            completionHandler?(nil, NetworkingError.badURL)
            return
        }

        var request = URLRequest (url: url)
        request.allHTTPHeaderFields = self.defaultHeader()
        let task = session.dataTask(with: request) { data, response, errors in
            if let errors = errors {
                completionHandler?(nil, errors)
                return
            }

            do {
                guard let data = data else {
                    completionHandler?(nil, errors)
                    return
                }

                let body = try self.getAPIBody(fromData: data)
                let jsonDecoder = self.commonJSONDecoder()
                let jsonData = try jsonDecoder.decode(type, from: body)
                completionHandler?(jsonData, nil)

            } catch {
                print("API Error: \(error)")
            }
        }

        task.resume()
    }

    // MARK: - Helper
    func commonJSONDecoder() -> JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)

        return jsonDecoder
    }

    func decodeAPIResponseToDictionary<T>(data: Data) throws -> T? {
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? T else {
            return nil
        }

        return json
    }

    func getAPIBody(fromData data: Data) throws -> Data {
        guard let responseJSON: [String: Any]? = try self.decodeAPIResponseToDictionary(data: data),
              let dataJSON = responseJSON?["data"] as? [Any] else {
            throw NetworkingError.responseJSONError
        }

        return try JSONSerialization.data(withJSONObject: dataJSON, options: [])
    }

    
}
