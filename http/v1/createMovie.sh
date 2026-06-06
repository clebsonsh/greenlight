BODY='{
    "title": "Moana",
    "year": 2016,
    "runtime": 107,
    "genres": [
        "animation",
        "adventure"
    ]
}'

curl -s -d "$BODY" localhost:4000/v1/movies

echo -e "-------------------"

BODY='{
    "title": "Inception",
    "year": 2010,
    "runtime": 148,
    "genres": [
        "action",
        "sci-fi",
        "thriller"
    ]
}'

curl -s -d "$BODY" localhost:4000/v1/movies

echo -e "-------------------"

BODY='{
    "title": "The Godfather",
    "year": 1972,
    "runtime": 175,
    "genres": [
        "crime",
        "drama"
    ]
}'

curl -s -d "$BODY" localhost:4000/v1/movies
