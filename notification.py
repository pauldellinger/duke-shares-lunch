
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import select
import psycopg2
import psycopg2.extensions
from datetime import datetime
import json
import jwt
import time
import requests
from hyper.contrib import HTTP20Adapter

dbc = psycopg2.connect(database='lunches', user='notifier', host='127.0.0.1', password='verysecret', port=5432)
#set as autocommit otherwise we have to call commit function every time
dbc.set_isolation_level(psycopg2.extensions.ISOLATION_LEVEL_AUTOCOMMIT)
cur = dbc.cursor()
def main():

    process_new_notifications()
    cur.execute('LISTEN notificationqueue')
    while 1:
        if not select.select([dbc],[],[],5) == ([],[],[]):
            dbc.poll()
            while dbc.notifies:
                notify = dbc.notifies.pop(0)
                print ("Got NOTIFY:", notify.pid, notify.channel, notify.payload)
                process_new_notifications()


def process_new_notifications():
    '''
    Get the unprocessed notifications from queue
    For each, construct payload and parameters
    Send request to APNS
    Mark requests as processed
    '''

    cur.execute('SELECT * FROM notificationqueue WHERE processed is NULL')
    records = cur.fetchall()
    print(records)
    now = datetime.now()
    #cur.execute('UPDATE notificationqueue set processed = (%s)', (now,))
    auth_token = get_token()
    session = start_session(auth_token)
    for row in records:
        if row[0] is not None:
            payload = gen_payload(row)
            device_token = row[0]
            make_request(session, payload, device_token)
    cur.execute('UPDATE notificationqueue set processed = (%s)', (now,))
def get_token():
    with open('/home/pauldell123/duke-shares-lunch/flask/apns-token.txt', 'r') as file:
        token = file.read()

    return "Bearer " + token
    '''
    with open('../AuthKey_NY9QVDNTSP.p8', 'r') as file:
            secret = file.read()
    token = jwt.encode({'iss':'6GH5DL24KD', 'iat': time.time()}, secret, algorithm='ES256', headers = {'alg':'ES256', 'kid': 'NY9QVDNTSP'}).decode('utf-8')
    return "Bearer " + token
    '''
def gen_payload(row):
    payload = {"aps":
{"alert": row[2],
"sound": "default",
"badge": 1 }
}
    return payload
def start_session(auth_token):
    s = requests.Session()
    s.headers = {"apns-topic": "July-Guys.FoodPointer",
                 "Authorization": auth_token,
                 "Content-Type": "application/json"
                }
    s.mount('https://api.sandbox.push.apple.com', HTTP20Adapter())
    return s
def make_request(session, payload, device_token):
    url = 'https://api.sandbox.push.apple.com/3/device/' + device_token
    print(payload, url)
    r = session.post(url, json = payload)
    print(r.status_code, r.content)


if __name__ == "__main__":
    print(get_token())
    main()
