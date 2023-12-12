from flask import Flask
from sqlalchemy import create_engine, Table, Column, Integer, String, MetaData

# MSSQL CONFIGURATION
username  = "sa" 					# default username
password = "MSSQLpassword!"			# set in docker-compose.yml
host = "mssql"						# uri of host. resolves to an IP for our mssql container
database = "tempdb"					# name of database

engine = create_engine("mssql+pymssql://{}:{}@{}/{}".format(username, password, host, database))

app = Flask(__name__)				# initialize app

metadata = MetaData()				# make some metadata

users = Table("users", metadata,	# and a table
	Column("id", Integer, primary_key=True),
	Column("name", String(80))
)

metadata.create_all(engine)

c = engine.connect()				# connect to database
c.execute(users.delete())			# remove old entries
c.execute(users.insert(), [			# insert new entries
	{ "name": "John Carse" },
	{ "name": "Claudia Watson" }
])
c.close()							# close connection

@app.route("/")						# root of app
def hello():						# grab all users from 'users' and list them...
	c = engine.connect()
	result = c.execute("SELECT * FROM users")
	users = [ user["name"] for user in result ]
	c.close()
	return str(users)				# ...and send them as our app

if __name__ == "__main__":			# run test server at localhost:8080 (127.0.0.1:8080)
	app.run(host='0.0.0.0', port=8080, debug=True)
