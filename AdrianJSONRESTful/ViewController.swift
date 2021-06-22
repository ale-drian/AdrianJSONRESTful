//
//  ViewController.swift
//  AdrianJSONRESTful
//
//  Created by Mac 14 on 6/16/21.
//  Copyright © 2021 Mac 14. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtContrasena: UITextField!
    
    var users = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func logear(_ sender: Any) {
        let ruta = "http://localhost:3000/usuarios?"
        let usuario = txtUsuario.text!
        let contrasena = txtContrasena.text!
        let url = ruta + "nombre=\(usuario)&clave=\(contrasena)"
        let crearURL = url.replacingOccurrences(of: " ", with: "%20")
        validarUsuario(ruta: crearURL){
            if self.users.count <= 0{
               print("Nombre de usuario y/o contraseña es incorrecto")
                let alerta = UIAlertController(title:"Error", message: "Nombre de usuario y/o contraseña es incorrecto", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                alerta.addAction(btnOK)
                self.present(alerta,animated: true,completion: nil)
            }else{
                print("Logeo exitoso")
                self.performSegue(withIdentifier: "segueLogeo", sender: self.users[0])
                for data in self.users{
                    print("id:\(data.id),nombre:\(data.nombre),email:\(data.email)")
                }
            }
        }
    }
    
    func validarUsuario(ruta:String, completed:@escaping () -> ()){
        let url = URL(string: ruta)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do{
                    self.users = try JSONDecoder().decode([Users].self, from: data!)
                    DispatchQueue.main.async{
                        completed()
                    }
                }catch{
                    print("Error en JSON")
                }
            }
            
        }.resume()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueLogeo"{
            let navVC = segue.destination as? UINavigationController
            let siguienteVC = navVC?.viewControllers.first as! BuscarViewController
            siguienteVC.user = sender as? Users
        }
    }}

