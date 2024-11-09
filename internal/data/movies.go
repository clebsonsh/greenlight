package data

import "time"

type Movie struct {
	CreatedAt time.Time `json:"id"`
	Title     string    `json:"created_at"`
	Genres    []string  `json:"title"`
	ID        int64     `json:"year"`
	Year      int32     `json:"runtime"`
	Runtime   int32     `json:"genres"`
	Version   int32     `json:"version"`
}
