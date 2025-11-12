# Entrega 2.3 — TravelLog-PhotoViewer

## Contexto general

TravelLog-PhotoViewer es una PWA móvil enfocada en la exploración y consulta de fotografías asociadas a los viajes del usuario en la plataforma TravelLog. A diferencia de la aplicación principal, esta PWA no crea ni edita viajes, posts o imágenes: su objetivo es ofrecer acceso móvil rápido, instalación como aplicación, navegación estructurada (Trips > Posts > Pictures), visualización de imágenes y un buscador semántico por etiquetas (labels) derivadas del análisis automático. Todo el contenido se obtiene exclusivamente desde las apis disponibles desde backend-server y backend-serverless (entrega 2.2), sin introducir endpoints adicionales salvo un `heartbeat` para verificación de conectividad y las configuraciones que sean necesarias para resolver los problemas de CORS considerando que la PWA se servirá desde un dominio distinto al del backend.

Para la descripción de la aplicación se utilizará una estrategia de desarrollo ágil basada en historias de usuario, priorizadas y organizadas en Epics. Cada historia detalla una funcionalidad específica, sus criterios de aceptación y la Definition of Done (DoD), para alinear el desarrollo con lo que sería una práctica estándar de la industria.

### Principios clave

- Consumo exclusivo de APIs existentes
- Actualización de datos estructurados solo bajo demanda (botón "Actualizar"), evitando sincronizaciones automáticas
- Caché controlado y acotado para uso offline
- Simplicidad de interfaz: acordeón jerárquico, modal bloqueante y buscador semántico colapsable sin paginación

### Requerimientos y excepciones

- La aplicación debe ser desarrollada usando React (con Create React App, Vite, Next.js u otro framework similar)
- Debe ser compatible con a lo menos un browser/os (se recomienda Chrome sobre Android)
- La PWA debe ser instalable y funcionar correctamente en modo `standalone`
- No se requiere uso de frameworks nativos como React Native, Flutter u otros
- No se requiere que la PWA sea instalable en browser de escritorio
- No se requiere el uso de estados o hooks avanzados más allá de lo necesario para cumplir los requisitos funcionales. Se acepta `Inline JS` y resulta suficiente para comportamientos simples como los toggles de los elementos visuales

### Layout general como SPA

- Esta entrega se debe centrar en la problemática de las PWAs móviles, no en el diseño visual detallado
- En la carpeta `example` se incluye una maqueta HTML/CSS/JS estática que ilustra la estructura y comportamiento esperado de la aplicación
- La maqueta es una guía funcional que se puede utilizar tal cual para su entrega; será responsabilidad del equipo desglosar los componentes que sean necesarios para implementarla en React

### Organización del desarrollo

- [Epic 1: Implementación inicial de la PWA](#epic-1-implementacion-inicial-de-la-pwa)
  - [US-PWA-01 - Integración de maqueta en React](#us-PWA-01---integracion-de-maqueta-en-react)
  - [US-PWA-02 - Login UI con validaciones](#us-PWA-02---login-ui-con-validaciones)
  - [US-Auth-01 - Inicio de sesión con credenciales existentes](#us-auth-01---inicio-de-sesion-con-credenciales-existentes)
  - [US-Auth-02 - Persistencia y restauración de sesión](#us-auth-02---persistencia-y-restauracion-de-sesion)
  - [US-Auth-03 - Cierre de sesión](#us-auth-03---cierre-de-sesion)
- [Epic 2: Compilación estática y despliegue en S3 + CloudFront](#epic-2-compilacion-estatica-y-despliegue-en-s3--cloudfront)
  - [US-Build-01 - Compilación estática de la PWA](#us-build-01---compilacion-estatica-de-la-pwa)
  - [US-Deploy-01 - Sitio disponible via CloudFront y HTTPS](#us-deploy-01---sitio-disponible-via-cloudfront-y-https)
  - [US-Deploy-02 - IaC: Infra core + certificado y dominio](#us-deploy-02---iac-infra-core--certificado-y-dominio)
  - [US-PWA-03 - Instalación como PWA](#us-pwa-03---instalacion-como-pwa)
  - [US-API-01 - Backend: heartbeat y CORS](#us-API-01---backend-heartbeat-y-cors)
  - [US-API-02 - Frontend: botón Probar y manejo de errores](#us-API-02---frontend-boton-probar-y-manejo-de-errores)
- [Epic 3: Recuperación y visualización básica de datos](#epic-3-recuperacion-y-visualizacion-basica-de-datos)
  - [US-Data-01 - Fetch y ensamblado del árbol](#us-Data-01---fetch-y-ensamblado-del-arbol)
  - [US-Data-02 - Persistencia en localStorage y arranque desde caché](#us-Data-02---persistencia-en-localstorage-y-arranque-desde-cache)
  - [US-Data-03 - Botón de actualización completa](#us-Data-03---boton-de-actualizacion-completa)
  - [US-Data-04 - Visualización en acordeón](#us-Data-04---visualizacion-en-acordeon)
  - [US-Data-05 - Caché y modo sin conexión](#us-Data-05-cache-y-modo-sin-conexion)
- [Epic 4: Visualización de imágenes con modal y caché](#epic-4-visualizacion-de-imagenes-con-modal-y-cache)
  - [US-Image-01 - Lista de vínculos por imagen usando el content del post](#us-image-01---lista-de-vinculos-por-imagen-usando-el-content-del-post)
  - [US-Image-02 - Modal: camino feliz (obtain, redirect, render)](#US-Image-02---modal-camino-feliz-obtain-redirect-render)
  - [US-Image-03 - Modal: errores y reintentos](#US-Image-03---modal-errores-y-reintentos)
  - [US-Image-04 - Caché: almacenamiento de imágenes vistas](#US-Image-04---cache-almacenamiento-de-imagenes-vistas)
  - [US-Image-05 - Caché: política LRU de 9 imágenes](#US-Image-05---cache-politica-lru-de-9-imagenes)
  - [US-Image-06 - Comportamiento sin conexión en el modal](#US-Image-06---comportamiento-sin-conexion-en-el-modal)
- [Epic 5: Buscador semántico](#epic-5-buscador-semantico)
  - [US-Sem-01 - UI y mapeo de etiquetas](#US-Sem-01---ui-y-mapeo-de-etiquetas)
  - [US-Sem-02 - Integración API: construcción de query `scan` y fetch](#US-Sem-02---integracion-api-construccion-de-query-scan-y-fetch)
  - [US-Sem-03 - Grilla 3x3: layout y placeholders](#US-Sem-03---grilla-3x3-layout-y-placeholders)
  - [US-Sem-04 - Grilla 3x3: reutilización de caché sin refetch](#US-Sem-04---grilla-3x3-reutilizacion-de-cache-sin-refetch)
  - [US-Sem-05 - Modal al hacer clic sobre thumbnail](#US-Sem-05---modal-al-hacer-clic-sobre-thumbnail)
  - [US-Sem-06 - Estados de carga y errores en buscador](#US-Sem-06---estados-de-carga-y-errores-en-buscador)

## Epic 1: Implementación inicial de la PWA

Objetivo: Inicializar la aplicación React y habilitar el acceso con las credenciales existentes en el backend-server actual, con persistencia de sesión y cierre de sesión, sin considerar aún el uso en dispositivos móviles.

### Historias de usuario

#### US-Auth-01 - Inicio de sesión con credenciales existentes

- Historia de usuario:
  - Como usuario de TravelLog-PhotoViewer, quiero iniciar sesión con las mismas credenciales que uso en la app de escritorio para acceder a mis fotos
- Criterios de aceptación:
  - Dado credenciales válidas, al enviar el formulario accedo a la app en estado autenticado
  - Dado credenciales inválidas, veo un mensaje claro de error
  - La autenticación usa exclusivamente la API del backend-server

#### US-Auth-02 - Persistencia y restauración de sesión

- Historia de usuario:
  - Como usuario, quiero mantener mi sesión al reabrir la app para no tener que reautenticarme cada vez
- Criterios de aceptación:
  - Si existe una sesión válida, la app inicia autenticada sin mostrar login
  - Si la sesión expira se limpia el estado y se redirige a login
  - No es necesario refrescar tokens automáticamente; basta con detectar expiración y pedir re-login

#### US-Auth-03 - Cierre de sesión

- Historia de usuario:
  - Como usuario, quiero cerrar sesión y volver a la pantalla de login
- Criterios de aceptación:
  - Al cerrar sesión se invalida la sesión en el cliente
  - Se limpia cualquier estado de usuario en el cliente
  - La app redirige a la pantalla de login
  - Se elimina el token o credenciales almacenadas en el cliente
  - No es necesario invalidar la sesión en el servidor

### No requerido como parte del Epic 1

- App shell cacheado, funcionamiento offline, estrategias de caché, background sync, notificaciones, UI de galería u otras funcionalidades. El epic se centra exclusivamente en la construcción de la app, el login/logout y la persistencia de sesión como webapp de escritorio no instalable
- No es necesario gestionar roles, permisos, recuperación de contraseñas u otros flujos de autenticación avanzados

### Definition of Done (Epic 1)

- Login, persistencia de sesión y logout funcionando en navegador de escritorio

#### US-PWA-01 - Integración de maqueta en React

- Historia de usuario:
  - Como desarrollador, quiero adaptar la maqueta HTML/CSS/JS a componentes de React para acelerar la implementación
- Criterios de aceptación:
  - La aplicación React está inicializada con el framework elegido (Vite, CRA, Next u otro) y tiene estructura mínima lista para desarrollo local
  - La maqueta está integrada en React: se desglosa en componentes reutilizables (p. ej.: Header, MainContainer) conservando estilos y comportamiento visual

#### US-PWA-02 - Login UI con validaciones

- Historia de usuario:
  - Como desarrollador, quiero construir la pantalla de inicio de sesión con validaciones básicas y un submit para luego conectar la API
- Criterios de aceptación:
  - Existe una vista de “Inicio de sesión” con campos de usuario/email y contraseña, y un botón “Ingresar”
  - Validaciones básicas en cliente: campos requeridos y mensajes de error visibles en la propia vista
  - El envío del formulario invoca una función interna que se debe conectar a la API en US-Auth-01
  - La app muestra la vista de inicio de sesión por defecto cuando no hay sesión activa

## Epic 2: Compilación estática y despliegue en S3 + CloudFront

Objetivo: Compilar la aplicación como sitio estático y disponibilizarla públicamente desde un bucket S3 servido mediante una distribución CloudFront. Esto se puede hacer de dos formas:

- **Manual (consola web AWS)**: se debe crear un bucket S3 (privado, acceso solo vía CloudFront), se debe crear una distribución CloudFront con Origin Access Control (OAC) apuntando al bucket, se debe configurar una política de caché deshabilitada (TTL 0; `Managed-CachingDisabled` o equivalente), se debe asociar el dominio previsto en `exampledomain.cloud` con un certificado SSL emitido y validado por AWS Certificate Manager (ACM), se debe ajustar la política del bucket para permitir OAC y se deben subir los artefactos de build
- **Infraestructura como Código**: se puede extender el template de CloudFormation de la entrega 2.2 agregando recursos S3 + CloudFront (+ OAC, políticas, outputs), se debe deshabilitar caché en la distribución (TTL 0; cache policy sin almacenamiento) y se debe asociar el dominio provisto con certificado de ACM (se puede parametrizar el ARN del certificado). Puede tomarse como referencia el ejemplo de despliegue del laboratorio 9

### Historias de usuario

#### US-Build-01 - Compilación estática de la PWA

- Historia de usuario:
  - Como responsable de despliegue, quiero generar un artefacto estático (build) para poder servir la app desde S3/CloudFront
- Criterios de aceptación:
  - El proyecto compila a assets estáticos (HTML/CSS/JS/manifest/iconos) mediante el script de build del frontend
  - El resultado queda en una carpeta de salida lista para ser subida a S3

#### US-Deploy-01 - Sitio disponible via CloudFront y HTTPS

- Historia de usuario:
  - Como usuario final, quiero acceder a la PWA mediante una URL pública de CloudFront para poder usarla desde el celular
- Criterios de aceptación:
  - Existe un bucket S3 con los artefactos de build y una distribución CloudFront configurada como CDN del bucket
  - La distribución usa una política de caché deshabilitada (TTL 0) para evitar invalidaciones durante esta entrega
  - La URL pública de CloudFront (dominio por defecto de CF) carga correctamente la aplicación; SPA fallback configurado si aplica
  - Los tipos MIME/headers permiten servir correctamente HTML, JS, CSS, imágenes, manifest e iconos
  - El dominio provisto para el grupo resuelve a la distribución de CloudFront mediante alias
  - La distribución tiene asociado un certificado válido emitido por AWS Certificate Manager (ACM) para ese dominio
  - La PWA es accesible vía HTTPS en el dominio provisto

#### US-Deploy-02 - IaC: Infra core + certificado y dominio (ACM/Route53)

- Historia de usuario:
  - Como responsable de despliegue, quiero automatizar el despliegue de la infraestructura (core + certificado/dominio) mediante IaC para asegurar consistencia y reproducibilidad
- Criterios de aceptación:
  - Existe un template de CloudFormation o equivalente que despliega los recursos core necesarios para la PWA (S3, CloudFront con OAC, políticas del bucket/origen, outputs)
  - El template permite asociar un dominio provisto a la distribución (alias) y un certificado de ACM (ARN parametrizable)
  - Se documenta la validación DNS del certificado (si aplica) y el proceso de enlace con CloudFront
  - El despliegue puede realizarse con un solo comando o acción automatizada
  - El template está versionado y documentado

#### US-PWA-03 - Instalación como PWA

- Historia de usuario:
  - Como usuario móvil, quiero instalar la app desde el navegador para usarla como app independiente
- Criterios de aceptación:
  - Web App Manifest válido: `name`, `short_name`, `start_url`, `scope`, `display=standalone`, `theme_color`, `background_color`, `icons` (192, 512)
  - Service Worker mínimo registrado (sin requerir cache offline)
  - El navegador permite "Instalar app" desde el menú y, tras instalar, la app abre en modo `standalone` con su ícono
  - No es necesario implementar un botón de "Instalar" en la UI

#### US-API-01 - Backend: heartbeat y CORS

- Historia de usuario:
  - Como desarrollador, necesito un endpoint simple que confirme conectividad y CORS antes de avanzar con funcionalidades complejas
- Criterios de aceptación:
  - Tanto el backend-server como el backend-serverless exponen un endpoint `GET /heartbeat` que retorna un mensaje aleatorio en cada solicitud, p. ej.: `{ "message": "<texto_aleatorio>" }`
  - CORS está configurado para permitir solicitudes específicamente desde el dominio de la PWA en CloudFront (sin wildcard `*`)
  - El endpoint responde con 200 en menos de 1s bajo condiciones normales

#### US-API-02 - Frontend: botón Probar y manejo de errores

- Historia de usuario:
  - Como desarrollador, quiero verificar desde la PWA la conectividad a ambos backends con manejo de errores
- Criterios de aceptación:
  - La PWA obtiene la URL base de la API desde variables de entorno de build o archivo de configuración versionado (no hardcodeada)
  - Las solicitudes desde el dominio de CloudFront a la API pasan validación CORS (si aplica) sin errores
  - Existe un botón "Probar" en la UI
  - Al presionarlo, la app llama al endpoint `/heartbeat` del backend-server y del backend-serverless y muestra un `alert()` con las respuestas `message` obtenidas
  - Ante errores de red o CORS, se muestra un mensaje de error apropiado en la interfaz

### No requerido como parte del Epic 2

- WAF, logging avanzado de CloudFront o pipelines CI/CD

### Definition of Done (Epic 2)

- Build estático reproducible y artefactos desplegados en S3
- Distribución CloudFront operativa con URL pública y política de caché deshabilitada que carga la PWA correctamente
- Dominio provisto configurado en CloudFront con certificado SSL de ACM; acceso HTTPS validado
- PWA instalable: manifest válido (iconos 192/512, start_url/scope/display) y Service Worker mínimo registrado; instalación y apertura en modo `standalone` verificada en Android
- Endpoint `/heartbeat` disponible en backend-server con CORS habilitado para el dominio de la PWA
- La PWA incluye un botón que invoca `/heartbeat` y muestra un alert con el texto retornado

## Epic 3: Recuperación y visualización básica de datos

Objetivo: obtener desde el servidor la información necesaria para construir y mostrar un acordeón jerárquico con Trips; cada Trip con sus Posts; cada Post con sus Pictures. Implementar un cache local para permitir visualización del árbol ya obtenido cuando la aplicación se abre sin conexión. El árbol sólo se actualiza manualmente al presionar el botón "Actualizar"; no se realizan actualizaciones automáticas al iniciar sesión o al abrir la aplicación.

La aplicación debe utilizar `localStorage` para guardar el árbol serializado y reconstruirlo al abrir la app sin conexión. Se debe mostrar un indicador visible de "Sin conexión" en el header cuando la app se abre sin red y se utiliza el árbol cacheado. En este modo, el botón "Actualizar" debe aparecer deshabilitado.

### Alcance de datos

- Trips: sólo `id`, `title`, `starts_on`
- Posts: `id`, `trip_id`, `content`
- Pictures: todos los campos requeridos: `id`, `post_id`, `url`, `created_at`

### Historias de usuario

#### US-Data-01 - Fetch y ensamblado del árbol

- Historia de usuario:
  - Como usuario autenticado, quiero que la aplicación construya un acordeón Trips > Posts > Pictures para explorar mi contenido
- Criterios de aceptación:
  - Si no existe árbol cacheado y el usuario desea verlo, se debe obtener automáticamente el árbol completo inicial (Trips, Posts, Pictures)
  - Se construye en memoria la estructura Trips > Posts > Pictures con sólo los campos definidos en alcance

#### US-Data-02 - Persistencia en localStorage y arranque desde caché

- Historia de usuario:
  - Como usuario, quiero que el árbol obtenido quede guardado y que la app arranque leyéndolo si existe
- Criterios de aceptación:
  - Se persiste en caché local (localStorage) una estructura serializada con todos los Trips, con sus Posts y Pictures
  - Al entrar, si existe un árbol cacheado se muestra directamente sin pedir datos al servidor

#### US-Data-03 - Botón de actualización completa

- Historia de usuario:
  - Como usuario, quiero forzar una actualización completa para reconstruir el árbol con datos frescos
- Criterios de aceptación:
  - Existe un botón "Actualizar" en la esquina superior derecha
  - Al presionarlo, se vuelven a obtener todos los Trips, Posts y Pictures y se reemplaza el árbol en memoria y cache
  - Durante la actualización se muestra estado el estado cargando

#### US-Data-04 - Visualización en acordeón

- Historia de usuario:
  - Como usuario, quiero ver un acordeón donde cada Trip despliega sus Posts y cada Post muestra las URLs de sus Pictures
- Criterios de aceptación:
  - La interfaz presenta un acordeón: nivel 1 (Trips), nivel 2 (Posts), nivel 3 listado plana de URLs de Pictures
  - Si un Trip no tiene Posts o un Post no tiene Pictures, se muestra mensaje ("Sin posts" / "Sin imágenes")

#### US-Data-05 Caché y modo sin conexión

- Historia de usuario:
  - Como usuario, quiero poder abrir la app sin conexión y ver el último árbol descargado
- Criterios de aceptación:
  - Si no hay red al abrir y existe un árbol cacheado, se muestra el acordeón con un indicador visible de "Sin conexión" en el header de la vista
  - El botón "Actualizar" aparece deshabilitado
  - Como la carga inicial del árbol es automática en el primer ingreso, puede asumirse que el árbol cacheado siempre existe tras el primer uso online

### Estructura sugerida en caché (ejemplo JSON)

```json
{
  "trips": [
    {
      "id": 10,
      "title": "Atacama",
      "starts_on": "2025-07-03",
      "posts": [
        {
          "id": 99,
          "trip_id": 10,
          "content": "Día en el valle lunar",
          "pictures": [
            {
              "id": 501,
              "post_id": 99,
              "url": "https://.../xxxxxxxxxxx.jpg",
              "created_at": "2025-07-03T12:11:00Z"
            }
          ]
        }
      ]
    }
  ],
  "last_updated_at": "2025-11-11T18:30:00Z"
}
```

### No requerido como parte del Epic 3

- Filtros avanzados, búsqueda por texto, ordenamientos configurables
- Vista de detalle de Picture o previsualización avanzada
- Mecanismos de sincronización incremental / delta inteligente
- Optimización de uso de ancho de banda (solo se realiza fetch completo)

### Definition of Done (Epic 3)

- Árbol Trips > Posts > Pictures construido con los campos especificados y cacheado localmente
- Botones: "Probar" arriba izquierda y "Actualizar" arriba derecha funcionales
- Acordeón operativo mostrando jerarquía y mensajes en casos vacíos
- Apertura sin conexión muestra árbol cacheado e indicador de estado sin conexión
- Confirmado que no existen actualizaciones automáticas del árbol (solo mediante "Actualizar")

## Epic 4: Visualización de imágenes con modal y caché

Objetivo: Reemplazar el listado de URLs de imágenes por una lista de vínculos donde el texto visible sea el `content` del post. Al hacer clic, se abre un modal bloqueante que muestra la imagen obtenida desde el endpoint `obtain` del backend-serverless (entrega 2.2). Las imágenes vistas deben quedar cacheadas para estar disponibles sin conexión. El caché conservará únicamente las últimas 9 fotografías accedidas y eliminará de forma efectiva (no solo expirar) cualquier imagen más antigua cuando se supere ese límite.

El caché de las imágenes debe estar implementado mediante la [Cache Storage API](https://developer.mozilla.org/es/docs/Web/API/CacheStorage), no se debe alterar el comportamiento de caché HTTP estándar del navegador. El modal debe manejar adecuadamente los estados de carga, éxito y error (401, 404, otros). En modo sin conexión, si la imagen está en caché se muestra correctamente; si no, se informa al usuario que la imagen no está disponible offline.

### Historias de usuario

#### US-Image-01 - Lista de vínculos por imagen usando el content del post

- Historia de usuario:
  - Como usuario, quiero ver, bajo cada Post, una lista de vínculos (uno por Picture) cuyo texto visible sea el `id` de la imagen para mantener una interfaz simple y legible
- Criterios de aceptación:
  - En el acordeón de cada Post, las imágenes se representan como una lista de enlaces de texto con el valor `id` de la imagen
  - Se mantiene un enlace por cada Picture asociado al Post
  - Al hacer clic en un enlace, no se navega a otra página: se abre un modal bloqueante

#### US-Image-02 - Modal: camino feliz (obtain, redirect, render)

- Historia de usuario:
  - Como usuario, quiero que el modal muestre la imagen correspondiente a un link del post obtenida desde la API `obtain` y me entregue estados claros de carga, éxito y error.
- Criterios de aceptación:
  - Al abrir el modal, la app invoca el endpoint `obtain` del backend-serverless para esa imagen y sigue el redirect (302) hacia la signed URL
  - Mientras se descarga, el modal muestra un estado de carga (spinner o similar); al terminar, se renderiza la imagen
  - El modal bloquea la interacción con el resto de la UI

#### US-Image-03 - Modal: errores y reintentos

- Historia de usuario:
  - Como usuario, quiero mensajes claros ante errores y poder reintentar sin efectos colaterales
- Criterios de aceptación:
  - Errores de autorización (401) redirigen a login
  - Un error 404 muestra "Imagen no encontrada". Otros errores muestran mensaje genérico
  - Estados visibles diferenciados: cargando, listo, error (401/404/otros)
  - Tras un error, es posible cerrar el modal y reintentar abriendo el enlace nuevamente sin efectos colaterales

#### US-Image-04 - Caché: almacenamiento de imágenes vistas

- Historia de usuario:
  - Como usuario, quiero que las últimas 9 imágenes que abrí queden disponibles sin conexión para poder verlas posteriormente
- Criterios de aceptación:
  - Las imágenes visualizadas en el modal se almacenan en un caché local (por ejemplo, `Cache Storage API` o `IndexedDB` Blob) con una política de fotos únicas (una entrada por imagen)
  - Por fotos únicas se refiere a que si una misma foto es accedida dentro de las últimas visualizaciones, se considera una sola entrada (no se duplica)
  - La implementación debe eliminar el contenido de caché de imágenes que se tenga como parte de la aplicación, no solo marcarlas expiradas
  - No es necesario alterar el comportamiento del browser respecto a su caché HTTP estándar

#### US-Image-05 - Caché: política LRU de 9 imágenes

- Historia de usuario:
  - Como usuario, quiero que sólo se conserven las 9 fotos más recientes y que las más antiguas se eliminen
- Criterios de aceptación:
  - Se mantiene una política LRU con un máximo de 9 fotografías
  - Al agregar una décima imagen, se elimina físicamente la menos recientemente usada hasta volver al máximo de 9

#### US-Image-06 - Comportamiento sin conexión en el modal

- Historia de usuario:
  - Como usuario, quiero que si no tengo conexión y abro una imagen previamente vista, esta se muestre; y si no estaba cacheada, se me informe claramente
- Criterios de aceptación:
  - Si no hay red y la imagen solicitada está en caché, el modal la muestra correctamente
  - Si no hay red y la imagen solicitada no está en caché, el modal muestra un mensaje: "Imagen no disponible sin conexión. Conéctate a Internet para verla por primera vez"
  - El cierre del modal mediante click en cualquier lugar de la pantalla funciona correctamente en modo offline

### Consideraciones técnicas

- El modal ya está disponible como parte de la maqueta estática en la carpeta `example`
- Endpoint `obtain`: se debe utilizar el endpoint definido en la entrega 2.2 (ej.: `/obtain/{user_id}-{image_hash}.{extension}`) y manejar el redirect 302 a la signed URL
- Identidad de imagen: se debe vincular cada enlace con el identificador de la imagen, que corresponde al campo `id` en la estructura de `Pictures`
- Caché: se recomienda un esquema explícito (por ejemplo, mantener una lista ordenada por último acceso) y almacenamiento de binarios. Debe garantizarse borrado efectivo de contenidos expulsados
- Offline: se debe detectar el estado de red y actuar en consecuencia dentro del flujo del modal

### No requerido como parte del Epic 4

- Prefetching de imágenes, thumbnails generados en distintos tamaños
- Zoom/gestos avanzados o edición de imágenes
- Compartir o descargar imágenes al dispositivo

### Definition of Done (Epic 4)

- Lista de vínculos por imagen bajo cada Post, con texto visible igual al `id` de la imagen
- Modal bloqueante que obtiene y muestra la imagen vía `obtain` siguiendo el redirect a la signed URL
- Caché funcional que conserva sólo las últimas 9 imágenes vistas y elimina físicamente las más antiguas al superar el límite
- Comportamiento sin conexión del modal: muestra imágenes cacheadas y mensaje claro cuando una imagen no está disponible offline
- Manejo de errores 401/404/otros con mensajes adecuados

## Epic 5: Buscador semántico

Objetivo: Implementar la sección de "Explorador de etiquetas". Esta sección permite seleccionar una etiqueta y un criterio de inclusión/exclusión por umbral, y al presionar "Obtener" muestra un máximo de 9 fotografías en una grilla 3x3 (thumbnails cuadrados). Al hacer clic en un thumbnail se abre el mismo modal de imágenes del acordeón (Epic 4).

### Historias de usuario

#### US-Sem-01 - UI y mapeo de etiquetas

- Historia de usuario:
  - Como usuario, quiero elegir una etiqueta y un criterio de inclusión/exclusión con umbral para buscar fotos
- Criterios de aceptación:
  - Select de etiquetas: exactamente 25 opciones, con nombres en español mapeados internamente a etiquetas en inglés para llamar a `scan` (como fue implementado en 2.2)
  - Las 25 etiquetas son fijas y pueden estar hardcodeadas en el frontend
  - Select de criterio: opciones "incluir > 90", "incluir > 75", "excluir > 90", "excluir > 75"

#### US-Sem-02 - Integración API: construcción de query `scan` y fetch

- Historia de usuario:
  - Como usuario, quiero obtener resultados al presionar "Obtener" según la etiqueta y criterio seleccionados
- Criterios de aceptación:
  - Al presionar "Obtener", se construye el query de `scan` con un sólo filtro `label` que combine etiqueta, operador (`>` para incluir, `<` para excluir) y umbral (90 o 75)
  - Se obtiene la lista de imágenes desde el endpoint `scan`

#### US-Sem-03 - Grilla 3x3: layout y placeholders

- Historia de usuario:
  - Como usuario, quiero ver hasta 9 resultados de búsqueda semántica en una grilla 3x3 con thumbnails cuadrados del mismo tamaño
- Criterios de aceptación:
  - Si el endpoint `scan` retorna 9 o más imágenes, se muestran cualquier 9 (no se requiere determinismo ni persistencia del subconjunto; no hay paginación)
  - Si retorna menos de 9, los espacios faltantes se completan con un placeholder que hace claro que no hay más fotografías que las que se muestran
  - Los thumbnails mantienen proporciones cuadradas uniformes (p. ej., CSS `object-fit: cover` sobre contenedores cuadrados fijos)

#### US-Sem-04 - Grilla 3x3: reutilización de caché sin refetch

- Historia de usuario:
  - Como usuario, quiero que si ya vi una imagen, la grilla la use desde el caché sin volver a descargarla
- Criterios de aceptación:
  - La imagen utilizada por cada thumbnail es la misma fuente/objeto que utiliza el modal (no se generan thumbnails separados ni duplicados del recurso en caché)
  - Si alguna de las imágenes de la grilla ya está en caché (últimas 9 vistas del modal), se debe usar esa versión y no hacer fetch adicional

#### US-Sem-05 - Modal al hacer clic sobre thumbnail

- Historia de usuario:
  - Como usuario, quiero abrir el mismo modal de visualización de imágenes (Epic 4) al hacer clic en un thumbnail
- Criterios de aceptación:
  - El click en un thumbnail debe mostrar el modal bloqueante con la imagen correspondiente
  - La imagen se debe obtener desde el caché, considerando que la carga en la grilla dejará a todas las fotografías seleccionables como parte de las últimas 9 vistas

#### US-Sem-06 - Estados de carga y errores en buscador

- Historia de usuario:
  - Como usuario, quiero feedback claro mientras se realiza la búsqueda y ante errores
- Criterios de aceptación:
  - Mientras `scan` está en progreso, se muestra estado de carga en la sección
  - Ante error (CORS, red, 4xx/5xx), se muestra un mensaje visible (un alert es suficiente) y se permite reintentar presionando "Obtener" nuevamente

### Consideraciones técnicas

- Mapeo de etiquetas
  - Se debe explorar la tabla de registro de imágenes en el backend-serverless para identificar las etiquetas disponibles y sus nombres en inglés
  - Se debe definir un mapeo estático en el frontend entre nombres en español (visibles en el select) y nombres en inglés (para el query de `scan`)
  - Las opciones pueden estar hardcodeadas en el frontend
- Construcción de query `scan`: se debe usar un solo filtro `label` por solicitud con el operador según el select (incluir: `>`; excluir: `<`) y el umbral (90 o 75)
- Layout: grilla responsiva 3x3, cuadrados uniformes; placeholders para celdas vacías (se proporciona en `example`)
- Interacción con acordeón: el buscador no modifica el árbol cacheado ni su estado; sólo alterna la visibilidad
- Reutilización de recurso: tanto la grilla como el modal deben leer y escribir sobre la misma entrada de caché por imagen (clave única por `id`/archivo), evitando duplicaciones

### No requerido como parte del Epic 5

- Combinación de múltiples etiquetas o filtros simultáneos
- Paginación, ordenamiento o reintentos automáticos
- Persistir resultados de búsqueda para uso offline (sólo aplica el cache de imágenes del modal de Epic 4)

### Definition of Done (Epic 5)

- Toggle funcional "desplegar/ocultar" que alterna visibilidad entre acordeón y buscador
- Formulario con 10 etiquetas en español mapeadas correctamente a inglés y select de criterio con 4 opciones; botón "Obtener" operativo
- Llamada a `scan` construyendo el parámetro `label` con el operador y umbral correctos
- Grilla 3x3 con hasta 9 thumbnails cuadrados; placeholders cuando falten resultados; sin paginación
- Click en thumbnail abre el mismo modal (Epic 4) con su política de caché (9 imágenes LRU) y comportamiento offline
- Mensajería de estados (cargando/errores) visible y reintento posible

## Evaluación

> ⚠️ Elegibilidad: Para ser elegible para evaluación **el despliegue de la infraestructura debe ser en sa-east-1** con excepción del certificado ACM (que debe star en us-east-1) y el eventual bucket que puedan haber utilizado para resolver los problemas de tamaño de imagen de la entrega 2.2 (que puede estar en otra región). **No cumplir con esta regla es equivalente a no haber entregado**.

### Criterios de Evaluación

Cada historia de usuario será evaluada en escala 0-5:

- **5**: Implementación completa y correcta, cumple todos los requisitos especificados
- **4**: Implementación completa, cumple todos los requisitos con pequeñas oportunidades de mejora
- **3**: Implementación mayormente correcta, con detalles menores por mejorar
- **2**: Implementación parcial, cumple algunos requisitos básicos pero faltan funcionalidades clave
- **1**: Solución incompleta con errores graves o sin cumplir requisitos mínimos
- **0**: No implementado o no funcional

### Calificación Final

Son obligatorias las siguientes 10 historias de usuario:

- US-PWA-02 - Login UI con validaciones (stub)
- US-Auth-01 - Inicio de sesión con credenciales existentes
- US-Deploy-01 - Sitio disponible via CloudFront y HTTPS
- US-PWA-03 - Instalación como PWA
- US-Data-01 - Fetch y ensamblado del árbol
- US-Data-02 - Persistencia en localStorage y arranque desde caché
- US-Data-04 - Visualización en acordeón
- US-Data-05 Caché y modo sin conexión
- US-Image-02 - Modal: camino feliz (obtain, redirect, render)
- US-Image-04 - Caché: almacenamiento de imágenes vistas

Si no se obtiene a lo menos 35 puntos entre todas estas historias, la nota se calculará en base a los puntos obtenidos en estas historias obligatorias, sin considerar las demás historias de usuario. Pasado el umbral de 35 puntos, la nota se calculará en base a la suma total de puntos obtenidos en todas las historias de usuario implementadas.

Este enunciado considera 28 historias de usuario, que otorgan un total de 140 puntos, sin embargo, para obtener un 7 serán necesarios solo 105 puntos (un 75% de los puntos disponibles). Esto permite que los estudiantes puedan optar por no implementar o implementar parcialmente algunas historias para obtener la nota máxima sin necesidad de completar todo el enunciado.

En caso que la nota final de la entrega supere el 7 (dada la cantidad de puntos disponibles podría llegar hasta 9), al momento de calcular la nota final del curso la nota de esta entrega no se limitará a 7, sino que se considerará la nota real obtenida aunque esta sea mayor a 7.

### Forma y Fecha de Entrega

**Entrega**

La entrega se realiza mediante un pull request al repositorio que incluya al ayudante de proyecto asignado. El pull request debe incluir:
- Código fuente completo de la PWA en una carpeta `/pwa` en la raiz del repositorio
- Se debe poder compilar directamente mediante un llamado a `npm install` y `npm run build` para generar los artefactos estáticos
- En caso de haber desarrollado la historia **US-Deploy-02 - IaC: Infra core + certificado y dominio (ACM/Route53)**, el template de CloudFormation debe estar en `/pwa/infrastructure`

**Acceso a la app**

- En el buzón de Canvas se debe indicar la URL pública de la PWA desplegada en CloudFront, junto con credenciales de usuario válidas para probar la aplicación
- El usuario que se entregue debe proveer las informaciones suficientes (Trips, Posts, Pictures) para probar todas las funcionalidades implementadas, incluidos diferentes filtros de etiquetas en Rekognition
- Se agradecerá indicar algunas keywords/etiquetas relevantes para probar el buscador semántico de forma más eficiente

**Fecha límite**

- **Miércoles 26/11/2025 a las 23:59 hrs**
