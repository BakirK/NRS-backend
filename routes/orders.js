const express = require("express");
const router = express.Router();
const authChecks = require("../authChecks.js");
const flash = require("express-flash");
const connection = require("../database.js");
const queries = require("../queries/ordersQueries.js");
const { ROLE } = require("../roles.js");
var htmlEncode = require("js-htmlencode").htmlEncode;

router.get("/orders", (req, res) => {
  queries.getOrders((data) => res.json(data));
});

router.get(
  //TODO - add html render
  "/orders/add",
  authChecks.checkAuthenticated,
  authChecks.authRole(ROLE.ADMIN),
  async (req, res) => {
    res.render("addUser.ejs");
  }
);

router.get(
  "/orders/:id",
  //authChecks.checkAuthenticated,
  //authChecks.authRole(ROLE.ADMIN),
  (req, res) => {
    queries.getOrderById(req.params.id, (error, results) => {
      if (error) {
        res.writeHead("500");
        res.write(JSON.stringify({ error: "Server error" }));
        res.send();
      } else if (results[0] == null) {
        res.writeHead("404");
        res.write(JSON.stringify({ error: "Order not found" }));
        res.send();
      } else {
        console.log(JSON.stringify(results));
        res.json(results[0]);
      }
    });
  }
);

router.delete(
  "/orders/:id",
  //authChecks.checkAuthenticated,
  //authChecks.authRole(ROLE.ADMIN),
  (req, res) => {
    queries.deleteOrderById(req.params.id, (error, results, fields) => {
      if (error) {
        res.writeHead(500);
        res.write(JSON.stringify({ error: "Order not found" }));
        res.send();
      } else {
        res.json({ success: "Order deleted" });
      }
    });
  }
);

router.put(
  "/orders/:id",
  //authChecks.checkAuthenticated,
  //authChecks.authRole(ROLE.ADMIN),
  async (req, res) => {
    let order = {};

    order.id = req.params.id;
    if (req.body.korisnicki_racun !== undefined) {
      order.korisnicki_racun = htmlEncode(req.body.korisnicki_racun);
    }
    if (req.body.skladiste_id !== undefined) {
      order.skladiste_id = htmlEncode(req.body.skladiste_id);
    }
    if (req.body.datum_isporuke !== undefined) {
      if (req.body.datum_isporuke !== null) {
        order.datum_isporuke = htmlEncode(req.body.datum_isporuke);
      } else {
        order.datum_isporuke = req.body.datum_isporuke;
      }
    }

    queries.updateOrderById(order, (error, results) => {
      if (error) {
        res.writeHead("404");
        res.write(JSON.stringify({ error: "User or warehouse not found" }));
        res.send();
      } else if (results[0] == null) {
        res.writeHead("404");
        res.write(JSON.stringify({ error: "Order not found" }));
        res.send();
      } else {
        res.json(results[0]);
      }
    });
  }
);

router.post("/orders", async (req, res) => {
  try {
    let order = {};
    if (req.body.korisnicki_racun != undefined) {
      if (req.body.korisnicki_racun == null) {
        order.korisnicki_racun = req.body.korisnicki_racun;
      } else {
        order.korisnicki_racun = htmlEncode(req.body.korisnicki_racun);
      }
    }
    if (req.body.skladiste_id != undefined) {
      if (req.body.skladiste_id == null) {
        order.skladiste_id = req.body.skladiste_id;
      } else {
        order.skladiste_id = htmlEncode(req.body.skladiste_id);
      }
    }
    if (req.body.datum_isporuke != undefined) {
      if (req.body.datum_isporuke == null) {
        order.datum_isporuke = req.body.datum_isporuke;
      } else {
        order.datum_isporuke = htmlEncode(req.body.datum_isporuke);
      }
    }
    queries.addOrder(order, (error, results) => {
      if (error) {
        res.writeHead("404");
        res.write(JSON.stringify({ error: "User or warehouse not found!" }));
        res.send();
      } else if (results == null) {
        res.writeHead("404");
        res.write(JSON.stringify({ error: "Order not found" }));
        res.send();
      } else {
        res.json(results);
      }
    });
  } catch (error) {
    console.log(error);
    res.status(500).send();
  }
});

module.exports = router;