//
//  Peliculas.swift
//  AdrianJSONRESTful
//
//  Created by Mac 14 on 6/16/21.
//  Copyright © 2021 Mac 14. All rights reserved.
//

import Foundation

struct Peliculas:Decodable{
    let usuarioId:Int
    let id:Int
    let nombre:String
    let genero:String
    let duracion:String
}
