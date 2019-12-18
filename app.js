const express = require("express")
const hbs = require("hbs")
// importieren des MySQL-Modules:
const mysql = require("mysql")
const Cookies = require("cookies")
const app = express()

hbs.registerPartials(__dirname + "/views/components")
app.set("view engine", "hbs")
app.set("views", __dirname + "/views")

let cookies

// damit man aus dem partial auf die anzahl der Produkte im Warenkorb zugreifen kann
// ohne, dass man für jede unterseite als parameter übergeben muss
hbs.registerHelper("warenkorb_anzahl", function() {
	var WarenkorbStr = cookies.get("Warenkorb")
	if (WarenkorbStr) {
		let WarenkorbArr = Array.from(WarenkorbStr.split(","))

		for (let i = 0; i < WarenkorbArr.length; i++) {
			WarenkorbArr[i] = parseInt(WarenkorbArr[i])
		}
		let anzahl = WarenkorbArr.length
		return anzahl
	} else {
		return 0
	}
})
// Erstellen einer Verbindung zur Datenbank
var con = mysql.createConnection({
	host: "localhost",
	user: "root",
	password: "",
	database: "weebay"
})

app.use("/static", express.static("./static"))

con.connect(function(err) {
	if (err) throw err

	app.get("/", (req, res) => {
		cookies = new Cookies(req, res)
		con.query("SELECT * FROM `artikel` ORDER BY RAND() LIMIT 3", function(
			err,
			result,
			fields
		) {
			if (err) throw err
			console.log(result)
			// einzelnen eintrag ausgeben: ("Name" und "address" vom ersten Eintrag der Tabelle)

			res.render("index", {
				titletag: "startseite"
			})
		})
	})

	app.get("/search", (req, res) => {
		cookies = new Cookies(req, res)
		// Speichern des URL-Parameters mit dem Namen
		// "suchbegriff" in der Variable "suchbegriff"
		let suchbegriff = req.query.suchbegriff
		let suchergebnisse = []
		console.log(suchbegriff)
		con.query(
			"SELECT * FROM artikel where bennenung LIKE" +
				"'" +
				suchbegriff +
				"%" +
				"';",

			function(err, result, fields) {
				if (err) console.log("fehler:", err)
				res.render("search", {
					titletag: "Suchergebnisse",
					suchbegriff: suchbegriff,
					suchergebnisse: result
				})
			}
		)
	})

	app.get("/kategorie", (req, res) => {
		cookies = new Cookies(req, res)
		console.log(req.query.kategorie)
		con.query(
			"SELECT * FROM artikel where bennenung LIKE" +
				"'" +
				suchbegriff +
				"%" +
				"';",

			function(err, result, fields) {
				if (err) throw err
				/*for (let i = 0; i < result.length; i++) {
					console.log(result[i].bennenung)
				}*/

				// einzelnen eintrag ausgeben: ("Name" und "address" vom ersten Eintrag der Tabelle)

				res.render("search", {
					titletag: "suchergebnisse",
					suchbegriff: suchbegriff,
					suchergebnisse: result
				})
			}
		)
		res.render("kategorie")
	})

	app.get("/warenkorb-hinzu", (req, res) => {
		cookies = new Cookies(req, res)

		// Zeitraum in MS, nachdem die Cookies auslaufen sollen
		let ExpDate = 9999999999

		var WarenkorbCookie = cookies.get("Warenkorb")

		if (WarenkorbCookie) {
			var WarenkorbStr = cookies.get("Warenkorb")
			let WarenkorbArr = Array.from(WarenkorbStr.split(","))

			for (let i = 0; i < WarenkorbArr.length; i++) {
				WarenkorbArr[i] = parseInt(WarenkorbArr[i])
			}

			WarenkorbArr.push(parseInt(req.query.produkt))

			// WarenkorbArr wieder in String verwandeln:
			WarenkorbArr = JSON.stringify(WarenkorbArr)
			WarenkorbArr = WarenkorbArr.replace("[", "")
			WarenkorbArr = WarenkorbArr.replace("]", "")

			cookies.set("Warenkorb", WarenkorbArr, {
				maxAge: ExpDate
			})
		} else {
			let WarenkorbArr = [parseInt(req.query.produkt)]
			WarenkorbArr = JSON.stringify(WarenkorbArr)
			WarenkorbArr = WarenkorbArr.replace("[", "")
			WarenkorbArr = WarenkorbArr.replace("]", "")

			cookies.set("Warenkorb", WarenkorbArr, {
				maxAge: ExpDate
			})
		}
		res.redirect("back")
	})

	app.get("/warenkorb", (req, res) => {
		cookies = new Cookies(req, res)
		// cookies kriegen und dann in die SQL query
		var WarenkorbCookie = cookies.get("Warenkorb")

		let WarenkorbArrBennenung = []
		let WarenkorbArrPreis = []

		//console.log(cookies.get("Warenkorb"))
		if (!WarenkorbCookie) {
			res.render("warenkorb")
		} else {
			con.query(
				"SELECT * FROM artikel where nummer_artikel in (" +
					WarenkorbCookie +
					");",

				function(err, result, fields) {
					if (err) throw err

					for (let i = 0; i < result.length; i++) {
						WarenkorbArrBennenung.push(result[i].bennenung)
					}
					console.log(WarenkorbArrBennenung)

					res.render("warenkorb", {
						titletag: "suchergebnisse",
						inhalt: result
					})
				}
			)
		}
	})
})

app.listen(8080)
