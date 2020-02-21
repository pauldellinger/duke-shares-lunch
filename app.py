from flask import Flask
from flask import request
import firebase_admin
from firebase_admin import credentials
from firebase_admin import auth
import jwt
import time
import psycopg2
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
        encoded_jwt = jwt.encode({'role': uid, 'exp': time.time()+60}, 'zOTMma3rOGRey8y4prnnxt08P52DXWZ5', algorithm='HS256').decode('utf-8')
        auth_header = 'Bearer ' + encoded_jwt

        #return response conforming to nginx
        return ("token verifed", 202, {'ContentType':'text/html', 'Authorization':auth_header})

    #firebase raises exceptions for any issues

    except: #(KeyError, firebase_admin.exceptions.UnknownError, firebase_admin._auth_utils.InvalidIdTokenError, firebase_admin._token_gen.InvalidSessionCookieError, firebase_admin.exceptions.NotFoundError) as e:
        return ("Token not accepted", 401, {'ContentType':'text/html'})

@app.route('/authorize', methods=['GET', 'POST', 'PUT', 'DELETE'])
def create_role():
    #!/usr/bin/env python3
    # Overview:
    #   Provides idempotent remote RDS PostgreSQL (application) role/user creation from python for use outside of CM modules.
    #   Because PostgreSQL doesn't have something like 'CREATE ROLE IF NOT EXISTS' which would be nice.
    #   ref: https://stackoverflow.com/questions/8546759/how-to-check-if-a-postgres-user-exists
    # Requirements: 
    #   Python3 and psycopg2 module 
    # cmcc

    ##### update creds for each kube cluster
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


    #firebase raises exceptions for any issues

    except: #(KeyError, firebase_admin.exceptions.UnknownError, firebase_admin._auth_utils.InvalidIdTokenError, firebase_admin._token_gen.InvalidSessionCookieError, firebase_admin.exceptions.NotFoundErro$
        return ("Token not accepted", 401, {'ContentType':'text/html'})

    cluster_name = "foo123"
    db_host = "localhost"
    db_port = 5432

    # postgres admin creds
    admin_db_name = "lunches"
    admin_db_user = "authorizer"
    admin_db_pass = "hY2zPbSM6vbEgxGn"

    # deis creds
    deis_db_name = "lunches"
    deis_app_user = uid
    deis_app_passwd = "super-secret2"
    ##### Dont change below code


    # thanks to contributors here: https://stackoverflow.com/questions/8546759/how-to-check-if-a-postgres-user-exists
    check_user_cmd = ("SELECT 1 FROM pg_roles WHERE rolname='%s'" % (deis_app_user))

    # our create role/user command and vars
    create_user_cmd = ('CREATE ROLE "%s"' % (deis_app_user))

    grant_todo_user_cmd = ('GRANT todo_user to "%s"' % (deis_app_user))
    grant_authenticator_cmd = ('GRANT "%s" to authenticator' % (deis_app_user))

    # thanks to contributors here: https://stackoverflow.com/questions/37488175/simplify-database-psycopg2-usage-by-creating-a-module
    class RdsCreds():
        def __init__(self):
            self.conn = psycopg2.connect("dbname=%s user=%s host=%s password=%s" % (admin_db_name, admin_db_user, db_host, admin_db_pass))
            self.conn.set_isolation_level(0)
            self.cur = self.conn.cursor()

        def query(self, query):
            self.cur.execute(query)
            return self.cur.rowcount > 0

        def close(self):
            self.cur.close()
            self.conn.close()

    db = RdsCreds()
    user_exists = db.query(check_user_cmd)

    # PostgreSQL currently has no 'create role if not exists'
    # So, we only want to create the role/user if not exists else psycopg2 
    if (user_exists) is True:
        print("%s user_exists: %s" % (deis_app_user, user_exists))
        print("Idempotent: No credential modifications required. Exiting...")
        db.close()
        return ("Role already exists", 422, {'ContentType':'text/html'})
    else:
        print("%s user_exists: %s" % (deis_app_user, user_exists))
        print("Creating %s user now" % (deis_app_user))
        db.query(create_user_cmd)
        db.query(grant_todo_user_cmd)
        db.query(grant_authenticator_cmd)
        user_exists = db.query(check_user_cmd)
        db.close()
        print("%s user_exists: %s" % (deis_app_user, user_exists))
        return ("Role created", 201, {'ContentType':'text/html'})
if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0')
