//
//  UbigeoService.swift
//  SCS-iOS-Project
//
//  Created by Diego Gatica on 21/08/24.
//

import Foundation
import Alamofire

class UbigeoService {
    static let shared = UbigeoService()
    private let baseUrl = "\(Constants.baseUrl)ubigeo"

    private init() {}
    
    private func getHeaders() -> HTTPHeaders? {
        if let token = AuthService.shared.getToken() {
            return ["Authorization": "Bearer \(token)"]
        }
        return nil
    }
    
    // Método para listar departamentos
    func listarDepartamentos(completion: @escaping (Result<[String], AFError>) -> Void) {
        NetworkManager.shared.session.request("\(baseUrl)/departamentos", headers: getHeaders())
            .responseDecodable(of: [String].self) { response in
                NetworkManager.shared.handleResponse(response: response, completion: completion)
            }
    }

    // Método para listar provincias por departamento
    func listarProvincias(departamento: String, completion: @escaping (Result<[String], AFError>) -> Void) {
        NetworkManager.shared.session.request("\(baseUrl)/provincias/\(departamento)", headers: getHeaders())
            .responseDecodable(of: [String].self) { response in
                NetworkManager.shared.handleResponse(response: response, completion: completion)
            }
    }

    // Método para listar distritos por departamento y provincia
    func listarDistritos(departamento: String, provincia: String, completion: @escaping (Result<[Ubigeo], AFError>) -> Void) {
        NetworkManager.shared.session.request("\(baseUrl)/distritos/\(departamento)/\(provincia)", headers: getHeaders())
            .responseDecodable(of: [Ubigeo].self) { response in
                NetworkManager.shared.handleResponse(response: response, completion: completion)
            }
    }

    // Método para buscar un departamento por nombre
    func buscarDepartamento(departamento: String, completion: @escaping (Result<Ubigeo, AFError>) -> Void) {
        NetworkManager.shared.session.request("\(baseUrl)/buscar/departamento/\(departamento)", headers: getHeaders())
            .responseDecodable(of: Ubigeo.self) { response in
                NetworkManager.shared.handleResponse(response: response, completion: completion)
            }
    }

    // Método para buscar una provincia por nombre
    func buscarProvincia(provincia: String, completion: @escaping (Result<Ubigeo, AFError>) -> Void) {
        NetworkManager.shared.session.request("\(baseUrl)/buscar/provincia/\(provincia)", headers: getHeaders())
            .responseDecodable(of: Ubigeo.self) { response in
                NetworkManager.shared.handleResponse(response: response, completion: completion)
            }
    }

    // Método para buscar un distrito por nombre
    func buscarDistrito(distrito: String, completion: @escaping (Result<Ubigeo, AFError>) -> Void) {
        NetworkManager.shared.session.request("\(baseUrl)/buscar/distrito/\(distrito)", headers: getHeaders())
            .responseDecodable(of: Ubigeo.self) { response in
                NetworkManager.shared.handleResponse(response: response, completion: completion)
            }
    }

    // Método para buscar por código de ubigeo
    func buscarPorCodigo(codigo: String, completion: @escaping (Result<Ubigeo, AFError>) -> Void) {
        NetworkManager.shared.session.request("\(baseUrl)/buscar/codigo/\(codigo)", headers: getHeaders())
            .responseDecodable(of: Ubigeo.self) { response in
                NetworkManager.shared.handleResponse(response: response, completion: completion)
            }
    }

    // Método para eliminar un ubigeo por ID
    func eliminarUbigeo(id: Int, completion: @escaping (Result<Void, AFError>) -> Void) {
        NetworkManager.shared.session.request("\(baseUrl)/eliminar/\(id)", method: .delete, headers: getHeaders())
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    // Método para actualizar un ubigeo
    func actualizarUbigeo(ubigeo: Ubigeo, completion: @escaping (Result<Ubigeo, AFError>) -> Void) {
        guard let parameters = convertToParameters(ubigeo) else {
            let encodingError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error al codificar los parámetros."])
            completion(.failure(AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: encodingError))))
            return
        }

        NetworkManager.shared.session.request("\(baseUrl)/actualizar", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: getHeaders())
            .responseDecodable(of: Ubigeo.self) { response in
                NetworkManager.shared.handleResponse(response: response, completion: completion)
            }
    }
}

extension UbigeoService {
    
    func convertToParameters<T: Encodable>(_ encodable: T) -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(encodable),
              let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return nil
        }
        return json
    }
}
