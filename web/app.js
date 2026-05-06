'use strict';

// ── State ─────────────────────────────────────────────────────────────────────
let questions = [];
let currentQ  = null;
let startedIds = new Set();

// ── DOM refs ──────────────────────────────────────────────────────────────────
const qList         = document.getElementById('question-list');
const welcome       = document.getElementById('welcome');
const qPanel        = document.getElementById('question-panel');

const qIdBadge      = document.getElementById('q-id-badge');
const qTopicBadge   = document.getElementById('q-topic-badge');
const qDiffBadge    = document.getElementById('q-difficulty-badge');
const qStatusBadge  = document.getElementById('q-status-badge');
const qTitle        = document.getElementById('q-title');
const qOriginal     = document.getElementById('q-original');
const qSummary      = document.getElementById('q-summary');
const qRequiredFiles= document.getElementById('q-required-files');
const qHints        = document.getElementById('q-hints');
const terminalCmds  = document.getElementById('terminal-commands');
const qWorkdir      = document.getElementById('q-workdir');

const btnStart      = document.getElementById('btn-start');
const btnMark       = document.getElementById('btn-mark');
const btnReset      = document.getElementById('btn-reset');

const resultsPanel  = document.getElementById('results-panel');
const resultsSummary= document.getElementById('results-summary');
const resultsOutput = document.getElementById('results-output');
const toast         = document.getElementById('toast');

// ── Init ──────────────────────────────────────────────────────────────────────
async function init() {
  try {
    const res = await fetch('/api/questions');
    if (!res.ok) throw new Error('Failed to load questions');
    questions = await res.json();
    renderSidebar();
    // check status for all questions so dots show on load
    questions.forEach(q => checkStatus(q.id));
  } catch (e) {
    showToast('Error loading questions: ' + e.message, 4000);
  }
}

// ── Sidebar ───────────────────────────────────────────────────────────────────
function renderSidebar() {
  qList.innerHTML = '';
  questions.forEach(q => {
    const li = document.createElement('li');
    li.className = 'q-item';
    li.setAttribute('role', 'option');
    li.dataset.id = q.id;
    li.innerHTML = `
      <div class="q-started-dot" title="Started"></div>
      <div class="q-item-info">
        <div class="q-item-id">${esc(q.id)}</div>
        <div class="q-item-title">${esc(q.title)}</div>
        <div class="q-item-badges">
          <span class="badge diff-${esc(q.difficulty)}">${esc(q.difficulty)}</span>
          <span class="badge badge-topic">${esc(topicLabel(q.topic))}</span>
        </div>
      </div>`;
    li.addEventListener('click', () => selectQuestion(q));
    qList.appendChild(li);
  });
}

function topicLabel(t) {
  const map = {
    vim: 'Vim',
    shell_scripting: 'Shell',
    shell_scripting_advanced: 'Shell+',
    data_processing: 'Data',
  };
  return map[t] || t;
}

// ── Question selection ────────────────────────────────────────────────────────
function selectQuestion(q) {
  currentQ = q;

  // sidebar highlight
  document.querySelectorAll('.q-item').forEach(el => {
    el.classList.toggle('active', el.dataset.id === q.id);
    el.setAttribute('aria-selected', el.dataset.id === q.id);
  });

  welcome.hidden = true;
  qPanel.hidden  = false;

  // populate header
  qIdBadge.textContent    = q.id;
  qTopicBadge.textContent = topicLabel(q.topic);
  qDiffBadge.textContent  = q.difficulty;
  qDiffBadge.className    = `badge diff-${q.difficulty}`;
  qTitle.textContent      = q.title;

  // task tab
  qOriginal.textContent = q.original_text;
  qSummary.textContent  = q.task_summary;

  qRequiredFiles.innerHTML = '';
  (q.required_files || []).forEach(f => {
    const li = document.createElement('li');
    li.textContent = f;
    qRequiredFiles.appendChild(li);
  });

  // hints tab
  qHints.innerHTML = '';
  (q.commands_likely_needed || []).forEach(cmd => {
    const li = document.createElement('li');
    li.textContent = cmd;
    qHints.appendChild(li);
  });

  // terminal tab
  const workdir = `practice/runs/${q.id}`;
  qWorkdir.textContent = workdir;
  const workdirBlock = qWorkdir.closest('.cmd-block');
  workdirBlock.querySelector('.copy-btn').onclick = () => copyText(workdir, workdirBlock.querySelector('.copy-btn'));

  const steps = [
    { step: '1', cmd: `./start.sh ${q.id}`,       note: 'Set up working directory' },
    { step: '2', cmd: `cd practice/runs/${q.id}`, note: 'Move into working directory' },
    { step: '3', cmd: `./mark.sh ${q.id}`,         note: 'Check your answer (or use the Mark button)' },
  ];
  terminalCmds.innerHTML = '';
  steps.forEach(s => {
    const div = document.createElement('div');
    div.className = 'cmd-block';
    div.id = `step-${s.step}`;
    div.innerHTML = `
      <span class="cmd-step">${s.step}</span>
      <code>${esc(s.cmd)}</code>
      <button class="copy-btn" title="${esc(s.note)}">Copy</button>`;
    div.querySelector('.copy-btn').addEventListener('click', () =>
      copyText(s.cmd, div.querySelector('.copy-btn'))
    );
    terminalCmds.appendChild(div);
  });

  // reset results
  resultsPanel.hidden = true;
  resultsOutput.innerHTML = '';
  resultsSummary.textContent = '';

  // status badge
  updateStatusBadge(q.id);

  // switch to task tab
  switchTab('task');
}

// ── Status badge ──────────────────────────────────────────────────────────────
async function checkStatus(id) {
  try {
    const res = await fetch(`/api/status/${id}`);
    const data = await res.json();
    if (data.started) startedIds.add(id);
    else startedIds.delete(id);
    // update sidebar dot
    const li = qList.querySelector(`[data-id="${id}"]`);
    if (li) li.classList.toggle('started', data.started);
    if (currentQ && currentQ.id === id) updateStatusBadge(id);
  } catch { /* ignore */ }
}

function updateStatusBadge(id) {
  const started = startedIds.has(id);
  qStatusBadge.hidden = !started;
}

// ── Tabs ──────────────────────────────────────────────────────────────────────
document.getElementById('q-tabs').addEventListener('click', e => {
  if (e.target.matches('.tab')) switchTab(e.target.dataset.tab);
});

function switchTab(name) {
  document.querySelectorAll('.tab').forEach(t => {
    const active = t.dataset.tab === name;
    t.classList.toggle('active', active);
    t.setAttribute('aria-selected', active);
  });
  document.querySelectorAll('.tab-content').forEach(c => {
    c.hidden = c.id !== `tab-${name}`;
    c.classList.toggle('active', c.id === `tab-${name}`);
  });
}

// ── Actions ───────────────────────────────────────────────────────────────────
btnStart.addEventListener('click', async () => {
  if (!currentQ) return;
  await runAction('start', currentQ.id, btnStart, async (data) => {
    await checkStatus(currentQ.id);
    // highlight the cd step
    const cdBlock = document.getElementById('step-2');
    if (cdBlock) cdBlock.classList.add('highlight');
    switchTab('terminal');
    showOutput(data.output, data.success);
    if (data.success) showToast(`${currentQ.id} started — open Ed terminal and run the shown commands`);
  });
});

btnMark.addEventListener('click', async () => {
  if (!currentQ) return;
  resultsPanel.hidden = false;
  resultsOutput.textContent = 'Running mark.sh…';
  await runAction('mark', currentQ.id, btnMark, (data) => {
    showOutput(data.output, data.success);
  });
});

btnReset.addEventListener('click', async () => {
  if (!currentQ) return;
  const confirmed = window.confirm(
    `Reset ${currentQ.id}?\n\nYour work in practice/runs/${currentQ.id} will be deleted.`
  );
  if (!confirmed) return;
  await runAction('reset', currentQ.id, btnReset, async (data) => {
    await checkStatus(currentQ.id);
    const cdBlock = document.getElementById('step-2');
    if (cdBlock) cdBlock.classList.remove('highlight');
    showOutput(data.output, true);
    if (data.success) showToast(`${currentQ.id} reset — run Start to begin again`);
  });
});

async function runAction(action, id, btn, onDone) {
  const origHTML = btn.innerHTML;
  btn.disabled = true;
  btn.innerHTML = `<span class="btn-spinner"></span> ${action.charAt(0).toUpperCase() + action.slice(1)}ing…`;

  try {
    const res = await fetch(`/api/${action}/${id}`, { method: 'POST' });
    const data = await res.json();
    await onDone(data);
  } catch (e) {
    showOutput(`Error: ${e.message}`, false);
  } finally {
    btn.disabled = false;
    btn.innerHTML = origHTML;
  }
}

// ── Output rendering ──────────────────────────────────────────────────────────
function showOutput(raw, success) {
  resultsPanel.hidden = false;

  const lines = (raw || '').split('\n');
  let passCount = 0, failCount = 0, warnCount = 0;

  resultsOutput.innerHTML = '';
  lines.forEach(line => {
    const span = document.createElement('span');
    span.textContent = line + '\n';

    // Strip common ANSI colour codes for classification
    const plain = line.replace(/\x1b\[[0-9;]*m/g, '');

    if (/✅|PASS|pass/.test(plain)) {
      span.className = 'out-pass'; passCount++;
    } else if (/❌|FAIL|fail/.test(plain)) {
      span.className = 'out-fail'; failCount++;
    } else if (/⚠️|WARN|warn/.test(plain)) {
      span.className = 'out-warn'; warnCount++;
    } else if (/ℹ️|INFO|info/.test(plain)) {
      span.className = 'out-info';
    } else if (/^[═─]+$/.test(plain.trim())) {
      span.className = 'out-sep';
    }

    resultsOutput.appendChild(span);
  });

  // summary line
  const parts = [];
  if (passCount) parts.push(`<span class="summary-pass">${passCount} PASS</span>`);
  if (failCount) parts.push(`<span class="summary-fail">${failCount} FAIL</span>`);
  if (warnCount) parts.push(`<span class="summary-warn">${warnCount} WARN</span>`);
  resultsSummary.innerHTML = parts.join(' · ');

  // scroll to bottom of output
  resultsOutput.scrollTop = resultsOutput.scrollHeight;
}

// ── Copy to clipboard ─────────────────────────────────────────────────────────
function copyText(text, btn) {
  if (!navigator.clipboard) {
    // Fallback for older browsers / non-HTTPS
    const ta = document.createElement('textarea');
    ta.value = text;
    ta.style.position = 'fixed';
    ta.style.opacity = '0';
    document.body.appendChild(ta);
    ta.select();
    try { document.execCommand('copy'); } catch { /* ignore */ }
    document.body.removeChild(ta);
  } else {
    navigator.clipboard.writeText(text).catch(() => {});
  }
  const orig = btn.textContent;
  btn.textContent = 'Copied!';
  btn.classList.add('copied');
  setTimeout(() => {
    btn.textContent = orig;
    btn.classList.remove('copied');
  }, 1500);
}

// ── Toast ─────────────────────────────────────────────────────────────────────
let toastTimer = null;
function showToast(msg, duration = 3000) {
  toast.textContent = msg;
  toast.hidden = false;
  void toast.offsetWidth; // reflow to restart transition
  toast.classList.add('show');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => {
    toast.classList.remove('show');
    setTimeout(() => { toast.hidden = true; }, 250);
  }, duration);
}

// ── Utilities ─────────────────────────────────────────────────────────────────
function esc(str) {
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

// ── Start ─────────────────────────────────────────────────────────────────────
init();
