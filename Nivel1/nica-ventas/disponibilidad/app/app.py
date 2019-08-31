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
