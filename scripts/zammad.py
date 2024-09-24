import os
import requests
import argparse
import json
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Get Zammad API details from environment variables
ZAMMAD_API_URL = os.getenv('ZAMMAD_API_URL')
ZAMMAD_API_TOKEN = os.getenv('ZAMMAD_API_TOKEN')

# Debugging: Print loaded environment variables to check if they're being read correctly
print(f"Zammad API URL: {ZAMMAD_API_URL}")
print(f"Zammad API Token (First 6 characters for security): {ZAMMAD_API_TOKEN[:6]}...")

# Function to retrieve tickets from Zammad and save to a JSON file
def get_tickets(output_file):
    url = f"{ZAMMAD_API_URL}/tickets"
    
    # Debugging: Print the full request URL to ensure it's constructed properly
    print(f"Request URL: {url}")

    headers = {
        "Authorization": f"Token token={ZAMMAD_API_TOKEN}",
        "Content-Type": "application/json"
    }

    # Debugging: Print headers to ensure token is being passed correctly
    print(f"Request Headers: {headers}")

    try:
        response = requests.get(url, headers=headers)

        # Debugging: Print the response status code and content for further insight
        print(f"Response Status Code: {response.status_code}")
        print(f"Response Text: {response.text[:200]}...")  # Truncate for readability

        if response.status_code == 200:
            tickets = response.json()
            print(f"Successfully retrieved {len(tickets)} tickets.")

            # Save tickets to JSON file
            with open(output_file, 'w') as file:
                json.dump(tickets, file, indent=4)
            print(f"Tickets saved to {output_file}")
        else:
            print(f"Error: {response.status_code} - {response.text}")

    except Exception as e:
        print(f"An error occurred: {e}")

# Main function to handle command pattern
def main():
    parser = argparse.ArgumentParser(description="Zammad API Ticket Manager")
    parser.add_argument('command', choices=['get-tickets'], help="Command to execute")
    parser.add_argument('--output', required=True, help="Path to output JSON file")

    args = parser.parse_args()

    # Command pattern handling
    if args.command == 'get-tickets':
        get_tickets(args.output)

if __name__ == "__main__":
    main()
