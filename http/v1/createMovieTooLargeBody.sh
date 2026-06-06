printf '{"title": "%01048576d"}' 0 | curl -i -d @- localhost:4000/v1/movies
