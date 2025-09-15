# Entrega 1.4 - Implementación de Funciones Avanzadas

## Objetivos

En esta entrega el foco está en implementar funcionalidad en la aplicación enfocada en publicación y compartición del contenido de los viajes.

## Conjunto de Características a Desarrollar

5. [1.0] Desde una `Location` donde han hecho *check-in*, los usuarios pueden crear publicaciones (`Post`) que ahora podrán incluir texto, imágenes (`Picture`), vídeos (`Video`) y audios (`Audio`).
7. [1.0] Los usuarios pueden buscar a otros usuarios por *handle* y agregarlos como *travel buddies* (`TravelBuddy`), registrando la `Location` y la fecha en que se conocieron.
8. [1.0] Los usuarios pueden invitar a sus *travel buddies* a un viaje específico (`TravelBuddy`), permitiéndoles contribuir con sus propias publicaciones.
10. [1.5] Los usuarios pueden ver las publicaciones de un `Trip` como una galería multimedia, sencilla, permitiendo ver las imágenes, vídeos y audios publicados.
11. [1.5] Los usuarios pueden ver en un mapa el recorrido de un viaje, visualizando las `Locations` visitadas y los contenidos publicados en cada una.

## Implementación de la Funcionalidad

**Requisito 5**

Para implementación de este requisito es necesario enviar archivos al backend. El backend ya está configurado para usar ActiveStorage, y los modelos de `Picture`, `Audio` y `Video` soportan un archivo adjunto.

Puedes ver más abajo en la sección "Flujos de subida de archivos con ActiveStorage" cómo Rails con ActiveStorage ofrecen dos flujos de subida de archivos para las aplicaciones con frontend desacoplado como la que estás desarrollando. Para un ejemplo de componente de subida de archivos, revisa [este gist](https://gist.github.com/claudio-alvarez/3fa7c6e9271bd95ae2191bd8dd0ddf75), que contiene un ejemplo que muestra el flujo de subida de archivo directa. Básicamente, en este ejemplo el handler `handleSubmit` implementa el proceso de subida de archivos, y lo hace de la siguiente manera:

1. **Preparación del estado**: reinicia la barra de progreso y limpia mensajes de estado anteriores.

2. **Creación del blob en Rails**  
   - Envía una petición `POST` a `/rails/active_storage/direct_uploads` con la metadata del archivo (nombre, tamaño, tipo de contenido y checksum MD5).  
   - Rails responde con un `signed_id` y los datos de `direct_upload` (URL y headers) necesarios para subir el archivo al storage configurado.

3. **Subida del archivo al servicio de almacenamiento**  
   - Realiza un `PUT` de los bytes del archivo directamente a la URL firmada (`direct_upload.url`).  
   - Este paso incluye los headers provistos por Rails (ej. `Content-Type`, `Content-MD5`).  
   - Se actualiza el progreso en pantalla mediante `onUploadProgress`.

4. **Creación del registro de Video**  
   - Envía una petición `POST` a `/videos`, pasando el título ingresado y el `signed_id` recibido en el paso 2.  
   - Rails asocia el blob subido al nuevo modelo `Video`.

5. **Manejo de resultados**  
   - Si todo resulta exitoso, se muestra un mensaje con el ID del video creado.  
   - Si ocurre un error en cualquiera de las etapas, se captura y se muestra un mensaje de error.

En síntesis, `handleSubmit` coordina los tres pasos fundamentales del proceso de subida de archivo:
- registrar el blob en Rails,  
- subir el archivo al destino final,  
- y asociar el blob con un modelo (`Video`).

**Requisito 11**

A diferencia del ejemplo que has visto en el laboratorio 5, en el proyecto del curso es necesario guardar los marcadores del mapa con los destinos del viaje en el backend, es decir, no localmente con `localStorage`, sino en la base de datos de la aplicación. Esto permitirá que el usuario pueda iniciar la aplicación en distintos dispositivos, y que la información de destinos de viaje en el mapa se mantenga persistente y siempre accesible en forma consistente.

Si fuera necesario, puedes modificar y agregar endpoints que te faciliten lo anterior, e incluso realizar migraciones para modificar las tablas en la base de datos.

## Sobre herramientas a utilizar

En esta entrega pueden aplicarse todos los conocimientos vistos en clases, en los laboratorios, y en la lectura del libro The Road to React. Esto incluye el uso de módulos con hooks desarrollados por terceros, el uso de componentes de MUI, etc.

### Flujos de subida de archivos con ActiveStorage

ActiveStorage dos tipos de **flujos de subida** de archivos para una aplicación con frontend desacoplado (SPA) como es el caso en nuestro proyecto:

#### 1. Subida directa al controlador Rails (*Direct Attachment*)
- **Descripción**: el archivo se envía como parte de un `multipart/form-data` directamente al endpoint de tu modelo (ej. `POST /videos` con `video[file]`).
- **Qué pasa internamente**:  
  - Rails recibe el archivo como parámetro.  
  - Se crea un blob en ActiveStorage y se guarda el archivo en el servicio configurado (Disk, S3, etc.).  
  - El modelo queda asociado al blob con `has_one_attached` o `has_many_attached`.
- **Ventajas**: implementación sencilla, no requiere lógica extra en el frontend.  
- **Desventajas**: el backend Rails procesa y transmite todos los bytes → puede ser un cuello de botella para archivos grandes o muchos usuarios.

#### 2. Subida directa al servicio de almacenamiento (*Direct Upload*)
- **Descripción**: el frontend coordina la subida.  
  1. Pide a Rails la creación de un blob (`POST /rails/active_storage/direct_uploads`).  
  2. Sube el archivo **directamente** al servicio de almacenamiento (S3/GCS/Disk) usando la URL firmada.  
  3. Informa a Rails el `signed_id` para asociarlo al modelo.
- **Qué pasa internamente**:  
  - Rails genera un blob y devuelve credenciales temporales de subida.  
  - El archivo nunca pasa por Rails (salvo si el servicio es `Disk`, en cuyo caso Rails recibe el `PUT`).  
  - Al crear el modelo (ej. `POST /videos`), se adjunta el blob con `file: signed_id`.
- **Ventajas**: Rails no procesa los bytes → mejor rendimiento y escalabilidad.  
- **Desventajas**: más complejo de implementar (necesita checksum, manejo de dos requests en frontend).

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

La fecha límite para la entrega 1.4 es viernes 26/9 a las 23:59 hrs.