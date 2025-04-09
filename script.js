const sqlite3 = require("sqlite3").verbose();
const path = require('path');
const express = require('express');
const app = express();
const port = 3000;
let sql;

app.set('view engine', 'ejs');

app.set('views', path.join(__dirname, 'templates'));

app.use('/images', express.static(path.join(__dirname, 'images')));

const db = new sqlite3.Database("./LocalDB", sqlite3.OPEN_READWRITE, (err) => {
    if (err) return console.error(err.message);
});

function myFunction() {
    alert("Hello! I am an alert box!!");
}

app.get('/', (req, res) => {
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

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
      