//
//  Tray.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 24/04/2024.
//

import SwiftUI

struct TrayView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    // Base layer with a slight offset to create the edge/frame effect
                    RoundedRectangle(cornerRadius: max(geometry.size.width, geometry.size.height) * 0.03)
                        .fill(Color.theme.darkAccent) // Darker color for depth
                        .frame(width: geometry.size.width, height: geometry.size.height) // Increased height
                        .shadow(radius: 5, x: 3, y: 3) // Optional: adds more depth with shadow

                    // Top surface of the tray, slightly smaller to show the base as an edge
                    RoundedRectangle(cornerRadius: max(geometry.size.width, geometry.size.height) * 0.025)
                        .fill(Color.theme.accent)
                        .frame(width: geometry.size.width - 10, height: geometry.size.height - 10) // Slightly smaller than base
                }
                //.padding()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct TrayView_Previews: PreviewProvider {
    static var previews: some View {
        TrayView()
    }
}
