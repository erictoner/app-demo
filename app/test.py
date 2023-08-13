import requests
import sys

BASE_URL = "http://127.0.0.1:8001"

def test_get_name():
    response = requests.get(f"{BASE_URL}/get_name")
    data = response.json()
    print("GET /get_name:")
    print(data)
    print()
    return response.status_code

def test_update_name(new_name):
    update_response = requests.put(f"{BASE_URL}/update_name?name={new_name}")
    update_status = update_response.status_code
    print(f"PUT /update_name?name={new_name}:")
    print(update_response.json())
    print()

    # Verify the new name
    get_response = requests.get(f"{BASE_URL}/get_name")
    get_data = get_response.json()
    print("GET /get_name after update:")
    print(get_data)
    print()

    return update_status, get_data.get('name')

def test_status():
    response = requests.get(f"{BASE_URL}/status")
    print("GET /status:")
    print(f"Status Code: {response.status_code}")
    print()
    return response.status_code

if __name__ == "__main__":
    get_name_status = test_get_name()

    new_name = "jane"
    update_name_status, updated_name = test_update_name(new_name)

    status_status = test_status()

    if get_name_status != 200:
        print("Test failed: GET /get_name did not have a 200 status code.")
        sys.exit(1)

    if update_name_status != 200 or updated_name != new_name:
        print("Test failed: PUT /update_name did not have a 200 status code or name was not updated.")
        sys.exit(1)

    if status_status != 200:
        print("Test failed: GET /status did not have a 200 status code.")
        sys.exit(1)

    print("All tests passed successfully.")
    sys.exit(0)
