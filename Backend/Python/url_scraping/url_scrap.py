import scrapetube
import time
import requests
import json
import time

Headers = {"Content-Type": "application/json"}
last_video_id = ""


def schedule():
    while True:
        main1()
        time.sleep(3600)


def main ():
    global last_video_id
    time.sleep(2)
    while True:
        videos = []
        first = 0
        count = 0
        videos_raw = scrapetube.get_channel("UCPi3_GbTljPZ6b2Laiw-Z5g", limit=10)
        for video in videos_raw:
            count = count + 1
            videoId = str(video['videoId'])
            if videoId == last_video_id:
                break
            if first == 0:
                last_video_id = videoId
                first = 1
            thumbnail = video['thumbnail']['thumbnails'][3]['url']
            title = video['title']['runs'][0]['text']
            try:
                description = video['descriptionSnippet']['runs'][0]['text']
            except KeyError:
                description = ""
            print(video['title']['runs'][0]['text'])
            dictionary = {
                "videoId": video['videoId'],
                "thumbnail": video['thumbnail']['thumbnails'][3]['url'],
                "title": video['title']['runs'][0]['text'],
                "description":  description,
                "publishedTime": video['publishedTimeText']['simpleText'],
                "lengthVideo": video['lengthText']['simpleText'],
                "viewCount": video['shortViewCountText']['accessibility']['accessibilityData']['label'],
            }
            videos.append(dictionary)
            '''print("https://www.youtube.com/watch?v="+str(video['videoId']))
            print(video['thumbnail']['thumbnails'][3]['url'])
            print(video['title']['runs'][0]['text'])
            print(video['descriptionSnippet']['runs'][0]['text'])
            print(video['publishedTimeText']['simpleText'])
            print(video['lengthText']['simpleText'])
            print(video['shortViewCountText']['accessibility']['accessibilityData']['label'])
            print("\n")'''
        if len(videos) != 0:
            json_data = {
                "videos": videos 
            }
            z = json.dumps(json_data)
            print("Data sended - Videos")
            r = requests.post(url = "http://0.0.0.0:8000/api/additional/videos", data = z, headers= Headers)
        print("---------------------------------")
        print("\n")
        time.sleep(3600)



def main1 ():
    videos = []
    videos_raw = scrapetube.get_channel("UCPi3_GbTljPZ6b2Laiw-Z5g", limit=20)
    for video in videos_raw:
        videoId = str(video['videoId'])
        thumbnail = video['thumbnail']['thumbnails'][3]['url']
        title = video['title']['runs'][0]['text']
        try:
            description = video['descriptionSnippet']['runs'][0]['text']
        except KeyError:
            description = ""
        print(video['title']['runs'][0]['text'])
        dictionary = {
            "videoId": video['videoId'],
            "thumbnail": video['thumbnail']['thumbnails'][3]['url'],
            "title": video['title']['runs'][0]['text'],
            "description":  description,
            "publishedTime": video['publishedTimeText']['simpleText'],
            "lengthVideo": video['lengthText']['simpleText'],
            "viewCount": video['shortViewCountText']['accessibility']['accessibilityData']['label'],
        }
        videos.append(dictionary)
    videos.reverse()
    #print(videos)
    json_data = {
        "videos": videos
    }
    z = json.dumps(json_data)
    print("Data sended         000000000000000000000000000000000000000000000000000000000")
    r = requests.post(url = "http://slavia-api:8000/api/additional/videos", data = z, headers= Headers) #10.143.103.78 #0.0.0.0 #localhost




schedule()




#for video in videos:
#v = list(videos[1])
#print(v[0])
    #videos = next(videos_raw)
    #print(videos)


'''import urllib
import json

def get_all_video_in_channel(channel_id):
    api_key = "AIzaSyBURwceGNujgqGw6TPLcyXIXZd7EdNgkuw"

    base_video_url = 'https://www.youtube.com/watch?v='
    base_search_url = 'https://www.googleapis.com/youtube/v3/search?'

    first_url = base_search_url+'key={}&channelId={}&part=snippet,id&order=date&maxResults=25'.format(api_key, channel_id)

    video_links = []
    url = first_url
    while True:
        inp = urllib.(url)
        resp = json.load(inp)

        for i in resp['items']:
            if i['id']['kind'] == "youtube#video":
                video_links.append(base_video_url + i['id']['videoId'])

        try:
            next_page_token = resp['nextPageToken']
            url = first_url + '&pageToken={}'.format(next_page_token)
        except:
            break
    return video_links

get_all_video_in_channel("UCPi3_GbTljPZ6b2Laiw-Z5g")'''

#UCPi3_GbTljPZ6b2Laiw