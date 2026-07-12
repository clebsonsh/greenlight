# 1. Create a user
POST http://localhost:4000/v1/users
{
    "name": "API Permissions User",
    "email": "api-permissions@example.com",
    "password": "password123"
}

HTTP 202
[Asserts]
jsonpath "$.user.email" == "api-permissions@example.com"

# 2. Authenticate to get a token
POST http://localhost:4000/v1/tokens/authentication
{
    "email": "api-permissions@example.com",
    "password": "password123"
}

HTTP 201
[Captures]
api_token: jsonpath "$.authentication_token.token"

# 3. Try to read a movie using the token (Will fail because user is not activated)
GET http://localhost:4000/v1/movies/1
Authorization: Bearer {{api_token}}

HTTP 403
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "your user account must be activated to access this resource"
