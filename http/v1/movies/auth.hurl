# Auth: Missing Authorization header
GET http://localhost:4000/v1/movies

HTTP 401
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "you must be authenticated to access this resource"


# Auth: Invalid scheme (no Bearer keyword)
GET http://localhost:4000/v1/movies
Authorization: Token RSTUVWXYZABCDEFGHIJKLMNOPQ

HTTP 401
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "invalid or missing authentication token"


# Auth: Bearer with no token
GET http://localhost:4000/v1/movies
Authorization: Bearer

HTTP 401
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "invalid or missing authentication token"


# Auth: Token too short
GET http://localhost:4000/v1/movies
Authorization: Bearer ABC

HTTP 401
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "invalid or missing authentication token"


# Auth: Valid format but token not found in DB
GET http://localhost:4000/v1/movies
Authorization: Bearer ZZZZZZZZZZZZZZZZZZZZZZZZZ

HTTP 401
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "invalid or missing authentication token"


# Auth: Valid token but user not activated
GET http://localhost:4000/v1/movies
Authorization: Bearer YZABCDEFGHIJKLMNOPQRSTUVWX

HTTP 403
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "your user account must be activated to access this resource"


# Auth: Valid token and activated but user lacks permissions
GET http://localhost:4000/v1/movies
Authorization: Bearer BBCDEFGHIJKLMNOPQRSTUVWXYZ

HTTP 403
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "your user account doesn't have the necessary permissions to access this resource"
