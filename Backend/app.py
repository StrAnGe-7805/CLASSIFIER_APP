from flask import Flask, jsonify
from flask import abort
from flask import request
from flask import make_response
from model import mainmodel

app = Flask(__name__)

tasks = [
    {
        'id': 1,
        'input': u'#',
        'output': u'sport'
    }
]

@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'error': 'Not found'}), 404)


@app.route('/todo/api/v1.0/tasks', methods=['GET'])
def get_tasks():
    return jsonify({'tasks': tasks})


@app.route('/todo/api/v1.0/tasks/<string:task_input>', methods=['GET'])
def get_task(task_input):
    task = [task for task in tasks if task['input'] == task_input]
    if len(task) == 0:
        abort(404)
    return jsonify({'task': task[0]})


@app.route('/todo/api/v1.0/tasks', methods=['POST'])
def create_task():
    if not request.json or not 'input' in request.json:
        abort(400)
    task = {
        'id': tasks[-1]['id'] + 1,
        'input': request.json['input'],
        'output': mainmodel(request.json['input'])
    }
    tasks.append(task)
    return jsonify({'task': task}), 201

if __name__ == '__main__':
    app.run(debug=True)