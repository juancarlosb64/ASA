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
	    │   │   ├── app.py
	    │   │   ├── requirements.txt
	    │   │   └── worklog.py
	    │   ├── Dockerfile
	    │   └── schema.sql
	    └── docker-compose.yml
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
Se modificó la función **get_active**, acá lo que hacemos es obtener las variables country y city con request.args.get() las cuales son enviadas con un cliente web, luego creamos una variable de tipo **Worklog** llamada wl a la que pasamos por medio de el constructor la variable mysql para podernos conectar a la base de datos. Dentro de la variable wl accedemos a la función **find_location** pasandole como parámetro country y city, esta función lo que hace es que consulta a la tabla location el country y city enviado, y retorna el estado del registro este resultado se almacena en la variable js, en caso de que el registro no exista se crea un objeto con el mensaje **Registro no encontrado** en caso positivo crea un objeto agregando country, city y active con sus respectivos valores, este objeto lo convertimos en json con la función jsonify y lo retornamos al cliente web, en caso de que se genere un error se ejecuta except enviando el mensaje **Ha ocurrido un error, Verifique el URL**.

    @app.route('/active', methods=['GET'])
    def get_active():
        try:
            country = request.args.get('country')
            city = request.args.get('city')
    
            wl = Worklog(mysql, app.logger)
            js = wl.find_location(country, city)
        
            if js is None:
                data = {"mensaje": "Registro no encontrado"}
            else:
                data = {
                            "country": js[0],
                            "city": js[1],
                            "active": bool(js[2])
                       }
    
            return jsonify(data)
        except:
            return jsonify({"mensaje": "Ha ocurrido un error, Verifique el URL."})

Se creó la ruta active con el método post y la función **post_active**, esta función espera los datos en formato json, para leer estos datos utilizamos request.get_json() y los almacenamos en la variable payload, creamos una variable de tipo worklog llamanda wl y usamos la función **find_location** para verificar si existe el country y city enviado, en caso positivo se arma una variable de tipo objeto con el mensaje **El registro ya existe en la base de datos** y la retornamos al cliente, en caso contrario usamos la función **save_location** para almacenar el registro en la base de datos pasandole como parámetros payload, si todo se ejecuta sin error se arma una variable de tipo objeto agregándole los valores guardado y agregando el mensaje **Registro guardado satisfactoriamente**, si se genera un error se ejecuta except y manda el mensaje **Ha ocurrido un error, Verifique el URL**. 

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
Se creó la ruta active con el método put y la función **put_active**, esta función espera los datos en formato json, para leer estos datos utilizamos request.get_json() y los almacenamos en la variable payload, leemos del encabezado de la petición el token enviado por el cliente con request.get("authorization"), se realizan ciertas verificaciones por ejemplo si el token no se envia se crea una variable de tipo objeto con el mensaje No ha enviado token, si el token no es igual al esperado se envía el mensaje **El token enviado no esta autorizado** y en caso de que sea igual se crea la variable wl de tipo Worklog, se accede a la función **state_location** pasando como  parámetro la variable payload.
La función **state_location** lo que hace es que modifica el valor del campo active en la tabla location con el valor que se envía en el json, la función retorna 1 en caso de que se haya actualizado el registro y 0 en caso de que el registro no haya tenido cambio, por lo tanto se verifica y se notifica si se actualizó el registro o no.

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

	            if res == 0:
	                data = {
	                            "mensaje": "No se actualizo ningun registro",
	                            "token": auth,
	                            "country": payload['country'],
	                            "city": payload['city'],
	                            "active": payload['active']
	                       }
	            else:
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
## Contenido de app.py

    #!flask/bin/python
    from flask import Flask, jsonify, request, escape
    import os
    from flask_mysqldb import MySQL
    from worklog import Worklog
    
    app = Flask(__name__)

    app.config['MYSQL_HOST'] = os.environ['DATABASE_HOST']
    app.config['MYSQL_USER'] = os.environ['DATABASE_USER']
    app.config['MYSQL_PASSWORD'] = os.environ['DATABASE_PASSWORD']
    app.config['MYSQL_DB'] = os.environ['DATABASE_NAME']
    
    mysql = MySQL(app)

    @app.route('/active', methods=['GET'])
    def get_active():
        try:
            country = request.args.get('country')
            city = request.args.get('city')

	        wl = Worklog(mysql, app.logger)
	        js = wl.find_location(country, city)
    
	        if js is None:
	            data = {"mensaje": "Registro no encontrado"}
	        else:
	            data = {
	                        "country": js[0],
	                        "city": js[1],
	                        "active": bool(js[2])
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

	            if res == 0:
	                data = {
	                            "mensaje": "No se actualizo ningun registro",
	                            "token": auth,
	                            "country": payload['country'],
	                            "city": payload['city'],
	                            "active": payload['active']
	                       }
	            else:
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
Dentro de este fichero se agregó el nombre de la libreria flask_mysqldb para que se instale en el contenedor y el micro servicio funcione sin problemas.

    Click==7.0
    Flask==1.1.1
    itsdangerous==1.1.0
    Jinja2==2.10.1
    MarkupSafe==1.1.1
    Werkzeug==0.15.5
    flask_mysqldb

## worklog.py
Es una clase de python la cual funciona como un repositorio, dentro de este documento están las funciones que utilizamos en el archivo app.py, estas funciones tienen las consultas sql las cuales se arman con los parámetros enviados desde app.py y se ejecutan en el servidor de base de datos, la conexión a la base de datos se realiza en la función __init__.

    class Worklog:

    def __init__(self, dbcon, logger):
        self._dbcon=dbcon
        self._logger=logger

    def save_location(self, **kwargs):
        sql = """
        insert into location 
        (country,city,active) 
        values ('{}','{}',false)
        """.format(  
            kwargs['country'],
            kwargs['city'])
        cur = self._dbcon.connection.cursor()
        cur.execute(sql)
        self._dbcon.connection.commit()
        cur.close()
        self._logger.info(sql)

    def find_location(self, vCountry, vCity):
        sql = """
        select country, city, active from location where country="{}" and city="{}";
        """.format(
                vCountry,
                vCity)
        cur = self._dbcon.connection.cursor()
        cur.execute(sql)
        rv = cur.fetchone()
        cur.close()
        self._logger.info(sql)
        self._logger.info(rv)
        return rv

    def state_location(self, **kwargs):
        sql = """
        update location 
        set active = "{}"
        where country="{}" and city="{}";
        """.format(
                int(kwargs['active']),
                kwargs['country'],
                kwargs['city'])
        cur = self._dbcon.connection.cursor()
        res = cur.execute(sql)
        self._dbcon.connection.commit()
        cur.close()
        self._logger.info(sql)
        return res 
## schema.sql
Es un script de sql con el que se crean las tablas y se insertan registros de prueba en la base de datos MySQL.

    CREATE TABLE IF NOT EXISTS location (
    	country varchar(2) NOT NULL,
    	city varchar(100) NOT NULL,
    	active bool NOT NULL,
    	PRIMARY KEY (country, city)
    ) ENGINE=innodb;

    INSERT INTO location (country, city, active) VALUES ('PR', 'Guayama', false);
    INSERT INTO location (country, city, active) values ('AF', 'Kabul', false);
    INSERT INTO location (country, city, active) values ('ZA', 'Pretoria', false);
    INSERT INTO location (country, city, active) values ('AL', 'Tirana', false);
    INSERT INTO location (country, city, active) values ('DE', 'Berlin', false);
    INSERT INTO location (country, city, active) values ('AD', 'Andorra', false);
    INSERT INTO location (country, city, active) values ('AO', 'Luanda', false);
    INSERT INTO location (country, city, active) VALUES ('NI', 'Leon', false);
## docker-compose.yml
Es un fichero en el que especificamos los diferentes contenedores y servicios que utilizaremos. 

### Contenedor nica-ventas
En la configuración del contenedor tenemos:

 - **image:** se especifica la imagen que se utilizará cuando se ejecute el docker.
 - **build:** se utiliza para indicar donde está el fichero Dockerfile.
 - **ports:** se mapea el puerto localhost con el puerto del escucha del docker.
 - **volumes:** se mapea el directorio actual directamente con el directorio app de la aplicación.
 - **environment:** en esta sección se declaran las variables de entorno del contenedor. 
 - **command:** se escribe el comando que permite ejecutar la aplicación en modo servidor.

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
    command: flask run --host=0.0.0.0

### Contenedor nicaventas-db 
En la configuración del contenedor tenemos:
**image:** se especifica la imagen mysql que se utilizará. 
**environment:** se declaran las variables de entorno del contenedor. 
**expose:** se especifica el puerto de escucha del docker. 
**volumes:** se especifica donde se encuentra el script sql para copiarlo en el docker y que este cree la base de datos con sus tablas y registros de prueba.

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

### Contenido de docker-compose.yml

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

Una vez finalizado el micro servicio procedemos a ejecutarlo con el siguiente comando:

    docker-compose up

Con esto se carga el contenedor nica-ventas y de mysql.

Para consumir la llamada [GET] /active desde un cliente web como curl se utiliza el siguiente comando:

    curl -i 'localhost:8000/active?city=leon&country=ni'
Para guardar una nueva ciudad se utiliza el siguiente comando:

    curl -i -d '{"country":"ni", "city":"Leon"}' -H "Content-Type: application/json" -X POST localhost:8000/active
Para cambiar el estado de una ciudad se utiliza el siguiente comando:

    curl -i -X PUT -H "Authorization: Bearer 2234hj234h2kkjjh42kjj2b20asd6918" -H "Content-Type: application/json" -d '{"country":"ni", "city":"Leon", "active":true}' localhost:8000/active
Para crear la imagen del microservicio se utiliza el siguiente comando:

    docker build -t juancarlosb64/nica-ventas:v2.0 .
Para subir la imagen al repositorio dockerhub se utiliza el siguiente comando:

    docker push juancarlosb64/nica-ventas:v2.0
Si se desea descargar la imagen del repositorio de dockerhub se utiliza el siguiente comando:

    docker pull juancarlosb64/nica-ventas:v2.0
Url de imagen en dockerhub

    https://hub.docker.com/r/juancarlosb64/nica-ventas
Y con esto completamos el nivel 2 del ejercicio.

