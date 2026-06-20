# Delete Movie: Valid ID
DELETE http://localhost:4000/v1/movies/4

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.message" == "movie successfully deleted"


# Delete Movie: Non-existent ID
DELETE http://localhost:4000/v1/movies/99

HTTP 404
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "the requested resource could not be found"


# Delete Movie: Invalid ID (non-numeric)
DELETE http://localhost:4000/v1/movies/abc

HTTP 404
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "the requested resource could not be found"


# Delete Movie: Already deleted movie
DELETE http://localhost:4000/v1/movies/4

HTTP 404
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "the requested resource could not be found"
