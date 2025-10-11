# Entrega 2.1 - Prueba de concepto para el procesamiento de imágenes con AWS Rekognition

## Objetivos

El objetivo de segunda parte del proyecto consiste en implementar un sistema de procesamiento serverless automático de imágenes mediante servicios de AWS que se integre con la aplicación TravelLog existente.

En la entrega 2.1 se desarrollará una prueba de concepto funcional que permita validar la arquitectura propuesta y los flujos de datos entre los componentes.

## Descripción del Sistema

En esta entrega se desarrollará una prueba de concepto de un sistema distribuido que procese automáticamente las imágenes subidas por los usuarios a la plataforma TravelLog. El sistema debe funcionar de forma paralela al flujo actual de la aplicación.

Se denominará al actual despliegue de la aplicación como **backend-server** y al sistema de procesamiento automático como **backend-serverless**.

### Arquitectura del Sistema

El sistema backend-serverless estará compuesto por los siguientes componentes de AWS:

1. Bucket S3 `travellog-images-<número>`: Almacena imágenes indexadas por su hash, donde `<número>` es un número aleatorio de 3 dígitos que cada grupo debe determinar
2. Tabla DynamoDB `travellog-images-registry`: Almacena metadatos y resultados del análisis
3. Función Lambda de Ingreso `travellog-image-receiver`: Recibe imágenes desde la aplicación TravelLog
4. Función Lambda de Procesamiento `travellog-image-analyzer`: Procesa imágenes con Rekognition

### Flujo del Sistema

1. Cuando se asocia una imagen a un post, en creación o edición, el backend-server envía cada imagen, de forma independiente, a la función de recepción `travellog-image-receiver`
2. La función de recepción calcula el hash SHA-256 correspondiente al archivo enviado y almacena la imagen en un bucket S3 usando el hash como nombre de archivo y asociando una extensión basada en el tipo de contenido (por ejemplo, .jpg, .png, etc.)
3. La función retorna el nombre del archivo con el que fue guardada la imagen en S3
4. Al guardarse la imagen en S3, se dispara automáticamente la función de procesamiento `travellog-image-analyzer`
5. La función de procesamiento usa AWS Rekognition para detectar objetos y escenas mediante labels
6. Los resultados del análisis de la imagen se almacenan en DynamoDB usando el nombre del archivo como llave de partición

## Requisitos Técnicos

### Función Lambda de Recepción

**Funcionalidad requerida**:

-   Se debe desarrollar una función Lambda utilizando Python 3.13
-   Debe recibir una imagen en formato base64
-   Debe calcular hash SHA-256 de la imagen
-   Debe subir imagen a S3 usando el hash como nombre de archivo y asignando una extensión basada en el tipo de contenido (por ejemplo, .jpg, .png, etc.)
-   Debe retornar como respuesta el nombre con el que la imagen fue guardada en S3
-   La función debe tener un token de autenticación
-   Tanto el token de autenticación como el nombre del bucket deben estar configurados como variables de entorno

**Parámetros de entrada** (por cada imagen):

```json
{
    "image": "base64_encoded_image_data",
    "content_type": "image/jpeg",
    "post_id": 123,
    "user_id": 456,
    "picture_id": 789,
    "secret_token": "your_secret_token_here"
}
```

**Respuesta esperada**:

```json
{
    "file_name": "a1b2c3d4e5f6789abcdef1234567890abcdef12.jpg"
}
```

### Integración backend-server con backend-serverless

**Funcionalidad requerida**:

-   Modificar el controlador de imágenes para enviar automáticamente cada nueva imagen a la función Lambda de recepción
-   Se debe almacenar el nombre de archivo retornado por la función Lambda en el modelo `Picture`
-   Si un post contiene múltiples imágenes, cada una se envía como una llamada separada a la función Lambda
-   El backend-server debe enviar un token secreto en las cabeceras para autenticar la llamada a la función Lambda. Este valor debe ser fijo y definido por cada grupo
-   El backend-server debe utilizar directamente la url de la función Lambda, sin uso de APIGateway o similares

### Bucket S3 y Trigger Configuration

**Configuración requerida**:

-   El bucket creado para almacenar las imágenes debe invocar automáticamente la función Lambda de procesamiento `travellog-image-analyzer` cada vez que se suba una nueva imagen

### Función Lambda de Procesamiento

**Funcionalidad requerida**:

-   Se debe desarrollar una función Lambda utilizando Python 3.13
-   La función debe descargar directamente la imagen desde S3
-   Debe procesar la imagen usando AWS Rekognition con el servicio **detect_labels** para detectar objetos y escenas
-   Debe almacenar las etiquetas retornadas por Rekognition en DynamoDB, pero solo aquellas que tengan confianza mayor o igual a 75.0%
-   La función debe tener el nombre de la tabla DynamoDB configurado como variable de entorno
-   El límite de confianza para almacenar etiquetas (75.0%) debe estar configurado como variable de entorno

**Actividad bono (opcional)**:

El servicio Amazon Rekognition permite detectar contenido inapropiado (pornografía, violencia, etc.) usando el servicio **detect_moderation_labels**. Para la actividad bono se tomará la idea tras este servicio pero se implementará de la forma siguiente:

-   La función debe revisar las etiquetas retornadas por **detect_labels**
-   Si el set de etiquetas contiene la etiqueta "cat" (que indica la presencia de gatos) con confianza mayor a 90%, debe marcar el estado del análisis como "rejected", si es mayor a 50% pero menor o igual a 90% debe marcar el estado como "under_review"
-   La etiqueta, así como los límites de confianza para marcar el estado como "rejected" o "under_review" debe estar configurado como variable de entorno
-   Note que la función debe seguir almacenando las etiquetas con confianza mayor o igual al límite configurado, independientemente del estado del análisis; por ejemplo, si una imagen tiene la etiqueta cat con un 60% de confianza, la imagen debe ser marcada como "under_review" independientemente de que la etiqueta no sea guardada en DynamoDB por no superar el umbral configurado de 75%

### Tabla DynamoDB

-   **Nombre de tabla**: `travellog-images-registry`
-   **Llave primaria**: `file_name` (String)
-   **Esquema del item**:
    ```json
    {
        "file_name": "a1b2c3d4e5f6789abcdef1234567890abcdef12.jpg",
        "processing_timestamp": "2025-10-11T10:35:00Z",
        "rekognition_results": {
            "labels": [
                { "name": "Beach", "confidence": 95.5 },
                { "name": "Ocean", "confidence": 89.2 },
                { "name": "Water", "confidence": 92.1 },
                { "name": "Outdoors", "confidence": 87.8 },
                { "name": "Nature", "confidence": 91.3 }
            ]
        },
        "status": "processed"
    }
    ```

## Entregables

### Código de las Funciones Lambda

Utilizando las funcionalidades de la consola de Lambda Functions, se debe obtener un archivo ZIP exportado para cada función, el que se debe incluir en el repositorio:

-   `travellog-image-receiver.zip` (función de ingreso)
-   `travellog-image-analyzer.zip` (función de procesamiento)

### Informe de implementación

Se debe incluir en el repositorio un documento en formato Markdown que detalle:

-   Arquitectura del sistema
-   Cualquier configuración diferente a la configuración por omisión que haya sido requerida incluyendo:
    -   Permisos IAM asignados a cada función Lambda
    -   Configuración del bucket S3 y trigger
    -   Configuración de la tabla DynamoDB
-   Análisis de costos del backend-serverless considerando:
    -   10.000 usuarios activos mensuales, el doble durante los meses de julio, diciembre, enero y febrero
    -   Cada usuario activo tiene un viaje durante el mes
    -   Los viajes se distribuyen de forma uniforme durante las semanas del mes
    -   Cada viaje tiene en promedio 10 posts con desviación estándar 5
    -   Cada post tiene en promedio 5 imágenes con desviación estándar 2
    -   Las imágenes tienen un tamaño promedio de 4 MB con desviación estándar 2 MB
    -   El 50% de los post son creados de forma uniforme durante los días del fin de semana, y el otro 50% de forma uniforme durante el resto de la semana
    -   El 75% de las imágenes se sube de forma uniforme entre las 20:00 y las 22:00 hrs, y el resto se sube de forma uniforme durante el resto del día
    -   No debe considerarse los beneficios de las capas gratuitas de AWS
    -   Debe considerar por separado los costos de procesamiento y almacenamiento
    -   Debe considerar los costos bajo modelos de pago por uso y de reserva de recursos
    -   Debe presentar los costos mensuales anualizados (osea, el costo mensual promedio considerando la estacionalidad del tráfico)
    -   Debe justificar las decisiones tomadas para optimizar costos y explicar cualquier supuesto adicional a lo indicado que pueda afectar o haya sido necesario para realizar el análisis

## Evaluación

La evaluación será calificada en base a un porcentaje asociado a cada uno de los items que se indican a continuación. Todos los puntajes se sumarán para obtener la nota final de la entrega.

Dada la actividad bono, el porcentaje total puede superar el 100%, en cuyo caso el porcentaje final se ajustará a 100%.

### Criterios de Evaluación

Cada componente será evaluado en escala 0-5:

-   **0**: No entregado o no funcional
-   **1**: Solución incompleta con errores graves o sin cumplir requisitos mínimos
-   **2**: Implementación parcial, cumple algunos requisitos básicos pero faltan funcionalidades clave
-   **3**: Implementación mayormente correcta, con detalles menores por mejorar
-   **4**: Implementación completa, cumple todos los requisitos con pequeñas oportunidades de mejora
-   **5**: Implementación completa y correcta, cumple todos los requisitos especificados

### Aspectos específicos de evaluación:

- 60% Correcta implementación del flujo automático
    - 20% Correcta implementación de la función Lambda de ingreso
    - 10% Correcta configuración y uso del bucket S3 y trigger
    - 20% Correcta implementación de la función Lambda de procesamiento
        - 5% Extra: Correcta implementación de la actividad bono
    - 10% Correcta configuración y uso de la tabla DynamoDB
- 10% Correcta integración con el sistema existente
- 30% Informe de implementación
    - 5% Arquitectura del sistema
    - 10% Configuración de AWS
    - 15% Análisis de costos

## Consideraciones Adicionales

### Simplificaciones

-   Esta es una prueba de concepto, no se preocupe de condiciones de borde como el caso en que la imagen ya exista en S3
-   Puede asumir que las imágenes enviadas son siempre válidas y no corruptas
-   No es necesario implementar autenticación avanzada en la función Lambda, el envío de un token fijo en las cabeceras es suficiente
-   No es necesario almacenar metadatos adicionales en DynamoDB (como post_id, user_id, etc.) más allá de los solicitados, aunque estos hayan sido enviados a la función Lambda de ingreso
-   No es necesario cumplir con el principio de menor privilegio en los permisos IAM asignados a las funciones Lambda

### Performance

-   Configurar timeouts y memoria apropiados para las funciones Lambda

### Usuario para revisión

Utilizando IAM se debe crear un usuario denominado `revisor` con acceso a la consola. Este usuario debe tener asociada la policy `ReadOnlyAccess`. El usuario debe ser creado como IAM user y la password debe ser entregada mediante el formulario de entrega en Canvas.

## Forma y Fecha de Entrega

**Entrega**: Pull request al repositorio que incluya al ayudante de proyecto asignado. El pull request debe incluir:

-   Código de las funciones Lambda en `/serverless/`
-   Informe de implementación en `/serverless/README.md`

**Fecha límite**: Domingo 19/10/2025 a las 23:59 hrs.

## Recursos de Referencia

-   [AWS Lambda Developer Guide](https://docs.aws.amazon.com/lambda/)
-   [AWS Rekognition API Reference](https://docs.aws.amazon.com/rekognition/)
-   [DynamoDB Developer Guide](https://docs.aws.amazon.com/dynamodb/)
-   [S3 Event Notifications](https://docs.aws.amazon.com/s3/latest/dev/notification-content-structure.html)
