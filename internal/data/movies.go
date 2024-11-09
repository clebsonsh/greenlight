package data

import "time"

type Movie struct {
	CreatedAt time.Time
	Title     string
	Genres    []string
	ID        int64
	Year      int32
	Runtime   int32
	Version   int32
}
