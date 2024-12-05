const http = require("node:http");

const PORT = 4444;

const MIME_TYPES = {
  default: "application/octet-stream",
  html: "text/html; charset=UTF-8",
  js: "application/javascript",
};

http
  .createServer(async (req, res) => {
    // we serve the same resource regardless of the called url
    // /external-scripts/head, /external-scripts/body-top or /external-scripts/body-bottom

    res.writeHead(200, { "Content-Type": MIME_TYPES.js });
    res.write(new Date().toISOString());
    res.end();
    console.log(`${req.method} ${req.url} 200`);
  })
  .listen(PORT);

console.log(`Mock ESI tags server running at http://localhost:${PORT}/`);
