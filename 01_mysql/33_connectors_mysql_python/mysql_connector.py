
"""
MySQL connector example using mysql.connector

This script connects to the 'hello_mysql' database and
defines a function that searches users by name.
"""

import mysql.connector  # library that allows connecting to MySQL

# Connection configuration
config = {
    "host": "127.0.0.1",
    "port": "3306",
    "database": "hello_mysql",
    "user": "root",
    "password": "Jane0909.",  # ← replace with your own password in real projects
}


# Function that receives a name and searches it in the database
def print_user(name: str) -> None:
    connection = mysql.connector.connect(**config)
    cursor = connection.cursor()

    # We use %s to avoid SQL injection
    query = "SELECT * FROM users WHERE name = %s;"
    cursor.execute(query, (name,))  # pass the parameter as a tuple
    result = cursor.fetchall()

    for row in result:
        print(row)

    cursor.close()
    connection.close()


# Example calls
print_user("Dani")
print_user("'; UPDATE users SET age = '15' WHERE user_id = 1; --")
