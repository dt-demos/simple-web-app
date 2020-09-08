import time
import atexit
import autodynatrace
import requests

class BoomApp:

    @autodynatrace.trace
    def process(self):
        self.callUrl("https://www.dynatrace.com")
        self.letsleep(30)
        b = BoomAppBomb()
        b.boom()

    @autodynatrace.trace
    def letsleep(self,numseconds):
        print("Sleeping " + str(numseconds) + " seconds")
        time.sleep( numseconds )

    @autodynatrace.trace
    def callUrl(self,url):
        print("Calling: " + url + " Response Code : " + str(requests.get(url).status_code))

class BoomAppBomb:
    @autodynatrace.trace
    def boom(self):
        print("Boom!!")
        raise Exception("I am blowing up!!!")

# main
# add this to allow DT to capture the exception message
atexit.register(time.sleep,5)
a = BoomApp()
a.process()