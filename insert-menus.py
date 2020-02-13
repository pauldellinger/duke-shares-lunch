#!/usr/bin/env python
# -*- coding: utf-8 -*-


import psycopg2
import json

def main():
    dbc = psycopg2.connect(database='lunches', user='notifier', host='127.0.0.1', password='verysecret', port=5432)
    #set as autocommit otherwise we have to call commit function every time
    dbc.set_isolation_level(psycopg2.extensions.ISOLATION_LEVEL_AUTOCOMMIT)
    cur = dbc.cursor()
    with open('restaurants.json', 'r') as file:
        restaurants = json.loads(file.read())

    for index in range(len(restaurants)):
        region = restaurants[index]
        #print(region)
        for key in region:
            area = region[key]
            for location in area:
                locationName = location["name"].replace("'", "''")
                #print(locationName)
                cur.execute("INSERT INTO LOCATIONS(region,name) VALUES('%s','%s')" % (key, locationName))
                menu = location["menu"]
                for item in menu:
                    itemName = item["name"].replace("'","''")
                    itemPrice = item["price"]
                    #print(itemName, itemPrice)
                    cur.execute("INSERT INTO MENUS(name,price,location) VALUES('%s', %f, (SELECT lid from LOCATIONS WHERE name = '%s'))" % (itemName, itemPrice, locationName)) 
if __name__ == "__main__":
    main()
