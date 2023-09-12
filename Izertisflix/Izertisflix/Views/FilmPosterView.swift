//
//  FilmPosterView.swift
//  Izertisflix
//
//  Created by Pablo Álvarez Álvarez on 9/9/23.
//

/**
 View que se utiliza para mostrar imágenes de póster de películas.
 La vista puede cargar imágenes de forma asíncrona desde una URL en la red y también puede cachear las imágenes para un acceso más rápido en el futuro. 
 */

import Foundation
import SwiftUI
import Combine

struct FilmPosterView: View {
    
    // La vista se va actualizando automáticamente cuando cambia esta URL.
    @State var posterURL: String

    // Almacena la imagen del póster cuando se cargue.
    @State private var posterImage: UIImage?
    
    /* Array para mantener un seguimiento de las suscripciones a eventos de Combine.
    Útil para cancelar suscripciones cuando la vista se destruye o ya no es visible. */
    @State private var subscriptions: [AnyCancellable] = []

    /* 2 estados posibles: Si 'posterImage' es 'nulo' (la imagen aún no se ha cargado), muestra un icono de "photo" como marcador de posición con un fondo gris. Si 'posterImage' contiene una imagen descargada, muestra esa imagen. */
    var body: some View {
        if posterImage == nil {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .padding()
                .onAppear(perform: loadPoster)
                .foregroundColor(.gray)
        } else {
            Image(uiImage: posterImage!)
                .resizable()
                .scaledToFit()
        }
    }

    /* Se encarga de cargar la imagen del póster.
     Primero verifica si la URL es válida y, si la imagen ya está en la caché de la aplicación, la recupera y la muestra.
     Si la imagen no está en la caché, utiliza 'URLSession.shared.dataTaskPublisher(for:)' para realizar una solicitud de red y descargar la imagen.
     La imagen descargada se asigna a 'posterImage', y también se almacena en la caché de la aplicación utilizando una función 'cache(key:value:)'. */
    private func loadPoster() {
        guard let url = URL(string: posterURL) else {
            return
        }

        if let data = cached(key: url.absoluteString) {
            posterImage = UIImage(data: data as Data)
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: {
                    self.posterImage = UIImage(data: $0)
                    cache(key: url.absoluteString, value: $0)
                }
            )
            .store(in: &subscriptions)
    }
}

// Vista previa para la interfaz de desarrollo.
struct FilmPosterView_Previews: PreviewProvider {
    static var previews: some View {
        FilmPosterView(posterURL: FilmViewModel.example.poster)
    }
}
