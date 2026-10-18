#!/usr/bin/env node
/*
 * TerraPortal — one-click local launcher.
 *
 *   node serve.js            serve this folder and open the browser
 *   node serve.js --no-open  serve only, print the URL
 *   node serve.js 9000       serve on a specific port
 *
 * No dependencies: plain Node, about 120 lines. The page needs to be served over
 * http:// rather than opened as a file:// URL for one reason — some browsers
 * refuse to run <script> loads and WebP decoding from a file URL, and a local
 * server makes behaviour identical to the deployed site.
 */
'use strict';

const http = require('http');
const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');

const ROOT = __dirname;
const FIRST_PORT = Number(process.argv.find(a => /^\d+$/.test(a))) || 8731;
const NO_OPEN = process.argv.includes('--no-open');

const MIME = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'application/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.webp': 'image/webp',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon',
  '.md': 'text/markdown; charset=utf-8',
  '.txt': 'text/plain; charset=utf-8'
};

function send(res, code, body, type) {
  const buf = Buffer.isBuffer(body) ? body : Buffer.from(body);
  res.writeHead(code, {
    'Content-Type': type || 'text/plain; charset=utf-8',
    'Content-Length': buf.length,
    'Cache-Control': 'no-cache'
  });
  res.end(buf);
}

function handler(req, res) {
  let rel;
  try {
    rel = decodeURIComponent(new URL(req.url, 'http://localhost').pathname);
  } catch (e) {
    return send(res, 400, 'Bad request');
  }
  if (rel === '/' || rel === '') rel = '/index.html';

  // never serve outside this folder
  const full = path.join(ROOT, path.normalize(rel).replace(/^(\.\.[/\\])+/, ''));
  if (!full.startsWith(ROOT)) return send(res, 403, 'Forbidden');

  fs.stat(full, (err, st) => {
    if (err || !st.isFile()) {
      return send(res, 404, 'Not found: ' + rel);
    }
    const type = MIME[path.extname(full).toLowerCase()] || 'application/octet-stream';
    res.writeHead(200, {
      'Content-Type': type,
      'Content-Length': st.size,
      'Cache-Control': 'no-cache'
    });
    fs.createReadStream(full).pipe(res);
  });
}

function openBrowser(url) {
  const cmd = process.platform === 'win32' ? `start "" "${url}"`
            : process.platform === 'darwin' ? `open "${url}"`
            : `xdg-open "${url}"`;
  exec(cmd, () => { /* best effort */ });
}

function listen(port, triesLeft) {
  const server = http.createServer(handler);
  server.on('error', err => {
    if (err.code === 'EADDRINUSE' && triesLeft > 0) {
      listen(port + 1, triesLeft - 1);
      return;
    }
    console.error('  could not start the server:', err.message);
    process.exit(1);
  });
  server.listen(port, '127.0.0.1', () => {
    const url = `http://127.0.0.1:${port}/`;
    console.log('');
    console.log('  TerraPortal');
    console.log('  ' + url);
    console.log('');
    console.log('  Serving ' + ROOT);
    console.log('  Press Ctrl+C to stop.');
    console.log('');
    if (!NO_OPEN) openBrowser(url);
  });
}

listen(FIRST_PORT, 9);
