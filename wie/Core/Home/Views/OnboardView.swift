//
//  OnboardView.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 26/10/2023.
//

import SwiftUI

struct OnboardView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var isFilled = false
    let menuItems = Menu.options
    @State private var selection: String?
    @State private var showDetailView: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            SearchBarView(searchText: $vm.searchText)
            menu
        }
        .background(
            NavigationLink(
                destination: destinationView(),
                isActive: $showDetailView,
                label: { EmptyView() }))
   
    }

    private var menu: some View {
        List (menuItems) { item in
     
                Button(action: {
                    self.selection = "\(item.id)"
                    showDetailView.toggle()
                }) {
                    menuItemView(item)
                }
                .buttonStyle(PlainButtonStyle())
                .listRowSeparator(.hidden)
                .listRowBackground(Color.theme.background)
            }
        .listStyle(PlainListStyle())
    }
    
    private func menuItemView(_ item: MenuItem) -> some View {
        ZStack(alignment: .leading) {
            Image("\(item.id)")
                .resizable()
                .scaledToFill()
                .overlay(
                    heartIconOverlay,
                    alignment: .topTrailing
                )
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
            
            Text(item.title)
                .font(.title)
                .foregroundColor(Color.theme.accent)
                .multilineTextAlignment(.leading)
                .frame(alignment: .leading)
                .padding(.leading, 115)
                .padding(.top, item.id == 1 ? 42 : 15)
                .padding(.trailing, item.id == 1 ? 10 : 0)
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 10)
    }

    private var heartIconOverlay: some View {
        Image(systemName: isFilled ? "heart.fill" : "heart")
            .font(.system(size: 25))
            .padding()
            .foregroundColor(Color.theme.accent)
            .background(
                Circle()
                    .fill(Color.theme.yellow.opacity(0.2)))
            .padding(8)
            .onTapGesture {
                isFilled.toggle()
            }
    }

    private func destinationView() -> some View {
        switch selection {
        case "1": // Assuming IDs are integers
            return AnyView(CommonExceptionWordsView())
        case "2":
            return AnyView(MakeSentenceView()
                .environmentObject(OrientationInfo())
                .ignoresSafeArea()
            )
        case "3":
            return AnyView(DescribeView()
                .ignoresSafeArea()
            )
        case "4":
            return AnyView(WordSearchView()
                .ignoresSafeArea()
            )
        default:
            return AnyView(Text("Default View"))
        }
    }
}

struct Previews_OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardView().environmentObject(HomeViewModel())
    }
}
