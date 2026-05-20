package main

import (
	"encoding/json"
	"errors"
	"maps"
	"net/http"
	"strconv"

	"github.com/julienschmidt/httprouter"
)

func (app *application) readIDParam(r *http.Request) (int64, error) {
	params := httprouter.ParamsFromContext(r.Context())
	id, err := strconv.ParseInt(params.ByName("id"), 10, 64)

	if err != nil || id < 1 {
		return 0, errors.New("invalid id parameter")
	}

	return id, nil
}

type envelope map[string]any

func (app *application) JsonResponse(w http.ResponseWriter, status int, data envelope, headers http.Header) error {
	response, err := json.Marshal(data)
	if err != nil {
		return err
	}

	maps.Copy(w.Header(), headers)
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	w.Write(response)

	return nil
}
