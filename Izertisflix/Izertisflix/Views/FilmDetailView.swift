//
//  FilmDetailView.swift
//  Izertisflix
//
//  Created by Pablo Álvarez Álvarez on 9/9/23.
//

/**
 View que muestra barra de progreso mientras los datos se están cargando y  los detalles de la película, incluyendo la imagen del póster, el título, la descripción y otros detalles relevantes.
 */

import SwiftUI

struct FilmDetailView: View {
    
    // Declara una variable 'viewModel' que se observa (@ObservedObject).
    // El 'FilmDetailViewModel' proporcionado contiene los datos y la lógica relacionada con los detalles de la película.
    @ObservedObject var viewModel: FilmDetailViewModel

    // Muestra una barra de progreso mientras se cargan los detalles de la película.
    var loadingView: some View {
        ProgressView(value: 0.0)
            .progressViewStyle(CircularProgressViewStyle())
    }

    // Vista que representa los detalles completos de la película.
    var detailView: some View {
        VStack(alignment: .leading, spacing: 10) {
            FilmPosterView(posterURL: viewModel.poster)
                .ignoresSafeArea()

            // Header Group
            Group {
                Text(viewModel.title)
                    .font(.title)
                Text(viewModel.plot)
                Text(viewModel.type)
                    .foregroundColor(.secondary)
            }

            // Información Group
            Group {
                headerView(title: "Director")
                Text(viewModel.director)

                headerView(title: "Rating")
                HStack {
                    Text(viewModel.rating)
                    Text(viewModel.votes)
                        .foregroundColor(.secondary)
                }

                headerView(title: "Year")
                Text(viewModel.year)
                
                headerView(title: "Language")
                Text(viewModel.language)
            }

            Spacer()
        }
        .padding([.leading, .trailing, .bottom])
    }

    // Si 'viewModel.isLoaded' es 'false', muestra la vista de carga.
    // Si 'viewModel.isLoaded' es 'true', muestra la vista de detalles.
    var body: some View {
        if !viewModel.isLoaded {
            loadingView
                .onAppear(perform: viewModel.load)
        } else {
            ScrollView {
                detailView
            }
            .navigationBarTitle("Details")
        }
    }

    // Función auxiliar que crea una vista de encabezado con un título en negrita y espacio en la parte superior.
    func headerView(title: String) -> some View {
        Text(title)
            .fontWeight(.bold)
            .padding(.top)
    }
}

// Vista previa para la interfaz de desarrollo.
struct FilmDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FilmDetailView(viewModel: FilmDetailViewModel.example)
        }
    }
}
