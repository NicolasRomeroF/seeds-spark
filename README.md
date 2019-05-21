# Machine Learning con Spark R (utilizando Google Cloud Platform)
## Integrantes:
- Nicolás Romero
- Richard Torti
- Franco Leal

## Descripción del problema
El objetivo del Laboratorio N°2 consiste en entrenar un modelo de Machine Learning utilizando el lenguaje R en conjunto con Spark, utilizando una base de datos distribuida en los servidores de Google Cloud Platform. Además, se debe disponibilizar un servicio para consultar el modelo.

## Enfoque de la solución
Para dar solución al problema planteado, se utiliza un dataset de semillas, el cual se utiliza para predecir la clase de nuevos sujetos.
Las semillas pueden ser de 3 tipos:
- Kama
- Rosa
- Canadian

Los parámetros que se desfinen en el dataset son los siguientes:
- area
- perimeter
- compactness
- lengthk (largo del núcleo)
- widthk (ancho del núcleo)
- asymmetry
- lengthkg (largo de la ranura del núcleo)

## Desarrollo de la actividad

### Inconvenientes

Uno de los principales inconvenientes es la instalación propiamentetal del entorno de ejecución de la solución, para lograr utilizar Spark y posteriormente, montar el servicio para consultar el resultado.

### Funcionalidades principales

1.- Predicted

Funcionalidad que permite realizar una consulta con valores por defecto:
- area: 14.88
- perimeter: 14.57
- compactness: 0.8811
- lengthk (largo del núcleo): 5.554
- widthk (ancho del núcleo): 3.333
- asymmetry: 1.0180
- lengthkg (largo de la ranura del núcleo): 4.596

Se accede mediante la ruta /predicted con método get

2.- Predict
Funcionalidad que permite predecir la clase de una nueva semilla. Se deben entregar los parámetros indicados anteriormente.
Se accede mediante la ruta /predict con método post
