//
//  BuscarViewController.swift
//  AdrianJSONRESTful
//
//  Created by Mac 14 on 6/16/21.
//  Copyright © 2021 Mac 14. All rights reserved.
//

import UIKit

class BuscarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var peliculas = [Peliculas]()
    var user:Users?
    
    @IBOutlet weak var txtBuscar: UITextField!
    @IBOutlet weak var tablaPeliculas: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaPeliculas.delegate = self
        tablaPeliculas.dataSource = self
        //print(user)
        let ruta = "http://localhost:3000/peliculas/"
        cargarPeliculas(ruta: ruta){
            self.tablaPeliculas.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let ruta = "http://localhost:3000/peliculas/"
        cargarPeliculas(ruta: ruta){
            self.tablaPeliculas.reloadData()
        }
    }
    @IBAction func btnEditarPerfil(_ sender: Any) {
        performSegue(withIdentifier: "perfilSegue", sender: nil)
    }
    
    @IBAction func btnSalir(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnBuscar(_ sender: Any) {
        let ruta = "http://localhost:3000/peliculas?"
        let nombre = txtBuscar.text!
        let url = ruta + "nombre_like=\(nombre)"
        let crearURL = url.replacingOccurrences(of: " ", with: "%20")
        if nombre.isEmpty{
            let ruta = "http://localhost:3000/peliculas/"
            self.cargarPeliculas(ruta: ruta){
                self.tablaPeliculas.reloadData()
            }
        }else{
            self.cargarPeliculas(ruta: crearURL){
                if self.peliculas.count <= 0{
                    self.mostrarAlerta(titulo: "Error", mensaje: "No se encontraron coincidencias para \(nombre)", accion: "Cancel")
                }else{
                    self.tablaPeliculas.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peliculas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(peliculas[indexPath.row].nombre)"
        cell.detailTextLabel?.text = "Genero:\(peliculas[indexPath.row].genero) Duracion:\(peliculas[indexPath.row].duracion)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pelicula = peliculas[indexPath.row]
        performSegue(withIdentifier: "segueEditar", sender: pelicula)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if     editingStyle == .delete {
            print("Delete")
            let id = peliculas[indexPath.row].id
            mostrarAlertaDelete(id: id)
         }
     }
    
    func cargarPeliculas(ruta:String, completed:@escaping () -> ()){
        let url = URL(string: ruta)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do{
                    self.peliculas = try JSONDecoder().decode([Peliculas].self, from: data!)
                    DispatchQueue.main.async{
                        completed()
                    }
                }catch{
                    print("Error en JSON")
                }
            }
            
        }.resume()
    }
    func mostrarAlerta(titulo: String, mensaje: String, accion: String){
        let alerta = UIAlertController(title:titulo, message: mensaje, preferredStyle: .alert)
        let btnOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnOK)
        present(alerta,animated: true,completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueEditar"{
            let siguienteVC = segue.destination as! AgregarViewController
            siguienteVC.pelicula = sender as? Peliculas
        }else if segue.identifier == "perfilSegue"{
           let siguienteVC = segue.destination as! PerfilViewController
           siguienteVC.user = user
       }
    }

    func metodoDELETE(ruta:String){
        let url:URL = URL(string: ruta)!
        var request = URLRequest(url: url)
        let session = URLSession.shared
        request.httpMethod = "DELETE"
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
    func mostrarAlertaDelete(id: Int){
        let alerta = UIAlertController(title:"Esta eguro de eliminar esta pelicula", message: "Una vez eliminado no podra recuperar su informacion", preferredStyle: .alert)
        let btnCancel = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        let btnOK = UIAlertAction(title: "Eliminar", style: .default, handler: { (UIAlertAction) in
                let ruta = "http://localhost:3000/peliculas/\(id)"
                self.metodoDELETE(ruta:ruta)
                let ruta2 = "http://localhost:3000/peliculas/"
                self.cargarPeliculas(ruta: ruta2){
                    self.tablaPeliculas.reloadData()
                }
        })
        alerta.addAction(btnOK)
        alerta.addAction(btnCancel)
        present(alerta,animated: true,completion: nil)
    }
}
