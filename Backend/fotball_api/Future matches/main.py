import requests
import json
import http.client


subUrls = [
    "status",
    "/fixtures/rounds?season=2022&league=346",
    "/standings?league=345&season=2022",
    "/teams/statistics?season=2022&team=560&league=346",
    "/teams?league=345&season=2022",
    "/fixtures?league=345&season=2022&league=345&season=2022&team=560&",

]

parameters = [
]

conn = http.client.HTTPSConnection("v3.football.api-sports.io")

headers = {
    'x-rapidapi-host': "v3.football.api-sports.io",
    'x-rapidapi-key': "53eab603a7c3ec8222692fb4d3270d5c"
    }



def main():
    conn.request("GET", subUrls[5], headers=headers)
    res = conn.getresponse()
    data = res.read()
    data1 = json.loads(data)
    json_formatted_str = json.dumps(data1, indent=2, ensure_ascii=False).encode('utf8')
    #print(json_formatted_str)
    f = open("data.txt", "w")
    f.write(json_formatted_str.decode("utf-8"))
    #print(data.decode("utf-8"))

main()

