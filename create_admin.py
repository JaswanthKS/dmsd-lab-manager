from flask_bcrypt import Bcrypt

bcrypt = Bcrypt()

password = "admin123"
hashed = bcrypt.generate_password_hash(password).decode('utf-8')

print("password hash in the database:")
print(hashed)
