import jwt
import time
def main():
    with open('/home/pauldell123/duke-shares-lunch/AuthKey_NY9QVDNTSP.p8', 'r') as file:
        secret = file.read()
    token = jwt.encode({'iss':'6GH5DL24KD', 'iat': time.time()}, secret, algorithm='ES256', headers = {'alg':'ES256', 'kid': 'NY9QVDNTSP'}).decode('utf-8')
    with open('/home/pauldell123/duke-shares-lunch/flask/apns-token.txt', 'w') as file:
       file.write(token)
    print("Sucessfully wrote new token")
if __name__ == "__main__":
    main()


