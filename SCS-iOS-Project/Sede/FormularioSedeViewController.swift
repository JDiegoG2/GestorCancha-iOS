//
//  FormularioSedeViewController.swift
//  SCS-iOS-Project
//
//  Created by Diego Gatica on 21/08/24.
//

import UIKit

class FormularioSedeViewController: UIViewController, UITextFieldDelegate {
    
    var sede: Sede?
    
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var telefonoTextField: UITextField!
    @IBOutlet weak var direccionTextField: UITextField!
    @IBOutlet weak var departamentoTextField: UITextField!
    @IBOutlet weak var provinciaTextField: UITextField!
    @IBOutlet weak var distritoTextField: UITextField!
    
    private let departamentoPicker = UIPickerView()
    private let provinciaPicker = UIPickerView()
    private let distritoPicker = UIPickerView()
    
    private var departamentos: [String] = []
    private var provincias: [String] = []
    private var distritos: [Ubigeo] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPickers()
        loadDepartamentos()
        
        if let sedeExistente = sede {
                cargarDatosSede(sedeExistente.id)
            }
        
        departamentoTextField.delegate = self
        provinciaTextField.delegate = self
        distritoTextField.delegate = self
    }
    
    func cargarDatosSede(_ id: Int) {
        SedeService.shared.obtenerSede(id: id) { [weak self] result in
            switch result {
            case .success(let sede):
                self?.sede = sede
                self?.actualizarCamposConDatosDeSede(sede)
            case .failure(let error):
                print("Error al obtener la sede: \(error)")
                self?.showAlert(message: "Ocurrió un error al cargar los datos de la sede. Inténtalo nuevamente.")
            }
        }
    }

    func actualizarCamposConDatosDeSede(_ sede: Sede) {
        nombreTextField.text = sede.nombre
        telefonoTextField.text = sede.telefono
        direccionTextField.text = sede.direccion
        departamentoTextField.text = sede.departamento
        provinciaTextField.text = sede.provincia
        distritoTextField.text = sede.distrito
    }
    
    @IBAction func v(_ sender: Any) {
        let textFields: [(UITextField, String)] = [
            (nombreTextField, "Nombre"),
            (telefonoTextField, "Teléfono"),
            (direccionTextField, "Dirección"),
            (departamentoTextField, "Departamento"),
            (provinciaTextField, "Provincia"),
            (distritoTextField, "Distrito")
        ]
        
        for (textField, fieldName) in textFields {
            if textField.text?.isEmpty ?? true {
                showAlert(message: "El campo '\(fieldName)' es obligatorio.")
                return
            }
        }
        
        let nombre = nombreTextField.text!
        let telefono = telefonoTextField.text!
        let direccion = direccionTextField.text!
        let departamento = departamentoTextField.text!
        let provincia = provinciaTextField.text!
        let distrito = distritoTextField.text!
        
        if var sedeExistente = sede {
            // Editando una sede existente
            sedeExistente.nombre = nombre
            sedeExistente.telefono = telefono
            sedeExistente.direccion = direccion
            sedeExistente.departamento = departamento
            sedeExistente.provincia = provincia
            sedeExistente.distrito = distrito
            
            SedeService.shared.actualizarSede(id: sedeExistente.id, sede: sedeExistente) { result in
                switch result {
                case .success(let sede):
                    print("Sede actualizada: \(sede.nombre)")
                    self.showSuccessAlert(message: "Sede actualizada correctamente.")
                case .failure(let error):
                    print("Error al actualizar la sede: \(error)")
                    self.showAlert(message: "Ocurrió un error al actualizar la sede. Inténtalo nuevamente.")
                }
            }
        } else {
            
            let ubigeo = Ubigeo(id: 1, departamento: departamento, provincia: provincia, distrito: distrito, codigo: "") // Ajusta según corresponda
            
            let sede = Sede(id: 0, nombre: nombre, direccion: direccion, telefono: telefono, estado: true, departamento: departamento, provincia: provincia, distrito: distrito, ubigeo: ubigeo)
            
            SedeService.shared.crearSede(sede: sede) { result in
                switch result {
                case .success(let sede):
                    print("Sede creada: \(sede.nombre)")
                    self.showSuccessAlert(message: "Sede creada correctamente.")
                case .failure(let error):
                    print("Error al crear la sede: \(error)")
                    self.showAlert(message: "Ocurrió un error al guardar la sede. Inténtalo nuevamente.")
                }
            }
        }
    }
    
    func showSuccessAlert(message: String) {
        let alert = UIAlertController(title: "Éxito", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }

    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Atención", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func setupPickers() {
        departamentoPicker.delegate = self
        departamentoPicker.dataSource = self
        provinciaPicker.delegate = self
        provinciaPicker.dataSource = self
        distritoPicker.delegate = self
        distritoPicker.dataSource = self
        
        departamentoTextField.inputView = departamentoPicker
        provinciaTextField.inputView = provinciaPicker
        distritoTextField.inputView = distritoPicker
        
    }
    
    
    func loadDepartamentos() {
        UbigeoService.shared.listarDepartamentos { [weak self] result in
            switch result {
            case .success(let departamentos):
                self?.departamentos = departamentos
                self?.departamentoPicker.reloadAllComponents()
            case .failure(let error):
                print("Error al cargar departamentos: \(error)")
            }
        }
    }
    
    func loadProvincias(for departamento: String) {
        UbigeoService.shared.listarProvincias(departamento: departamento) { [weak self] result in
            switch result {
            case .success(let provincias):
                self?.provincias = provincias
                self?.provinciaPicker.reloadAllComponents()
            case .failure(let error):
                print("Error al cargar provincias: \(error)")
            }
        }
    }
    
    func loadDistritos(for provincia: String, in departamento: String) {
        UbigeoService.shared.listarDistritos(departamento: departamento, provincia: provincia) { [weak self] result in
            switch result {
            case .success(let distritos):
                self?.distritos = distritos
                self?.distritoPicker.reloadAllComponents()
            case .failure(let error):
                print("Error al cargar distritos: \(error)")
            }
        }
    }
}

extension FormularioSedeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case departamentoPicker:
            return departamentos.count
        case provinciaPicker:
            return provincias.count
        case distritoPicker:
            return distritos.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case departamentoPicker:
            return departamentos[row]
        case provinciaPicker:
            return provincias[row]
        case distritoPicker:
            return distritos[row].distrito
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case departamentoPicker:
            departamentoTextField.text = departamentos[row]
            provinciaTextField.text = ""
            distritoTextField.text = ""
            loadProvincias(for: departamentos[row])
            departamentoTextField.resignFirstResponder()
        case provinciaPicker:
            provinciaTextField.text = provincias[row]
            distritoTextField.text = ""
            loadDistritos(for: provinciaTextField.text ?? "", in: departamentoTextField.text ?? "")
            provinciaTextField.resignFirstResponder()
        case distritoPicker:
            distritoTextField.text = distritos[row].distrito
            distritoTextField.resignFirstResponder()
        default:
            break
        }
    }
}
