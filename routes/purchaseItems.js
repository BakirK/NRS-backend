const express = require("express");
const router = express.Router();
const authChecks = require("../authChecks.js");
const flash = require("express-flash");
const queries = require("../queries/purchaseItemsQueries.js");
const { ROLE } = require("../roles.js");
var htmlEncode = require("js-htmlencode").htmlEncode;

router.get("/purchases/:id/items", authChecks.checkPurchase, (req, res) => {
  queries.getPurchaseItemsById(req.params.id, (error, results) => {
    if (error) {
      res.json(error);
    } else {
      res.json(results);
    }
  });
});

router.post(
  "/purchases/:id/items/:itemId",
  authChecks.checkPurchase,
  (req, res) => {
    let purchaseId = req.params.id;
    let itemId = req.params.itemId;
    let quantity = parseInt(req.body.quantity);
    if (!quantity || !itemId || !purchaseId) {
      res.json({ error: "Invalid params." });
      return;
    }
    quantity = htmlEncode(quantity);
    queries.addPurchaseItems(purchaseId, itemId, quantity, function (
      error,
      results,
      fields
    ) {
      if (error) {
        if (error.error) {
          res.json(error);
        } else {
          res.json({
            error: "Purchase already has that item.",
          });
        }
      } else {
        res.json({ success: "Item added to purchase." });
      }
    });
  }
);

router.delete(
  "/purchases/:id/items/:itemId",
  authChecks.checkPurchase,
  (req, res) => {
    let purchaseId = req.params.id;
    let itemId = req.params.itemId;
    if (!itemId || !purchaseId) {
      res.json({ error: "Invalid params." });
      return;
    }
    queries.deletePurchaseItemById(purchaseId, itemId, function (
      error,
      results,
      fields
    ) {
      if (error) {
        res.json(error);
      } else {
        res.json({ success: "Purchase item deleted" });
      }
    });
  }
);

router.delete("/purchases/:id/items", authChecks.checkPurchase, (req, res) => {
  let purchaseId = req.params.id;
  if (!purchaseId) {
    res.json({ error: "Invalid params." });
    return;
  }
  queries.deleteAllPurchaseItemsById(purchaseId, function (
    error,
    results,
    fields
  ) {
    if (error) {
      res.json(error);
    } else {
      res.json({ success: "Purchase items deleted" });
    }
  });
});

router.put(
  "/purchases/:id/items/:itemId",
  authChecks.checkPurchase,
  (req, res) => {
    let purchaseId = parseInt(req.params.id);
    let itemId = parseInt(req.params.itemId);
    let quantity = parseInt(req.body.quantity);
    if (!quantity || !itemId || !purchaseId) {
      res.json({ error: "Invalid params." });
      return;
    }
    quantity = htmlEncode(quantity);
    queries.updatePurchaseItemsById(purchaseId, itemId, quantity, function (
      error,
      results,
      fields
    ) {
      if (error) {
        res.json(error);
      } else {
        res.json({ success: "Purchase item updated." });
      }
    });
  }
);

module.exports = router;
