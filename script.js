const sqlite3 = require("sqlite3").verbose();
const path = require('path');
const express = require('express');
const expressLayouts = require('express-ejs-layouts');
const app = express();
const port = 3000;

app.set('view engine', 'ejs');

app.set('views', path.join(__dirname, 'templates'));

app.set('view engine', 'ejs');
app.use(expressLayouts);
app.set('layout', 'layout');

app.use('/images', express.static(path.join(__dirname, 'images')));
app.use(express.static(path.join(__dirname, 'public')));

const db = new sqlite3.Database("./LocalDB", sqlite3.OPEN_READWRITE, (err) => {
    if (err) return console.error(err.message);
});

app.get('/shop', (req, res) => {
    db.all('SELECT * FROM product', (err, products) => {
      if (err) {
        res.status(500).send('Database error');
        return;
      }
      res.render('shop', { products });
    });
  });

  app.get('/product/:productName', (req, res) => {
    const productName = req.params.productName;
    db.get('SELECT * FROM product WHERE productName = ?', [productName], (err, product) => {
      if (err) {
        res.status(500).send('Database error');
        return;
      }
      if (!product) {
        res.status(404).send('Product not found');
        return;
      }
      res.render('product', { product });
    });
});

app.get('/cart', (req, res) => {
  const userId = req.session.userId;

    db.all(`SELECT cartItems.*, products.ProductName, products.Price
        FROM cartItems
        JOIN products ON cartItems.productId = products.productId
        WHERE cartItems.userId = ?`, [userId]);

    res.render('cart', { cartItems });
});

// router.post('/cart/:id/complete', (req, res) => {
//   const cartId = req.params.id;

//   const sql = `UPDATE Cart SET CartStatus = 1 WHERE CartID = ?`;

//   db.run(sql, [cartId], function (err) {
//       if (err) {
//           console.error(err.message);
//           return res.status(500).send("Database error");
//       }

//       console.log(`Cart ${cartId} marked as purchased`);
//       res.redirect('/cart'); // or wherever you want to send the user next
//   });
// });

app.use(express.urlencoded({ extended: true })); // to support form parsing

app.post('/cart/add', async (req, res) => {
  const userId = req.session.userId;
  const { productId, quantity } = req.body;

  if (!userId) {
    return res.status(401).send('Please log in to add items to cart.');
  }

  // Step 1: Find or create a cart for the user
  db.get('SELECT cartId FROM carts WHERE userId = ?', [userId], (err, cart) => {
    if (err) return res.status(500).send('Database error.');

    const addToCart = (cartId) => {
      // Step 2: Insert the item into the cartItems table
      const insertItem = `
        INSERT INTO cartItems (cartId, productId, quantity)
        VALUES (?, ?, ?)
      `;
      db.run(insertItem, [cartId, productId, quantity], function (err) {
        if (err) return res.status(500).send('Error adding item to cart');
        res.redirect('/cart');
      });
    };

    if (cart) {
      // Cart exists
      addToCart(cart.cartId);
    } else {
      // Create a new cart
      const insertCart = `INSERT INTO carts (userId, createdAt) VALUES (?, datetime('now'))`;
      db.run(insertCart, [userId], function (err) {
        if (err) return res.status(500).send('Error creating cart');
        addToCart(this.lastID); // lastID = new cartId
      });
    }
  });
});


app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
