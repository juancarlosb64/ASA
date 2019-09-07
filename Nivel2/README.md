# Nivel 2
Objetivos:
1. Ampliar el micro servicio par que implemente la llamada [POST] /active. El estado, la ciudad y el país se deberá almacenar en una base de datos relacional.
2. Modificar el micro servicio para que la llamada [GET] /active obtenga sus resultados desde la base de datos.
3. Orquestar el funcionamiento del micro servicio con el de la base de datos haciendo uso de docker-compose. La base de datos en concreto es indiferente, pero se recomienda utilizar postgres, mysql o mariadb.
4. Crear una imagen docker que contenga dicho micro servicio y publicarla en dockerhub.

En la solución de este nivel se modificaron los archivos app.py y requirements, tambien se crearon nuevos archivos como worklog.py, schema y docker-compose.yml, quedando el arbol de directorio de la siguiente manera:

    └── nica-ventas
	    ├── disponibilidad
		│   ├── app
		│   ├── app.py
		│   ├── requirements.txt
		│   └── worklog.py
		├── Dockerfile
		└── schema.sql
		│	└── docker-compose.yml
## app.py
Este programa fue modificado ya que en este nivel se interactua con base de datos almacenando y consultando registros, para este ejemplo se esta utilizando MySQL como gestor de base de datos. Primeramente se agregó la libreria flask_mysqldb y una clase hecha en python llamada worklog que se encuentra en el archivo worklog.py, esta clase se conecta al servidor MySQL.

    from flask_mysqldb import MySQL
    from worklog import Worklog
En la configuración de la variable flask se agregaron las credenciales para conectarse al servidor de base de datos y se creo una variable MySQL, la cual utilizaremos para conectarnos al servidor.

    app = Flask(__name__)
    
    app.config['MYSQL_HOST'] = os.environ['DATABASE_HOST']
    app.config['MYSQL_USER'] = os.environ['DATABASE_USER']
    app.config['MYSQL_PASSWORD'] = os.environ['DATABASE_PASSWORD']
    app.config['MYSQL_DB'] = os.environ['DATABASE_NAME']
    
    mysql = MySQL(app)
Se modificó la función get_active, acá lo que hacemos es obtener las variables country y city con request.args.get() las cuales son enviadas con un cliente web, luego creamos una variable de tipo Worklog llamada wl a la que pasamos por medio de el constructor la variable mysql para podernos conectar a la base de datos. Dentro de la variable wl accedemos a la función find_location pasandole como parámetro country y city, esta función lo que hace es que consulta a la tabla location el country y city enviado, y retorna el estado del registro este resultado se almacena en la variable js, en caso de que el registro no exista se crea un objeto con el mensaje **Registro no encontrado** en caso positivo crea un objeto agregando country, city y active con sus respectivos valores, este objeto lo convertimos en json con la función jsonify y lo retornamos al cliente web, en caso de que se genere un error se ejecuta except enviando el mensaje **Ha ocurrido un error, Verifique el URL**.
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
