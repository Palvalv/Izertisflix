//
//  FilmListCellView.swift
//  Izertisflix
//
//  Created by Pablo Álvarez Álvarez on 9/9/23.
//

/**
 View de una fila de lista para mostrar información resumida de una película.
 La fila incluye una imagen de póster y detalles como el título, el año y el tipo de película, y estos detalles se obtienen del modelo de vista proporcionado (viewModel).
 Esta vista se utiliza para representar cada película en una lista más grande de películas.
 */

import SwiftUI

struct FilmListCellView: View {
    
    // Contiene datos relacionados con una película específica y se utiliza para poblar la fila de lista con información relevante.
    let viewModel: FilmViewModel

    // La vista se compone de 'HStack' que contiene dos elementos principales: imagen de póster y VStack que contiene el título, el año y si es película o serie.
    var body: some View {
        HStack(alignment: .top) {
            Rectangle()
                .foregroundColor(Color.white.opacity(1))
                .frame(width: 70, height: 100)
                .overlay(FilmPosterView(posterURL: viewModel.poster))
                .border(Color.black, width: 0.5)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 0.5))
            
            VStack(alignment: .leading) {
                Text(viewModel.title)
                    .font(.title2)
                Text(viewModel.year)
                    .font(.body)
                    .foregroundColor(.secondary)

                Spacer()

                Text(viewModel.type)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 4)
            }
            .padding(.top, 4)
        }
        .padding([.top, .bottom], 6)
    }
}

// Vista previa para la interfaz de desarrollo.
struct FilmCellView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            FilmListCellView(viewModel: FilmViewModel.example)
        }
        .listStyle(PlainListStyle())
    }
}
