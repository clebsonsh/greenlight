# Update Movie: Valid update (ID 1)
PUT http://localhost:4000/v1/movies/1
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


# Update Movie: Update another movie (ID 2)
PUT http://localhost:4000/v1/movies/2
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
PUT http://localhost:4000/v1/movies/999
{
    "title": "Non-existent Movie",
    "year": 2024,
    "runtime": "100 mins",
    "genres": ["action"]
}

HTTP 404
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "the requested resource could not be found"


# Update Movie: Invalid ID format
PUT http://localhost:4000/v1/movies/abc
{
    "title": "Invalid ID Movie",
    "year": 2024,
    "runtime": "100 mins",
    "genres": ["action"]
}

HTTP 404
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "the requested resource could not be found"


# Update Movie: Empty Body
PUT http://localhost:4000/v1/movies/1

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "body must not be empty"


# Update Movie: Malformed JSON
PUT http://localhost:4000/v1/movies/1
```
{"title": "Moana",}
```

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "body contains badly-formed JSON (at character 19)"


# Update Movie: Incorrect Type for year
PUT http://localhost:4000/v1/movies/1
{
    "title": "Moana",
    "year": "two thousand twenty four"
}

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "body contains incorrect JSON type for field \"year\""


# Update Movie: Unknown key
PUT http://localhost:4000/v1/movies/1
{
    "title": "Moana",
    "rating": 5
}

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "body contains unknown key \"rating\""


# Update Movie: Multiple JSON values
PUT http://localhost:4000/v1/movies/1
```
{"title": "Moana"}{"title": "Moana 2"}
```

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "body must only contain a single JSON value"


# Update Movie: Too large body
PUT http://localhost:4000/v1/movies/1
file,large_body.json;

HTTP 400
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error" == "body must not be larger than 1048576 bytes"


# Update Movie: Missing Title
PUT http://localhost:4000/v1/movies/1
{
    "year": 2024,
    "runtime": "100 mins",
    "genres": ["action"]
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.title" == "must be provided"


# Update Movie: Too Long Title
PUT http://localhost:4000/v1/movies/1
{
    "title": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc, quis gravida magna mi a libero. Fusce vulputate eleifend sapien. Vestibulum purus quam, scelerisque ut, mollis sed, nonummy id, metus. Nullam accumsan lorem in dui. Cras ultricies mi eu turpis hendrerit fringilla. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; In ac dui quis mi consectetuer lacinia. Nam pretium turpis et arcu. Duis arcu tortor, suscipit eget, imperdiet nec, imperdiet iaculis, ipsum. Sed aliquam ultrices mauris. Integer ante arcu, accumsan a, consectetuer eget, posuere ut, mauris. Praesent adipiscing. Phasellus ullamcorper ipsum rutrum nunc. Nunc nonummy metus. Sed tincidunt. Sed vel lectus. Donec odio tempus molestie, porttitor ut, iaculis quis, sem. Phasellus rhoncus. Aenean id metus id velit ullamcorper pulvinar. Vestibulum fermentum tortor id mi. Pellentesque ipsum. Nulla non arcu lacinia neque faucibus fringilla. Nulla non lectus sed nisl molestie malesuada. Proin in tellus sit amet nibh dignissim sagittis. Vivamus luctus egestas leo. Maecenas sollicitudin. Nullam rhoncus aliquam metus. Etiam egestas wisi a erat. Morbi imperdiet, mauris ac auctor dictum, nisl ligula egestas nulla, et sollicitudin sem purus in lacus. Maecenas libero neque, congue vel, consequat eget, tempor nec, sem. Fusce tellus odio, dapibus id fermentum quis, suscipit id erat. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Proin pharetra nonummy pede. Mauris et orci. Aenean nec lorem. In porttitor. Donec laoreet nonummy augue. Suspendisse dui purus, scelerisque at, vulputate vitae, pretium mattis, nunc. Mauris eget neque at sem venenatis eleifend. Ut nonummy. Fusce aliquet pede non pede. Suspendisse dapibus lorem pellentesque magna. Integer nulla. Donec blandit feugiat ligula. Donec hendrerit, felis et imperdiet euismod, purus ipsum pretium metus, in lacinia nulla nisl eget sapien. Donec ut est in lectus consequat consequat. Etiam eget dui. Aliquam erat volutpat. Sed at lorem in nunc porta tristique. Proin nec augue. Quisque aliquam tempor magna. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nunc ac magna. Maecenas odio dolor, vulputate vel, auctor ac, accumsan id, felis. Pellentesque cursus sagittis felis. Pellentesque porttitor, velit lacinia egestas auctor, diam eros tempus arcu, nec vulputate augue magna vel risus. Cras non magna vel ante adipiscing euismod. Nullam a lacus. Nulla facilisi. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Morbi accumsan ipsum velit. Nam nec tellus a odio tincidunt auctor a ornare odio. Sed non mauris vitae erat consequat auctor eu in elit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Mauris in erat justo. Nullam ac urna eu felis dapibus condimentum sit amet a augue. Sed non neque elit. Sed ut imperdiet nisi. Proin condimentum fermentum nunc. Etiam pharetra, erat sed fermentum feugiat, velit mauris egestas quam, ut aliquam massa nisl quis neque. Suspendisse in orci enim.",
    "year": 2024,
    "runtime": "100 mins",
    "genres": ["action"]
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.title" == "must not be more than 500 bytes long"


# Update Movie: Missing Year
PUT http://localhost:4000/v1/movies/1
{
    "title": "Moana",
    "runtime": "100 mins",
    "genres": ["action"]
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.year" == "must be provided"


# Update Movie: Year Before 1888
PUT http://localhost:4000/v1/movies/1
{
    "title": "Moana",
    "year": 1887,
    "runtime": "100 mins",
    "genres": ["action"]
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.year" == "must be greater than 1888"


# Update Movie: Year in Future
PUT http://localhost:4000/v1/movies/1
{
    "title": "Moana",
    "year": 2027,
    "runtime": "100 mins",
    "genres": ["action"]
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.year" == "must not be in the future"


# Update Movie: Missing Runtime
PUT http://localhost:4000/v1/movies/1
{
    "title": "Moana",
    "year": 2024,
    "genres": ["action"]
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.runtime" == "must be provided"


# Update Movie: Zero Runtime
PUT http://localhost:4000/v1/movies/1
{
    "title": "Moana",
    "year": 2024,
    "runtime": "0 mins",
    "genres": ["action"]
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.runtime" == "must be provided"


# Update Movie: Missing Genres
PUT http://localhost:4000/v1/movies/1
{
    "title": "Moana",
    "year": 2024,
    "runtime": "100 mins"
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.genres" == "must be provided"


# Update Movie: Empty Genres
PUT http://localhost:4000/v1/movies/1
{
    "title": "Moana",
    "year": 2024,
    "runtime": "100 mins",
    "genres": []
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.genres" == "must contain at least 1 genre"


# Update Movie: Too Many Genres
PUT http://localhost:4000/v1/movies/1
{
    "title": "Moana",
    "year": 2024,
    "runtime": "100 mins",
    "genres": ["a", "b", "c", "d", "e", "f"]
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.genres" == "must not contain more than 5 genres"


# Update Movie: Duplicate Genres
PUT http://localhost:4000/v1/movies/1
{
    "title": "Moana",
    "year": 2024,
    "runtime": "100 mins",
    "genres": ["action", "action"]
}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.genres" == "must not contain duplicate values"
