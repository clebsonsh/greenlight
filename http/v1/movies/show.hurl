# Show Movie with ID 1
GET http://localhost:4000/v1/movies/1
Authorization: Bearer {{auth_token}}

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movie.id" == 1
jsonpath "$.movie.title" == "Moana"
jsonpath "$.movie.year" == 2016
jsonpath "$.movie.runtime" == "107 mins"
jsonpath "$.movie.genres" count == 2
jsonpath "$.movie.genres[0]" == "animation"
jsonpath "$.movie.genres[1]" == "adventure"
jsonpath "$.movie.version" == 1


# Show Movie with ID 2
GET http://localhost:4000/v1/movies/2
Authorization: Bearer {{auth_token}}

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movie.id" == 2
jsonpath "$.movie.title" == "Black Panther"
jsonpath "$.movie.year" == 2018
jsonpath "$.movie.runtime" == "134 mins"
jsonpath "$.movie.genres" count == 2
jsonpath "$.movie.genres[0]" == "action"
jsonpath "$.movie.genres[1]" == "adventure"
jsonpath "$.movie.version" == 1


# Show Movie with non-existent ID
GET http://localhost:4000/v1/movies/99
Authorization: Bearer {{auth_token}}

HTTP 404
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "the requested resource could not be found"


# Show Movie with invalid ID
GET http://localhost:4000/v1/movies/abc
Authorization: Bearer {{auth_token}}

HTTP 404
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "the requested resource could not be found"
