# Rúbrica de Evaluación - Entrega 2.1

## Escala de Evaluación

Cada componente será evaluado en escala 0-5:

- **0**: No entregado o no funcional
- **1**: Solución incompleta con errores graves o sin cumplir requisitos mínimos
- **2**: Implementación parcial, cumple algunos requisitos básicos pero faltan funcionalidades clave
- **3**: Implementación mayormente correcta, con detalles menores por mejorar
- **4**: Implementación completa, cumple todos los requisitos con pequeñas oportunidades de mejora
- **5**: Implementación completa y correcta, cumple todos los requisitos especificados

---

## 1. Correcta implementación del flujo automático (60%)

### 1.1 Correcta implementación de la función Lambda de ingreso (20%)

#### 1.1.1 Recepción y validación de parámetros
- La función recibe correctamente la imagen en formato base64, valida el content_type, y verifica el token de autenticación usando variables de entorno

#### 1.1.2 Cálculo del hash SHA-256
- La función calcula correctamente el hash SHA-256 de la imagen decodificada y lo utiliza como nombre base del archivo

#### 1.1.3 Almacenamiento en S3 con extensión apropiada
- La función sube la imagen a S3 usando el hash como nombre y asigna la extensión correcta basada en el content_type (ej: .jpg, .png)

#### 1.1.4 Retorno de respuesta correcta
- La función retorna el nombre completo del archivo guardado en S3 en el formato JSON especificado

### 1.2 Correcta configuración y uso del bucket S3 y trigger (10%)

#### 1.2.1 Configuración del bucket S3
- El bucket está correctamente nombrado como `travellog-images-<número>` y tiene los permisos apropiados para que las funciones Lambda puedan leer y escribir

#### 1.2.2 Configuración del trigger automático
- El bucket S3 está configurado para invocar automáticamente la función Lambda de procesamiento cada vez que se sube una nueva imagen

### 1.3 Correcta implementación de la función Lambda de procesamiento (20%)

#### 1.3.1 Descarga de imagen desde S3
- La función se activa correctamente mediante el evento de S3 y descarga la imagen usando la información del evento

#### 1.3.2 Procesamiento con AWS Rekognition
- La función utiliza correctamente el servicio detect_labels de AWS Rekognition para analizar la imagen

#### 1.3.3 Filtrado de etiquetas por confianza
- La función filtra las etiquetas retornadas por Rekognition, almacenando solo aquellas con confianza >= 75.0% (o el valor configurado en variable de entorno)

#### 1.3.4 Almacenamiento de resultados en DynamoDB
- La función almacena correctamente los resultados en DynamoDB con el esquema especificado, incluyendo file_name, processing_timestamp, rekognition_results y status

### 1.4 Correcta configuración y uso de la tabla DynamoDB (10%)

#### 1.4.1 Estructura de la tabla
- La tabla está correctamente nombrada como `travellog-images-registry` con `file_name` como llave primaria (String)

#### 1.4.2 Formato de los items almacenados
- Los items almacenados cumplen con el esquema especificado, incluyendo todos los campos requeridos (file_name, processing_timestamp, rekognition_results con labels y sus atributos name/confidence, y status)

## 2. Correcta integración con el sistema existente (10%)

### 2.1 Modificación del controlador de imágenes
- El controlador de imágenes del backend-server envía automáticamente cada nueva imagen a la función Lambda de recepción con todos los parámetros requeridos

### 2.2 Almacenamiento y autenticación
- El backend-server almacena el nombre de archivo retornado por Lambda en el modelo Picture, envía el token secreto en las cabeceras, y utiliza directamente la URL de la función Lambda

## 3. Informe de implementación (30%)

### 3.1 Arquitectura del sistema

#### 3.1.1 Descripción de componentes y flujo
- El informe describe clara y completamente la arquitectura del sistema, incluyendo todos los componentes (S3, Lambda functions, DynamoDB) y el flujo de datos entre ellos

### 3.2 Configuración de AWS (10%)

#### 3.2.1 Permisos y políticas IAM
- El informe detalla los roles y permisos IAM asignados a cada función Lambda, incluyendo políticas específicas para acceso a S3, DynamoDB y Rekognition, así como la creación y permisos del usuario `revisor` con `ReadOnlyAccess`

#### 3.2.2 Configuración de recursos AWS
- El informe documenta la configuración del bucket S3 (nombre, trigger hacia la Lambda de procesamiento, permisos, y políticas de ciclo de vida) y la configuración de la tabla DynamoDB (nombre, llave primaria `file_name`, capacidad/auto-scaling e índices secundarios si aplican)

### 3.3 Análisis de costos (15%)

#### 3.3.1 Uso pertinente de la información y tratamiento de la variabilidad
- El análisis utiliza de forma pertinente todos los parámetros provistos (usuarios activos, estacionalidad, distribución de posts/imágenes, patrones temporales) para modelar el volumen de uso
- El análisis incorpora la desviación estándar u otra medida de dispersión en el modelado (p. ej. escenarios promedio/alto/bajo, intervalos de confianza o simulaciones) para reflejar incertidumbre en las estimaciones

#### 3.3.2 Cobertura completa de componentes y métricas relevantes
- El análisis utiliza todas las métricas necesarias para estimar costos: transferencia de datos (GB ingress/egress), tamaño medio de objetos, número de invocaciones de Lambda, tiempo de ejecución y memoria de Lambda, operaciones y capacidad de DynamoDB (incluyendo tamaño mínimo y tamaños de item), y llamadas API externas
- El análisis documenta cómo se calculó cada componente (fórmulas, supuestos y fuentes de precios) y no omite elementos habituales como costos de transferencia, overheads de solicitud o tamaños mínimos facturables

#### 3.3.3 Separación y comparación de costos de procesamiento vs almacenamiento
- El análisis separa explícitamente el costo de procesamiento (operacional, prácticamente instantáneo: invocaciones, Rekognition, tiempo de CPU/memoria) del costo de almacenamiento (acumulativo: S3, DynamoDB), mostrando cómo cada uno evoluciona con el tiempo
- El análisis compara su impacto a corto y largo plazo (p. ej. coste mensual vs coste acumulado)

## Puntos Extra

### E.1 Detección de contenido inapropiado

- La función Lambda de procesamiento revisa las etiquetas retornadas por detect_labels y detecta correctamente la presencia de la etiqueta objetivo (ej: "cat")
- La etiqueta objetivo y los umbrales de confianza para "rejected" (>90%) y "under_review" (>50% y ≤90%) están correctamente configurados como variables de entorno
- La función marca correctamente el estado del análisis como "rejected" o "under_review" según los umbrales configurados
- La función almacena todas las etiquetas con confianza mayor o igual al límite configurado (≥75%), independientemente del estado del análisis
