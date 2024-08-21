//
//  NetworkManager.swift
//  SCS-iOS-Project
//
//  Created by Diego Gatica on 21/08/24.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared: NetworkManager = NetworkManager()
    private init() {}

    let session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        return Session(configuration: configuration)
    }()

    func handleResponse<T: Decodable>(response: AFDataResponse<T>, completion: (Result<T, AFError>) -> Void) {
        switch response.result {
        case .success(let value):
            if let statusCode = response.response?.statusCode {
                switch statusCode {
                case 200...299:
                    completion(.success(value))
                case 400:
                    print("Solicitud incorrecta")
                    completion(.failure(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: statusCode))))
                case 401:
                    print("No autorizado")
                    completion(.failure(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: statusCode))))
                case 500:
                    print("Error del servidor")
                    completion(.failure(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: statusCode))))
                default:
                    print("Código de estado HTTP no manejado: \(statusCode)")
                    completion(.failure(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: statusCode))))
                }
            }
        case .failure(let error):
            print("Error de red o de decodificación: \(error)")
            completion(.failure(error))
        }
    }
}

