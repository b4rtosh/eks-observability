import requests
import random
import time

def app_request(host_addr: str):
    endpoints = [
        "/",
        f"/items/{random.randint(1, 100)}",
        "/io_task",
        "/cpu_task",
        "/random_status",
        "/random_sleep",
        "/error_test",
        "/chain"
    ]
    endpoint = random.choice(endpoints)
    url = f"{host_addr}{endpoint}"
    try:
        response = requests.get(url, timeout=5)
        print(f"Requested {url} - Status: {response.status_code}")
    except Exception as e:
        print(f"Failed to request {url} - Error: {e}")

if __name__ == "__main__":
    host_addr = input("Enter host with proper port (e.g., http://localhost:8000): ").strip()
    if host_addr and not host_addr.startswith("http"):
        host_addr = "http://" + host_addr
        
    interval_str = input("Enter request interval in seconds (default 1): ").strip()
    try:
        interval = float(interval_str)
    except ValueError:
        interval = 1.0

    print(f"Sending requests to {host_addr} every {interval} seconds...")
    try:
        while True:
            app_request(host_addr)
            time.sleep(interval)
    except KeyboardInterrupt:
        print("\nStopped.")

