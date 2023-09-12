//
//  UserDefaults+Helpers.swift
//  Izertisflix
//
//  Created by Pablo Álvarez Álvarez on 9/9/23.
//

/**
 Simplifica la gestión de una lista de búsquedas recientes en la aplicación.
 Ofrece métodos para agregar nuevas búsquedas, eliminar búsquedas antiguas y acceder a la lista de búsquedas recientes de manera eficiente.
 */

import Foundation

extension UserDefaults {
    
    // Número máximo de elementos que se mantendrán en la lista de búsquedas recientes.
    static let maxRecentItems = 5
    
    // Claves para leer y escribir valores de 'UserDefaults'. Se utiliza para identificar la lista de búsquedas recientes.
    enum AppKeys: String {
        case recents
    }
    
    // Accede a las configuraciones de usuario y datos almacenados.
    static var shared: UserDefaults {
        UserDefaults.standard
    }
    
    // Devuelve una serie de búsquedas recientes. El valor predeterminado es un array vacío.
    var recents: [String] {
        guard let recents = UserDefaults.shared.object(forKey: AppKeys.recents.rawValue) as? [String]
        else { return [] }
        return recents
    }
    
    /* Obtiene la lista actual de búsquedas recientes.
     Inserta la nueva búsqueda en la parte superior de la lista 'at: 0' para mantener las búsquedas más recientes en la parte superior.
     Verifica si la lista supera el límite máximo de elementos y, si es así, elimina el último elemento para mantener el número máximo de elementos.
     Actualiza la lista de búsquedas recientes en 'UserDefaults' con los nuevos valores.*/
    func addRecent(value: String) {
        var values = recents
        values.insert(value, at: 0)
        if values.count > Self.maxRecentItems {
            values.removeLast()
        }
        UserDefaults.shared.setValue(values, forKey: AppKeys.recents.rawValue)
    }
    
    // Elimina un conjunto de índices de la lista de búsqueda reciente.
    func removeRecents(in offsets: IndexSet) {
        var values = recents
        values.remove(atOffsets: offsets)
        UserDefaults.shared.setValue(values, forKey: AppKeys.recents.rawValue)
    }
}
