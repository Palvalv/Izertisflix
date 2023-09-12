//
//  FilmListViewModel.swift
//  Izertisflix
//
//  Created by Pablo Álvarez Álvarez on 9/9/23.
//

/**
 Gestiona la viewModel que busca películas, almacena búsquedas recientes y proporciona una función de ejemplo para previsualización.
 Las películas y las búsquedas recientes se actualizan como propiedades publicadas para que las vistas observable puedan reflejar automáticamente los cambios en los datos.
 */

import Foundation
import Combine

// Publicar cambios en sus propiedades, permite a las vistas que dependen de este modelo actualizarse automáticamente cuando cambian los datos.
class FilmListViewModel: ObservableObject {
    
    /* Mantiene seguimiento de las suscripciones a eventos de Combine.
     Se utiliza para cancelar suscripciones cuando la instancia de 'FilmListViewModel' se destruye. */
    private var subscriptions: [AnyCancellable] = []
    
    // Almacena una colección de 'FilmViewModel'. Cualquier cambio en esta propiedad se notificará a las vistas observable para que se actualicen.
    @Published var films: [FilmViewModel] = []
    
    // Almacena una colección de búsquedas recientes como cadenas de texto.
    @Published var recents: [String] = []
    
    // Propiedades solo de lectura. Devuelven 'true' si hay películas o búsquedas recientes para presentar.
    var hasFilms: Bool {
        !films.isEmpty
    }
    var hasRecents: Bool {
        !recents.isEmpty
    }
    
    // Completa la vista de la lista reciente a partir de los valores predeterminados del usuario.
    init() {
        _recents = Published(wrappedValue: UserDefaults.shared.recents)
    }
    
    /* Busca películas desde API 'Omdb'.
     Realiza una limpieza del texto de búsqueda para eliminar espacios en blanco y saltos de línea al principio y al final.
     Si el texto de búsqueda resultante tiene una longitud > 0, se llama al método 'Films.publisher' para buscar películas utilizando Combine.
     Las películas encontradas se asignan a la propiedad 'films' y la búsqueda se agrega a la lista de búsquedas recientes.*/
    func find(text: String) {
        let search = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard search.count > 0  else {
            return
        }

        Films.publisher(text: search, store: &subscriptions)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("failed to get films: \(error)")
                    }
                },
                receiveValue: {
                    self.films = $0.map(FilmViewModel.init)
                    self.appendRecent(value: text)
                }
            )
            .store(in: &subscriptions)
    }
    
    // Elimina todas las películas de la lista 'films'.
    func clear() {
        films.removeAll()
    }
    
    /* Agrega nueva búsqueda reciente a la lista de búsquedas recientes, antes verifica si ya existe búsqueda idéntica.
     Las búsquedas recientes se insertan en la parte superior de la lista y se limitan a un número máximo definido por 'UserDefaults.maxRecentItems' y se almacenan en 'UserDefaults'.*/
    func appendRecent(value: String) {
        guard !recents.contains(value) else { return }
        
        recents.insert(value, at: 0)
        if recents.count > UserDefaults.maxRecentItems {
            recents.removeLast()
        }
        UserDefaults.shared.addRecent(value: value)
    }
    
    /* Elimina elementos de la lista de búsquedas recientes en los índices especificados por 'offsets' y las búsquedas recientes correspondientes en 'UserDefaults'. */
    func removeRecents(in offsets: IndexSet) {
        recents.remove(atOffsets: offsets)
        UserDefaults.shared.removeRecents(in: offsets)
    }
    
    // Vista previa para la interfaz de desarrollo.
    static var example: FilmListViewModel {
        let viewModel = FilmListViewModel()
        viewModel.films.append(
            .init(film: .init(id: "1", title: "ExampleTerminator", year: "2020", type: "movie", poster: "")))
        viewModel.films.append(
            .init(film: .init(id: "2", title: "ExampleRocky", year: "2019", type: "movie", poster: "")))
        viewModel.films.append(
            .init(film: .init(id: "3", title: "ExamplePeakyBlinders", year: "2018", type: "serie", poster: "")))
        return viewModel
    }
}
