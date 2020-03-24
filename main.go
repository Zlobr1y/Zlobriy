package main

import (
	"fmt"
	"html/template"
	"net/http"
)

type page struct {
	Title string
	Msg string
}

func index(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-type", "text/html")

	title := r.URL.Path[len("/"):]

	if title != "exec/" {
		t, _ := template.ParseFiles("index.html")
		t.Execute(w, &page{Title: "WTF!", Msg:"My awesome API"})
	} else {
			field := r.PostFormValue("field")
			if field == "ping"{
				fmt.Fprintf(w, "%s PONG, BLYAT'!", field)
			} else {
				fmt.Fprintf(w, "Your Banny wrote, %s", field)
			}

		}
}
func main() {
	http.HandleFunc("/", index)

	http.ListenAndServe(":8080", nil)
}
