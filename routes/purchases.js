const express = require("express");
const router = express.Router();
const authChecks = require("../authChecks.js");
const flash = require("express-flash");
const connection = require("../database.js");
const queries = require("../queries/purchasesQueries.js");
const queriesItems = require("../queries/purchaseItemsQueries.js");
const { ROLE } = require("../roles.js");
var htmlEncode = require("js-htmlencode").htmlEncode;

router.get("/purchases", (req, res) => {
  queries.getPurchases((data) => res.json(data));
});

router.get(
  //TODO - add html render
  "/purchases/add",
  authChecks.checkAuthenticated,
  authChecks.authRole(ROLE.ADMIN),
  async (req, res) => {
    res.render("addUser.ejs");
  }
);

router.get(
  "/purchases/:id",
  //authChecks.checkAuthenticated,
  //authChecks.authRole(ROLE.ADMIN),
  (req, res) => {
    queries.getPurchaseById(req.params.id, (error, data) => {
      if (error) {
        res.json(error);
      } else if (data == null) {
        res.writeHead("404");
        res.write(JSON.stringify({ error: "Purchase not found" }));
      } else {
        res.writeHead("200");
        res.write(JSON.stringify(data));
      }
      res.send();
    });
  }
);

router.delete(
  "/purchases/:id",
  //authChecks.checkAuthenticated,
  //authChecks.authRole(ROLE.ADMIN),
  (req, res) => {
    queries.deletePurchaseById(req.params.id, (error, results, fields) => {
      if (error) {
        res.writeHead(500);
        res.write(
          JSON.stringify({ error: "Purchase not found or has dependency" })
        );
      } else {
        res.writeHead(200);
        res.write(JSON.stringify({ success: "Purchase deleted" }));
      }
      res.send();
    });
  }
);

router.put(
  "/purchases/:id",
  //authChecks.checkAuthenticated,
  //authChecks.authRole(ROLE.ADMIN),
  async (req, res) => {
    var body = req.body;
    if (undefinedAndCheck(body.korisnicki_racun, body.stanje_id)) {
      res.json({ error: "Wrong params" });
      return;
    }
    let purchase = {};
    purchase.id = req.params.id;
    req.body.korisnicki_racun !== null
      ? (purchase.korisnicki_racun = htmlEncode(req.body.korisnicki_racun))
      : (purchase.korisnicki_racun = req.body.korisnicki_racun);

    req.body.stanje_id !== null
      ? (purchase.stanje_id = htmlEncode(req.body.stanje_id))
      : (purchase.stanje_id = req.body.stanje_id);
    queries.updatePurchaseById(purchase, (error, data) => {
      if (error) {
        res.writeHead("404");
        res.write(JSON.stringify({ error: "User or condition not found!" }));
      } else if (data == undefined || data == null) {
        res.writeHead("404");
        res.write(JSON.stringify({ error: "Purchase not found" }));
      } else {
        res.writeHead("200");
        res.write(JSON.stringify(data));
      }
      res.send();
    });
  }
);

router.post("/purchases", async (req, res) => {
  var body = req.body;
  let user;
  if (req.body.apy_key === process.env.API_KEY) {
    user = body.korisnicki_racun;
  } else {
    user = req.user.id;
  }
  if (undefinedOrCheck(body.korisnicki_racun, user)) {
    res.json({ error: "Wrong params" });
    return;
  }
  body.purchaseItems.forEach((element) => {
    if (undefinedOrCheck(element.quantity, element.itemId)) {
      res.json({ error: "Wrong params" });
      return;
    }
  });
  let purchase = {};
  user !== null
    ? (purchase.korisnicki_racun = htmlEncode(user))
    : (purchase.korisnicki_racun = user);

  body.stanje_id !== null
    ? (purchase.stanje_id = htmlEncode(body.stanje_id))
    : (purchase.stanje_id = body.stanje_id);

  purchase.purchaseItems = body.purchaseItems;
  queries.addPurchase(purchase, function (error, results, fields) {
    if (error) {
      res.writeHead(404);
      res.write(JSON.stringify({ error: "User or condition not found!" }));
      res.send();
    } else {
      let done = true;
      purchase.purchaseItems.forEach((element) => {
        queriesItems.addPurchaseItems(
          results.insertId,
          element.itemId,
          element.quantity,
          (error, data) => {
            if (error) {
              done = false;
              res.json(error);
              return;
            }
          }
        );
      });
      if (done) {
        queries.getPurchaseById(results.insertId, (error, data) => {
          if (data == null) {
            res.writeHead("404");
            res.write(JSON.stringify({ error: "Purchase not found" }));
          } else {
            res.writeHead("200");
            res.write(JSON.stringify(data));
          }
          res.send();
        });
      }
    }
  });
});

router.all(
  ["/purchases/:id/items", "/purchases/:id/items*"],
  //authChecks.checkAuthenticated,
  //authChecks.authRole(ROLE.ADMIN),
  require("./purchaseItems")
);

module.exports = router;

function undefinedOrCheck(...params) {
  for (param of params) {
    if (param === undefined) {
      return true;
    }
  }
  return false;
}

function undefinedAndCheck(...params) {
  for (param of params) {
    if (param !== undefined) {
      return false;
    }
  }
  return true;
}
