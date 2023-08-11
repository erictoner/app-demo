from flask import Flask, request
from flasgger import Swagger

app = Flask(__name__)
Swagger(app)

# Initial name value
name_data = {'name': 'john'}

@app.route('/get_name', methods=['GET'])
def get_name():
    """
    Get the current name value.
    ---
    responses:
      200:
        description: A JSON object with the current name.
        schema:
          properties:
            name:
              type: string
    """
    return jsonify(name_data)

@app.route('/update_name', methods=['PUT'])
def update_name():
    """
    Update the name value.
    ---
    parameters:
      - name: name
        in: query
        type: string
        required: true
        description: The new name value.
    responses:
      200:
        description: Name updated successfully.
      400:
        description: Invalid input.
    """
    new_name = request.args.get('name')
    if new_name:
        name_data['name'] = new_name
        return jsonify({'message': 'Name updated successfully'})
    else:
        return jsonify({'message': 'Invalid input'}), 400

@app.route('/status', methods=['GET'])
def status():
    """
    Check the server status.
    ---
    responses:
      200:
        description: Server is available.
    """
    return '', 200

if __name__ == '__main__':
    app.run(debug=True)
