const express = require('express');
const cors = require('cors');
const { Octokit } = require('@octokit/rest');

const app = express();
app.use(cors());
app.use(express.json({ limit: '2mb' }));
app.use(express.static(__dirname));

const PORT = process.env.PORT || 10000;
const OWNER = process.env.GITHUB_OWNER;
const REPO = process.env.GITHUB_REPO;
const BRANCH = process.env.GITHUB_BRANCH || 'main';
const ROOT = 'src/';

const gh = new Octokit({ auth: process.env.GITHUB_PAT });

// Only allow files inside src/
function safePath(p) {
  return typeof p === 'string' && p.startsWith(ROOT) && !p.includes('..') && !p.endsWith('/');
}

function fail(res, err) {
  console.error(err);
  const status = err.status >= 400 && err.status < 600 ? err.status : 500;
  res.status(status).json({ error: err.message });
}

// Returns { sha, content } or null if the file doesn't exist
async function getFile(p) {
  try {
    const { data } = await gh.repos.getContent({ owner: OWNER, repo: REPO, path: p, ref: BRANCH });
    return { sha: data.sha, content: Buffer.from(data.content, 'base64').toString('utf8') };
  } catch (err) {
    if (err.status === 404) return null;
    throw err;
  }
}

// LIST: every file under src/
app.get('/api/files', async (req, res) => {
  try {
    const { data: ref } = await gh.git.getRef({ owner: OWNER, repo: REPO, ref: `heads/${BRANCH}` });
    const { data: tree } = await gh.git.getTree({
      owner: OWNER, repo: REPO, tree_sha: ref.object.sha, recursive: 'true',
    });
    const files = tree.tree
      .filter(t => t.type === 'blob' && t.path.startsWith(ROOT))
      .map(t => t.path)
      .sort();
    res.json({ branch: BRANCH, files });
  } catch (err) { fail(res, err); }
});

// READ: one file
app.get('/api/file', async (req, res) => {
  const p = req.query.path;
  if (!safePath(p)) return res.status(400).json({ error: 'Path must start with src/' });
  try {
    const f = await getFile(p);
    if (!f) return res.status(404).json({ error: 'File not found: ' + p });
    res.json({ path: p, content: f.content });
  } catch (err) { fail(res, err); }
});

// CREATE or UPDATE
app.put('/api/file', async (req, res) => {
  const { path: p, content, message } = req.body || {};
  if (!safePath(p) || typeof content !== 'string') {
    return res.status(400).json({ error: 'Need a src/ path and content.' });
  }
  try {
    const existing = await getFile(p);
    await gh.repos.createOrUpdateFileContents({
      owner: OWNER, repo: REPO, path: p, branch: BRANCH,
      message: message || (existing ? `Update ${p}` : `Create ${p}`),
      content: Buffer.from(content, 'utf8').toString('base64'),
      sha: existing ? existing.sha : undefined,
    });
    res.json({ ok: true, action: existing ? 'updated' : 'created', path: p });
  } catch (err) { fail(res, err); }
});

// DELETE
app.delete('/api/file', async (req, res) => {
  const { path: p, message } = req.body || {};
  if (!safePath(p)) return res.status(400).json({ error: 'Path must start with src/' });
  try {
    const existing = await getFile(p);
    if (!existing) return res.status(404).json({ error: 'File not found: ' + p });
    await gh.repos.deleteFile({
      owner: OWNER, repo: REPO, path: p, branch: BRANCH,
      sha: existing.sha, message: message || `Delete ${p}`,
    });
    res.json({ ok: true, action: 'deleted', path: p });
  } catch (err) { fail(res, err); }
});

app.get('/health', (_, res) => res.json({ ok: true, branch: BRANCH }));

app.listen(PORT, () => console.log(`motmot files running on port ${PORT}`));
