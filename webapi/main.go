package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

type whoami struct {
	Name    string
	Title   string
	State   string
	Team    string
	Members string
}

func main() {
	request1()
}

func whoAmI(response http.ResponseWriter, r *http.Request) {
	who := []whoami{
		whoami{Name: "Efrei Paris",
			Title:   "DevOps and Continous Deployment",
			State:   "FR",
			Team:    "BCFF",
			Members: "Charlotte BIGARE, Antoine CRAIPEAU, Romain FOUCHER, Léo FOULLOY",
		},
	}

	json.NewEncoder(response).Encode(who)

	fmt.Println("Endpoint Hit", who)
}

func error(response http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(response, "Error. This is an error endpoint for testing purposes.")
	fmt.Println("Endpoint Hit: error")
}

func homePage(response http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(response, "Welcome to the Web API!")
	fmt.Println("Endpoint Hit: homePage")
}

func aboutMe(response http.ResponseWriter, r *http.Request) {
	who := "EfreiParis"

	fmt.Fprintf(response, "A little bit about me...")
	fmt.Println("Endpoint Hit: ", who)
}

func request1() {
	http.HandleFunc("/", homePage)
	http.HandleFunc("/aboutme", aboutMe)
	http.HandleFunc("/whoami", whoAmI)
	http.HandleFunc("/error", whoAmI)

	log.Fatal(http.ListenAndServe(":8080", nil))
}
