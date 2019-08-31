#!flask/bin/python
from flask import Flask, jsonify, request, escape
import os
from flask_mysqldb import MySQL
from worklog import Worklog
import redis
import requests
import json
import sys

app = Flask(__name__)

app.config['MYSQL_HOST'] = os.environ['DATABASE_HOST']
app.config['MYSQL_USER'] = os.environ['DATABASE_USER']
app.config['MYSQL_PASSWORD'] = os.environ['DATABASE_PASSWORD']
app.config['MYSQL_DB'] = os.environ['DATABASE_NAME']
app.config['JSON_AS_ASCII'] = False

mysql = MySQL(app)

redis_cli = redis.Redis(host=os.environ['REDIS_LOCATION'], port=os.environ['REDIS_PORT'])

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

@app.route('/quote', methods=['POST'])
def post_quote():
    try:
        payload = request.get_json()
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
        else:
            wl = Worklog(mysql, app.logger)
            clima = requests.get('http://api.openweathermap.org/data/2.5/weather?q=' + payload['city'] + ',' + payload['country'] + '&appid=3225ae99d4c4cb46be4a2be004226918').json()
            
            if clima['cod'] == "404":
                data = {"mensaje": "No existe informacion metereologica para " + payload['city']}
            else:
                js = wl.find_rules(clima['weather'][0]['id'], **payload)

                if js is None:
                    data = {"mensaje": "Registro no encontrado"}
                else:
                    redis_cli.setex(key, 300, '{"sku":"' + js[0] + 
                                              '","description":"' + js[1] + 
                                              '","country":"' + js[2] + 
                                              '","city":"' + js[3] + 
                                              '","base_price":' + str(js[4]) + 
                                              ',"variation":' + str(js[5]) + '}'
                                   ) 
                    data = {
                                "sku": js[0], 
                                "description": js[1], 
                                "country": js[2], 
                                "city": js[3], 
                                "base_price": str(js[4]),
                                "variation": str(js[5]),
                                "cache": "miss"
                           }

        return jsonify(data)
    except:
        return jsonify({"mensaje": "Ha ocurrido un error, Verifique el URL."})

if __name__ == '__main__':
    app.run(debug=True)
