
#!/usr/bin/env python
# -*- coding: utf-8 -*-
import requests
import json
import jwt
import time
import requests
from hyper.contrib import HTTP20Adapter

def gen_token():
    
    with open('../AuthKey_NY9QVDNTSP.p8', 'r') as file:
            secret = file.read()
    token = jwt.encode({'iss':'6GH5DL24KD', 'iat': time.time()}, secret, algorithm='ES256', headers = {'alg':'ES256', 'kid': 'NY9QVDNTSP'}).decode('utf-8')
    return "Bearer " + token

def make_request(payload, token):
    s = requests.Session()
    s.headers = {"apns-topic": "July-Guys.FoodPointer",
                 "Authorization": token,
                 "Content-Type": "application/json"
                }
    print(type(payload), payload)
    s.mount('https://api.sandbox.push.apple.com', HTTP20Adapter())
    r = s.post('https://api.sandbox.push.apple.com/3/device/aeba7e4439967cb7aba6b1e5bfae9fddb0e73fc54b6a383dc67e3ce3e3cc4b24', json = payload)
    print(r.status_code, r.content)

if __name__ == "__main__":
    gen_token()
    make_request({"aps":
{"alert":"Hey there!",
"sound": "default",
"link_url": "https://raywenderlich.com"}
}, "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiIsImtpZCI6Ik5ZOVFWRE5UU1AifQ.eyJpc3MiOiI2R0g1REwyNEtEIiwiaWF0IjoxNTc3ODI0MDc4LjQ0NjUyMDZ9.tQOq5MfUgM77EjixTJ6TSz8n0MWX0wsCYP1po-Q-TyCtsrRTC7UvdBKPKKXnYOhfnmNpyK8e5wnUKbk5svDm8w")
