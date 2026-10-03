# Autopartes Pro

Prototipo web en Flutter para una comercializadora de autopartes. Centraliza decisiones de inventario, atención al cliente y visibilidad comercial en un solo panel.

## Capacidades demostradas

- Indicadores de ventas, disponibilidad, pedidos y satisfacción.
- Alertas de reposición y listado filtrable de inventario prioritario.
- CRUD de inventario: crear, consultar, editar y eliminar referencias (solo administrador).
- Persistencia local en el navegador para conservar los cambios del catálogo tras recargar.
- Módulo CRUD de compras y proveedores: aliados, órdenes de compra, estados y valores.
- Módulos CRUD de atención al cliente (casos) y visibilidad comercial (campañas).
- Chatbot de atención integrado con respuestas sobre inventario, pedidos, garantías y horarios.
- Acciones rápidas para compras, cotizaciones y campañas.
- Seguimiento a conversaciones de clientes y estado del servicio.
- Navegación por módulos y diseño responsivo para escritorio y móvil.

## Ejecutar

```powershell
flutter pub get
flutter run -d chrome
```

Los datos son demostrativos y se encuentran definidos en `lib/main.dart`.

AUTOPARTES PRO
Sistema de gestión comercial de autopartes

Descripción
Prototipo web desarrollado en Flutter como caso de estudio
de interacción humano-computador (HCI).

Tecnologías
- Flutter
- Dart
- Material Design
- HTML
- LocalStorage

Módulos
- Autenticación
- Dashboard
- Inventario
- Compras
- Proveedores
- Atención al cliente
- Campañas comerciales
- Chatbot
- Carrito de compras

Características HCI
- Diseño centrado en el usuario
- Usabilidad
- Accesibilidad
- Diseño responsivo
- Retroalimentación de acciones
- Navegación por módulos

Ejecución

flutter pub get
flutter run -d chrome

Datos
El prototipo utiliza datos demostrativos y almacenamiento local
del navegador.

AUTOPARTES
│
├── 📁 assets
│   └── 📁 images
│
├── 📁 lib
│   └── main.dart
│
├── 📁 web
│   └── index.html
│
├── 📄 .gitignore
├── 📄 .metadata
├── 📄 analysis_options.yaml
├── 📄 pubspec.lock
├── 📄 pubspec.yaml
└── 📄 README.md
Frontend

El frontend está desarrollado con:

Flutter + Dart

Los principales archivos son:
lib/main.dart
web/index.html
assets/images/
pubspec.yaml
Flutter se utiliza para construir la interfaz visual y la interacción del usuario.

Incluye módulos/prototipos como:

Inicio de sesión
Dashboard
Inventario
Proveedores
Compras
Atención al cliente
Campañas
Chatbot
Carrito de compras

backend

En la versión del proyecto no existe un backend tradicional separado.

El proyecto utiliza principalmente:

LocalStorage del navegador

En main.dart aparece el uso de:
html.window.localStorage
Frontend: desarrollado en Flutter y Dart, con una interfaz web responsiva y componentes orientados a la interacción humano-computador.
Persistencia de datos: mediante LocalStorage del navegador, utilizado para almacenar datos demostrativos del prototipo.
Backend: el prototipo no implementa actualmente un backend independiente ni una base de datos remota; la persistencia se realiza localmente para efectos de demostración.
┌─────────────────────────────────────┐
│             USUARIO                 │
└─────────────────┬───────────────────┘
                  │
                  ▼
┌─────────────────────────────────────┐
│       FRONTEND – FLUTTER/DART       │
│                                     │
│  Login │ Dashboard │ Inventario     │
│  Compras │ Proveedores │ Clientes   │
│  Campañas │ Chatbot │ Carrito       │
└─────────────────┬───────────────────┘
                  │
                  ▼
┌─────────────────────────────────────┐
│       LOCALSTORAGE DEL NAVEGADOR    │
│                                     │
│       Datos demostrativos           │
└─────────────────────────────────────┘
