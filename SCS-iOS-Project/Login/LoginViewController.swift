//
//  ViewController.swift
//  SCS-iOS-Project
//
//  Created by Diego Gatica on 11/08/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPasswordToggle()
        passwordTextField.isSecureTextEntry = true
        emailTextField.keyboardType = .emailAddress
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginButtonTappedAction(_ sender: Any) {
        login()
    }
    
    func setupPasswordToggle() {
        let passwordToggleButton = UIButton(type: .custom)
        passwordToggleButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        passwordToggleButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
        passwordToggleButton.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        
        passwordTextField.rightView = passwordToggleButton
        passwordTextField.rightViewMode = .always
    }
    
    @objc func togglePasswordView(_ sender: UIButton) {
        sender.isSelected.toggle()
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    func login() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Por favor, ingrese su correo electrónico y contraseña.")
            return
        }
        
        AuthService.shared.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let loginResponse):
                // Guardar el token
                AuthService.shared.saveToken(loginResponse.token)
                // Redirigir al usuario a la pantalla principal
                self?.navigateToMainScreen()
            case .failure(let error):
                print("Error de inicio de sesión: \(error)")
                self?.showAlert(message: "Error al iniciar sesión. Por favor, intente de nuevo.")
            }
        }
        
    }
    
    func navigateToMainScreen() {
        let storyboard = UIStoryboard(name: "Menu", bundle: nil)
        if let menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController {
            menuViewController.modalPresentationStyle = .fullScreen
            present(menuViewController, animated: true, completion: nil)
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Atención", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
}

