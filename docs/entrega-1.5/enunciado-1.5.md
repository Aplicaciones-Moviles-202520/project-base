# Entrega 1.5 - Completar la funcionalidad y desplegar en producción

## Objetivos

En esta entrega el foco está en completar la funcionalidad de la aplicación TravelLog y realizar su despliegue en el ambiente de producción.

## Conjunto de Características a Desarrollar

Para esta entrega se requiere implementar la siguiente funcionalidad. Notar que al igual que en los enunciados anteriores, los números de las funcionalidades son en referencia al enunciado general del proyecto.

6. [1.5] Los usuarios pueden ver la cronología de publicaciones de un viaje, ordenadas por fecha y agrupadas por ubicación visitada.
9. [1.5] Los usuarios pueden etiquetar (`Tag`) a sus *travel buddies* en las imágenes y vídeos de sus publicaciones.
12. [1.5] Los usuarios pueden acceder al perfil de otros usuarios, visualizar sus viajes públicos y sus publicaciones compartidas.

Aparte de las tres funcionalidades anteriores, en esta entrega final se requiere el despliegue en producción de la aplicación.

## Implementación de la Funcionalidad

**Requisito 6**

Para lograr una experiencia altamente usable en dispositivos móviles con React 19 + MUI, se recomienda considerar los siguientes aspectos:

1. **Estructura de timeline**
   - Usar `List` o [`Timeline`](https://mui.com/material-ui/react-timeline/) de MUI para representar la cronología.
   - Mantener un diseño **vertical con scroll suave** (más natural en pantallas móviles).
   - Evitar timelines horizontales, ya que resultan incómodos en pantallas pequeñas.

2. **Agrupación por ubicación**
   - Utilizar [`Accordion`](https://mui.com/material-ui/react-accordion/) para plegar/desplegar publicaciones por ciudad o lugar visitado.
   - Alternativamente, usar [`ListSubheader`](https://mui.com/material-ui/api/list-subheader/) como encabezado sticky con el nombre de la ubicación.

3. **Representación visual clara**
   - Mostrar cada publicación en un `Card` o `Paper` con:
     - `CardMedia` para la foto/video.
     - `CardContent` para fecha, descripción y tags.
   - Usar `Chip` para resaltar fecha o ubicación.
   - Mostrar tags de *travel buddies* con [`AvatarGroup`](https://mui.com/material-ui/api/avatar-group/).

4. **Jerarquía visual y navegación**
   - Orden cronológico descendente (lo más reciente primero).
   - Separar secciones de ubicación con `Divider` con texto, por ejemplo:  
     *“Roma, Italia – Junio 2025”*.
   - Usar tipografía legible: `Typography` con `body2` o `subtitle2`.

5. **Interacciones táctiles**
   - Mantener botones de acción (`IconButton`) con tamaño mínimo de **44×44 px**.
   - Ofrecer acciones rápidas (like, comentar, compartir).
   - Para acciones adicionales, usar `Menu` contextual o un `BottomSheet`.

6. **Performance y carga progresiva**
   - Se puede implementar **carga floja/infinite scroll** con [`IntersectionObserver`](https://www.npmjs.com/package/react-intersection-observer). Dejamos esto como un desafío para quiénes tengan interés en implementar una vista con carga óptima, no es una obligación.
   - Si se usa carga floja, mostrar placeholders con [`Skeleton`](https://mui.com/material-ui/api/skeleton/) de MUI durante la carga.
   - Optimizar imágenes (miniaturas adaptadas a pantallas móviles).

**Requisito 9**

En consideración de la usabilidad en dispositivos móviles, damos recomendaciones respecto a la implementación de este requisito:

### Consejos para implementar el etiquetado de *travel buddies* en imágenes y vídeos

1. **Selección de usuarios a etiquetar**
   - Usar un campo de autocompletado (`Autocomplete` de MUI) para buscar y seleccionar amigos (*travel buddies*).  
   - Permitir selección múltiple (`multiple`), mostrando los nombres como `Chip` con `Avatar` integrado.

2. **Interacción sobre la imagen/video**
   - Al tocar una zona de la imagen, mostrar un **overlay** o **popover** donde el usuario pueda elegir el amigo a etiquetar.  
   - Para simplificar en móviles, se recomienda un **tap simple + menú de selección** en vez de arrastrar o gestos complejos.
   - Sería necesario guardar las coordenadas del tag usando `x_frac`, `y_frac` en el modelo `Tag`.
   - Para vídeos bastaría mostrar una lista con las personas etiquetadas, debajo del vídeo.

3. **Visualización de etiquetas**
   - Idealmente, mostrar un **marcador discreto** (círculo o ícono) sobre la imagen en la posición del tag. Es decir, al desplegar una imagen, deben cargarse sus tags y renderizar los marcadores encima de la imagen. El marcador podría consistir, por ejemplo, en un caracter ° en fondo transparente.
   - Al tocar el marcador, se despliega el nombre del amigo (por ejemplo, con un `Tooltip` o `Popover`).

4. **Edición y borrado**
   - Los tags deben ser editables: opción de eliminar .  
   - Para mantener la usabilidad en móviles, es recomendable usar un **menú contextual con opciones “Editar” y “Eliminar”**.

5. **Accesibilidad y feedback**
   - Incluir feedback inmediato: cuando se agrega un tag, debe aparecer de forma visible en la imagen y en la lista de etiquetados.  
   - Usar colores contrastantes para que los marcadores sean distinguibles tanto en modo claro como en modo oscuro.

**Requisito 12**

Para este requisito es importante mantener la consistencia de la interfaz, y utilizar componentes de MUI apropiados como los que se proponen en las recomendaciones para los requisitos anteriores.

**Despliegue en Producción**

Podrán desplegar su aplicación en producción utilizando una infraestructura que ha sido dispuesta para estos fines, junto con automatización provista por GitHub Actions. Para realizar el despliegue, deben leer la página ["Proyecto 1: Despliegue en Producción"](https://uandes.instructure.com/courses/41133/pages/proyecto-1-despliegue-en-produccion) disponible en Canvas, la cual incluye un vídeo explicativo.

## Evaluación

Cada requisito en cada una de las partes será evaluado en escala 1-10. Estos puntos se traducen a ponderadores:

* 1: No entregado
* 2 a 4: Esbozo de solucion
* 5 a 6: Logro intermedio
* 7 a 8: Alto logro con deficiencias o errores menores
* 9 a 10: Implementación completa y correcta

Estos puntajes (P_i) serán traducidos a un ponderador entre 0 y 1 considerando (1/9)(P_i-1). Dichos ponderadores serán aplicados al puntaje máximo del ítem. La nota será la suma de los puntajes ponderados más el punto base.

## Forma y fecha de entrega

El código con la implementación de la aplicación debe ser entregado en este repositorio. Para la evaluación, se debe realizar un pull request que incluya al ayudante de proyecto asignado.

La fecha límite para la entrega 1.5 es lunes 6/10 a las 23:59 hrs., sin posibilidad de postergación.