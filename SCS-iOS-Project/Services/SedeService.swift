//
//  SedeService.swift
//  SCS-iOS-Project
//
//  Created by Diego Gatica on 21/08/24.
//

import Foundation
import Alamofire

class SedeService {
    static let shared = SedeService()
    private let apiUrl = "\(Constants.baseUrl)sede"

    private init() {}
    
    private func getHeaders() -> HTTPHeaders? {
        if let token = AuthService.shared.getToken() {
            return ["Authorization": "Bearer \(token)"]
        }
        return nil
    }
    
    // Método para actualizar el estado de una sede
    func actualizarEstado(id: Int, estado: Bool, completion: @escaping (Result<Sede, AFError>) -> Void) {
        let estadoValue = estado ? 1 : 0
        let parameters: [String: Any] = ["estado": estadoValue]
        NetworkManager.shared.session.request("\(apiUrl)/estado/\(id)", method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: getHeaders())
            .responseDecodable(of: Sede.self) { response in
                NetworkManager.shared.handleResponse(response: response, completion: completion)
            }
    }

    // Método para listar sedes activas
    func listarSedesActivas(completion: @escaping (Result<[Sede], AFError>) -> Void) {
        NetworkManager.shared.session.request("\(apiUrl)/activas", headers: getHeaders())
            .responseDecodable(of: [Sede].self) { response in
                NetworkManager.shared.handleResponse(response: response, completion: completion)
            }
    }

    // Método para listar todas las sedes
    func listarSedes(completion: @escaping (Result<[Sede], AFError>) -> Void) {
        NetworkManager.shared.session.request("\(apiUrl)/listar", headers: getHeaders())
            .responseDecodable(of: [Sede].self) { response in
                NetworkManager.shared.handleResponse(response: response, completion: completion)
            }
    }

    // Método para obtener una sede por ID
    func obtenerSede(id: Int, completion: @escaping (Result<Sede, AFError>) -> Void) {
        NetworkManager.shared.session.request("\(apiUrl)/\(id)", headers: getHeaders())
            .responseDecodable(of: Sede.self) { response in
                NetworkManager.shared.handleResponse(response: response, completion: completion)
            }
    }

    // Método para crear una nueva sede
    func crearSede(sede: Sede, completion: @escaping (Result<Sede, AFError>) -> Void) {
        guard let parameters = convertToParameters(sede) else {
            let encodingError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error al codificar los parámetros."])
            completion(.failure(AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: encodingError))))
            return
        }

        NetworkManager.shared.session.request("\(apiUrl)/guardar", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: getHeaders())
            .responseDecodable(of: Sede.self) { response in
                NetworkManager.shared.handleResponse(response: response, completion: completion)
            }
    }

    // Método para actualizar una sede existente
    func actualizarSede(id: Int, sede: Sede, completion: @escaping (Result<Sede, AFError>) -> Void) {
        guard let parameters = convertToParameters(sede) else {
            let encodingError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error al codificar los parámetros."])
            completion(.failure(AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: encodingError))))
            return
        }

        NetworkManager.shared.session.request("\(apiUrl)/\(id)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: getHeaders())
            .responseDecodable(of: Sede.self) { response in
                NetworkManager.shared.handleResponse(response: response, completion: completion)
            }
    }



    // Método para eliminar una sede
    func eliminarSede(id: Int, completion: @escaping (Result<Void, AFError>) -> Void) {
        NetworkManager.shared.session.request("\(apiUrl)/\(id)", method: .delete, headers: getHeaders())
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

extension SedeService {
    
    func convertToParameters<T: Encodable>(_ encodable: T) -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(encodable),
              let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return nil
        }
        return json
    }
}
