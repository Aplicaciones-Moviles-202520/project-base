# Entrega 1.3 - Implementación de Funcionalidad Básica

## Objetivos

El objetivo de esta entrega es avanzar en la implementación de la funcionalidad de la aplicación después de haber prototipado la mayor parte de su funcionalidad relevante, y haber iniciado la implementación con React y MUI del frontend en la entrega anterior.

## Conjunto de Características a Desarrollar

En esta entrega el foco está en implementar funcionalidad en la aplicación que permita al usuario autenticarse y crear viajes, buscar ubicaciones, registrar ubicaciones visitadas en los viajes, y realizar publicaciones en los viajes. Las características específicas del enunciado general que se deben incorporar son las siguientes:

1. [1.0] Los usuarios (ver modelo `User` y tabla correspondiente) pueden registrarse ingresando nombre, correo electrónico, un *handle* (similar a X o Instagram, p. ej., `@nomadclimber`), y su nacionalidad (ver modelo `Country`).
2. [1.0] Los usuarios pueden crear nuevos viajes (`Trip`), dándoles un título y descripción, además de una fecha de inicio y término opcional.
3. [1.5] Los usuarios pueden buscar ubicaciones (`Location`) por nombre o seleccionarlas desde un mapa interactivo, y agregarlas a algún viaje en el orden en que las visitarán.
4. [.5] Los usuarios pueden hacer *check-in* en una `Location` de un `Trip` en curso, registrando la fecha de la visita. Esto crea una entrada en `TripLocation`.
5. [1.0] Desde una `Location` donde han hecho *check-in*, los usuarios pueden crear publicaciones (`Post`) que incluyan sólo texto (por ahora).
6. [1.0] Los usuarios pueden ver la cronología de publicaciones de un viaje, ordenadas por fecha y agrupadas por ubicación visitada.

## Implementación de la Funcionalidad

**Requisito 1**
La funcionalidad de registro usuario y acceso autenticado a la aplicación es provista por la aplicación de backend a través de su API. Considerar las siguientes rutas y sus controladores y acciones asociados:

```ruby
  devise_for :users, defaults: { format: :json }, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }
```

Se debe incorporar a la interfaz web móvil los componentes necesarios para el, registro, inicio y cierre de sesión. El formulario de registro debe validar el texto de los campos necesarios. Esto incluye validar en el frontend el formato de dirección de correo electrónico, y que campos obligatorios no estén vacíos. El formulario de login también tiene que tener validación. Si nombre de usuario y contraseñas son incorrectos, se debe mostrar una retroalimentación apropiada al usuario.

**Requisito 2**

Deben utilizar Formik y Yup para implementar la funcionalidad requerida. Además, deben utilizar `DatePicker` de MUI para la selección de fechas.

**Requisito 3**

Deben utilizar las APIs de Google Maps y geocoder para buscar ubicaciones. Para esto tendrán como base los laboratorios 4 y 5, junto con los ejemplos de la clase 5. Todo este material estará disponible en GitHub.

**Requisito 6**

La carga de las publicaciones debe realizarse en forma completamente asíncrona, usando hook `useReducer` (función reductora) para actualizar los estados de carga, error, y las publicaciones. Para el estado de carga considerar un mensaje desplegado en la interfaz "cargando..." o el uso de una animación de tipo spinner. Estará permitido no usar `useReducer` con un máximo de 3/5 puntos en este ítem de evaluación.

Dado que el número de publicaciones puede ser considerable, incorporar [paginación de elementos con MUI](https://mui.com/material-ui/react-pagination/), o [scrolling infinito con MUI](https://stackblitz.com/edit/react-ektjug?file=Demo.tsx).

## Sobre herramientas a utilizar

En esta entrega pueden aplicarse todos los conocimientos vistos en clases, en los laboratorios, y en la lectura del libro The Road to React. Esto incluye el uso de módulos con hooks desarrollados por terceros, como el de `use-local-storage-state`, y `axios-hooks`.

## Sobre el Backend

La aplicación de backend contiene controladores requeridos por la funcionalidad básica a implementar en esta entrega. Está permitido modificar los controladores e incorporar nuevas rutas si por cualquier razón (p.ej., falta de funcionalidad) se requiere.

Actualmente, en el script de seeds de la base de datos se utilizan fábricas de FactoryBot definidas en `backend/spec/factories`. Si bien es posible omitir el uso de fábricas y crear modelos directamente en la base de datos,o usar archivos con fixtures, el uso de fábricas permite crear objetos para fines de desarrollo o pruebas con mucha flexibilidad y en gran cuantía si fuera necesario.

* Libro de [FactoryBot](https://thoughtbot.github.io/factory_bot/intro.html)

## Evaluación

Cada requisito en cada una de las partes será evaluado en escala 1-5. Estos puntos se traducen a ponderadores:

* 1 -> 0.00: No entregado
* 2 -> 0.25: Esbozo de solucion
* 3 -> 0.50: Logro intermedio
* 4 -> 0.75: Alto logro con deficiencias o errores menores
* 5 -> 1.00: Implementación completa y correcta

Los ponderadores aplican al puntaje máximo del ítem. La nota en escala 1-7 se calcula como la suma de puntajes parciales ponderados más el punto base.

## Forma y fecha de entrega

El código con la implementación de la aplicación debe ser entregado en este repositorio. Para la evaluación, se debe realizar un pull request que incluya al ayudante de proyecto asignado.

La fecha límite para la entrega 1.3 es viernes 12/9 a las 23:59 hrs.