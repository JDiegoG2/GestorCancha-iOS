//
//  FormularioCanchaViewController.swift
//  SCS-iOS-Project
//
//  Created by Diego Gatica on 22/08/24.
//

import UIKit

class FormularioCanchaViewController: UIViewController, UITextFieldDelegate {
    
    var cancha: Cancha?
    var canchaResponse: CanchaResponse?
    
    @IBOutlet weak var tipoCanchaTextField: UITextField!
    @IBOutlet weak var telefonoCanchaTextField: UITextField!
    @IBOutlet weak var precioCanchaTextField: UITextField!
    @IBOutlet weak var sedeCanchaTextField: UITextField!
    @IBOutlet weak var disponibilidadCanchaInicioTextField: UITextField!
    @IBOutlet weak var disponibilidadCanchaFinTextField: UITextField!
    
    private let tipoCanchaPicker = UIPickerView()
    private let sedeCanchaPicker = UIPickerView()
    
    private var tipoCancha: [String] = TipoCancha.allCases.map { $0.rawValue }
    private var sedeCancha: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickers()
        
        if let canchaExistente = cancha {
            cargarDatosCancha(canchaExistente.id)
        }
        
        tipoCanchaTextField.delegate = self
        sedeCanchaTextField.delegate = self
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
    
    func actualizarCamposConDatosDeCancha(_ cancha: CanchaResponse) {
        tipoCanchaTextField.text = cancha.numero
        precioCanchaTextField.text = "\(cancha.precio)"
    }
    
    @IBAction func guardarCanchaAction(_ sender: Any) {
        let textFields: [(UITextField, String)] = [
            (tipoCanchaTextField, "Tipo de Cancha"),
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
              let precio = Double(precioCanchaTextField.text ?? ""),
              let sedeId = Int(sedeCanchaTextField.text ?? ""),
              let disHrInicio = Int(disponibilidadCanchaInicioTextField.text ?? ""),
              let disHrFin = Int(disponibilidadCanchaFinTextField.text ?? "") else {
            showAlert(message: "Por favor, revisa los campos y vuelve a intentar.")
            return
        }
        
        if let canchaExistente = cancha {
            // Editando una cancha existente
            let canchaActualizar = Cancha(estado: canchaExistente.estado, id: canchaExistente.id, tipoCancha: tipoCancha, numero: "", precio: precio, sedeId: sedeId, disHrInicio: disHrInicio, disHrFin: disHrFin)
            
            CanchaService.shared.actualizarCancha(id: canchaActualizar.id, cancha: canchaActualizar) { result in
                switch result {
                case .success(let cancha):
                    print("Cancha actualizada")
                    self.showSuccessAlert(message: "Cancha actualizada correctamente.")
                case .failure(let error):
                    print("Error al actualizar la cancha: \(error)")
                    self.showAlert(message: "Ocurrió un error al actualizar la cancha. Inténtalo nuevamente.")
                }
            }
        } else {
            // Crear una nueva cancha
            let nuevaCancha = Cancha(estado: true, id: 0, tipoCancha: tipoCancha, numero: "", precio: precio, sedeId: sedeId, disHrInicio: disHrInicio, disHrFin: disHrFin)
            
            CanchaService.shared.guardarCancha(cancha: nuevaCancha) { result in
                switch result {
                case .success(let cancha):
                    print("Cancha creada")
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
            tipoCanchaTextField.resignFirstResponder() // Cierra el picker
            
        case sedeCanchaPicker:
            sedeCanchaTextField.text = sedeCancha[row]
            sedeCanchaTextField.resignFirstResponder() // Cierra el picker

        default:
            break
        }
    }
}
