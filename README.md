![SwiftUI](https://img.shields.io/badge/swift-F05138.svg?style=for-the-badge&logo=swift&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)
![Xcode](https://img.shields.io/badge/xcode-336ADB?style=for-the-badge&logo=xcode&logoColor=white)
[![CodeStyle](https://img.shields.io/badge/code%20style-%E2%9D%A4-FF4081.svg?style=for-the-badge)](https://github.com/realm/SwiftLint)
![Swift](https://img.shields.io/badge/swift-5.9-F05138.svg?style=for-the-badge)
![iOS](https://img.shields.io/badge/iOS-17.0-000000?style=for-the-badge)

<h1 align="center"> RickMortyApp </h1>

<p align="center">
  <b>Una aplicación iOS moderna construida con SwiftUI que consume la API de Rick and Morty</b>
</p>

## 📱 Descripción

RickMortyApp es una aplicación iOS desarrollada con SwiftUI que permite explorar los personajes, episodios y ubicaciones de la serie de TV [Rick and Morty](https://www.imdb.com/title/tt2861424/). La aplicación utiliza la [Rick and Morty API](https://rickandmortyapi.com) para obtener los datos.

La aplicación ha sido desarrollada siguiendo los principios de **Clean Architecture**, el patrón **Repository**, y la arquitectura **MVVM** en la capa de presentación, utilizando componentes de SwiftUI.

## ✨ Características

- 📋 Lista de personajes con paginación
- 🔍 Detalles de personajes
- ⭐ Sistema de favoritos
- 🎨 Interfaz moderna con soporte para modo oscuro
- 🏗️ Arquitectura limpia y escalable
- 🧪 Código testeable
- 📦 Inyección de dependencias con Resolver

## 🏗️ Arquitectura

La aplicación sigue los principios de **Clean Architecture**. Esta arquitectura permite:

- **Bajo acoplamiento** entre módulos
- **Alta testabilidad** del código
- **Separación de responsabilidades** clara
- **Escalabilidad** para proyectos grandes
- **Mantenibilidad** a largo plazo

### Capas de la Arquitectura

1. **Presentation Layer**: Contiene las vistas de SwiftUI y ViewModels (MVVM)
2. **Domain Layer**: Contiene las entidades, casos de uso y protocolos de repositorios
3. **Data Layer**: Implementa los repositorios, servicios de red y almacenamiento local

## 🛠️ Tecnologías

- **SwiftUI** - Framework de UI declarativo
- **Swift Concurrency** - Async/await para operaciones asíncronas
- **Resolver** - Inyección de dependencias
- **SwiftLint** - Linter para mantener el código consistente
- **CoreData** - Almacenamiento local para favoritos

## 📋 Requisitos

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+
- CocoaPods

## 📂 Estructura del Proyecto

```
RickMortyApp/
├── features/              # Features organizados por módulo
│   ├── characters/       # Módulo de personajes
│   ├── favorites/        # Módulo de favoritos
│   ├── home/            # Pantalla principal
│   ├── settings/        # Configuración
│   └── splash/          # Pantalla de inicio
├── core/                 # Código compartido
│   ├── network/         # Cliente de red
│   ├── state/           # Estados compartidos
│   └── error/           # Manejo de errores
├── component/           # Componentes reutilizables
├── theme/               # Tema y estilos
└── extensions/          # Extensiones de Swift
```

## 👤 Autor

**Iago Uhia**

- GitHub: [@iagouhia](https://github.com/iagouhia)

