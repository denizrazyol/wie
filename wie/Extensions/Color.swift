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
}


struct ColorTheme {
    
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let yellow = Color("YellowColor")
    let secondaryText = Color("SecondaryTextColor")
    let iconColor = Color("IconColor")
    
}

struct LaunchTheme {
    
    let accent = Color("LaunchAccentColor")
    let background = Color("LaunchBackgroundColor")
}




