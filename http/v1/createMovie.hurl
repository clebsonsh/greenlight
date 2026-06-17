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

HTTP 201
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movie.title" == "Moana"
jsonpath "$.movie.year" == 2016
jsonpath "$.movie.runtime" == "107 mins"
jsonpath "$.movie.genres[0]" == "animation"
jsonpath "$.movie.genres[1]" == "adventure"
jsonpath "$.movie.id" exists
jsonpath "$.movie.version" exists


# Create Movie: Black Panther (Valid)
POST http://localhost:4000/v1/movies
{
    "title": "Black Panther",
    "year": 2018,
    "runtime": "134 mins",
    "genres": [
        "action",
        "adventure"
    ]
}

HTTP 201
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movie.title" == "Black Panther"
jsonpath "$.movie.year" == 2018
jsonpath "$.movie.runtime" == "134 mins"
jsonpath "$.movie.genres[0]" == "action"
jsonpath "$.movie.genres[1]" == "adventure"
jsonpath "$.movie.id" exists
jsonpath "$.movie.version" exists


# Create Movie: Deadpool (Valid)
POST http://localhost:4000/v1/movies
{
    "title": "Deadpool",
    "year": 2016,
    "runtime": "108 mins",
    "genres": [
        "action",
        "comedy"
    ]
}

HTTP 201
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movie.title" == "Deadpool"
jsonpath "$.movie.year" == 2016
jsonpath "$.movie.runtime" == "108 mins"
jsonpath "$.movie.genres[0]" == "action"
jsonpath "$.movie.genres[1]" == "comedy"
jsonpath "$.movie.id" exists
jsonpath "$.movie.version" exists


# Create Movie: The Breakfast Club (Valid)
POST http://localhost:4000/v1/movies
{
    "title": "The Breakfast Club",
    "year": 1986,
    "runtime": "96 mins",
    "genres": [
        "drama"
    ]
}

HTTP 201
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movie.title" == "The Breakfast Club"
jsonpath "$.movie.year" == 1986
jsonpath "$.movie.runtime" == "96 mins"
jsonpath "$.movie.genres[0]" == "drama"
jsonpath "$.movie.id" exists
jsonpath "$.movie.version" exists


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


# Create Movie: Missing Title
POST http://localhost:4000/v1/movies
{
    "year": 2016,
    "runtime": "107 mins",
    "genres": ["animation"]
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.title" == "must be provided"


# Create Movie: Too Long Title (> 500 characters)
POST http://localhost:4000/v1/movies
{
    "title": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc, quis gravida magna mi a libero. Fusce vulputate eleifend sapien. Vestibulum purus quam, scelerisque ut, mollis sed, nonummy id, metus. Nullam accumsan lorem in dui. Cras ultricies mi eu turpis hendrerit fringilla. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; In ac dui quis mi consectetuer lacinia. Nam pretium turpis et arcu. Duis arcu tortor, suscipit eget, imperdiet nec, imperdiet iaculis, ipsum. Sed aliquam ultrices mauris. Integer ante arcu, accumsan a, consectetuer eget, posuere ut, mauris. Praesent adipiscing. Phasellus ullamcorper ipsum rutrum nunc. Nunc nonummy metus. Vestibulum volutpat pretium libero. Cras id dui. Aenean ut",
    "year": 2016,
    "runtime": "107 mins",
    "genres": ["animation"]
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.title" == "must not be more than 500 bytes long"


# Create Movie: Missing Year
POST http://localhost:4000/v1/movies
{
    "title": "Moana",
    "runtime": "107 mins",
    "genres": ["animation"]
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.year" == "must be provided"


# Create Movie: Year Before 1888
POST http://localhost:4000/v1/movies
{
    "title": "Moana",
    "year": 1887,
    "runtime": "107 mins",
    "genres": ["animation"]
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.year" == "must be greater than 1888"


# Create Movie: Year in Future
POST http://localhost:4000/v1/movies
{
    "title": "Moana",
    "year": 2027,
    "runtime": "107 mins",
    "genres": ["animation"]
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.year" == "must not be in the future"


# Create Movie: Missing Runtime
POST http://localhost:4000/v1/movies
{
    "title": "Moana",
    "year": 2016,
    "genres": ["animation"]
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.runtime" == "must be provided"


# Create Movie: Zero Runtime
POST http://localhost:4000/v1/movies
{
    "title": "Moana",
    "year": 2016,
    "runtime": "0 mins",
    "genres": ["animation"]
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.runtime" == "must be provided"


# Create Movie: Missing Genres
POST http://localhost:4000/v1/movies
{
    "title": "Moana",
    "year": 2016,
    "runtime": "107 mins"
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.genres" == "must be provided"


# Create Movie: Empty Genres
POST http://localhost:4000/v1/movies
{
    "title": "Moana",
    "year": 2016,
    "runtime": "107 mins",
    "genres": []
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.genres" == "must contain at least 1 genre"


# Create Movie: Too Many Genres (> 5)
POST http://localhost:4000/v1/movies
{
    "title": "Moana",
    "year": 2016,
    "runtime": "107 mins",
    "genres": ["a", "b", "c", "d", "e", "f"]
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.genres" == "must not contain more than 5 genres"


# Create Movie: Duplicate Genres
POST http://localhost:4000/v1/movies
{
    "title": "Moana",
    "year": 2016,
    "runtime": "107 mins",
    "genres": ["animation", "animation"]
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.genres" == "must not contain duplicate values"

