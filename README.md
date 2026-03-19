# rickapi

## descripción del proyecto

Mi Multiverso Squad es una aplicación web desarrollada con Flutter que se integra con la Rick and Morty API para consumir el endpoint de personajes. La plataforma renderiza a cada personaje en tarjetas organizadas en un Grid, ofreciendo una experiencia fluida y visualmente atractiva.

### Funcionalidades
-Filtrado : Incluye un DropdownButton para filtrar por estado (Alive, Dead, Unknown) y un buscador por nombre con respuesta en tiempo real.

-Gestión de Favoritos: Permite gestionar una lista de personajes favoritos visualizada en un ListView.

-Estado con Provider: Utiliza Provider para notificar cambios a los widgets correspondientes. Al agregar o eliminar un personaje mediante el botón de tipo toggle, la interfaz se repinta automáticamente sin necesidad de recargar la página.

-Persistencia de Datos: Se utiliza shared_preferences para garantizar que la lista de favoritos se conserve en el almacenamiento local, permitiendo que los personajes sigan presentes en la vista de favoritos incluso tras recargar el navegador.

### Estética y Diseño
Visualmente, el proyecto adopta una estética radiactiva y futurista, donde predominan los tonos verdes neón y tipografías temáticas de la serie, complementadas con frases e iconos icónicos de Rick and Morty.

## Instrucciones de instalación 
1. Clonar el proyecto
   
Abre la terminal y ejecuta:
```bash
git clone https://github.com/sofisdevops/rick_and_morty-Persistencia-de-datos-Flutter.git
cd rick_and_morty-Persistencia-de-datos-Flutter
  ```
2.Instalar dependencias

Descarga todos los paquetes necesarios (Provider, Shared Preferences, http) definidos en el pubspec.yaml
```bash
flutter pub get
  ```
3. Ejecutar la aplicación

Para ejecutar el proyecto en el navegador ejecuta:

```bash
flutter run -d chrome
  ```

## Captura de pantalla 

### screen explorar

### screen explorar

### screen favoritos

