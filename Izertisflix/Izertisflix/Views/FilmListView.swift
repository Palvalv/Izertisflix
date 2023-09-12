//
//  FilmListView.swift
//  Izertisflix
//
//  Created by Pablo Álvarez Álvarez on 9/9/23.
//

/**
 View de una lista de películas, series o juegos y aspectos relacionados con la búsqueda y visualización de ellos.
 La vista se compone de: un campo de búsqueda, una lista de resultados de búsqueda y una lista de búsquedas recientes.
 Permite al usuario interactuar con las películas y las búsquedas.
 */

import SwiftUI

// Representa la interfaz de usuario de la lista de películas y la búsqueda relacionada.
// La vista principal se organiza en un NavigationView.
struct FilmListView: View {
    
    // Espera un objeto 'FilmListViewModel' que proporcionará los datos y la lógica relacionada con la lista de películas.
    @EnvironmentObject private var viewModel: FilmListViewModel
    
    // Significa que esta propiedad es mutable y puede cambiar en respuesta a la interacción del usuario.
    @State private var searchText: String = ""
    
    // Vista que contiene un campo de búsqueda de texto y un botón de reinicio.
    var searchTextField: some View {
        HStack {
            TextField(
                "Search for a movie, serie or game...",
                text: $searchText,
                onEditingChanged: { _ in },
                onCommit: {
                    viewModel.find(text: searchText)
                }
            )
            .textFieldStyle(RoundedBorderTextFieldStyle())

            Button {
                resetView()
            } label: {
                Image(systemName: "xmark.circle")
            }
        }
        .padding()
    }

    // Muestra los resultados de búsqueda de películas a través de un bucle 'foreach'.
    var searchResultsList: some View {
        List {
            ForEach(viewModel.films) { film in
                NavigationLink(
                    destination: FilmDetailView(viewModel: FilmDetailViewModel(id: film.id)),
                    label: {
                        FilmListCellView(viewModel: film)
                    }
                )
            }
        }
        .listStyle(PlainListStyle())
    }

    // Muestra las búsquedas recientes del usuario y función de borrado.
    var recentsList: some View {
        List {
            Section(
                header: Text("Recents")
                    .font(.title3)
            ) {
                ForEach(viewModel.recents, id: \.self) { recent in
                    Button(recent) {
                        viewModel.find(text: recent)
                    }
                    .buttonStyle(DefaultButtonStyle())
                }
                .onDelete(perform: { indexSet in
                    viewModel.removeRecents(in: indexSet)
                })
            }
            .padding(.top)
        }
        .listStyle(InsetGroupedListStyle())
    }

    var body: some View {
        NavigationView {
            VStack {
                searchTextField

                Spacer()

                if viewModel.hasFilms {
                    searchResultsList
                } else {
                    if viewModel.hasRecents {
                        recentsList
                    }
                }
            }
            .navigationTitle("Izertisflix 🎥👾")
        }
    }

    // Borrar el texto de búsqueda y limpiar la vista.
    func resetView() {
        searchText.removeAll()
        viewModel.clear()
    }
}

// Vista previa para la interfaz de desarrollo.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FilmListView()
            .environmentObject(FilmListViewModel.example)
    }
}
