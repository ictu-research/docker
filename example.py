from impala.dbapi import connect
conn = connect(host='localhost', port=10000)
cursor = conn.cursor()
cursor.execute('SELECT * FROM mytable LIMIT 100')
print(cursor.description)  # prints the result set's schema
results = cursor.fetchall()
