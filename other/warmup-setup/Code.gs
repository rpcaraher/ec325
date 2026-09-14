/**
 * EC325 Warm-Up — Google Apps Script backend
 * =========================================================================
 * Bound to a Google Sheet. Serves the question of the day to the student
 * page, accepts submissions, and hands the whole set back to the review
 * page when the correct review key is supplied.
 *
 * Two tabs do all the work (run setupSheets() once and they appear):
 *
 *   Config       one row per class day. The ACTIVE round is the LAST row
 *                whose `open` column is TRUE. Flip it to FALSE to close.
 *   Submissions  one row per student per round. Appended automatically.
 *
 * Setup, in order:
 *   1. Run setupSheets() once from this editor.
 *   2. Project settings -> Script properties -> add REVIEW_KEY = <your key>.
 *   3. Deploy -> New deployment -> Web app
 *        Execute as:      Me
 *        Who has access:  Anyone        <-- must be "Anyone", NOT
 *                                           "Anyone with a Google Account",
 *                                           or students will hit a login wall.
 *   4. Copy the /exec URL into API in index.html and review.html.
 *
 * Re-deploy (Deploy -> Manage deployments -> edit -> Version: New version)
 * after any edit to this file, or the live URL keeps serving the old code.
 */

var CONFIG_SHEET = 'Config';
var SUBS_SHEET   = 'Submissions';

var CONFIG_HEADERS = ['round_id','label','question','data_url','data_var','packages','starter_code','open'];
var SUBS_HEADERS   = ['uid','timestamp','round_id','name','answer','code','winner'];


/* ======================= one-time setup ======================= */

/**
 * Write any missing headers into row 1. Safe to re-run: an existing sheet keeps
 * its data and simply gains the columns it doesn't have yet.
 */
function ensureHeaders_(sheet, headers) {
  if (sheet.getLastRow() === 0) {
    sheet.getRange(1, 1, 1, headers.length).setValues([headers]).setFontWeight('bold');
    sheet.setFrozenRows(1);
    return headers.slice();
  }
  var existing = sheet.getRange(1, 1, 1, Math.max(sheet.getLastColumn(), 1))
                      .getValues()[0].map(function (h) { return String(h).trim(); });
  var added = [];
  headers.forEach(function (h) {
    if (existing.indexOf(h) === -1) {
      sheet.getRange(1, sheet.getLastColumn() + 1).setValue(h).setFontWeight('bold');
      added.push(h);
    }
  });
  return added;
}

function setupSheets() {
  var ss = SpreadsheetApp.getActiveSpreadsheet();

  var cfg = ss.getSheetByName(CONFIG_SHEET) || ss.insertSheet(CONFIG_SHEET);
  var cfgAdded = ensureHeaders_(cfg, CONFIG_HEADERS);
  if (cfg.getLastRow() === 1) {
    cfg.appendRow([
      'w01-sample',
      "Today's question",
      'The Card & Krueger data is loaded as ck — one row per restaurant per wave.\n\n' +
      'Compute the difference-in-differences estimate of the effect of New Jersey\'s\n' +
      'minimum wage increase on FTE employment using only group means — no regression.\n\n' +
      'Report the number.',
      'https://raw.githubusercontent.com/rpcaraher/ec325/main/data/card_krueger/ck_1994.csv',
      'ck',
      '',
      '# ck is already loaded. state is "NJ" or "PA"; period is "pre" or "post".\n' +
      '# Some fte values are NA — use na.rm = TRUE.\n\n' +
      'table(ck$state, ck$period)\n',
      false
    ]);
    cfg.setColumnWidth(3, 420);
    cfg.setColumnWidth(7, 260);
  }

  var subs = ss.getSheetByName(SUBS_SHEET) || ss.insertSheet(SUBS_SHEET);
  var subsAdded = ensureHeaders_(subs, SUBS_HEADERS);
  if (subs.getLastRow() === 1) {
    subs.setColumnWidth(5, 300);
    subs.setColumnWidth(6, 420);
  }

  var msg = 'Sheets ready.';
  if (cfgAdded.length)  msg += '\n\nAdded to Config: ' + cfgAdded.join(', ');
  if (subsAdded.length) msg += '\nAdded to Submissions: ' + subsAdded.join(', ');
  msg += '\n\nIf this is a first run: Project settings -> Script properties -> add ' +
         'REVIEW_KEY, then Deploy as a web app with access set to "Anyone".';
  SpreadsheetApp.getUi().alert(msg);
}


/* ======================= helpers ======================= */

function json_(obj) {
  return ContentService
    .createTextOutput(JSON.stringify(obj))
    .setMimeType(ContentService.MimeType.JSON);
}

function sheet_(name) {
  return SpreadsheetApp.getActiveSpreadsheet().getSheetByName(name);
}

/** Rows of a sheet as objects keyed by the header row. */
function rows_(name) {
  var sh = sheet_(name);
  if (!sh || sh.getLastRow() < 2) return [];
  var values = sh.getDataRange().getValues();
  var head = values[0].map(function (h) { return String(h).trim(); });
  return values.slice(1).map(function (row, i) {
    var o = { _row: i + 2 };
    head.forEach(function (h, c) { if (h) o[h] = row[c]; });
    return o;
  });
}

function truthy_(v) {
  if (v === true) return true;
  var s = String(v).trim().toLowerCase();
  return s === 'true' || s === 'yes' || s === 'y' || s === '1';
}

/** The active round: the last Config row with open = TRUE. */
function activeRound_() {
  var all = rows_(CONFIG_SHEET).filter(function (r) { return truthy_(r.open); });
  return all.length ? all[all.length - 1] : null;
}

function keyOk_(key) {
  var want = PropertiesService.getScriptProperties().getProperty('REVIEW_KEY');
  return !!want && String(key) === String(want);
}

function norm_(s) { return String(s == null ? '' : s).trim().toLowerCase().replace(/\s+/g, ' '); }


/**
 * A light handle on the Submissions sheet: header row only.
 * The submit path must never read the whole sheet — with 24 students hitting
 * Submit within a few seconds, a full getDataRange() inside the lock starves
 * everyone behind it.
 */
function subsIndex_() {
  var sh = sheet_(SUBS_SHEET);
  if (!sh) return null;
  var lastRow = sh.getLastRow(), lastCol = sh.getLastColumn();
  if (lastCol < 1) return null;
  var head = sh.getRange(1, 1, 1, lastCol).getValues()[0]
               .map(function (h) { return String(h).trim(); });
  return {
    sh: sh, head: head, lastRow: lastRow,
    col: function (n) { return head.indexOf(n) + 1; }
  };
}

/** Row number of this student's existing entry for this round, or 0. */
function findRow_(ix, rid, name) {
  if (!ix || ix.lastRow < 2) return 0;
  var rc = ix.col('round_id'), nc = ix.col('name');
  if (rc < 1 || nc < 1) return 0;
  // one contiguous block covering both columns: a single API round trip
  var lo = Math.min(rc, nc), hi = Math.max(rc, nc);
  var block = ix.sh.getRange(2, lo, ix.lastRow - 1, hi - lo + 1).getValues();
  var want = norm_(name);
  for (var i = 0; i < block.length; i++) {
    if (String(block[i][rc - lo]) === rid && norm_(block[i][nc - lo]) === want) return i + 2;
  }
  return 0;
}

/** How many rows this round has, without pulling the whole sheet. */
function countRound_(rid) {
  var ix = subsIndex_();
  if (!ix || ix.lastRow < 2) return 0;
  var rc = ix.col('round_id');
  if (rc < 1) return 0;
  var vals = ix.sh.getRange(2, rc, ix.lastRow - 1, 1).getValues();
  var n = 0;
  for (var i = 0; i < vals.length; i++) if (String(vals[i][0]) === rid) n++;
  return n;
}


/* ======================= GET ======================= */

function doGet(e) {
  var action = (e && e.parameter && e.parameter.action) || 'config';

  if (action === 'config') {
    var r = activeRound_();
    if (!r) return json_({ open: false });
    return json_({
      open: true,
      round_id:     String(r.round_id || ''),
      label:        String(r.label || ''),
      question:     String(r.question || ''),
      data_url:     String(r.data_url || ''),
      data_var:     String(r.data_var || ''),
      packages:     String(r.packages || ''),
      starter_code: String(r.starter_code || '')
    });
  }

  if (action === 'count') {
    return json_({ count: countRound_(String(e.parameter.round || '')) });
  }

  if (action === 'submissions') {
    if (!keyOk_(e.parameter.key)) return json_({ error: 'bad_key' });
    var round = activeRound_();
    var rid = round ? String(round.round_id) : String(e.parameter.round || '');
    var list = rows_(SUBS_SHEET)
      .filter(function (s) { return String(s.round_id) === rid; })
      .map(function (s) {
        return {
          id:        String(s.uid),
          timestamp: s.timestamp instanceof Date ? s.timestamp.toISOString() : String(s.timestamp),
          name:      String(s.name || ''),
          answer:    String(s.answer || ''),
          code:      String(s.code || ''),
          winner:    truthy_(s.winner)
        };
      });
    return json_({
      round: round ? {
        round_id: String(round.round_id),
        question: String(round.question || ''),
        open: true
      } : { round_id: rid, question: '', open: false },
      submissions: list
    });
  }

  return json_({ error: 'unknown_action' });
}


/* ======================= POST ======================= */

function doPost(e) {
  var body;
  try {
    body = JSON.parse(e.postData.contents);
  } catch (err) {
    return json_({ ok: false, error: 'bad_body' });
  }

  if (body.action === 'winner') {
    if (!keyOk_(body.key)) return json_({ ok: false, error: 'bad_key' });
    var sh = sheet_(SUBS_SHEET);
    var wcol = SUBS_HEADERS.indexOf('winner') + 1;
    rows_(SUBS_SHEET).forEach(function (s) {
      if (String(s.round_id) !== String(body.round_id)) return;
      var isWinner = String(s.uid) === String(body.id);
      if (truthy_(s.winner) !== isWinner) sh.getRange(s._row, wcol).setValue(isWinner);
    });
    return json_({ ok: true });
  }

  // default: a student submission
  var round = activeRound_();
  if (!round) return json_({ ok: false, error: 'closed' });

  var rid  = String(round.round_id);
  var name = String(body.name || '').trim();
  if (!name) return json_({ ok: false, error: 'no_name' });

  // 45s, not 8s: a whole class submitting at once queues here, and a student
  // whose wait expires sees a scary failure for a submission that was fine.
  var lock = LockService.getScriptLock();
  try { lock.waitLock(45000); } catch (err) { return json_({ ok: false, error: 'busy' }); }

  try {
    var ix = subsIndex_();
    if (!ix) return json_({ ok: false, error: 'no_sheet' });

    var row = findRow_(ix, rid, name);

    if (row) {
      // Resubmission: rewrite in place, preserving uid and winner.
      var uidCol = ix.col('uid'), winCol = ix.col('winner');
      var uid = uidCol > 0 ? ix.sh.getRange(row, uidCol).getValue() : Utilities.getUuid();
      var won = winCol > 0 ? truthy_(ix.sh.getRange(row, winCol).getValue()) : false;
      ix.sh.getRange(row, 1, 1, SUBS_HEADERS.length).setValues([[
        uid, new Date(), rid, name,
        String(body.answer || ''), String(body.code || ''), won
      ]]);
      return json_({ ok: true, resubmitted: true });
    }

    ix.sh.appendRow([
      Utilities.getUuid(), new Date(), rid, name,
      String(body.answer || ''), String(body.code || ''), false
    ]);
    return json_({ ok: true, resubmitted: false });

  } finally {
    lock.releaseLock();
  }
}
