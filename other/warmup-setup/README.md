# EC325 Warm-Up — setup and daily use

A start-of-class coding activity. Students open one link, see the question of
the day, write and **run R in the browser** (no RStudio needed), and submit an
answer plus their code. You watch submissions land on a projector view and
crown a winner.

```
book/warmup/index.html    student page   →  /ec325/warmup/
book/warmup/review.html   your view      →  /ec325/warmup/review.html
other/warmup-setup/Code.gs                  paste into Apps Script
```

Student names and code live in **your** Google Sheet. Nothing student-identifying
passes through anything else.

---

## One-time setup (about 15 minutes)

### 1. Make the Sheet and the script

1. Create a new Google Sheet in your Colby Drive. Name it `EC325 Warm-Ups`.
2. **Extensions → Apps Script**. Delete the stub `myFunction`, paste all of
   `Code.gs`, and save.
3. In the toolbar, pick `setupSheets` from the function dropdown and press
   **Run**. Authorize when prompted (it's your own script; the "unverified app"
   screen is expected — *Advanced → Go to …*). You should end up with a
   `Config` tab and a `Submissions` tab.

### 2. Set the review key

This is what stops a curious student from reading the class's submissions.

Generate one in Terminal:

```bash
openssl rand -hex 16
```

In Apps Script: **⚙ Project settings → Script properties → Add script property**

| Property | Value |
|---|---|
| `REVIEW_KEY` | *(the string you just generated)* |

### 3. Deploy

**Deploy → New deployment → ⚙ → Web app**

| Setting | Value |
|---|---|
| Execute as | **Me** |
| Who has access | **Anyone** |

> ⚠️ It must be **Anyone**, not *Anyone with a Google Account*. The second one
> throws students into a login wall, and some will be signed into a personal
> Google account that isn't allowed through.

Copy the deployment URL. It ends in `/exec`.

### 4. Paste the URL into both pages

In `book/warmup/index.html` and `book/warmup/review.html`, near the top of the
`<script>` block:

```js
const API = "PASTE_YOUR_APPS_SCRIPT_WEB_APP_URL_HERE";
```

Replace with your `/exec` URL. Same URL in both files.

### 5. Publish

Add `warmup` to the `resources:` list in `book/_quarto.yml`, then render and push:

```r
quarto::quarto_render("book")
```

```bash
git add -A && git commit -m "Add warm-up activity" && git push
```

Live at `https://www.raymondcaraher.com/ec325/warmup/` a minute or two later.

### 6. Unlock the review page once

Open `/ec325/warmup/review.html` on the podium machine and paste the review key.
It's kept in that browser's local storage, so you won't be asked again on that
machine.

---

## Running it in class

**The night before**, add a row to the `Config` tab:

| Column | What goes in it |
|---|---|
| `round_id` | Anything unique — `w03-tue`, `2026-09-15`. Groups the submissions. |
| `label` | Heading above the question. Blank gives "Today's question". |
| `question` | The prompt. Line breaks are preserved. |
| `data_url` | Raw GitHub URL of a CSV, or blank for no data. |
| `data_var` | R name the data loads under, e.g. `ck`. |
| `starter_code` | Pre-filled in the code box. Good for scaffolding. |
| `open` | `TRUE` for the live one. |

**The active round is the last row where `open` is TRUE.** Flip the previous
day's row to `FALSE`. If nothing is open, students see "No warm-up is open
right now."

Raw GitHub URLs for the data already in this repo:

```
https://raw.githubusercontent.com/rpcaraher/ec325/main/data/card_krueger/ck_1994.csv
https://raw.githubusercontent.com/rpcaraher/ec325/main/data/ohie/ohie_sample.csv
https://raw.githubusercontent.com/rpcaraher/ec325/main/data/blau_khan/blau_khan_psid.csv
```

`ck_1994.csv` is 41 KB and loads almost instantly. The Blau–Khan file is 3 MB —
fine, but slower on classroom wifi with everyone loading at once. Skip
`ardz.csv` (19 MB) for warm-ups.

**In class**, project `review.html`:

| Key | Does |
|---|---|
| click a card | open it full-size |
| `←` `→` or space | move between submissions (wraps around) |
| `w` | crown the one on screen |
| `Esc` | leave the winner screen |
| `Present` / `List` | toggle the two views |

It polls every 10 seconds, so the count climbs on its own while students file in.

**Afterwards**, the `Submissions` tab is your participation record — one row per
student per round, with a `winner` column. That feeds Engaged Learning without
any extra bookkeeping.

---

## Things worth knowing

**Resubmitting.** A student submitting twice under the same name *replaces*
their earlier row rather than adding one. Names are matched case- and
whitespace-insensitively. A student who types their name differently on two days
will show up as two people in the sheet — sort by name at the end of the
semester and merge the obvious ones.

**The R console is a bonus, never a requirement.** If webR fails to load —
old browser, locked-down laptop, bad wifi — the page says so and submitting
still works normally. Nobody gets blocked from participating by a wasm download.

**Packages work, but they cost download time.** webR has its own repository of
CRAN compiled to WebAssembly — 21,623 packages for R 4.4, so essentially
everything. `fixest`, `plm`, `AER`, `estimatr`, `ivreg`, `sandwich`, `lmtest`,
`modelsummary`, `rdrobust`, `HonestDiD` and `wooldridge` are all present.
(`lfe` is the one notable absence; `fixest` replaces it.)

The constraint is weight, since every student downloads it on first load:

| package | dependencies | download |
|---|---|---|
| `dplyr` | 16 | 6.4 MB |
| `fixest` | 10 | 11 MB |
| `modelsummary` | 23 | 17 MB |
| `ggplot2` | 28 | 17–25 MB |
| `did` | 132 | 126 MB |

Up to about 15 MB is fine on classroom wifi. `did` is not — 132 packages
including `stringi` and `BH`, which at 25 students is roughly 3 GB across the
room. Save Callaway–Sant'Anna for RStudio.

Base R needs no download at all: `lm`, `summary`, `coef`, `mean`, `table`,
`tapply`, `aggregate`, and the built-in datasets like `mtcars` are there
instantly. A warm-up that stays in base R starts in about ten seconds.

**A whole class submitting at once is fine, but it is the tight spot.**
Google serialises writes to the sheet, so 24 submissions in the same few seconds
queue up rather than running in parallel. Measured against a real deployment with
24 simultaneous submissions:

| | result |
|---|---|
| 8s server lock, no client retry | **14 of 24 failed** |
| with client retry (4 tries, backoff) | 24 of 24, median 14s, worst 23s |

The page now retries quietly with jittered backoff, showing "Lots of submissions
at once — still sending…" rather than an error, and the server holds its lock for
45s and reads only the two columns it needs instead of the whole sheet. A student
should never see a failure from congestion alone.

If you ever do see failures, the thing to check is that the deployed `Code.gs`
is the current version — the old one read the entire Submissions sheet inside
the lock, which is what produced that 14-of-24 result.

**The ceiling is roughly 2x a normal section, not 10x.** Pushed to 100
simultaneous submissions, 74 landed and 26 failed (17 lock timeouts, 9 of
Google's simultaneous-execution errors); median wait rose to 25s and 40 of the
100 needed all four retries. Effective throughput is about 1.4 writes/second
because Google serialises writes to a sheet. A 24-person section drains in
around 17 seconds and is comfortable. Two sections at once, or a 60-person
lecture, would start dropping submissions — that would need a different backend,
or dropping the lock on first-time submissions so only resubmissions serialise.

**Infinite loops.** GitHub Pages can't send the COOP/COEP headers webR needs for
its interruptible channel, so a student who writes `while(TRUE){}` has to reload
the tab. Worth saying out loud the first time you use it.

**Changing the question doesn't need a deploy.** Editing the Sheet is enough.
You only re-deploy the Apps Script if you edit `Code.gs` — and then it must be
**Manage deployments → edit → Version: New version**, or the live URL keeps
serving the old code.

**Re-rendering the book won't clobber this.** The pages live in `book/warmup/`
and are copied to `docs/warmup/` by the `resources:` entry, so
`quarto_render()` reproduces them rather than deleting them.

---

## If something breaks

| Symptom | Cause |
|---|---|
| "Couldn't reach the server" | `API` still has the placeholder, or the deployment isn't set to **Anyone**. |
| Students see a Google login | Access is *Anyone with a Google Account*. Redeploy as **Anyone**. |
| "No warm-up is open right now" | No `Config` row has `open` = TRUE. |
| Review page says the key didn't work | `REVIEW_KEY` script property missing, or it was added after the last deploy. |
| Code edits don't take effect | You deployed without picking **New version**. |
| Console never becomes ready | webR CDN blocked on that network. Submitting still works. |
