# Duke Shares Lunch
### An iOS app to help Duke students sell their food points

## Code Structure

- In the root directory you'll find our database set up files
- The sql files are in the sql directory
- The DukeShareLunch directory contains the iOS app

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
  - type the following:
  - `cp test.pauldellinger.com /etc/nginx/sites-available`

  - `sudo ln -s /etc/nginx/sites-available/test.pauldellinger.com /etc/nginx/sites-enabled/`


   - Open the nginx.conf file with
   `nano etc/nginx/nginx.conf`

  - Change the line `include /etc/nginx/sites-enabled/*;"`  &rarr;  `include /etc/nginx/sites-enabled/test.pauldellinger.com;`
  - now run
  `sudo systemctl restart nginx`

#### If you're fine with no authentication you should be able to stop here
- just change build.sh so it doesn't run sql/auth.sql
- type `./build.sh`
- access the database with psql lunches
#### Configure auth:
- follow instructions in link to clone this repository and set up pgcrypto
https://github.com/michelp/pgjwt

#### Add the randomly generated database:
- `psql lunches -af sql/random-db.sql`
  - run `./build.sh` again if you want to overwrite it with empty db
#### Configure the app for your IP address:
- find your external IP address
- replace every instance of '35.193.85.182' in xcode project with your IP
  - in the works: a little script that would do this automatically

## Limitations to Current Implementation 12/10
- Details in last section of milestones/final_report.pdf
- shouldn't be able to buy from yourself but it's convenient for showing to people
