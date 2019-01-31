#import packages
import requests, lxml, re, smtplib, email
from lxml import html
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

#Set password, from email address, and to email address here
PASSWORD = null
EMAIL_FROM = null
EMAIL_TO = null

#setup SMTP
server = smtplib.SMTP_SSL('smtp.gmail.com',465)
server.login(EMAIL_FROM, PASSWORD)

#Gather data from Vidalia and process it into strings
VidaliaReq = requests.get("http://georgiaweather.net/?content=calculator&variable=CC&site=VIDALIA")
VidaliaData = html.document_fromstring(VidaliaReq.content)
VidaliaTable = VidaliaData.cssselect("[class=TableRow2]")
Vidaparsed = []
for element in VidaliaTable:
	text = element.text_content()
	parsed1 = text.split("&nbsp")
	Vidaparsed.append(parsed1)
vidacleaned = []
for vidax in Vidaparsed:
	y = str(vidax)
	vidacleaner = y.split(',')
	vidacleaner2 = str(vidacleaner).replace("['",'')
	vidacleaner3 = str(vidacleaner2).replace('\\r','')
	vidacleaner4 = str(vidacleaner3).replace('\\t','')
	vidacleaner5 = str(vidacleaner4).replace('\\n','')
	vidacleaner6 = str(vidacleaner5).replace("\\",'')
	vidacleaner7 = str(vidacleaner6).replace('\'','')
	vidacleaner8 = str(vidacleaner7).replace(']\"','')
	vidacleaner9 = str(vidacleaner8).replace('&deg','')
	vidacleaned.append(str(vidacleaner9))
VidaMinTemp = str(vidacleaned[-2]).strip('[]')
VidaMaxTemp = str(vidacleaned[-3]).strip('[]')
VidaPrecip = str(vidacleaned[-4]).strip('[]')
VidaMinTempCleaner = VidaMinTemp.split(',')[2]
VidaMinTempClean = VidaMinTempCleaner.replace('\" ','')
VidaMaxTempCleaner = VidaMaxTemp.split(',')[2]
VidaMaxTempClean = VidaMaxTempCleaner.replace('\" ','')
VidaPrecipCleaner = VidaPrecip.split(',')[2]
VidaPrecipClean = VidaPrecipCleaner.replace('\" ','')

#Do the same things for Statesboro
statesReq = requests.get("http://georgiaweather.net/?content=calculator&variable=CC&site=STATES")
statesData = html.document_fromstring(statesReq.content)
statesTable = statesData.cssselect("[class=TableRow2]")
statesparsed = []
for element in statesTable:
	text = element.text_content()
	parsed1 = text.split("&nbsp")
	statesparsed.append(parsed1)
statescleaned = []
for statesx in statesparsed:
	y = str(statesx)
	statescleaner = y.split(',')
	statescleaner2 = str(statescleaner).replace("['",'')
	statescleaner3 = str(statescleaner2).replace('\\r','')
	statescleaner4 = str(statescleaner3).replace('\\t','')
	statescleaner5 = str(statescleaner4).replace('\\n','')
	statescleaner6 = str(statescleaner5).replace("\\",'')
	statescleaner7 = str(statescleaner6).replace('\'','')
	statescleaner8 = str(statescleaner7).replace(']\"','')
	statescleaner9 = str(statescleaner8).replace('&deg','')
	statescleaned.append(str(statescleaner9))
statesMinTemp = str(statescleaned[-2]).strip('[]')
statesMaxTemp = str(statescleaned[-3]).strip('[]')
statesPrecip = str(statescleaned[-4]).strip('[]')
statesMinTempCleaner = statesMinTemp.split(',')[2]
statesMinTempClean = statesMinTempCleaner.replace('\" ','')
statesMaxTempCleaner = statesMaxTemp.split(',')[2]
statesMaxTempClean = statesMaxTempCleaner.replace('\" ','')
statesPrecipCleaner = statesPrecip.split(',')[2]
statesPrecipClean = statesPrecipCleaner.replace('\" ','')

msg = MIMEMultipart()
msg['Subject'] = 'Daily Weather Report'
msg['From'] = EMAIL_FROM
msg['To'] = EMAIL_TO
text = "\nHere is the daily weather report for Vidalia and Statesboro: \n Vidalia \n ---------- \n Maximum Temperature: "+VidaMaxTempClean+"\n Minimum Temperature: "+VidaMinTempClean+"\n Precipitation: "+VidaPrecipClean+"\n----------\n Statesboro \n --------- \n Maximum Temperature: "+statesMaxTempClean+"\n Minimum Temperature: "+statesMinTempClean+"\n Precipitation: "+statesPrecipClean 
body = MIMEText(text, 'plain')
msg.attach(body)

server.sendmail(EMAIL_FROM, EMAIL_TO, msg.as_string())
server.quit()