//
//  AuthService.swift
//  SCS-iOS-Project
//
//  Created by Diego Gatica on 21/08/24.
//

import Foundation
import Alamofire
import KeychainAccess

class AuthService {
    static let shared = AuthService()
    private init() {}
    
    func login(email: String, password: String, completion: @escaping (Result<LoginResponse, AFError>) -> Void) {
        let url = "\(Constants.baseUrl)auth/login"
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        NetworkManager.shared.session.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: LoginResponse.self) { response in
                NetworkManager.shared.handleResponse(response: response, completion: completion)
            }
    }

    // Nuevo método para el registro
    func register(user: Register, completion: @escaping (Result<String, AFError>) -> Void) {
        let url = "\(Constants.baseUrl)auth/register"
        let parameters: [String: Any] = [
            "email": user.email,
            "password": user.password,
            "nro_documento": user.nroDocumento,
            "nombres": user.nombres,
            "apellidos": user.apellidos,
            "telefono": user.telefono
        ]
        
        NetworkManager.shared.session.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: String.self) { response in
                NetworkManager.shared.handleResponse(response: response, completion: completion)
            }
    }
}


extension AuthService {
    func saveToken(_ token: String) {
        let keychain = Keychain(service: "com.example.SCS-iOS-Project")
        do {
            try keychain.set(token, key: "userToken")
        } catch let error {
            print("Error al guardar el token: \(error)")
        }
    }

    func getToken() -> String? {
        let keychain = Keychain(service: "com.example.SCS-iOS-Project")
        do {
            return try keychain.get("userToken")
        } catch let error {
            print("Error al obtener el token: \(error)")
            return nil
        }
    }

    func logout() {
        let keychain = Keychain(service: "com.example.SCS-iOS-Project")
        do {
            try keychain.remove("userToken")
        } catch let error {
            print("Error al eliminar el token: \(error)")
        }
    }
}

