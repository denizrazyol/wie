//
//  Color.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 27/10/2023.
//

import Foundation
import SwiftUI

extension Color {
    
    static let theme = ColorTheme()
    static let launch = LaunchTheme()
    
    static var random: Color {
            return Color(
                red: .random(in: 0...1),
                green: .random(in: 0...1),
                blue: .random(in: 0...1)
            )
        }
}


struct ColorTheme {
    
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let yellow = Color("YellowColor")
    let secondaryText = Color("SecondaryTextColor")
    let iconColor = Color("IconColor")
    let fillingColor = Color("FillingColor")
    let darkAccent = Color("DarkAccentColor")
    
}

struct LaunchTheme {
    
    let accent = Color("LaunchAccentColor")
    let background = Color("LaunchBackgroundColor")
}




