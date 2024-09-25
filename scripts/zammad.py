import os
import time
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
    
    headers = {
        "Authorization": f"Token token={ZAMMAD_API_TOKEN}",
        "Content-Type": "application/json"
    }

    all_tickets = []
    page = 1
    per_page = 100 
    has_more_pages = True

    while has_more_pages:
        try:
            # Fetch a single page of tickets
            response = requests.get(f"{url}?page={page}&per_page={per_page}", headers=headers)

            if response.status_code == 200:
                tickets = response.json()
                
                # If there are no tickets, break the loop
                if not tickets:
                    has_more_pages = False
                    break

                all_tickets.extend(tickets)  # Add current page's tickets to the list
                
                print(f"Page {page}: Retrieved {len(tickets)} tickets. Total so far: {len(all_tickets)}")

                # Increment the page number to get the next set of tickets
                page += 1

                # Optional: Delay to prevent overwhelming the server (if needed)
                time.sleep(1)
            else:
                print(f"Error: {response.status_code} - {response.text}")
                has_more_pages = False

        except Exception as e:
            print(f"An error occurred: {e}")
            break

    # Save all tickets to JSON file
    with open(output_file, 'w') as file:
        json.dump(all_tickets, file, indent=4)
    print(f"Total tickets saved to {output_file}: {len(all_tickets)}")

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
