//
//  PerfilViewController.swift
//  AdrianJSONRESTful
//
//  Created by Mac 14 on 6/22/21.
//  Copyright © 2021 Mac 14. All rights reserved.
//

import UIKit

class PerfilViewController: UIViewController {
    var user:Users?
    
    @IBOutlet weak var txtEditUsuario: UITextField!
    @IBOutlet weak var txtEditEmail: UITextField!
    @IBOutlet weak var txtEditClave: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEditUsuario.text = user!.nombre
        txtEditEmail.text = user!.email
        txtEditClave.text = user!.clave

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnEditar(_ sender: Any) {
        let nombre = txtEditUsuario.text!
        let email = txtEditEmail.text!
        let clave = txtEditClave.text!
        let datos = ["nombre":"\(nombre)", "clave":"\(clave)", "email":"\(email)"] as Dictionary<String, Any>
        let ruta = "http://localhost:3000/usuarios/\(user!.id)"
        metodoPUT(ruta:ruta, datos:datos)
        navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func metodoPUT(ruta:String, datos:[String:Any]){
        let url:URL = URL(string: ruta)!
        var request = URLRequest(url: url)
        let session = URLSession.shared
        request.httpMethod = "PUT"
        let params = datos
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        }catch{
            //catch
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if (data != nil){
                do{
                    let dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves)
                    print(dict)
                }catch{
                    //catch
                }
            }
        })
        task.resume()
    }


}
