//
//  View+DataCache.swift
//  Izertisflix
//
//  Created by Pablo Álvarez Álvarez on 9/9/23.
//

/**
 Agrega dos funciones para trabajar con una caché de datos de la aplicación.
 La función cached(key:) se utiliza para recuperar datos de la caché.
 La función cache(key:value:) se utiliza para almacenar datos en la caché de la aplicación.
 */

import Foundation
import SwiftUI

/* La constante privada 'appDataCache', representa una caché de datos de la aplicación.
  Utiliza 'NSCache', proporcionado por el framework Foundation en iOS para almacenar datos en memoria de manera eficiente.
  La caché almacena objetos 'NSData' asociados con claves 'NSString'. */
private let appDataCache = NSCache<NSString, NSData>()

extension View {

    /* Permite recuperar un objeto 'Data' de la caché de la aplicación utilizando una clave proporcionada.
     Toma una clave en forma 'String' como parámetro y devuelve el objeto 'Data' asociado con esa clave si se encuentra en la caché, de lo contrario, devuelve 'nil'.*/
    func cached(key: String) -> Data? {
        appDataCache.object(forKey: NSString(string: key)) as Data?
    }
    
    /* Permite agregar un objeto 'Data' a la caché de la aplicación.
     Toma una clave en forma de 'String' y un valor en forma de objeto 'Data' como parámetros y asocia el valor con la clave en la caché de la aplicación.*/
    func cache(key: String, value: Data) {
        appDataCache.setObject(NSData(data: value), forKey: NSString(string: key))
    }
}
