const express = require("express");
const bodyParser = require("body-parser");

const router = require("./router");

const app = express()
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: true }))

router(app);


//for dev, 3000 is a common choice
app.listen(3001, '0.0.0.0', () => {
    console.log("Server started at port 3001");
})