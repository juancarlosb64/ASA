# Nivel 1
Objetivos:
 1. Desarrollar un micro servicio en flask que implemente la llamada [GET] /active con una respuesta dummy fija.
 2. Crear una imagen docker que contenga dicho micro servicio y publicarla en dockerhub.

En este documento se explicará como se resolvió el ejercicio, archivos que se crearon y algunos comandos que hacen posible que el micro servicio funcione. Para la solución de este nivel se creó el árbol de directorio siguiente:

    └── nica-ventas
	    └── disponibilidad
			├── app
			│   ├── app.py
			│   └── requirements.txt
			└── Dockerfile
El directorio nica-ventas es el directorio principal dentro del cual están almacenados los microservicios, dentro de nica-ventas creamos el directorio disponibilidad porque se le da solución al **servicio de consulta de disponibilidad de ventas** y dentro de disponibilidad creamos el directorio app y el fichero Dockerfile.
## Dockerfile
Es un archivo de texto plano que contiene las instrucciones necesarias para automatizar la creación de una imagen que será utilizada posteriormente para la ejecución de instancias (docker), el contenido del archivo Dockerfile es el siguiente:

    FROM python
    COPY /app /app
    RUN pip install -r /app/requirements.txt
    WORKDIR app
    CMD ["python", "app.py"]
    EXPOSE 5000
## Analizando el contenido de Dockerfile.

 - FROM python: crea la imagen del micro servicio basada en una imagen de python.
 - COPY /app /app: copia los archivos que tenemos en el directorio app al directorio app del docker.
 - RUN pip install -r /app/requirements.txt: instala en el docker todos los paquetes especificados dentro del archivo requirements.txt
 - WORKDIR app: especifica el directorio de trabajo del docker.
 - CMD ["python", "app.py"]: especifica el primer comando que se ejecutará cuando el docker este en ejecución, en este caso será app.py el cual es un programa python.
 - EXPOSE 5000: especifica el puerto de escucha del docker.
## Directorio app.
Dentro del directorio app se crearon dos ficheros: 
 - app.py
Que es un pequeño programa escrito en lenguaje python y es el que se encarga de atender las solicitudes que hagamos con un cliente web, para crear este programa se realizó lo siguiente:

	1. Especificar los paquetes que se utilizarán:
	flask: es un miniframework que permite crear aplicaciones web.
	jsonify: se utiliza para codificar los objetos json.
	request: se utiliza para obtener los parámetros enviados a los diferentes servicios.
	2. Crear una variable de tipo Flask, ya que es la que nos permite correr un servidor web, atendiendo peticiones.
	3. Crear una ruta llamada active usando el método GET, esta ruta es la que llamaremos con un cliente web.
	4. Definir una función llamada get_active, la cual se ejecutará cuando se consuma la ruta [GET] /active.
	5. Crear una variable de tipo objeto con el nombre data en la cual guardamos los datos que retornaremos.
	6. Crear un json a partir de la variable data.

Dado que el ejercicio nos pide que retornemos un dummy fijo retornamos los mismos datos que enviamos a [GET] /active.
## Contenido de app.py

    #!flask/bin/python
    from flask import Flask, jsonify, request
    import os
    
    app = Flask(__name__)
    
    @app.route('/active', methods=['GET'])
    def get_active():
    	    data = {
					    "active": True,
		                "country": request.args.get('country'),
		                "city": request.args.get('city')
			       }
	return jsonify(data)
	
	if __name__ == '__main__':
	    app.run(debug=True, host='0.0.0.0')
## requirements.txt
Es un archivo que texto plano que contiene un listado de nombres de paquetes que se necesitan instalar dentro del docker para que este funcione correctamente.

## Contenido de requirements.txt

    Click==7.0
    Flask==1.1.1
    itsdangerous==1.1.0
    Jinja2==2.10.1
    MarkupSafe==1.1.1
    Werkzeug==0.15.5

Con esto tendríamos finalizado el micro servicio, a continuación se procede con la creación de la imagen, para esto se utilizó el siguientes comando:

    docker build -t juancarlosb64/nica-ventas:v1.0 .

Debido a que se esta trabajando en el nivel 1 creamos la imagen con el tag v1.0, con la imagen creada se procede a subirla al repositorio en dockerhub con el siguiente comando:

    docker push juancarlosb64/nica-ventas:v1.0

Si se desea descargar la imagen del repositorio de dockerhub se utiliza el siguiente comando:

    docker pull juancarlosb64/nica-ventas:v1.0

Para ejecutar la imagen de nica-ventas utilizando el puerto 8000 para el cliente web enlazándolo con el 5000 que es el puerto que escucha el docker se utiliza el siguiente comando:
 
    docker run -p 8000:5000 juancarlosb64/nica-ventas:v1.0

Para consumir la llamada [GET] /active desde un cliente web como curl se utiliza el siguiente comando:

    curl -i 'localhost:8000/active?city=leon&country=ni'

Url de imagen en dockerhub

    https://hub.docker.com/r/juancarlosb64/nica-ventas

Y con esto completamos el nivel 1 del ejercicio.
