from flask import Flask
from flask import request
import firebase_admin
from firebase_admin import credentials
from firebase_admin import auth
import jwt
import time
app = Flask(__name__)
@app.route('/', methods=['GET', 'POST', 'PUT', 'DELETE'])


def verify_firebase_token():
    """
    Verify the original jwt from firebase is legit using admin sdk
    Return 202 if yes, 401 if no, conforming to nginx auth_request module
    Set a new Authorization header that will be used by nginx
    New header has jwt signed by same secret key as PostgREST
    The new jwt should be encoded with the user role for RLS
    """
    try:
        if (not len(firebase_admin._apps)):
        #initialize firebase app
            cred = credentials.Certificate('duke-shares-lunch-firebase-adminsdk-dz86v-a563f4f34c.json')
            default_app = firebase_admin.initialize_app(cred)

        #get the firebase jwt
        authorization = request.headers['Authorization']
        if len(authorization)<7:
            return ("No token", 401, {'ContentType':'text/html'})
        #get rid of the Bearer part
        token = request.headers['Authorization'][7:]
        decoded_token = auth.verify_id_token(token)
        uid = decoded_token['uid']

        #load the secret key from external file
        with open('../database-secret.key', 'r') as file:
            secret = file.read().replace('\n', '')

        #mint the new jwt with access to postgrest
        encoded_jwt = jwt.encode({'role': uid.lower(), 'exp': time.time()+60}, 'zOTMma3rOGRey8y4prnnxt08P52DXWZ5', algorithm='HS256').decode('utf-8')
        auth_header = 'Bearer ' + encoded_jwt

        #return response conforming to nginx
        return ("token verifed", 202, {'ContentType':'text/html', 'Authorization':auth_header})

    #firebase raises exceptions for any issues

    except: #(KeyError, firebase_admin.exceptions.UnknownError, firebase_admin._auth_utils.InvalidIdTokenError, firebase_admin._token_gen.InvalidSessionCookieError, firebase_admin.exceptions.NotFoundError) as e:
        return ("Token not accepted", 401, {'ContentType':'text/html'})

if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0')
