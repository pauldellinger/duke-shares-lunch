# Duke Shares Lunch
### An iOS app to help Duke students sell their food points

## Code Structure

- In the root directory you'll find our database set up files
- The sql files are in the sql directory
- The DukeShareLunch directory contains the iOS app
- flask directory contains a small python app to convert firebase tokens

## Setup
### If you just want to see the iOS app:
  - Clone the repository *in xcode*, open the xcode project file (must have updated macOS)
  - may have some signing issues but if you sign in with your appleid it should build
  - make sure that the build target version is configured correctly
  - backend should be running on our end so it should work
  - A good overview of the app can be seen on the storyboard

### Configure Everything:
  - do the above then for the backend:
  - Install psql version 10
  - Install nginx with `apt-get install nginx`
  - Configure domain name and certification: [tutorial](https://medium.com/@nishankjaintdk/serving-a-website-on-a-registered-domain-with-https-using-nginx-and-lets-encrypt-8d482e01a682)
  - set up [Firebase Admin SDK](https://firebase.google.com/docs/admin/setup/?authuser=0)
  - not sure if the flask app is going to carry over so you may have to [configure it](https://www.digitalocean.com/community/tutorials/how-to-serve-flask-applications-with-uswgi-and-nginx-on-ubuntu-18-04)
  - type `cp nginx.conf /etc/nginx/nginx.conf` (say yes to overwrite)
  - now run `sudo systemctl restart nginx`
  - run `gunicorn --bind 0.0.0.0:5000 wsgi:app`

#### If you're fine with no authentication you should be able to stop here
- just change build.sh so it doesn't run sql/auth.sql
- type `./build.sh`
- access the database with psql lunches
- serve the database on port 3000 with ./postgrest database-server.conf
  - remember to configure a secret key in database-server.key
#### Configure auth:
- follow instructions in link to clone this repository and set up pgcrypto
https://github.com/michelp/pgjwt

#### Add the randomly generated database:
- `psql lunches -af sql/random-db.sql`
  - run `./build.sh` again if you want to overwrite it with empty db

## Limitations to Current Implementation 12/10
- Details in last section of milestones/final_report.pdf
- shouldn't be able to buy from yourself but it's convenient for showing to people
