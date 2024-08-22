//
//  TipoCanchaService.swift
//  SCS-iOS-Project
//
//  Created by Diego Gatica on 22/08/24.
//

import Foundation
import Alamofire

class TipoCanchaService {
    static let shared = TipoCanchaService()
    private let apiUrl = "\(Constants.baseUrl)cancha/tipoCancha"

    private init() {}
    
    private func getHeaders() -> HTTPHeaders? {
        if let token = AuthService.shared.getToken() {
            return ["Authorization": "Bearer \(token)"]
        }
        return nil
    }
    
    // Método para obtener los tipos de cancha
    func getTiposCancha(completion: @escaping (Result<[String], AFError>) -> Void) {
        NetworkManager.shared.session.request(apiUrl, headers: getHeaders())
            .responseDecodable(of: [String].self) { response in
                NetworkManager.shared.handleResponse(response: response, completion: completion)
            }
    }
}
