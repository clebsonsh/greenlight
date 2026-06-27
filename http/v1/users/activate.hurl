# Activate User: Valid Token (seeded)
PUT http://localhost:4000/v1/users/activated
{
    "token": "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
}

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.user.activated" == true
jsonpath "$.user.email" == "activate-test@example.com"
jsonpath "$.user.name" == "Activation Test"
jsonpath "$.user.id" exists
jsonpath "$.user.created_at" exists
jsonpath "$.user.password" not exists


# Activate User: Reuse token after activation (should fail)
PUT http://localhost:4000/v1/users/activated
{
    "token": "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.token" == "invalid or expired activation token"


# Activate User: Missing token field
PUT http://localhost:4000/v1/users/activated
{}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.token" == "must be provided"


# Activate User: Empty token
PUT http://localhost:4000/v1/users/activated
{
    "token": ""
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.token" == "must be provided"


# Activate User: Token too short (3 chars)
PUT http://localhost:4000/v1/users/activated
{
    "token": "ABC"
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.token" == "must be 26 bytes long"


# Activate User: Token too long (27 chars)
PUT http://localhost:4000/v1/users/activated
{
    "token": "ABCDEFGHIJKLMNOPQRSTUVWXYZA"
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.token" == "must be 26 bytes long"


# Activate User: Valid length but not found in DB
PUT http://localhost:4000/v1/users/activated
{
    "token": "ZZZZZZZZZZZZZZZZZZZZZZZZZZ"
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.token" == "invalid or expired activation token"


# Activate User: Empty Body
PUT http://localhost:4000/v1/users/activated

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "body must not be empty"


# Activate User: Malformed JSON (trailing comma)
PUT http://localhost:4000/v1/users/activated
```
{"token": "ABC",}
```

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" startsWith "body contains badly-formed JSON"


# Activate User: Unknown key
PUT http://localhost:4000/v1/users/activated
{
    "token": "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
    "foo": "bar"
}

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "body contains unknown key \"foo\""


# Activate User: Multiple JSON values
PUT http://localhost:4000/v1/users/activated
```
{"token": "ABC"}{"token": "DEF"}
```

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "body must only contain a single JSON value"
