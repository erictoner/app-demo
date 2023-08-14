import requests
import sys
import argparse
from urllib.parse import urlparse

def test_get_name(base_url):
    response = requests.get(f"{base_url}/get_name")
    data = response.json()
    print("GET /get_name:")
    print(data)
    print()
    return response.status_code

def test_update_name(base_url, new_name):
    update_response = requests.put(f"{base_url}/update_name?name={new_name}")
    update_status = update_response.status_code
    print(f"PUT /update_name?name={new_name}:")
    print(update_response.json())
    print()

    # Verify the new name
    get_response = requests.get(f"{base_url}/get_name")
    get_data = get_response.json()
    print("GET /get_name after update:")
    print(get_data)
    print()

    return update_status, get_data.get('name')

def test_status(base_url):
    response = requests.get(f"{base_url}/status")
    print("GET /status:")
    print(f"Status Code: {response.status_code}")
    print()
    return response.status_code

def main():
    parser = argparse.ArgumentParser(description="Test script with command line options.")
    parser.add_argument("--base-url", default="127.0.0.1:8001", help="Override the base URL")
    args = parser.parse_args()

    base_url = args.base_url
    if not base_url.startswith("http://") and not base_url.startswith("https://"):
        base_url = "http://" + base_url

    get_name_status = test_get_name(base_url)

    new_name = "jane"
    update_name_status, updated_name = test_update_name(base_url, new_name)

    status_status = test_status(base_url)

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

if __name__ == "__main__":
    main()
