package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"os"
	"io"
	"math/rand/v2"
	"net/http"
	"net/url"
)

type Bird struct {
	Name        string
	Description string
	Image       string
}

func defaultBird(err error) Bird {
	return Bird{
		Name:        "Bird in disguise",
		Description: fmt.Sprintf("This bird is in disguise because: %s", err),
		Image:       "https://www.pokemonmillennium.net/wp-content/uploads/2015/11/missingno.png",
	}
}

//function added to get default value for the BIRDIMAGE_API environment variable if id does not exist
func GetEnvDefault(key, defVal string) string {
	api, isExist := os.LookupEnv(key)
	if !isExist {
	  return defVal
	}
	return api
}

func getBirdImage(birdName string) (string, error) {
	api := GetEnvDefault("BIRDIMAGE_API", "http://localhost:4200")

	res, err := http.Get(fmt.Sprintf("%s?birdName=%s", api, url.QueryEscape(birdName)))
    if err != nil {
        return "", err
    }
    body, err := io.ReadAll(res.Body)
    return string(body), err
}

func getBirdFactoid() Bird {
	res, err := http.Get(fmt.Sprintf("%s%d", "https://freetestapi.com/api/v1/birds/", rand.IntN(50)))
	if err != nil {
		fmt.Printf("Error reading bird API: %s\n", err)
		return defaultBird(err)
	}
	body, err := io.ReadAll(res.Body)
	if err != nil {
		fmt.Printf("Error parsing bird API response: %s\n", err)
		return defaultBird(err)
	}
	var bird Bird
	err = json.Unmarshal(body, &bird)
	if err != nil {
		fmt.Printf("Error unmarshalling bird: %s", err)
		return defaultBird(err)
	}
    birdImage, err := getBirdImage(bird.Name)
    if err != nil {
        fmt.Printf("Error in getting bird image: %s\n", err)
        return defaultBird(err)
    }
    bird.Image = birdImage
	return bird
}

func bird(w http.ResponseWriter, r *http.Request) {
	var buffer bytes.Buffer
	json.NewEncoder(&buffer).Encode(getBirdFactoid())
	io.WriteString(w, buffer.String())
}

func main() {
	http.HandleFunc("/", bird)
	http.ListenAndServe(":4201", nil)
}
