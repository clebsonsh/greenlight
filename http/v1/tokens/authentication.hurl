# Create Authentication Token: Valid credentials (Alice)
POST http://localhost:4000/v1/tokens/authentication
{
    "email": "alice@example.com",
    "password": "password123"
}

HTTP 201
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.authentication_token.token" exists
jsonpath "$.authentication_token.expiry" exists
jsonpath "$.authentication_token.hash" not exists
jsonpath "$.authentication_token.user_id" not exists
jsonpath "$.authentication_token.scope" not exists


# Create Authentication Token: Non-existent email
POST http://localhost:4000/v1/tokens/authentication
{
    "email": "nobody@example.com",
    "password": "password123"
}

HTTP 401
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "invalid authentication credentials"


# Create Authentication Token: Wrong password
POST http://localhost:4000/v1/tokens/authentication
{
    "email": "alice@example.com",
    "password": "wrongpassword"
}

HTTP 401
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "invalid authentication credentials"


# Create Authentication Token: Missing email
POST http://localhost:4000/v1/tokens/authentication
{
    "password": "password123"
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.email" == "must be provided"


# Create Authentication Token: Invalid email format
POST http://localhost:4000/v1/tokens/authentication
{
    "email": "not-an-email",
    "password": "password123"
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.email" == "must be a valid email address"


# Create Authentication Token: Missing password
POST http://localhost:4000/v1/tokens/authentication
{
    "email": "alice@example.com"
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.password" == "must be provided"


# Create Authentication Token: Password too short (< 8 bytes)
POST http://localhost:4000/v1/tokens/authentication
{
    "email": "alice@example.com",
    "password": "short"
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.password" == "must be at least 8 bytes long"


# Create Authentication Token: Password too long (> 72 bytes)
POST http://localhost:4000/v1/tokens/authentication
{
    "email": "alice@example.com",
    "password": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.password" == "must not be more than 72 bytes long"


# Create Authentication Token: Empty Body
POST http://localhost:4000/v1/tokens/authentication

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "body must not be empty"


# Create Authentication Token: Malformed JSON (trailing comma)
POST http://localhost:4000/v1/tokens/authentication
```
{"email": "alice@example.com", "password": "password123",}
```

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" startsWith "body contains badly-formed JSON"


# Create Authentication Token: Unknown key
POST http://localhost:4000/v1/tokens/authentication
{
    "email": "alice@example.com",
    "password": "password123",
    "foo": "bar"
}

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "body contains unknown key \"foo\""


# Create Authentication Token: Multiple JSON values
POST http://localhost:4000/v1/tokens/authentication
```
{"email": "alice@example.com", "password": "password123"}{"email": "bob@example.com", "password": "password123"}
```

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "body must only contain a single JSON value"