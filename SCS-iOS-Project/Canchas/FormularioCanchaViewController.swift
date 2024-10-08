//
//  FormularioCanchaViewController.swift
//  SCS-iOS-Project
//
//  Created by Diego Gatica on 22/08/24.
//

import UIKit

class FormularioCanchaViewController: UIViewController, UITextFieldDelegate {
    
    var canchaResponse: CanchaResponse?
    
    @IBOutlet weak var tipoCanchaTextField: UITextField!
    @IBOutlet weak var numeroDeCanchaTextField: UITextField!
    @IBOutlet weak var precioCanchaTextField: UITextField!
    @IBOutlet weak var sedeCanchaTextField: UITextField!
    @IBOutlet weak var disponibilidadCanchaInicioTextField: UITextField!
    @IBOutlet weak var disponibilidadCanchaFinTextField: UITextField!
    
    private let tipoCanchaPicker = UIPickerView()
    private let sedeCanchaPicker = UIPickerView()
    
    private var tipoCancha: [String] = TipoCancha.allCases.map { $0.rawValue }
    private var sedeCancha: [String] = []
    private var sedes: [Sede] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickers()
        
        if let canchaExistente = canchaResponse {
            cargarDatosCancha(canchaExistente.id)
        }
        
        tipoCanchaTextField.delegate = self
        sedeCanchaTextField.delegate = self
        
        cargarSedesActivas()
    }
    
    func cargarDatosCancha(_ id: Int) {
        CanchaService.shared.consultarCancha(id: id) { [weak self] result in
            switch result {
            case .success(let cancha):
                self?.canchaResponse = cancha
                self?.actualizarCamposConDatosDeCancha(cancha)
            case .failure(let error):
                print("Error al obtener la cancha: \(error)")
                self?.showAlert(message: "Ocurrió un error al cargar los datos de la cancha. Inténtalo nuevamente.")
            }
        }
    }
    
    
    func cargarSedesActivas() {
        SedeService.shared.listarSedesActivas { [weak self] result in
            switch result {
            case .success(let sedes):
                self?.sedes = sedes
                self?.sedeCancha = sedes.map { $0.nombre }
                self?.sedeCanchaPicker.reloadAllComponents()
            case .failure(let error):
                print("Error al cargar las sedes activas: \(error)")
                self?.showAlert(message: "Ocurrió un error al cargar las sedes activas. Inténtalo nuevamente.")
            }
        }
    }
    
    func actualizarCamposConDatosDeCancha(_ cancha: CanchaResponse) {
        tipoCanchaTextField.text = cancha.tipoCancha.rawValue
        numeroDeCanchaTextField.text = cancha.numero
        precioCanchaTextField.text = "\(cancha.precio)"
    }
    
    @IBAction func guardarCanchaAction(_ sender: Any) {
        let textFields: [(UITextField, String)] = [
            (tipoCanchaTextField, "Tipo de Cancha"),
            (numeroDeCanchaTextField, "# Cancha"),
            (precioCanchaTextField, "Precio"),
            (sedeCanchaTextField, "Sede"),
            (disponibilidadCanchaInicioTextField, "Hora de Inicio"),
            (disponibilidadCanchaFinTextField, "Hora de Fin")
        ]
        
        for (textField, fieldName) in textFields {
            if textField.text?.isEmpty ?? true {
                showAlert(message: "El campo '\(fieldName)' es obligatorio.")
                return
            }
        }
        
        guard let tipoCancha = TipoCancha(rawValue: tipoCanchaTextField.text ?? ""),
              let numero = numeroDeCanchaTextField.text,
              let precio = Double(precioCanchaTextField.text ?? ""),
              let disHrInicio = Int(disponibilidadCanchaInicioTextField.text ?? ""),
              let disHrFin = Int(disponibilidadCanchaFinTextField.text ?? ""),
              let sedeSeleccionada = sedes.first(where: { $0.nombre == sedeCanchaTextField.text }) else {
            showAlert(message: "Por favor, revisa los campos y vuelve a intentar.")
            return
        }
        
        let sedeId = sedeSeleccionada.id
        
        let canchaRequest = CrearCanchaRequest(
            tipoCancha: tipoCancha,
            numero: numero,
            precio: precio,
            sedeId: sedeId,
            disHrInicio: disHrInicio,
            disHrFin: disHrFin,
            estado: true // Estado por defecto, siempre true al crear
        )
        
        if let canchaExistente = canchaResponse {
            // Editar una cancha existente
            CanchaService.shared.actualizarCancha(id: canchaExistente.id, cancha: canchaRequest) { result in
                switch result {
                case .success(_):
                    self.showSuccessAlert(message: "Cancha actualizada correctamente.")
                case .failure(let error):
                    print("Error al actualizar la cancha: \(error)")
                    self.showAlert(message: "Ocurrió un error al actualizar la cancha. Inténtalo nuevamente.")
                }
            }
        } else {
            // Crear una nueva cancha
            CanchaService.shared.guardarCancha(cancha: canchaRequest) { result in
                switch result {
                case .success(_):
                    self.showSuccessAlert(message: "Cancha creada correctamente.")
                case .failure(let error):
                    print("Error al crear la cancha: \(error)")
                    self.showAlert(message: "Ocurrió un error al guardar la cancha. Inténtalo nuevamente.")
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
        tipoCanchaPicker.delegate = self
        tipoCanchaPicker.dataSource = self
        sedeCanchaPicker.delegate = self
        sedeCanchaPicker.dataSource = self
        
        tipoCanchaTextField.inputView = tipoCanchaPicker
        sedeCanchaTextField.inputView = sedeCanchaPicker
    }
    
}

extension FormularioCanchaViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case tipoCanchaPicker:
            return tipoCancha.count
        case sedeCanchaPicker:
            return sedeCancha.count
        default:
            return 0
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case tipoCanchaPicker:
            return tipoCancha[row]
        case sedeCanchaPicker:
            return sedeCancha[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case tipoCanchaPicker:
            tipoCanchaTextField.text = tipoCancha[row]
            tipoCanchaTextField.resignFirstResponder()
            
        case sedeCanchaPicker:
            sedeCanchaTextField.text = sedeCancha[row]
            sedeCanchaTextField.resignFirstResponder()
            
        default:
            break
        }
    }
}
