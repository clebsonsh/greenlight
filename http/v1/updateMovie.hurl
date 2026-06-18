# Update Movie: Full update (ID 1)
PATCH http://localhost:4000/v1/movies/1
{
    "title": "Moana 2",
    "year": 2024,
    "runtime": "110 mins",
    "genres": [
        "animation",
        "adventure",
        "musical"
    ]
}

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movie.title" == "Moana 2"
jsonpath "$.movie.year" == 2024
jsonpath "$.movie.runtime" == "110 mins"
jsonpath "$.movie.genres[0]" == "animation"
jsonpath "$.movie.genres[1]" == "adventure"
jsonpath "$.movie.genres[2]" == "musical"
jsonpath "$.movie.id" == 1
jsonpath "$.movie.version" == 2


# Update Movie: Partial update - only title (ID 1)
PATCH http://localhost:4000/v1/movies/1
{
    "title": "Moana: The Series"
}

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movie.title" == "Moana: The Series"
jsonpath "$.movie.year" == 2024
jsonpath "$.movie.runtime" == "110 mins"
jsonpath "$.movie.version" == 3


# Update Movie: Partial update - only year (ID 1)
PATCH http://localhost:4000/v1/movies/1
{
    "year": 2023
}

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movie.title" == "Moana: The Series"
jsonpath "$.movie.year" == 2023
jsonpath "$.movie.version" == 4


# Update Movie: Partial update - only genres (ID 1)
PATCH http://localhost:4000/v1/movies/1
{
    "genres": ["animation", "comedy"]
}

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movie.genres[0]" == "animation"
jsonpath "$.movie.genres[1]" == "comedy"
jsonpath "$.movie.version" == 5


# Update Movie: Partial update - only runtime (ID 1)
PATCH http://localhost:4000/v1/movies/1
{
    "runtime": "115 mins"
}

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movie.runtime" == "115 mins"
jsonpath "$.movie.version" == 6


# Update Movie: Empty object (valid - no changes)
PATCH http://localhost:4000/v1/movies/1
{}

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movie.version" == 7


# Update Movie: Update another movie (ID 2)
PATCH http://localhost:4000/v1/movies/2
{
    "title": "Black Panther: Wakanda Forever",
    "year": 2022,
    "runtime": "161 mins",
    "genres": [
        "action",
        "drama"
    ]
}

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movie.title" == "Black Panther: Wakanda Forever"
jsonpath "$.movie.year" == 2022
jsonpath "$.movie.runtime" == "161 mins"
jsonpath "$.movie.genres[0]" == "action"
jsonpath "$.movie.genres[1]" == "drama"
jsonpath "$.movie.id" == 2
jsonpath "$.movie.version" == 2


# Update Movie: Non-existent ID
PATCH http://localhost:4000/v1/movies/999
{
    "title": "Non-existent Movie"
}

HTTP 404
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "the requested resource could not be found"


# Update Movie: Invalid ID format
PATCH http://localhost:4000/v1/movies/abc
{
    "title": "Invalid ID Movie"
}

HTTP 404
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "the requested resource could not be found"


# Update Movie: Empty Body
PATCH http://localhost:4000/v1/movies/1

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "body must not be empty"


# Update Movie: Malformed JSON
PATCH http://localhost:4000/v1/movies/1
```
{"title": "Moana",}
```

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "body contains badly-formed JSON (at character 19)"


# Update Movie: Incorrect Type for year
PATCH http://localhost:4000/v1/movies/1
{
    "year": "two thousand twenty four"
}

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "body contains incorrect JSON type for field \"year\""


# Update Movie: Unknown key
PATCH http://localhost:4000/v1/movies/1
{
    "rating": 5
}

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "body contains unknown key \"rating\""


# Update Movie: Multiple JSON values
PATCH http://localhost:4000/v1/movies/1
```
{"title": "Moana"}{"title": "Moana 2"}
```

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "body must only contain a single JSON value"


# Update Movie: Too large body
PATCH http://localhost:4000/v1/movies/1
file,large_body.json;

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "body must not be larger than 1048576 bytes"


# Update Movie: Empty title
PATCH http://localhost:4000/v1/movies/1
{
    "title": ""
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.title" == "must be provided"


# Update Movie: Too Long Title
PATCH http://localhost:4000/v1/movies/1
{
    "title": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.title" == "must not be more than 500 bytes long"


# Update Movie: Year Before 1888
PATCH http://localhost:4000/v1/movies/1
{
    "year": 1887
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.year" == "must be greater than 1888"


# Update Movie: Year in Future
PATCH http://localhost:4000/v1/movies/1
{
    "year": 2027
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.year" == "must not be in the future"


# Update Movie: Zero Runtime
PATCH http://localhost:4000/v1/movies/1
{
    "runtime": "0 mins"
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.runtime" == "must be provided"


# Update Movie: Empty Genres
PATCH http://localhost:4000/v1/movies/1
{
    "genres": []
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.genres" == "must contain at least 1 genre"


# Update Movie: Too Many Genres
PATCH http://localhost:4000/v1/movies/1
{
    "genres": ["a", "b", "c", "d", "e", "f"]
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.genres" == "must not contain more than 5 genres"


# Update Movie: Zero Year
PATCH http://localhost:4000/v1/movies/1
{
    "year": 0
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.year" == "must be provided"


# Update Movie: Duplicate Genres
PATCH http://localhost:4000/v1/movies/1
{
    "genres": ["action", "action"]
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.genres" == "must not contain duplicate values"
