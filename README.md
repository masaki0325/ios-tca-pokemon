# ポケモンリストアプリ

このSwiftUIアプリは、[PokéAPI](https://pokeapi.co/)のデータを使用してポケモンを探索し、お気に入りに追加することができます。[Composable Architecture (TCA)](https://github.com/pointfreeco/swift-composable-architecture)を使用した状態管理と、`SwiftData`を使用したお気に入りポケモンの永続的な保存機能を備えています。

## 特徴

- **ポケモンリスト**: 無限スクロール対応のページネーション付きポケモンリストを表示。
- **お気に入り機能**: ポケモンをお気に入りに追加し、専用タブで確認可能。
- **詳細画面**: 各ポケモンの詳細情報を表示。
- **データ永続化**: `SwiftData`を使用してお気に入りを永続的に保存。

## 使用技術

### フロントエンド
- **SwiftUI**: Appleの宣言的UIフレームワーク。
- **Composable Architecture (TCA)**: Point-Freeが開発した強力な状態管理アーキテクチャ。
- **Combine**: 非同期処理とデータストリーム管理。

### バックエンド
- **PokéAPI**: ポケモンに関するオープンなAPI。

### 永続化
- **SwiftData**: ローカルストレージを管理するための新しいデータ永続化フレームワーク。

## システム要件

- **Xcode**: バージョン15以上
- **iOS**: バージョン16以上
