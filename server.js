if (process.env.NODE_ENV !== 'production') {
    require('dotenv').config();
}

const express = require('express');
const app = express();
const expressLayouts = require('express-ejs-layouts');
const bcrypt = require('bcrypt');
const passport = require('passport');
const flash = require('express-flash');
const session = require('express-session');
const methodOverride = require('method-override');
const helmet = require('helmet')
var htmlEncode = require('js-htmlencode').htmlEncode;
const https = require('https');
const fs = require('fs');

const initializePassport = require('./passport-config');
const authChecks = require('./authChecks.js');
const connection = require('./database.js');
const { ROLE } = require('./roles.js');
const queries = require('./queries.js');

initializePassport(
    passport,
    async function (email, callback) {
        console.log("email" + email);
        queries.getUsers(
            connection,
            function (data) {
                callback(
                    data.find(function (user) {
                        return user.email === email;
                    })
                )
            }
            //data => data.find(user => user.email == email)
        )
    },
    function (id, callback) {
        queries.getUserById(
            connection,
            id,
            callback
        )
    }
)

const options = {
    key: fs.readFileSync('key.pem'),
    cert: fs.readFileSync('cert.pem')
};


app.use(expressLayouts);
app.set('view engine', 'ejs');
app.set('layout', 'layouts/layout');
app.set('views', __dirname + '/views')
app.use(express.urlencoded({ extended: false }));
app.use(flash());
app.use(session({
    secret: process.env.SESSION_SECRET,
    resave: false,
    saveUninitialized: false
}));
app.use(passport.initialize());
app.use(passport.session());
app.use(methodOverride('_method'));
app.use(express.json());
app.use(helmet());
app.use(helmet.xssFilter())

app.all("/", authChecks.checkAuthenticated, require('./routes/index'));

app.all(["/login", "/login*"], authChecks.checkNotAuthenticated, require('./routes/login'));
app.all("/logout", authChecks.checkAuthenticated, require('./routes/login'));

app.all(["/register", "/register*"], authChecks.checkNotAuthenticated, require('./routes/register'));

app.all(
    ["/users", "/users*"],
    authChecks.checkAuthenticated,
    authChecks.authRole(ROLE.ADMIN),
    require('./routes/users')
);


//app.listen(process.env.PORT || 8000);
https.createServer(options, app).listen(8000);
console.log("Server started. Listening on port 8000.");
