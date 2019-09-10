# Nivel 4
Objetivos:
1. Evolucionar la arquitectura existente para incluir un micro servicio que proporcione el API [POST] /quote, según lo especificado en el enunciado en Servicio de Consulta de Condiciones de Venta añadir al archivo docker-compose el nuevo micro servicio.
2. Añadir políticas de cacheo de forma que si se solicita [POST] /quote con los mismos parámetros se responda desde la cache de REDIS en lugar de volver a realizar la consultas a OpenWeather y la BBDD. La validez de uno de estos datos cacheados será de 5 min. Con objeto de verificar que la cache funciona, incluir en la respuesta un campo cache como se hizo anteriormente.

En la solución de este nivel se crearon nuevos archivos y directorios ya que al crearse un nuevo micro servicio se tuvo que realizar otro archivo app.py, worklog.py, requirements, etc. quedando el árbol de directorio de la siguiente manera:

    └── nica-ventas
        ├── condiciones
	    │   ├── app
	    │   │   ├── app.py
	    │   │   ├── requirements.txt
	    │   │   └── worklog.py
	    │   └── Dockerfile
	    ├── disponibilidad
	    │   ├── app
	    │   │   ├── app.py
	    │   │   ├── requirements.txt
	    │   │   └── worklog.py
	    │   ├── Dockerfile
	    │   └── schema.sql
	    └── docker-compose.yml

Dado que se le dio solución al Servicio de consulta de condiciones de venta se creó el directorio condiciones, dentro de este el directorio app y el archivo Dockerfile, el cual tiene un contenido igual al Dockerfile que se encuentra en disponibilidad y dentro de app los archivos app.py, requirements.txt y worklog.py.

## app.py
Dentro de este archivo se creo la llamada [GET] /price, la cual consulta los productos que se encuentra en la tabla product retornando el sku, description y base_price en caso de que no encuentre ningun registro retorna el mensaje Registro no encontrado.

    @app.route('/price/<sku>')
    def get_price(sku):
        try:
	        wl = Worklog(mysql, app.logger)
	        js = wl.find_product(sku)

	        if js is None:
	            data = {"mensaje": "Registro no encontrado"}
	        else:
	            data = {
	                        "sku": js[0],
	                        "description": js[1], 
	                        "base_price": str(js[2])
	                   }

	        return jsonify(data)
	    except:
	        return jsonify({"mensaje": "Ha ocurrido un error, Verifique el URL."})

 También se creo la llamada [POST] /quote, la cual primeramente verifica si existe una llave del registro consultado para retornar los datos desde la cache, estos datos son almacenados en la cache como un string en formato json. Si la llave existe se arma un objeto y se retorna en formato json.
 
    key = payload['country'].lower() + '_' + payload['city'].lower() + '_' + payload['sku'].lower()
    state = redis_cli.get(key)
    if state:
    	js = json.loads(state)
            
		data = {
				     "sku": js['sku'], 
				     "description": js['description'], 
				     "country": js['country'], 
				     "city": js['city'], 
				     "base_price": js['base_price'],
				     "variation": js['variation'], 
				     "cache": "hit"
		       }
Si la llave no existe antes de obtener el registro de la base de datos primero se consulta en la api openweathermap que tipo de clima tiene la ciudad esto se realiza con la siguiente instrucción:

    clima = requests.get('http://api.openweathermap.org/data/2.5/weather?q=' + payload['city'] + ',' + payload['country'] + '&appid=3225ae99d4c4cb46be4a2be004226918').json()

Si el elemento cod dentro de la variable clima es 404 significa que la ciudad no esta registrada dentro de la api.

    if clima['cod'] == "404":
    	data = {"mensaje": "No existe informacion metereologica para " + payload['city']}
Si el elemento es diferente de 404 significa que la ciudad existe y podemos obtener el elemento id el cual nos indica que tipo de clima tiene la ciudad con este valor podemos utilizar la función find_rules la cual nos permite consultar que productos tienen cierta variación por el clima de la ciudad.

    if clima['cod'] == "404":
    	data = {"mensaje": "No existe informacion metereologica para " + payload['city']}
    else:
    	js = wl.find_rules(clima['weather'][0]['id'], **payload)
	
Una vez obtenido el registro de la base de datos creamos una llave y almacenamos el registro con formato json, pasandole como tiempo un valor entero en segundos,  dado que son 5 minutos convertimos los minutos en segundo lo cual nos da 300 segundos. Con esto la llave expira después de 5 minutos.

    if js is None:
     	data = {"mensaje": "Registro no encontrado"}
    else:
    	redis_cli.setex(key, 300, '{"sku":"' + js[0] + 
                                  '","description":"' + js[1] + 
                                  '","country":"' + js[2] + 
                                  '","city":"' + js[3] + 
                                  '","base_price":' + str(js[4]) + 
                                  ',"variation":' + str(js[5]) +
                                  '}') 
    	data = {
    		     "sku": js[0], 
    		     "description": js[1], 
    		     "country": js[2], 
    		     "city": js[3], 
    		     "base_price": str(js[4]),
    		     "variation": str(js[5]),
    		     "cache": "miss"
    	       }
	       
## requirements.txt
Dentro de este fichero estan los mismos nombres de paquetes que existen en la carpeta disponibilidad.

    Click==7.0
    Flask==1.1.1
    itsdangerous==1.1.0
    Jinja2==2.10.1
    MarkupSafe==1.1.1
    Werkzeug==0.15.5
    worklog
    flask_mysqldb
    redis
    requests
## worklog.py
Dentro de este fichero se encuentran 2 funciones find_product la cual consulta en la tabla product y retorna el campo sku, description y base_price.

    def find_product(self, vSku):
    	sql = """
        select sku
               , description
               , base_price 
        from product 
        where sku="{}";
        """.format(
                vSku)
        cur = self._dbcon.connection.cursor()
        cur.execute(sql)
        rv = cur.fetchone()
        cur.close()
        self._logger.info(sql)
        self._logger.info(rv)
        return rv
    
Y find_rules la cual recibe como parámetros sku, country, city y el id de clima para consultar la variación del producto en determinada ciudad, estos datos se obtienen de la tabla rules.

    def find_rules(self, weather_id, **payload):
            sql = """
            select pr.sku
                   , pr.description
                   , coalesce(rl.country, "{}") as country
                   , coalesce(rl.city, "{}") as city
                   , pr.base_price
                   , coalesce(rl.variation, 1) as variation
            from product as pr
            left outer join rules as rl on pr.sku = rl.sku and "{}" between rl.min_condition and rl.max_condition and rl.country = "{}" and rl.city = "{}"
            where pr.sku = "{}";
            """.format(
                    payload['country'],
                    payload['city'],
                    weather_id,
                    payload['country'],
                    payload['city'],
                    payload['sku'])
            cur = self._dbcon.connection.cursor()
            cur.execute(sql)
            rv = cur.fetchone()
            cur.close()
            self._logger.info(sql)
            self._logger.info(rv)
            return rv
## Dockerfile
Dentro de este fichero tenemos el mismo contenido que existe en el archivo Dockerfile del directorio disponibilidad.

    FROM python
    
    COPY /app /app
    RUN pip install -r /app/requirements.txt
    
    WORKDIR app
    
    CMD ["python", "app.py"]
    
    EXPOSE 5000

## docker-compose.yml
Dentro de este archivo agregamos el contenedor nica-condiciones en el cual le especificamos que utilizará la imagen nica-condiciones, que el archivo Dockerfile se encuentra en el directorio condiciones y las variables de entorno de MySQL y redis.

    nica-condiciones:
    	image: juancarlosb64/nica-condiciones
    	build:
    		context: ./condiciones
    		dockerfile: Dockerfile
    	ports:
    		- "8100:5000"
    	volumes:
    		- ./condiciones/app:/app
    	environment:
    		- FLASK_DEBUG=1
    		- DATABASE_PASSWORD=nicaventaspass
    		- DATABASE_NAME=nicaventasdb
    		- DATABASE_USER=nicaventasuser
    		- DATABASE_HOST=nicaventas-db
    		- REDIS_LOCATION=redis
    		- REDIS_PORT=6379
    	command: flask run --host=0.0.0.0

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

	        nica-condiciones:
	                image: juancarlosb64/nica-condiciones
	                build:
	                       context: ./condiciones
	                       dockerfile: Dockerfile
	                ports:
	                       - "8100:5000"
	                volumes:
	                       - ./condiciones/app:/app
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
Con esto se carga el contenedor nica-ventas, nica-condiciones, mysql y redis.

Para consumir la llamada [GET] /active desde un cliente web como curl se utiliza el siguiente comando:

    curl -i 'localhost:8000/active?city=leon&country=ni'
Para guardar una nueva ciudad se utiliza el siguiente comando:

    curl -i -d '{"country":"ni", "city":"Leon"}' -H "Content-Type: application/json" -X POST localhost:8000/active
Para cambiar el estado de una ciudad se utiliza el siguiente comando:

    curl -i -X PUT -H "Authorization: Bearer 2234hj234h2kkjjh42kjj2b20asd6918" -H "Content-Type: application/json" -d '{"country":"ni", "city":"Leon", "active":true}' localhost:8000/active
Para consultar un producto se realiza en otro micro servicio el cual utiliza el puerto 8100 esto se realiza con el siguiente comando:

    curl 'localhost:8100/price/AZ00001'
Para consultar la variación de un producto se realiza el siguiente comando:

    curl -i -d '{"sku":"AZ00001", "country":"ni", "city":"Leon"}' -H "Content-Type: application/json" -X POST localhost:8100/quote

Para crear la imagen del micro servicio se utiliza el siguiente comando:

    docker build -t juancarlosb64/nica-ventas:v4.0 .
    docker build -t juancarlosb64/nica-condiciones:v4.0 .

Para subir las imagenes al repositorio dockerhub se utiliza el siguiente comando:

    docker push juancarlosb64/nica-ventas:v4.0
    docker push juancarlosb64/nica-condiciones:v4.0
Si se desea descargar la imagen del repositorio de dockerhub se utiliza el siguiente comando:

    docker pull juancarlosb64/nica-ventas:v4.0
    docker pull juancarlosb64/nica-condiciones:v4.0
Url de imagen en dockerhub

    https://hub.docker.com/r/juancarlosb64/nica-ventas
    https://hub.docker.com/r/juancarlosb64/nica-condiciones

Y con esto completamos el nivel 4 del ejercicio.

