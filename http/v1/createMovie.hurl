# Create Movie: Moana (Valid)
POST http://localhost:4000/v1/movies
{
    "title": "Moana",
    "year": 2016,
    "runtime": "107 mins",
    "genres": [
        "animation",
        "adventure"
    ]
}

HTTP 200
[Asserts]
header "Content-Type" == "text/plain; charset=utf-8"
body == "{Title:Moana Year:2016 Runtime:107 Genres:[animation adventure]}\n"


# Create Movie: Inception (Valid)
POST http://localhost:4000/v1/movies
{
    "title": "Inception",
    "year": 2010,
    "runtime": "148 mins",
    "genres": [
        "action",
        "sci-fi",
        "thriller"
    ]
}

HTTP 200
[Asserts]
header "Content-Type" == "text/plain; charset=utf-8"
body == "{Title:Inception Year:2010 Runtime:148 Genres:[action sci-fi thriller]}\n"


# Create Movie: The Godfather (Valid)
POST http://localhost:4000/v1/movies
{
    "title": "The Godfather",
    "year": 1972,
    "runtime": "175 mins",
    "genres": [
        "crime",
        "drama"
    ]
}

HTTP 200
[Asserts]
header "Content-Type" == "text/plain; charset=utf-8"
body == "{Title:The Godfather Year:1972 Runtime:175 Genres:[crime drama]}\n"


# Create Movie: Empty Body
POST http://localhost:4000/v1/movies

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "body must not be empty"


# Create Movie: Incorrect Type for year
POST http://localhost:4000/v1/movies
{
    "title": "Moana",
    "year": "two thousand and sixteen"
}

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "body contains incorrect JSON type for field \"year\""


# Create Movie: Malformed JSON syntax (trailing comma)
POST http://localhost:4000/v1/movies
```
{"title": "Moana",}
```

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "body contains badly-formed JSON (at character 19)"


# Create Movie: Malformed JSON top-level (array)
POST http://localhost:4000/v1/movies
```
[]
```

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "body contains badly-formed JSON (at character 1)"


# Create Movie: Malformed JSON unexpected EOF
POST http://localhost:4000/v1/movies
```
{"title": "Moana"
```

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "body contains badly-formed JSON"


# Create Movie: Multiple JSON values
POST http://localhost:4000/v1/movies
```
{"title": "Moana"}{"title": "Moana 2"}
```

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "body must only contain a single JSON value"


# Create Movie: Too large body (exceeds 1MB)
POST http://localhost:4000/v1/movies
file,large_body.json;

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "body must not be larger than 1048576 bytes"


# Create Movie: Unknown key in JSON
POST http://localhost:4000/v1/movies
{
    "title": "Moana",
    "rating": 5
}

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "body contains unknown key \"rating\""
