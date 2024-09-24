import os
import boto3
import requests
from requests_aws4auth import AWS4Auth
from dotenv import load_dotenv
import argparse
import json

# Load sensitive configuration from .env file
load_dotenv()

# Get configuration from environment variables
aws_access_key = os.getenv('AWS_ACCESS_KEY_ID')
aws_secret_key = os.getenv('AWS_SECRET_ACCESS_KEY')
aws_region = os.getenv('AWS_REGION')
opensearch_endpoint = os.getenv('OPENSEARCH_ENDPOINT')

# AWS authentication setup
def get_aws_auth():
    session = boto3.Session()
    credentials = session.get_credentials()
    auth = AWS4Auth(
        aws_access_key,
        aws_secret_key,
        aws_region,
        'es',  # OpenSearch service
        session_token=credentials.token
    )
    return auth

# Function to create index
def create_index(index_name):
    url = f"{opensearch_endpoint}/{index_name}"
    headers = {"Content-Type": "application/json"}
    
    # number of shards and replicas here
    data = '{"settings": {"number_of_shards": 3, "number_of_replicas": 2}}'  # check cluster setting to get this

    auth = get_aws_auth()
    response = requests.put(url, auth=auth, headers=headers, data=data)

    print(f"Response Code: {response.status_code}")
    print(response.text)

# Function to convert JSON to NDJSON format, required by OpenSearch
def convert_json_to_ndjson(input_file, output_file):
    # Load the JSON array from the input file
    with open(input_file, 'r') as file:
        try:
            data = json.load(file)
            # Ensure data is an array of objects
            if not isinstance(data, list):
                print("Error: JSON file should contain an array of objects.")
                return False
        except json.JSONDecodeError as e:
            print(f"Error: Invalid JSON file. {e}")
            return False

    # Convert the array to NDJSON format for bulk upload
    with open(output_file, 'w') as file:
        for doc in data:
            file.write('{"index": {}}\n')  # Action line for bulk API
            file.write(f'{json.dumps(doc)}\n')  # Document data

    print(f"Successfully converted {input_file} to NDJSON format: {output_file}")
    return True

# Function to upload JSON file to index
def upload_file_to_index(index_name, file_path):
    # First, convert the JSON to NDJSON format
    ndjson_file = file_path.replace('.json', '-bulk.ndjson')

    if not convert_json_to_ndjson(file_path, ndjson_file):
        print("Error converting JSON to NDJSON. Aborting upload.")
        return

    # Now, upload the converted NDJSON file
    url = f"{opensearch_endpoint}/{index_name}/_bulk"
    headers = {"Content-Type": "application/json"}

    # Read the NDJSON data
    with open(ndjson_file, 'r') as file:
        data = file.read()

    auth = get_aws_auth()
    response = requests.post(url, auth=auth, headers=headers, data=data)

    print(f"Response Code: {response.status_code}")
    print(response.text)

# Main function to handle commands
def main():
    parser = argparse.ArgumentParser(description="Manage OpenSearch indices.")
    parser.add_argument('command', choices=['create-index', 'upload-file'], help="Command to execute.")
    parser.add_argument('--index', required=True, help="Name of the OpenSearch index.")
    parser.add_argument('--file', help="Path to the JSON file for uploading data (required for 'upload-file').")

    args = parser.parse_args()

    if args.command == 'create-index':
        create_index(args.index)
    elif args.command == 'upload-file':
        if not args.file:
            print("Error: --file argument is required for uploading data.")
            return
        upload_file_to_index(args.index, args.file)

if __name__ == "__main__":
    main()
