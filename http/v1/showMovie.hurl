# Show Movie with ID 1
GET http://localhost:4000/v1/movies/1

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movie.id" == 1
jsonpath "$.movie.title" == "Casablanca"
jsonpath "$.movie.runtime" == "102 mins"
jsonpath "$.movie.genres" count == 3
jsonpath "$.movie.genres[0]" == "drama"
jsonpath "$.movie.genres[1]" == "romance"
jsonpath "$.movie.genres[2]" == "war"
jsonpath "$.movie.version" == 1


# Show Movie with ID 99
GET http://localhost:4000/v1/movies/99

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movie.id" == 99
jsonpath "$.movie.title" == "Casablanca"
jsonpath "$.movie.runtime" == "102 mins"
jsonpath "$.movie.genres" count == 3
jsonpath "$.movie.genres[0]" == "drama"
jsonpath "$.movie.genres[1]" == "romance"
jsonpath "$.movie.genres[2]" == "war"
jsonpath "$.movie.version" == 1


# Show Movie with invalid ID
GET http://localhost:4000/v1/movies/abc

HTTP 404
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "the requested resource could not be found"
