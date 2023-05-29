import requests
import json
import http.client

conn = http.client.HTTPSConnection("v3.football.api-sports.io")

headers = {
    'x-rapidapi-host': "v3.football.api-sports.io",
    'x-rapidapi-key': "fb36f876b1msh87974a9ebf4aa2bp1878c7jsn1173b15fe327"
    }

def main():
    conn.request("GET", "/{endpoint}", headers=headers)
    res = conn.getresponse()
    data = res.read()
    print(data.decode("utf-8"))
    #data = json.loads(response.text)
    #json_formatted_str = json.dumps(data, indent=2)
    #print(json_formatted_str)
    f = open("data.txt", "w")
    #f.write(json_formatted_str)
    f.write(data.decode("utf-8"))
main()