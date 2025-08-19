# Entrega 1.2 - Diseño e implementación de interfaz web móvil

## Objetivos

El objetivo de esta entrega es continuar documentando el diseño de la interfaz de usuario de la aplicación móvil y realizar una implementación inicial de la interfaz utilizando React con Material UI.

## Diseño de Interfaz de Usuario

Para los requisitos funcionales 9 a 12 del [enunciado general del proyecto](../../README.md) (verlos también aquí a continuación), se debe presentar un diseño de interfaz móvil de mediana fidelidad, es decir, mostrar todas las pantallas asemejándose a la interfaz real, pero sin implementar funcionalidad real, sino _sólo navegación básica mediante enlaces entre las distintas pantallas_.

Aparte de los requisitos funcionales ya mencionados, se debe considerar un diseño para la pantalla de inicio de la aplicación. Lo ideal es que la pantalla de inicio pueda ofrecer una funcionalidad básica al usuario sin aún registrarse en la aplicación. Pueden considerar el uso de mapas en esta pantalla, o un _feed_ con destinos populares o definidos por ustedes.

## Completar Diseño de la Interfaz de Usuario (50%)

Se debe completar el diseño de interfaz de usuario de la entrega anterior y ampliarlo para contener las pantallas de interfaz que cumplan con la siguiente funcionalidad (correspondiente a requisitos 9 a 12 del enunciado general):

9. Los usuarios pueden etiquetar (`Tag`) a sus *travel buddies* en las imágenes y vídeos de sus publicaciones.
10. Los usuarios pueden ver las publicaciones de un `Trip` como una galería multimedia, incluyendo las etiquetas y menciones a otros usuarios.
11. Los usuarios pueden ver en un mapa el recorrido de un viaje, visualizando las `Locations` visitadas y los contenidos publicados en cada una.
12. Los usuarios pueden acceder al perfil de otros usuarios, visualizar sus viajes públicos y sus publicaciones compartidas.

Además, se debe agregar diseño de interfaz de usuario para un usuario no registrado que abre la aplicación por primera vez, y una interfaz de pantalla _home_ desde la cual el usuario pueda acceder a las distintas funciones ofrecidas por la aplicación.

## Implementación de la Interfaz de Usuario (50%)

En esta entrega se deben implementar la versión inicial de su aplicación de frontend, la cual debe incluir sus propios componentes de React y el uso la biblioteca MUI para todas las principales pantallas contempladas en su diseño de aplicación. Es importante que los componentes incorporen los elementos de formulario necesarios, pero sin aún implementar su funcionalidad. No es necesario aún integrar mapas en la aplicación.

Deben desarrollar su aplicación de frontend incluyendo:

2.1. Componente principal `App` de la aplicación, junto con interfaz de inicio de la aplicación (home).

2.2. Componente(s) para la interfaz que lista viajes (`index` de viajes). Es necesario llamar a endpoint `GET api/v1/trips` de la API para obtener destinos a listar.

2.3. Componente(s) para la interfaz que lista lugares visitados en un viaje (`index` de lugares visitados). Es necesario llamar a endpoint `GET /api/v1/trips/:trip_id/trip_locations`.

2.4. Componente(s) para la interfaz que muestra las publicaciones en un destino visitado (`index` de bares/eventos). Necesitarían implementar la(s) ruta(s) necesarias en el backend para que recursos de `Posts` sean anidados a los viajes (trips) y ubicaciones visitadas (trip locations). Ejemplo de cómo podrían verse las rutas:

```ruby
# trip_location.rb
class TripLocation < ApplicationRecord
  # Agregar esto:
  has_many :posts, dependent: :destroy
end

# Con lo anterior, se puede hacer:

trip_location = TripLocation.find(123)
trip_location.posts # se obtienen todos los posts asociados a la TripLocation

# Además, hay que ajustar las rutas:

# routes.rb
resources :trips, only: [:index, :show, :create, :update, :destroy] do
  resources :trip_locations, only: [:index, :create, :update, :destroy]
end
resources :trip_locations, only: [:index, :create, :update, :destroy] do
  resources :posts, only: [:index]  # /trip_locations/:trip_location_id/posts
end

# Y modificar PostsController para listar posts de un TripLocation
#posts_controller.rb
def index
  if params[:trip_location_id]
    trip_location = TripLocation.find(params[:trip_location_id])
    render json: trip_location.posts
  else
    render json: Post.all
  end
end
```

2.5. Componente(s) para la interfaz que permitan buscar usuarios por su handle, y ver el perfil de un usuario. Basta la interfaz para ingresar el string de búsqueda. No es encesario implementar llamadas a la API aún.

2.6. Navegación entre la interfaz de inicio (home) y las pantallas arriba listadas. Para esto, incorporar `BrowserRouter` a la aplicación.

Los laboratorios 2 y 3 sirven como base para su trabajo.

## Evaluación

Las partes de diseño e implementación ponderan 50% c/u en la nota de la entrega. En cada parte hay seis ítems. Cada ítem aporta un punto a la parte. A la suma de puntos de cada parte se suma el punto base para obtener una nota en escala 1-7. La nota de la entrega es el promedio de las dos partes.

Cada requisito en cada una de las partes será evaluado en escala 1-5. Estos puntos se traducen a ponderadores:

* 1 -> 0.00: No entregado
* 2 -> 0.25: Esbozo de solucion
* 3 -> 0.50: Logro intermedio
* 4 -> 0.75: Alto logro con deficiencias o errores menores
* 5 -> 1.00: Implementación completa y correcta

Los ponderadores aplican al puntaje máximo del ítem. La nota en escala 1-7 se calcula como la suma de puntajes parciales ponderados más el punto base.

## Forma y fecha de entrega

Con respecto al diseño de interfaz de usuario, deben invitar al ayudante de proyecto que tengan asignado a su proyecto Figma o Axure RP. Además, es conveniente exportar el diseño completo a PDF con estas herramientas y ponerlo en la carpeta `docs/entrega-1.2`, con nombre 'grupoxx.abc', en donde xx es el número del grupo asignado por lista (publicada en Canvas), y .abc es la extensión que corresponda a la herramienta usada (Figma o Axure). 

El código con la implementación de la interfaz de usuario debe ser entregado en su repositorio. Para la evaluación, se debe realizar un pull request que incluya al ayudante de proyecto asignado. Pueden encontrar el usuario de GitHub del ayudante en el listado de grupos de proyecto publicado en Canvas.

La fecha límite para la entrega 1.2 es viernes 29/8 a las 23:59 hrs.