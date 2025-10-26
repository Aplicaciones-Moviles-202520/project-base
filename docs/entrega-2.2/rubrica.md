# Rúbrica de Evaluación - Entrega 2.2

## Escala de Evaluación

Cada componente será evaluado en escala 0-5:

-   **0**: No entregado o no funcional
-   **1**: Solución incompleta con errores graves o sin cumplir requisitos mínimos
-   **2**: Implementación parcial, cumple algunos requisitos básicos pero faltan funcionalidades clave
-   **3**: Implementación mayormente correcta, con detalles menores por mejorar
-   **4**: Implementación completa, cumple todos los requisitos con pequeñas oportunidades de mejora
-   **5**: Implementación completa y correcta, cumple todos los requisitos especificados

---

## 1. Correcta implementación del sistema serverless de producción (75%)

### 1.1 Correcta implementación del Lambda Authorizer (5%)

-   La función valida correctamente tokens JWT enviados en el header `Authorization` con formato `Bearer <token>`, extrae y valida los claims del usuario, y retorna la respuesta apropiada para que API Gateway permita o deniegue el acceso a las funciones protegidas

### 1.2 Correcta implementación de la función Lambda Receiver (15%)

#### 1.2.1 Recepción y validación de parámetros

-   La función recibe correctamente el image_hash SHA-256 calculado por el backend-server y todos los metadatos asociados (post_id, user_id, picture_id, información del post)

#### 1.2.2 Almacenamiento inicial en DynamoDB

-   La función crea correctamente un registro en DynamoDB con `image_hash.extension` como partition key y `user_id` como sort key, almacenando todos los parámetros recibidos y estableciendo campos iniciales apropiados

#### 1.2.3 Generación de signed URL para subida a S3

-   La función genera una signed URL de S3 para permitir la subida directa del archivo con nombre `{user_id}-{image_hash}.{extension}` y retorna la respuesta en el formato JSON especificado

### 1.3 Correcta implementación de la función Lambda Analyzer con optimización (15%)

#### 1.3.1 Procesamiento de mensajes SQS

-   La función procesa correctamente mensajes de la cola SQS y extrae correctamente el user_id e image_hash del nombre del archivo para localizar el registro en DynamoDB

#### 1.3.2 Reutilización de análisis previo

-   La función verifica si ya existe un registro para la misma imagen (mismo image_hash.extension) de cualquier usuario y reutiliza los resultados de rekognition_results si encuentra análisis previo completo

#### 1.3.3 Análisis condicional con Rekognition

-   Solo si no existe análisis previo, descarga la imagen desde S3, la procesa con AWS Rekognition usando detect_labels, y actualiza el registro en DynamoDB con los resultados del análisis

### 1.4 Correcta implementación de la función Lambda Obtain (15%)

#### 1.4.1 Recepción y validación de parámetros

-   La función recibe correctamente el nombre del archivo como path parameter y extrae el user_id del nombre del archivo comparándolo con el user_id del contexto de autorización JWT

#### 1.4.2 Generación de signed URL para descarga desde S3

-   La función maneja correctamente el caso de acceso autorizado: si el usuario accede a una imagen que le pertenece y existe, retorna redirect (302) con signed URL válida por 1 minuto

#### 1.4.3 Manejo de errores

-   La función maneja correctamente los casos de error: retorna 404 si la imagen del usuario no existe, y 401 si el user_id no coincide independientemente de si la imagen existe

### 1.5 Correcta implementación de la función Lambda Scan (25%)

#### 1.5.1 Recepción y validación de parámetros

-   La función determina correctamente el agrupamiento basado en query parameters (post_id, trip_id, location_id, o todas las imágenes del usuario) y retorna error 400 si se reciben múltiples parámetros de agrupamiento

#### 1.5.2 Consulta eficiente en DynamoDB

-   La función utiliza el índice secundario global (GSI) para consultar eficientemente las imágenes por user_id y los diferentes agrupamientos, evitando scans costosos en DynamoDB

#### 1.5.3 Filtrado por labels con operadores

-   La función aplica correctamente los filtros de labels con formato `label=<nombre_label><operador><valor_confianza>`, manejando operadores `>` y `<` para filtrar por nivel de confianza

#### 1.5.4 Lógica AND para múltiples filtros

-   La función implementa correctamente la lógica AND cuando se aplican múltiples filtros label, incluyendo solo las imágenes que cumplan todos los filtros especificados

#### 1.5.5 Formato correcto de la respuesta

-   La función retorna el objeto JSON con el formato correcto incluyendo grouping, grouping_id, filters, total_count e images, incluyendo solo los campos relevantes para evitar transferencia innecesaria de datos

## 2. Template de CloudFormation actualizado (5%)

-   Todas las funciones Lambda están incluidas inline en el template sin requerir archivos externos, con variables de entorno correctamente configuradas, permisos IAM apropiados, y configuración correcta de todos los recursos (API Gateway, Lambda Authorizer, SQS, DynamoDB con GSI, notificaciones S3) permitiendo despliegue completamente automatizado

## 3. Informe de implementación (20%)

### 3.1 Análisis de la problemática seleccionada

-   Se selecciona una de las tres problemáticas propuestas con justificación clara de la elección y se describe claramente cómo el problema seleccionado afecta al sistema actual, identificando consecuencias técnicas y operacionales

### 3.2 Propuesta de solución técnica

-   Se plantean dos aproximaciones técnicas diferentes y viables para enfrentar el problema, cada una claramente descrita con sus componentes técnicos y arquitectura propuesta

### 3.3 Evaluación y selección de la solución

-   Se evalúan objetivamente las ventajas y desventajas de cada solución propuesta considerando aspectos como complejidad, costo, mantenibilidad, escalabilidad, y se elige una solución con justificación técnica sólida

### 3.4 Plan de implementación detallado

-   Se describen detalladamente todas las modificaciones necesarias en el sistema actual para implementar la solución elegida, especificando cambios en código, configuración, nuevos recursos, consideraciones de despliegue, testing, migración, y estrategias de mitigación de riesgos

## Puntos Extra

### E.1 Eliminación del almacenamiento local de imágenes (10%)

#### E.1.1 Modificación del modelo Picture

-   Se modifica correctamente el modelo Picture para trabajar exclusivamente con referencias S3
-   Se eliminan campos relacionados con almacenamiento local de archivos
-   Se adapta la lógica de negocio del backend-server para no almacenar imágenes localmente
-   Se mantiene la funcionalidad completa del sistema sin duplicación de almacenamiento

#### E.1.3 Sistema funcional

-   El sistema completo funciona correctamente sin almacenamiento local de imágenes
-   Se mantiene la integridad de datos y la experiencia de usuario
