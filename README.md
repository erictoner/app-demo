# Simple Flask API with GET and PUT Endpoints

This repository contains a simple RESTful API built using Flask. It provides two endpoints: `/get_name` to retrieve a name value and `/update_name` to update the name value. Additionally, there is a `/status` endpoint to check the server status, and a `/apidocs` endpoint that returns HTTP documentation intended for browser usage.

## Getting Started

Follow these instructions to set up and use the API locally.

### Prerequisites

- Python 3.11.4
- pip (Python package installer)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/simple-flask-api.git
   ```

2. Navigate to the project directory

   ```bash
   cd app
   ```

3. Install the required packages
  pip install -r requirements.txt


### Usage

1. Start the Flask server
   ```bash
   python api.py
   ```

2. Open a web browser or use a tool like `curl` to interact with the API:

   - GET the current name value:

     ```
     http://127.0.0.1:5000/get_name
     ```

   - PUT to update the name value:

     ```
     http://127.0.0.1:5000/update_name?name=new_name_value
     ```

   - Check server status (returns only a 200 status code):

     ```
     http://127.0.0.1:5000/status
     ```

   - Access the OpenAPI documentation:

     ```
     http://127.0.0.1:5000/apidocs
     ```

### Testing
# Todo - Add steps for using ci/build_docker_image.sh
# Todo - Add steps for using ci/test_docker_image.sh


### Minikube Setup
1. Use minikube docker
   ```bash
   eval $(minikube docker-env)
   ```

2. Build your image in minikube via ci/build_docker_image.sh

Notes:
Test access to application prior to ingress setup via
`minikube service -n app app --url`

3. 

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
