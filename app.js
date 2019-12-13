const express = require("express")
const hbs = require("hbs")
const mysql = require("mysql")
const Cookies = require("cookies")
const app = express()

hbs.registerPartials(__dirname + "/views/components")
app.set("view engine", "hbs")
app.set("views", __dirname + "/views")

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
		let suchbegriff = req.query.search
		let suchergebnisse = []
		console.log(suchbegriff)
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
	})

	app.get("/kategorie", (req, res) => {
		console.log(req.query.kategorie)
		res.render("kategorie")
	})

	app.get("/warenkorb-hinzu", (req, res) => {
		var keys = ["some stuff"]
		// Zeitraum in MS, nachdem die Cookies auslaufen sollen
		let ExpDate = 9999999999
		var cookies = new Cookies(req, res, { keys: keys })
		var WarenkorbCookie = cookies.get("Warenkorb", { signed: true })

		if (WarenkorbCookie) {
			var WarenkorbStr = cookies.get("Warenkorb", { signed: true })
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
				signed: true,
				maxAge: ExpDate
			})
		} else {
			let WarenkorbArr = [parseInt(req.query.produkt)]
			WarenkorbArr = JSON.stringify(WarenkorbArr)
			WarenkorbArr = WarenkorbArr.replace("[", "")
			WarenkorbArr = WarenkorbArr.replace("]", "")

			cookies.set("Warenkorb", WarenkorbArr, {
				signed: true,
				maxAge: ExpDate
			})
		}
		res.redirect("back")
	})

	app.get("/warenkorb", (req, res) => {
		var keys = ["some stuff"]
		var cookies = new Cookies(req, res, { keys: keys })
		// Get a cookie
		var WarenkorbCookie = cookies.get("Warenkorb", { signed: true })

		//console.log(cookies.get("Warenkorb"))
		if (!WarenkorbCookie) {
			res.render("warenkorb")
		} else {
			res.render("warenkorb", {
				inhalt: WarenkorbCookie
			})
		}
	})
})

app.listen(8080)
