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
