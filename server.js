#!/usr/bin/env node
'use strict';

const http = require('http');
const fs = require('fs');
const path = require('path');
const { execFile } = require('child_process');
const { URL } = require('url');

const SCRIPT_DIR = __dirname;
const QUESTIONS_FILE = path.join(SCRIPT_DIR, '..', 'data', 'questions.json');
const WEB_DIR = path.join(SCRIPT_DIR, 'web');
const RUNS_DIR = path.join(SCRIPT_DIR, 'runs');
const PORT = parseInt(process.env.PORT || '3000', 10);

const MIME = {
  '.html': 'text/html; charset=utf-8',
  '.css':  'text/css; charset=utf-8',
  '.js':   'application/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.ico':  'image/x-icon',
};

// Load questions at startup and build a whitelist of valid IDs
let questions = [];
let validIds = new Set();
try {
  questions = JSON.parse(fs.readFileSync(QUESTIONS_FILE, 'utf8'));
  validIds = new Set(questions.map(q => q.id));
  console.log(`Loaded ${questions.length} questions from ${QUESTIONS_FILE}`);
} catch (err) {
  console.error(`Failed to load questions.json: ${err.message}`);
  process.exit(1);
}

// ── Helpers ──────────────────────────────────────────────────────────────────

function json(res, status, body) {
  const payload = JSON.stringify(body);
  res.writeHead(status, {
    'Content-Type': 'application/json; charset=utf-8',
    'Content-Length': Buffer.byteLength(payload),
  });
  res.end(payload);
}

function serveStatic(req, res, urlPath) {
  // Default to index.html
  const rel = urlPath === '/' ? '/index.html' : urlPath;
  const filePath = path.join(WEB_DIR, rel);

  // Prevent path traversal outside WEB_DIR
  if (!filePath.startsWith(WEB_DIR + path.sep) && filePath !== WEB_DIR) {
    json(res, 403, { error: 'Forbidden' });
    return;
  }

  fs.readFile(filePath, (err, data) => {
    if (err) {
      if (err.code === 'ENOENT') {
        // SPA fallback — serve index.html for any unknown path
        fs.readFile(path.join(WEB_DIR, 'index.html'), (e2, d2) => {
          if (e2) { json(res, 404, { error: 'Not found' }); return; }
          res.writeHead(200, { 'Content-Type': MIME['.html'] });
          res.end(d2);
        });
      } else {
        json(res, 500, { error: err.message });
      }
      return;
    }
    const ext = path.extname(filePath).toLowerCase();
    res.writeHead(200, { 'Content-Type': MIME[ext] || 'application/octet-stream' });
    res.end(data);
  });
}

function runScript(script, args, timeoutMs, res) {
  execFile(
    path.join(SCRIPT_DIR, script),
    args,
    {
      cwd: SCRIPT_DIR,
      maxBuffer: 10 * 1024 * 1024,
      timeout: timeoutMs,
      env: { ...process.env, TERM: 'xterm-256color' },
    },
    (err, stdout, stderr) => {
      const output = (stdout || '') + (stderr || '');
      if (err && err.killed) {
        json(res, 200, { success: false, output: output + '\n[Timed out]', exitCode: -1 });
      } else {
        json(res, 200, {
          success: !err || err.code === 0,
          output,
          exitCode: err ? (err.code ?? 1) : 0,
        });
      }
    }
  );
}

// ── Router ────────────────────────────────────────────────────────────────────

function extractId(urlPath, prefix) {
  // e.g. prefix = '/api/start/' → id = 'q001'
  return urlPath.startsWith(prefix) ? urlPath.slice(prefix.length) : null;
}

const server = http.createServer((req, res) => {
  // Normalise URL (strip query string)
  let urlPath;
  try {
    urlPath = new URL(req.url, `http://localhost`).pathname;
  } catch {
    json(res, 400, { error: 'Bad request' });
    return;
  }

  // ── GET /api/questions
  if (req.method === 'GET' && urlPath === '/api/questions') {
    json(res, 200, questions);
    return;
  }

  // ── GET /api/status/:id
  if (req.method === 'GET' && urlPath.startsWith('/api/status/')) {
    const id = extractId(urlPath, '/api/status/');
    if (!id || !validIds.has(id)) { json(res, 400, { error: 'Invalid question ID' }); return; }
    const runDir = path.join(RUNS_DIR, id);
    fs.stat(runDir, (err, stat) => {
      json(res, 200, { started: !err && stat.isDirectory() });
    });
    return;
  }

  // ── POST /api/start/:id
  if (req.method === 'POST' && urlPath.startsWith('/api/start/')) {
    const id = extractId(urlPath, '/api/start/');
    if (!id || !validIds.has(id)) { json(res, 400, { error: 'Invalid question ID' }); return; }
    runScript('start.sh', [id], 15000, res);
    return;
  }

  // ── POST /api/mark/:id
  if (req.method === 'POST' && urlPath.startsWith('/api/mark/')) {
    const id = extractId(urlPath, '/api/mark/');
    if (!id || !validIds.has(id)) { json(res, 400, { error: 'Invalid question ID' }); return; }
    runScript('mark.sh', [id], 30000, res);
    return;
  }

  // ── POST /api/reset/:id
  if (req.method === 'POST' && urlPath.startsWith('/api/reset/')) {
    const id = extractId(urlPath, '/api/reset/');
    if (!id || !validIds.has(id)) { json(res, 400, { error: 'Invalid question ID' }); return; }
    runScript('reset.sh', [id], 15000, res);
    return;
  }

  // ── Static files
  if (req.method === 'GET') {
    serveStatic(req, res, urlPath);
    return;
  }

  json(res, 405, { error: 'Method not allowed' });
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`Autograder UI running at http://0.0.0.0:${PORT}`);
  console.log(`Open http://localhost:${PORT} in your browser (or the EdStem web preview).`);
});

server.on('error', err => {
  console.error(`Server error: ${err.message}`);
  process.exit(1);
});
