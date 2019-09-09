# Nivel 4
Objetivos:
1. Evolucionar la arquitectura existente para incluir un micro servicio que proporcione el API [POST] /quote, según lo especificado en el enunciado en Servicio de Consulta de Condiciones de Venta añadir al archivo docker-compose el nuevo micro servicio.
2. Añadir políticas de cacheo de forma que si se solicita [POST] /quote con los mismos parámetros se responda desde la cache de REDIS en lugar de volver a realizar la consultas a OpenWeather y la BBDD. La validez de uno de estos datos cacheados será de 5 min. Con objeto de verificar que la cache funciona, incluir en la respuesta un campo cache como se hizo anteriormente.

En la solución de este nivel se crearon nuevos archivos y directorios ya que al crearse un nuevo micro servicio se tuvo que realizar otro archivo app.py, worklog.py, requirements, etc. quedando el árbol de directorio de la siguiente manera:

    └── nica-ventas
	    ├── disponibilidad
	    │   ├── app
	    │   │   ├── app.py
	    │   │   ├── requirements.txt
	    │   │   └── worklog.py
	    │   ├── Dockerfile
	    │   └── schema.sql
	    └── docker-compose.yml
Pero se realizaron cambios en los siguientes archivos:

## app.py
Se agregó la librería redis al inicio del programa.

    import redis

 Se creó una variable de tipo redis, indicando el host y puerto que se utilizará.
 
    redis_cli = redis.Redis(host=os.environ['REDIS_LOCATION'], port=os.environ['REDIS_PORT'])
Se modifica la llamada [GET] /active en la cual se obtiene el contenido de la llave con la instrucción:

    state = redis_cli.get(key)

Si la llave existe no se lee el registro en la base de datos y se crea un objeto indicando que se esta utilizando la cache con el campo cache igual a hit.
  
    if state:
    	data = {
					"country": country,
                    "city": city,
                    "active": bool(eval(state)),
                    "cache": "hit"
               }

Si la llave no existe se lee la información de la base de datos y se crea la llave, agregando el campo cache igual a miss en la variable objeto que retornamos.

    else: 
    	wl = Worklog(mysql, app.logger)
    	js = wl.find_location(country, city)

		if js is None:
			data = {"mensaje": "Registro no encontrado"}
		else:
			redis_cli.set(key, escape(js[2]))
			data = {
					    "country": js[0], 
                        "city": js[1],
                        "active": bool(js[2]), 
                        "cache": "miss"
                   }
El nombre de la llave es la unión del contenido de country con city.

    key = country.lower() + '_' + city.lower()
En la llamada [POST] /active no se invalida la cache dado que el registro que se crea no tiene creada ninguna llave en redis, pero si se invalida en la llamada [PUT] /active que es donde se cambia el estado del registro, para invalidar la cache lo que se hace es que se elimina la llave con la siguiente instrucción:

    redis_cli.delete(key)
## Contenido de app.py

    #!flask/bin/python
    from flask import Flask, jsonify, request, escape
    import os
    from flask_mysqldb import MySQL
    from worklog import Worklog
    import redis

    app = Flask(__name__)

    app.config['MYSQL_HOST'] = os.environ['DATABASE_HOST']
    app.config['MYSQL_USER'] = os.environ['DATABASE_USER']
    app.config['MYSQL_PASSWORD'] = os.environ['DATABASE_PASSWORD']
    app.config['MYSQL_DB'] = os.environ['DATABASE_NAME']

    mysql = MySQL(app)

    redis_cli = redis.Redis(host=os.environ['REDIS_LOCATION'], port=os.environ['REDIS_PORT'])

    @app.route('/active', methods=['GET'])
    def get_active():
        try:
            country = request.args.get('country')
            city = request.args.get('city')
            key = country.lower() + '_' + city.lower()

	        state = redis_cli.get(key)

	        if state:
	            data = {
	                        "country": country,
	                        "city": city,
	                        "active": bool(eval(state)),
	                        "cache": "hit"
	                   }
		    else: 
		        wl = Worklog(mysql, app.logger)
	            js = wl.find_location(country, city)

	            if js is None:
	                data = {"mensaje": "Registro no encontrado"}
	            else:
	                redis_cli.set(key, escape(js[2]))
	                data = {
	                            "country": js[0], 
	                            "city": js[1],
	                            "active": bool(js[2]), 
	                            "cache": "miss"
	                       }
        
	        return jsonify(data)
	    except:
	        return jsonify({"mensaje": "Ha ocurrido un error, Verifique el URL."})

    @app.route('/active', methods=['POST'])
    def post_active():
        try:
            payload = request.get_json()
            wl = Worklog(mysql, app.logger)
            js = wl.find_location(payload['country'], payload['city'])

	        if js is None:
	            wl.save_location(**payload)
	            data = {
	                        "mensaje": "Registro guardado satisfactoriamente",
	                        "country": payload['country'],
	                        "city": payload['city']
	                   }
	        else:
	            data = {"mensaje": "El registro ya existe en la base de datos"}

	        return jsonify(data)
	    except:
	        return jsonify({"mensaje": "Ha ocurrido un error, Verifique el URL."})

    @app.route('/active', methods=['PUT'])
    def put_active():
        try:
            payload = request.get_json()
            auth = request.headers.get("authorization", None)

	        if not auth:
	            data = {"mensaje": "No ha enviado token"}
	        elif auth != "Bearer 2234hj234h2kkjjh42kjj2b20asd6918":
	            data = {"mensaje": "El token enviado no esta autorizado"}
	        else:
	            wl = Worklog(mysql, app.logger)
	            res = wl.state_location(**payload)
	            key = payload['country'].lower() + '_' + payload['city'].lower()

	            if res == 0:
	                data = {
	                            "mensaje": "No se actualizo ningun registro",
	                            "token": auth,
	                            "country": payload['country'],
	                            "city": payload['city'],
	                            "active": payload['active']
	                       }
	            else:
	                redis_cli.delete(key)
	                data = { 
	                            "mensaje": "Registro actualizado satisfactoriamente",
	                            "token": auth,
	                            "country": payload['country'],
	                            "city": payload['city'],
	                            "active": payload['active']
	                       }
            
	        return jsonify(data)
	    except:
	        return jsonify({"mensaje": "Ha ocurrido un error, Verifique el URL."})

    if __name__ == '__main__':
        app.run(debug=True)
## requirements.txt
Dentro de este fichero se agrego el nombre de la libreria redis.

    Click==7.0
    Flask==1.1.1
    itsdangerous==1.1.0
    Jinja2==2.10.1
    MarkupSafe==1.1.1
    Werkzeug==0.15.5
    worklog
    flask_mysqldb
    redis
## docker-compose.yml
En este fichero se agregaron las variables REDIS_LOCATION y REDIS_PORT en la sección environment de nica-ventas para indicarle el host y el puerto de redis que se utilizará.

    nica-ventas:
    	image: juancarlosb64/nica-ventas
    	build:
    		context: ./disponibilidad
    		dockerfile: Dockerfile
    	ports:
    		- "8000:5000"
    	volumes:
    		- ./disponibilidad/app:/app
    	environment: 
    		- FLASK_DEBUG=1
    		- DATABASE_PASSWORD=nicaventaspass
    		- DATABASE_NAME=nicaventasdb
    		- DATABASE_USER=nicaventasuser
    		- DATABASE_HOST=nicaventas-db
    		- REDIS_LOCATION=redis
    		- REDIS_PORT=6379
Tambien se agrega el contenedor redis el cual se creará con la imagen de redis exponiendo el puerto 6379.

    redis:
    	image: redis
    	expose:
    		- 6379
## Contenido de docker-compose.yml

    version: '3'
    services:
            nica-ventas:
	            image: juancarlosb64/nica-ventas
                build:
                       context: ./disponibilidad
                       dockerfile: Dockerfile
                ports:
                       - "8000:5000"
                volumes:
                       - ./disponibilidad/app:/app
	            environment: 
                       - FLASK_DEBUG=1
                       - DATABASE_PASSWORD=nicaventaspass
                       - DATABASE_NAME=nicaventasdb
                       - DATABASE_USER=nicaventasuser
                       - DATABASE_HOST=nicaventas-db
                       - REDIS_LOCATION=redis
                       - REDIS_PORT=6379
	            command: flask run --host=0.0.0.0
	             
	        nicaventas-db:
               image: mysql:5 
               environment:
                       - MYSQL_ROOT_PASSWORD=123qwe
                       - MYSQL_DATABASE=nicaventasdb
                       - MYSQL_USER=nicaventasuser
                       - MYSQL_PASSWORD=nicaventaspass
               expose:
                       - 3306
               volumes:
                       - ./disponibilidad/schema.sql:/docker-entrypoint-initdb.d/schema.sql
        redis:
               image: redis
               expose:
                       - 6379
Una vez finalizado estos cambios procedemos a ejecutar el docker-compose con el siguiente comando:

    docker-compose up
Con esto se carga el contenedor nica-ventas, mysql y redis.

Para consumir la llamada [GET] /active desde un cliente web como curl se utiliza el siguiente comando:

    curl -i 'localhost:8000/active?city=leon&country=ni'
Si se ejecuta 2 veces el comando curl la primera ejecución retornará:

    {
    	"country": "ni",
    	"city": leon,
    	"active": false,
    	"cache": "miss"
    }
y la segunda ejecución retornará:

    {
    	"country": "ni",
    	"city": leon,
    	"active": false,
    	"cache": "hit"
    }
Para guardar una nueva ciudad se utiliza el siguiente comando:

    curl -i -d '{"country":"ni", "city":"Leon"}' -H "Content-Type: application/json" -X POST localhost:8000/active
Para cambiar el estado de una ciudad se utiliza el siguiente comando:

    curl -i -X PUT -H "Authorization: Bearer 2234hj234h2kkjjh42kjj2b20asd6918" -H "Content-Type: application/json" -d '{"country":"ni", "city":"Leon", "active":true}' localhost:8000/active
En este caso si la ciudad leon esta cargada en cache al cambiar el esto se borra la cache y si se consulta el campo cache igual a hit cambia a miss.

Para crear la imagen del micro servicio se utiliza el siguiente comando:

    docker build -t juancarlosb64/nica-ventas:v3.0 .
Para subir la imagen al repositorio dockerhub se utiliza el siguiente comando:

    docker push juancarlosb64/nica-ventas:v3.0
Si se desea descargar la imagen del repositorio de dockerhub se utiliza el siguiente comando:

    docker pull juancarlosb64/nica-ventas:v3.0
Url de imagen en dockerhub

    https://hub.docker.com/r/juancarlosb64/nica-ventas
Y con esto completamos el nivel 3 del ejercicio.

