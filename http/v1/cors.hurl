# Standard CORS request with trusted origin
GET http://localhost:4000/v1/healthcheck
Origin: http://localhost:9000

HTTP 200
[Asserts]
header "Access-Control-Allow-Origin" == "http://localhost:9000"


# CORS request with untrusted origin
GET http://localhost:4000/v1/healthcheck
Origin: http://untrusted.com

HTTP 200
[Asserts]
header "Access-Control-Allow-Origin" not exists


# Preflight CORS request with trusted origin
OPTIONS http://localhost:4000/v1/tokens/authentication
Origin: http://localhost:9000
Access-Control-Request-Method: POST

HTTP 200
[Asserts]
header "Access-Control-Allow-Origin" == "http://localhost:9000"
header "Access-Control-Allow-Methods" == "OPTIONS, PUT, PATCH, DELETE"
header "Access-Control-Allow-Headers" == "Authorization, Content-Type"


# Preflight CORS request missing Access-Control-Request-Method (should not return Allow-Methods or Allow-Headers)
OPTIONS http://localhost:4000/v1/tokens/authentication
Origin: http://localhost:9000

HTTP 200
[Asserts]
header "Access-Control-Allow-Origin" == "http://localhost:9000"
header "Access-Control-Allow-Methods" not exists
header "Access-Control-Allow-Headers" not exists
