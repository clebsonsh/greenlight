# List Movies: All movies (no filters)
GET http://localhost:4000/v1/movies
Authorization: Bearer {{auth_token}}

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movies" exists
jsonpath "$.movies" count >= 4
jsonpath "$.metadata" exists
jsonpath "$.metadata.current_page" == 1
jsonpath "$.metadata.page_size" == 20
jsonpath "$.metadata.first_page" == 1
jsonpath "$.metadata.total_records" >= 4


# List Movies: Filter by title (search for "Moana")
GET http://localhost:4000/v1/movies?title=Moana
Authorization: Bearer {{auth_token}}

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movies" count == 1
jsonpath "$.movies[0].title" == "Moana"
jsonpath "$.metadata.total_records" == 1


# List Movies: Filter by title (search for "Black")
GET http://localhost:4000/v1/movies?title=Black
Authorization: Bearer {{auth_token}}

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movies" count == 1
jsonpath "$.movies[0].title" == "Black Panther"
jsonpath "$.metadata.total_records" == 1


# List Movies: Filter by single genre (animation)
GET http://localhost:4000/v1/movies?genres=animation
Authorization: Bearer {{auth_token}}

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movies" count >= 1
jsonpath "$.movies[0].genres" contains "animation"


# List Movies: Filter by single genre (action)
GET http://localhost:4000/v1/movies?genres=action
Authorization: Bearer {{auth_token}}

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movies" count >= 2
jsonpath "$.metadata.total_records" >= 2


# List Movies: Filter by multiple genres (action,adventure) - movies must contain ALL genres
GET http://localhost:4000/v1/movies?genres=action,adventure
Authorization: Bearer {{auth_token}}

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movies" count == 1
jsonpath "$.movies[0].title" == "Black Panther"
jsonpath "$.movies[0].genres" contains "action"
jsonpath "$.movies[0].genres" contains "adventure"


# List Movies: Filter by genre with no matches
GET http://localhost:4000/v1/movies?genres=horror
Authorization: Bearer {{auth_token}}

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movies" count == 0
jsonpath "$.metadata" exists


# List Movies: Sort by title ascending
GET http://localhost:4000/v1/movies?sort=title
Authorization: Bearer {{auth_token}}

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movies[0].title" == "Black Panther"


# List Movies: Sort by title descending
GET http://localhost:4000/v1/movies?sort=-title
Authorization: Bearer {{auth_token}}

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movies[0].title" == "The Breakfast Club"


# List Movies: Sort by year ascending
GET http://localhost:4000/v1/movies?sort=year
Authorization: Bearer {{auth_token}}

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movies[0].year" == 1986


# List Movies: Sort by year descending
GET http://localhost:4000/v1/movies?sort=-year
Authorization: Bearer {{auth_token}}

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movies[0].year" == 2018


# List Movies: Pagination - page 1 with page_size 2
GET http://localhost:4000/v1/movies?page=1&page_size=2
Authorization: Bearer {{auth_token}}

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movies" count == 2
jsonpath "$.metadata.current_page" == 1
jsonpath "$.metadata.page_size" == 2
jsonpath "$.metadata.total_records" >= 4
jsonpath "$.metadata.last_page" >= 2


# List Movies: Pagination - page 2 with page_size 2
GET http://localhost:4000/v1/movies?page=2&page_size=2
Authorization: Bearer {{auth_token}}

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movies" count == 2
jsonpath "$.metadata.current_page" == 2
jsonpath "$.metadata.page_size" == 2


# List Movies: Pagination - last page
GET http://localhost:4000/v1/movies?page=3&page_size=2
Authorization: Bearer {{auth_token}}

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movies" count >= 0


# List Movies: Combined filters - title and genres
GET http://localhost:4000/v1/movies?title=Black&genres=action
Authorization: Bearer {{auth_token}}

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movies" count == 1
jsonpath "$.movies[0].title" == "Black Panther"


# List Movies: Combined filters - title and sort
GET http://localhost:4000/v1/movies?title=Deadpool&sort=-year
Authorization: Bearer {{auth_token}}

HTTP 200
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.movies" count == 1
jsonpath "$.movies[0].title" == "Deadpool"


# List Movies: Invalid page (zero)
GET http://localhost:4000/v1/movies?page=0
Authorization: Bearer {{auth_token}}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.page" == "must be greater than zero"


# List Movies: Invalid page (negative)
GET http://localhost:4000/v1/movies?page=-1
Authorization: Bearer {{auth_token}}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.page" == "must be greater than zero"


# List Movies: Invalid page_size (zero)
GET http://localhost:4000/v1/movies?page_size=0
Authorization: Bearer {{auth_token}}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.page_size" == "must be greater than zero"


# List Movies: Invalid page_size (negative)
GET http://localhost:4000/v1/movies?page_size=-5
Authorization: Bearer {{auth_token}}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.page_size" == "must be greater than zero"


# List Movies: Invalid page_size (too large)
GET http://localhost:4000/v1/movies?page_size=101
Authorization: Bearer {{auth_token}}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.page_size" == "must be a maximum of 100"


# List Movies: Invalid sort value
GET http://localhost:4000/v1/movies?sort=invalid_field
Authorization: Bearer {{auth_token}}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.sort" == "invalid sort value"


# List Movies: Invalid sort value (genres not in safe list)
GET http://localhost:4000/v1/movies?sort=genres
Authorization: Bearer {{auth_token}}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.sort" == "invalid sort value"


# List Movies: Multiple validation errors
GET http://localhost:4000/v1/movies?page=0&page_size=0&sort=invalid
Authorization: Bearer {{auth_token}}

HTTP 422
[Asserts]
header "Content-Type" == "application/json"
jsonpath "$.error.page" == "must be greater than zero"
jsonpath "$.error.page_size" == "must be greater than zero"
jsonpath "$.error.sort" == "invalid sort value"
