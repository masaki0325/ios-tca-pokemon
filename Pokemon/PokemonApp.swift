//
//  PokemonApp.swift
//  Pokemon
//
//  Created by Masaki Sato on 2024/11/01.
//

import SwiftUI
import ComposableArchitecture
import SwiftData

@main
struct PokemonApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FavoritePokemon.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}

struct MainView: View {
    var body: some View {
        TabView {
            ForEach(TabItem.allCases) { tab in
                tab.view.tabItem {
                    Label(tab.title, systemImage: tab.iconName)
                }
            }
        }
    }
}

enum TabItem: String, CaseIterable, Identifiable {
    case pokemonList
    case favoriteList
    case setting
    
    var id: String { self.rawValue }
    
    var title: String {
        switch self {
        case .pokemonList:
            return "ポケモン一覧"
        case .favoriteList:
            return "お気に入り"
        case .setting:
            return "設定"
        }
    }
    
    var iconName: String {
        switch self {
        case .pokemonList:
            return SFSymbols.list
        case .favoriteList:
            return SFSymbols.starFilled
        case .setting:
            return SFSymbols.gear
        }
    }
}

struct SFSymbols {
    static let list = "list.bullet"
    static let starFilled = "star.fill"
    static let star = "star"
    static let gear = "gearshape"
}

private extension TabItem {
    @ViewBuilder
    var view: some View {
        switch self {
        case .pokemonList:
            PokemonListView(
                store: Store(initialState: PokemonListFeature.State()) {
                    PokemonListFeature()
                }
            )
        case .favoriteList:
            FavoriteListView(
                store: Store(initialState: FavoriteListFeature.State()) {
                    FavoriteListFeature()
                }
            )
        case .setting:
            SettingView()
        }
    }
}

#Preview {
    MainView()
}
