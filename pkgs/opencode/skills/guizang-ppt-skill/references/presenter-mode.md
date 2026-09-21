# Presenter Mode and Speaker-Notes Contract

Load this file when building any deck that will be narrated live. The goal is not to copy on-page copy into the notes area, but to weave pages, narration, transitions, timing, and live control into a narrative chain that can be rehearsed and recovered.

## 1. The page plan covers both "what is seen" and "what is said"

Before writing any HTML, build a table first. Only fill the columns that the user's outline, materials, or confirmed live information can support:

| Page # | `data-slide-id` | Section | Page purpose | Visible on audience screen | Speaker additions | Suggested minutes | Transition | Optional live info |
|---|---|---|---|---|---:|---|---|

- **Visible on audience screen**: the conclusion, evidence, structure, or image the audience must read at this moment.
- **Speaker additions**: background, examples, reasoning, tone, and detail — don't recite the page verbatim.
- **Transition**: explains why the next page follows this one; don't just write "next page".
- **Optional live info**: may include pauses, questions, demos, videos, sensitive information, advance timing, fallback plans, or pronunciations.

Default to generating cue cards, not a verbatim script. Only write a full spoken script when the user explicitly asks for one.

## 2. How the model brings outline information into Presenter Mode

Do a structured extraction of the user's outline, project records, and additional remarks — do not invent live facts on your own.

- Continuous chapters that are already named or reliably inferable: write into `section`.
- If total duration or per-page pacing is given: `minutes` may be provided; the total suggested duration must not exceed 90% of live time.
- If the outline explicitly writes pauses, questions, demos, videos, tone, advance points, or fallback paths: write each into its corresponding optional field.
- Write `autoAdvanceSeconds` only when the user explicitly asks a page to auto-hold for some seconds.
- Don't guess on unprovided information, and don't write "to be added" into the presenter UI — just omit the field. The UI shows a dash for missing duration and hides other optional modules entirely.
- If a page is temporarily added without running validation and has no matching notes, the presenter UI shows only a neutral dash `—`, never "to be added" or invented content; the validator should still report that the notes do not match the pages.

`minutes` is a narration plan; `autoAdvanceSeconds` is a playback behavior. The two must be kept separate. Never auto-advance a page after a default 60 seconds just because it suggests narrating it for one minute.

## 3. Stable page IDs

Every page must have a unique, semantic, and stable ID:

```html
<section class="slide ..." data-slide-id="codepilot-capabilities">
```

- Use lowercase English slugs: `cover`, `codepilot-capabilities`, `demo-workflow`, `closing`.
- Keep the original ID when pages are reordered; only change it when a page's semantics fundamentally change.
- Don't use page numbers as IDs. Notes a presenter edits in the browser are saved by ID; stable IDs keep notes from leaking across pages after a reorder.

## 4. The `SPEAKER_NOTES` data structure

Keep one record matching each page ID in the deck, in exactly the same order as the slides:

```js
const SPEAKER_NOTES = [
  {
    id: 'codepilot-capabilities',
    title: 'What CodePilot can do',
    section: 'CodePilot',
    minutes: 0.9,
    purpose: 'Get the audience to grasp the full product first, then move into the implementation',
    talk: [
      'Walk capabilities through user actions, not the underlying Harness first',
      'Use four screenshots — home page, multi-model, Skills, sidebar — to build the full picture',
      'Emphasize that model, tools, and context work together in one workflow'
    ],
    transition: 'Once the audience sees what the product looks like, answer why it is built that way',
    cue: 'Point to the four capability areas in screenshot order',
    advance: 'Advance after covering the "same workflow" point'
  }
];
window.__SPEAKER_NOTES__ = SPEAKER_NOTES;
```

Required fields:

- `id`, `title`, `purpose`, `talk`, `transition`.
- `talk` defaults to 3–5 items, each expressing one idea; covers, chapter pages, and pure transition pages may be shorter.

Optional fields:

| Field | Purpose | When missing in the UI |
|---|---|---|
| `section` | chapter name and chapter progress | hide the chapter row |
| `minutes` | suggested narration minutes for this page | show `—` |
| `cue` | pause, demo, video, sensitive-info reminder | hide |
| `interaction` | live questions, raised hands, polls, or Q&A | hide |
| `delivery` | tone, emphasis, pace, or pauses | hide |
| `advance` | the sentence or action that times manual page turns | hide |
| `fallback` | alternate lines when a demo / video / network fails | hide |
| `pronunciation` | pronunciation of names, acronyms, and foreign words | hide |
| `autoAdvanceSeconds` | seconds this page auto-holds, overrides the global interval | use the global interval or don't auto-advance |

`cue`, `interaction`, `delivery`, `advance`, `fallback`, and `pronunciation` may each be a string or an array of strings.

## 5. Presenter UI behavior

- On a normal deck, the bottom-right control area shows `P Presenter Mode` — not a separate attention-grabbing floating button.
- Clicking it puts the current window into Presenter View and opens a separate audience screen.
- The body stays two columns: preview on the left, notes on the right; on the left, the current page on top and the next page below.
- The current- and next-page iframes must always hold strictly to `16:9`. When space is tight, keep margins and scale the whole thing down proportionally — never crop, squash, or reflow the inner text.
- Preview iframes load the HTML only on initial mount; page turns send the page number via `postMessage` instead of rewriting `src` and reloading the whole deck.
- On small screens, shrink the next-page preview first to give space to the current page.
- The bottom bar splits into three segments: on the left are three time groups — `elapsed / this page / remaining or overtime` — in the middle are two control rows (first row `first / prev / next / last`, second row `start or pause timing / reset timing / rehearse`), and on the right only `page # / total pages` plus a completion percentage. Don't repeat the current page title in the bottom bar. The timing buttons must be written plainly as "Start timing / Continue timing / Reset timing" so users never mistake them for resetting the whole talk.
- `Auto-advance` lives in the top-right status bar, not in the bottom navigation area.
- `Grid` sits beside the "current page" title. Once opened, the grid replaces the current/next preview area directly rather than popping a jarring fullscreen layer; cards show page number, title, section, and progress, and clicking a page returns immediately to the current/next preview. `ESC` toggles the grid.
- The right card shows `title / page purpose / draft (notes)` in that order, so the title or purpose never gets mixed into the draft body.
- Presenters can choose between "balanced / page-first / notes-first" layouts.
- Note edits are stored in `localStorage` keyed by `data-slide-id` with a save status; after switching pages the notes scroll back to the top, and font size is adjustable.
- `Home` / `End`, arrow keys, and PageUp/PageDown stay consistent with the visible buttons; the cursor inside the notes editor must not trigger page turns.
- While a dialog is open, `?` must not override it; only `Escape` closes the current dialog. On the last page, the "next page" preview shows "Presentation ended" rather than repeating the current page.
- The settings panel uses a recognizable card hierarchy; toggles use capsule switches, numeric intervals use a stepper with minus / value / plus, and the browser's native checkboxes or crude number inputs are never exposed directly.

## 6. Time control and rehearsal

- The timer starts explicitly by the user and can pause, continue, and reset; entering the mode must not start timing automatically.
- Show actual total time, actual time on this page, this page's plan, and remaining or overtime at the same time.
- Only when every page has `minutes` do you show the total plan and the estimated end time; if some pages lack it, show dashes.
- Show chapter position when `section` exists; show chapter time remaining only when every page of that chapter has a planned duration.
- Rehearsal mode records each page's actual duration plus the total, keeping the most recent 5 runs locally.
- Rehearsal results are plain data summaries — no "AI coach" style judgment.

## 7. Auto-advance

- Off by default; turned on explicitly by the user.
- A global interval can be set; a page's `autoAdvanceSeconds` takes priority when present.
- The auto countdown pauses when entering overview, during circling/annotation, with settings open, when the browser page is not visible, when the audience screen is black/white/frozen, or when the audience screen loses sync.
- On leaving a pause, resume from the original remaining time — don't restart the countdown.
- Stop after the last page; don't loop back to the first.

## 8. Laser pointer, circling, and audience-screen control

- `L` toggles the laser pointer; the red dot fades out briefly and is not saved.
- `C` toggles circling; annotations stay on the current page and clear on page turn.
- `X` clears annotations on the current page.
- All coordinates are normalized before being sent to the audience screen, so presenter-screen and audience-screen size differences do not matter.
- `B` toggles the audience screen black, `W` toggles it white, `F` freezes/resumes the audience screen.
- While frozen the presenter can keep advancing and the audience screen holds its old page; on resume it immediately catches up to the presenter's current page.

## 9. Audience-screen sync and recovery

The template syncs through window `postMessage`, `BroadcastChannel`, and `storage` events together. The audience page sends back a confirmation after loading and after every page turn; the presenter side displays:

- **Connecting**: audience window open, no confirmation yet.
- **Synced**: the audience page confirms the same page as the presenter, heartbeat valid.
- **Out of sync**: the audience heartbeat is still valid, but the two ends have different page numbers or sequence numbers.
- **Frozen**: the audience screen intentionally keeps its old page, not a sync failure.
- **Disconnected**: audience window never opened, was closed, or the heartbeat timed out. Even where some embedded browsers make the `window.closed` proxy unreliable, a heartbeat timeout must still land on "Disconnected".
- **Popup blocked**: the browser blocked opening the audience window.

"Reopen audience screen" must always be available and must send the current page immediately after recovery.

When the presenter exits Presenter Mode, `bye` must be sent. Audience windows opened by the script try to close themselves; if the browser does not allow self-closing, keep a dark "Presentation ended" overlay — never linger on the last page pretending the talk is still going.

The browser can only confirm the software sync state of the audience **page/window**; it cannot detect whether an HDMI, adapter, or projector cable is physically disconnected. Still visually confirm the external screen on site.

## 10. Pre-talk checks and shortcuts

The "check" panel verifies audience sync, popup permissions, fullscreen, fonts, images, video, and the current page's 16:9. Check results must never claim a physical external screen is connected.

| Key | Behavior |
|---|---|
| `L` | laser pointer |
| `C` | circling |
| `X` | clear marks |
| `B` / `W` | audience screen black / white |
| `F` | freeze / resume audience screen |
| `A` | enable / disable auto-advance |
| `R` | start / end rehearsal |
| `?` | open shortcut help |

## 11. Capability boundaries

This Presenter Mode depends only on the current HTML and the browser's local capabilities — no account or online service. Do not add by default:

- Live captions, speech-to-text, or external voice models.
- AI rehearsal coaching or scoring of the presenter.
- QR-code questions, online polls, or cloud interaction backends.
- Phone control or cross-device control that needs a server relay.

## 12. Post-generation validation

```bash
node <SKILL_ROOT>/scripts/validate-presenter-mode.mjs path/to/index.html
node <SKILL_ROOT>/scripts/validate-presenter-mode.mjs path/to/index.html --target-minutes 30
```

Hand-testing in the browser must cover at least: entering Presenter Mode; popup allow/block; turning forward and back without the preview iframe reloading; the in-page grid replacing the preview and returning after a page pick; first/last page; the last page's preview end state; restarting from the last page; showing "Disconnected" after the audience window closes; restoring sync after reopening; the audience screen closing or showing the end overlay after exiting Presenter Mode; note saving; timing; rehearsal records; auto-advance pause/resume; laser pointer; circling; clearing; black; white; freeze; the settings panel; and the pre-talk check.

Check at least one set of common sizes and one set of small-screen sizes: current page and next page stacked vertically, both iframes at `16:9`, and neither overflowing its own container.