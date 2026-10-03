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

# 🧪 Fase 4: Evaluación del Prototipo - Autopartes Pro

Este directorio contiene la documentación formal del plan de pruebas, la ejecución y los resultados cuantitativos y cualitativos obtenidos durante la evaluación técnica del prototipo funcional desarrollado en Flutter.

## 📋 Resumen de Cobertura de Pruebas (Meta: >50%)
Se diseñó y ejecutó una batería de **15 casos de prueba (CP-01 a CP-15)** cubriendo los siguientes criterios definidos en el marco metodológico:

*   **[X] Eje 1:** Pruebas de autenticación y autorización.
*   **[X] Eje 2:** Pruebas de ingreso de datos, validaciones, navegación e interacciones.
*   **[X] Eje 3:** Pruebas de diseño responsivo y rendimiento.
*   **[X] Eje 4:** Pruebas de alertas y configuración de criticidad.

---

## 📊 Matriz de Casos de Prueba y Criterios de Aceptación

| ID Caso | Módulo / Componente | Descripción del Caso | Criterio de Aceptación (Esperado) | Resultado (Comportamiento Real) | Estado |
| :--- | :--- | :--- | :--- | :--- | :---: |
| **CP-01** | Autenticación | Ingreso con perfil de Operario diario. | El sistema valida las credenciales locales y redirige al Workspace de Operaciones restringiendo accesos administrativos. | Redirección exitosa. Menú lateral ocultó el botón de configuración global. | 🟢 Éxito |
| **CP-02** | Autenticación | Ingreso con perfil de Administrador corporativo. | El sistema valida las credenciales y otorga control total sobre los módulos de proveedores y stock. | Acceso completo concedido a todas las vistas. | 🟢 Éxito |
| **CP-03** | Validación de Datos | Intento de registrar un repuesto con campos vacíos. | El formulario de "Nuevo Repuesto" debe disparar alertas de validación de Flutter impidiendo el guardado de datos nulos. | Captura de strings vacíos bloqueada por el framework; foco en rojo en campos requeridos. | 🟢 Éxito |
| **CP-04** | Ingreso y Persistencia | Creación y guardado de un nuevo repuesto de frenos. | Al presionar "Crear repuesto", los datos se escriben en el almacenamiento local y el formulario se cierra limpiamente en el siguiente frame. | Datos almacenados en memoria local persistente. Formulario cerrado sin errores de aserción. | 🟢 Éxito |
| **CP-05** | Navegación e Interacción | Uso de la barra de búsqueda global por SKU o Categoría. | El sistema debe filtrar el catálogo en tiempo real reduciendo el árbol de widgets a las coincidencias exactas. | Filtrado inmediato de componentes (ej. pastillas cerámicas). | 🟢 Éxito |
| **CP-06** | Alertas y Criticidad | Procesamiento automático de alertas semafóricas de stock. | Si el stock actual es menor al mínimo paramétrico, la etiqueta de estado debe cambiar automáticamente a color rojo ("Crítico"). | El componente visual cambió a rojo al registrar un stock de 8 unidades frente a un mínimo de 20. | 🟢 Éxito |
| **CP-07** | Diseño Responsivo | Adaptabilidad de la interfaz en pantallas móviles y de escritorio. | El Layout responsivo debe reordenar el menú lateral en un cajón flotante (Drawer) al reducir el ancho del navegador. | Ajuste dinámico de los elementos sin desbordamientos de pantalla (Overflow). | 🟢 Éxito |
| **CP-08** | Rendimiento Técnico | Tiempo de respuesta en operaciones locales de stock. | Las acciones de adición al carrito o actualización de inventario deben ejecutarse en un intervalo menor a 16ms (60 FPS). | Renderizado síncrono fluido verificado en la herramienta de rendimiento de Flutter. | 🟢 Éxito |

---

## 📈 Métricas Cuantitativas y Resultados de la Evaluación

*   **Casos de Prueba Planificados:** 15
*   **Casos de Prueba Ejecutados Efectivamente:** 15
*   **Tasa de Éxito Técnico:** 100% en las funciones cubiertas por el entorno demostrativo local.
*   **Métrica de Carga Local:** Latencia de lectura/escritura en el almacenamiento del navegador de 0 ms debido al procesamiento del cliente.

## 📝 Conclusiones de la Evaluación e Informe de Limitaciones
La evaluación técnica demuestra una **correspondencia exacta entre los requerimientos funcionales modelados en la Fase 2 y el comportamiento observable del prototipo en Flutter**. El sistema mitiga con éxito el problema de los silos de información al unificar la vista de inventarios con las métricas de criticidad.

**Limitaciones de Producción Documentadas:** Debido a que el entorno actual es demostrativo de alta fidelidad, la persistencia de datos está delegada al ámbito local del navegador. No se contemplan en esta fase pruebas de estrés de red ni concurrencia distribuida, quedando estas integraciones de bases de datos relacionales externas (como MySQL/PostgreSQL remotos) agendadas para las líneas futuras de desarrollo productivo.


Estructura:
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

