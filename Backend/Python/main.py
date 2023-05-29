import os
#from subprocess import Popen
import subprocess
def main():
    print("ahoj")
    subprocess.run("python3 data_scraping/spiders/post-scrap.py & python3 url_scraping/url_scrap.py", shell=True)
    #os.system("python data_scraping/spiders/post-scrap.py")  
    #os.system("python url_scraping/url_scrap.py")  
    #Popen(['python', 'data_scraping/spiders/post-scrap.py'])
    #Popen(['python', 'url_scraping/url_scrap.py'])













main()