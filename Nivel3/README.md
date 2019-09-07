# Nivel 3
Objetivos:
1. Modificar el micro servicio para que la respuesta de la llamada [GET] /active se haga desde una cache REDIS. 
La respuesta de este servicio ahora incluirá un campo cache que valdrá miss si la respuesta procede de la base de datos, 
y hit si la respuesta procede de caché.
2. Modificar el micro servicio para que la respuesta de la llamada [POST] /active invalide el posible contenido cacheado en REDIS.
3. Añadir al archivo docker-compose el servicio de redis.

En la solución de este nivel el árbol de directorios no sufrió ningún cambio:

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
