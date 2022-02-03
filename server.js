const express = require('express')
const app = express()
const port = 3000
const fs = require('fs')

app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.get('/cv', (req, res) => {
    var file = fs.createReadStream('./cv.pdf');
    var stat = fs.statSync('./cv.pdf');
    res.setHeader('Content-Length', stat.size);
    res.setHeader('Content-Type', 'application/pdf');
    file.pipe(res);
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})