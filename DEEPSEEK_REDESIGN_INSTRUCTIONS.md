# SmartPlate UI Redesign — Precise Instructions for DeepSeek

> **How to use this document:**  
> Feed each numbered TASK block to DeepSeek one at a time. Each task is self-contained.  
> After DeepSeek replies, paste the output into the correct file, then move to the next task.  
> Do NOT send all tasks at once.

---

## CONTEXT (read before every task)

SmartPlate is a restaurant management system. It has 6 HTML files:

- `index.html` — login page (all roles)
- `customer-dashboard.html` — customer portal (browse menu, place order, view orders, notifications)
- `chef-dashboard.html` — chef portal
- `employee-dashboard.html` — employee portal
- `supplier-dashboard.html` — supplier portal
- `manager-dashboard.html` — manager portal (most complex: many nav panels)

**Two separate design themes apply:**

| File | Theme |
|------|-------|
| `index.html` | Pixelated café (described below) |
| `customer-dashboard.html` | Pixelated café (described below) |
| `chef-dashboard.html` | Clean professional dark (described below) |
| `employee-dashboard.html` | Clean professional dark |
| `supplier-dashboard.html` | Clean professional dark |
| `manager-dashboard.html` | Clean professional dark |

---

## THEME SPECIFICATIONS

### A — Pixelated Café Theme (index.html + customer-dashboard.html)

**Palette:**
```
--bg:       #1a0f0a        /* dark espresso brown */
--surface:  #2d1f18        /* medium roast */
--surface2: #3d2b21        /* lighter panel */
--border:   #5c3d2e        /* warm brown border */
--accent:   #f4a535        /* golden caramel */
--accent2:  #e8724a        /* warm terracotta */
--text:     #f5e6d3        /* cream */
--muted:    #a07060        /* dusty rose-brown */
--green:    #7ec87e        /* mint leaf */
--red:      #e05050
--yellow:   #f4d03f
```

**Typography:**
```css
@import url('https://fonts.googleapis.com/css2?family=Press+Start+2P&family=VT323:wght@400&family=Nunito:wght@400;600;700&display=swap');

/* Headings, logo, nav labels: 'Press Start 2P' */
/* Secondary pixel text (prices, labels): 'VT323' */
/* Body text, descriptions, form inputs: 'Nunito' */
```

**Visual rules:**
- All borders: `2px solid var(--border)` with `border-radius: 0` (pixel-sharp, no rounded corners anywhere)
- Cards use `box-shadow: 4px 4px 0px var(--border)` (hard pixel shadow, no blur)
- Background: repeating checkered pattern using CSS `background-image: repeating-conic-gradient(#1a0f0a 0% 25%, #211410 0% 50%)` with `background-size: 20px 20px`
- Sidebar background: `var(--surface)` with a faint vertical stripe texture: `repeating-linear-gradient(180deg, transparent 0px, transparent 18px, rgba(255,255,255,0.015) 18px, rgba(255,255,255,0.015) 19px)`
- Buttons: pixel border style with hover animation (described in ANIMATIONS section)
- Active nav item: left border 4px solid `var(--accent)`, background `rgba(244,165,53,0.1)`
- All `input` and `select` elements: background `var(--surface2)`, border `2px solid var(--border)`, border-radius 0, color `var(--text)`, font-family Nunito

### B — Professional Dark Theme (chef, employee, supplier, manager dashboards)

**Palette:**
```
--bg:       #0d1117
--surface:  #161b22
--surface2: #21262d
--border:   #30363d
--accent:   #58a6ff
--accent2:  #3fb950
--text:     #e6edf3
--muted:    #8b949e
--red:      #f85149
--yellow:   #d29922
--orange:   #db6d28
```

**Typography:**
```css
@import url('https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;600&family=Inter:wght@400;500;600&display=swap');

/* Sidebar nav, code, numbers, IDs: 'JetBrains Mono' */
/* Everything else: 'Inter' */
```

**Visual rules:**
- `border-radius: 6px` for cards and buttons, `4px` for inputs
- Cards: `box-shadow: 0 1px 3px rgba(0,0,0,0.4)`
- Sidebar: solid `var(--surface)`, left border 1px `var(--border)` on right side
- Active nav: background `rgba(88,166,255,0.1)`, left border 3px `var(--accent)`
- Tables: alternating row background: even rows `rgba(255,255,255,0.02)`
- Inputs: background `var(--surface2)`, border `1px solid var(--border)`, border-radius 4px

---

## ANIMATIONS SPECIFICATION

### Café theme button animation (apply to ALL buttons in index.html and customer-dashboard.html):
```css
.btn {
  transition: transform 0.08s, box-shadow 0.08s;
  box-shadow: 4px 4px 0 var(--border);
}
.btn:hover {
  transform: translate(-2px, -2px);
  box-shadow: 6px 6px 0 var(--border);
}
.btn:active {
  transform: translate(2px, 2px);
  box-shadow: 2px 2px 0 var(--border);
}
```

### Professional theme button animation (chef, employee, supplier, manager):
```css
.btn {
  transition: background 0.15s, opacity 0.15s, transform 0.1s;
}
.btn:hover {
  filter: brightness(1.1);
  transform: translateY(-1px);
}
.btn:active {
  transform: translateY(0);
}
```

### Nav item hover (café):
```css
.nav-item {
  transition: color 0.1s, background 0.1s, border-left-color 0.1s;
  image-rendering: pixelated;
}
.nav-item:hover {
  background: rgba(244,165,53,0.07);
  color: var(--accent);
}
```

### Café login card entrance animation:
```css
@keyframes pixelIn {
  0%   { opacity: 0; transform: translateY(12px) scale(0.97); }
  60%  { opacity: 1; transform: translateY(-3px) scale(1.01); }
  100% { opacity: 1; transform: translateY(0) scale(1); }
}
.card { animation: pixelIn 0.4s ease forwards; }
```

### Pixel cursor blink (for loading text in café theme):
```css
@keyframes blink { 0%,49%{opacity:1} 50%,100%{opacity:0} }
.pixel-cursor::after { content:'█'; animation: blink 0.8s step-end infinite; color: var(--accent); }
```

---

## THE CAT (customer-dashboard.html only)

Place a small pixel-art cat in the bottom-right corner of the sidebar (`aside`), above the sign-out button.

Implement the cat as an inline SVG (pixel art, 32×32 viewBox, each "pixel" is a 2×2 rect).

**Cat color palette:**
- Body: `#f5c589` (orange tabby)
- Stripes: `#c88a40`
- Eyes: `#7ec87e` (green, matching --green)
- Nose: `#e87070`
- Outline: `#2d1f18`

**Cat idle animation (CSS, infinite):**
```css
@keyframes catBlink {
  0%, 90%, 100% { opacity: 1; }
  95%            { opacity: 0; }
}
/* Apply to the eye rects only using a wrapper g#cat-eyes */
#cat-eyes { animation: catBlink 3s infinite; }
```

**Cat tail wag animation:**
```css
@keyframes tailWag {
  0%, 100% { transform: rotate(0deg); }
  25%       { transform: rotate(12deg); }
  75%       { transform: rotate(-12deg); }
}
/* Apply to a g#cat-tail group, transform-origin at tail base */
#cat-tail { animation: tailWag 1.2s ease-in-out infinite; transform-origin: 14px 28px; }
```

**Cat hover interaction:** On hover over the SVG, add a `title` tooltip that says `"ฅ^•ﻌ•^ฅ Meow!"`. Also add a `cursor: pointer` style.

**Placement:** Inside `aside`, after `.nav-item` list, before `.aside-footer`:
```html
<div class="cat-container" style="text-align:center; padding: 12px 0 4px;">
  <!-- SVG here -->
  <div style="font-family:'Press Start 2P'; font-size:7px; color:var(--muted); margin-top:4px;">cafe cat</div>
</div>
```

---

## ELEMENTS TO REMOVE

### From index.html — REMOVE:
- The `.role-badges` div (the row showing Customer, Chef, Employee, Supplier, Manager badges at the bottom). It has no function.
- The three `.orb` background divs (`.orb1`, `.orb2`, `.orb3`) and the `.bg-orbs` wrapper. The café checkered background replaces it.

### From customer-dashboard.html — REMOVE:
- The `#auth-guard` loading overlay div and its associated CSS. Replace the auth check logic: instead of toggling display, redirect to `index.html` immediately if no valid token, with no visual loading state.
- The inline `style=""` attributes on the two wrapping divs inside `panel-menu` (the flex layout). Move those styles to the `<style>` block as `.menu-layout` and `.cart-column` classes.

### From chef-dashboard.html — REMOVE:
- Any decorative emoji that are purely ornamental in section headers (keep them in nav items only).

### From employee-dashboard.html — REMOVE:
- Same: any purely decorative emoji in section headings.

### From manager-dashboard.html — REMOVE:
- The `#panel-forecast` panel's two secondary buttons `fc-apply-stocks` and `fc-apply-prices` if they have no attached event listener in the JS. Check: search for `fc-apply-stocks` and `fc-apply-prices` in the script — if you find no `addEventListener` or `onclick` wiring, delete those buttons.
- Any `<button>` element whose `onclick` attribute is empty (`onclick=""`) or whose handler function is defined as an empty function body `function x(){}`.

---

## TASK 1 — Rewrite `index.html` (Café Login Page)

**Input:** The current `index.html` content (paste it in full).

**Instructions:**

Rewrite `index.html` completely. Preserve ALL JavaScript logic exactly — do not change any variable names, API URL, ROLE_PAGES mapping, `login()` function, or `sessionStorage` calls. Only change the HTML structure and CSS.

Apply the Café theme (Theme A above). Apply the pixelIn card animation. Remove the orb divs and role badges. Add the Google Fonts import at the top of `<style>`. Apply the café button animations to `.btn`.

The layout must remain: centered card, logo above it, email + password fields, one Sign In button, error text below button.

**Logo area changes:**
- Replace the `🍽` emoji with this text in Press Start 2P font: `SP`
- Title: `SmartPlate` in Press Start 2P, 18px
- Subtitle: `restaurant mgmt system` in VT323, 20px, color `var(--muted)`

**Output:** A complete, self-contained `index.html` file. No explanation, just the file.

---

## TASK 2 — Rewrite `customer-dashboard.html` (Café Customer Portal)

**Input:** The current `customer-dashboard.html` content (paste it in full).

**Instructions:**

Rewrite `customer-dashboard.html` completely. Preserve ALL JavaScript logic exactly — every function (`loadMenu`, `placeOrder`, `addToOrder`, `loadOrders`, `loadAlerts`, `show`, `signout`, `renderCart`, `esc`, `ah`, the IIFE auth check). Change only HTML structure and CSS.

Apply the Café theme (Theme A). Apply café button animations. Apply nav item hover animations.

**Sidebar changes:**
- Logo: `SP` in Press Start 2P 10px, `SmartPlate` in Press Start 2P 13px, `Customer Portal` in VT323 18px
- Nav section labels: Press Start 2P, 7px, color `var(--muted)`
- Nav items: Nunito 13px
- Insert the pixel-art cat (as specified in THE CAT section) between the nav items and `.aside-footer`
- User pill: keep it, style with café theme
- Sign Out button: apply café button animation (translate + hard shadow)

**Menu cards:**
- border-radius: 0 (pixel sharp)
- box-shadow: 4px 4px 0 var(--border)
- Item name: Nunito bold 15px
- Price: VT323 28px, color var(--accent)
- "Add" button: café animation, background var(--accent), color #1a0f0a, font Nunito bold

**Cart box:**
- Hard pixel border: `2px solid var(--border)`, box-shadow `4px 4px 0 var(--border)`, border-radius 0
- "Start New Order" / place order button: full width, café animation

**Remove:** auth-guard overlay div + CSS. Auth check IIFE stays but remove the `display` toggle lines, replace with: `if(!token || role !== 'customer'){ window.location.href='index.html'; return; }`

**Output:** Complete self-contained `customer-dashboard.html`. No explanation, just the file.

---

## TASK 3 — Rewrite `chef-dashboard.html` (Professional Dark)

**Input:** The current `chef-dashboard.html` content (paste it in full).

**Instructions:**

Rewrite `chef-dashboard.html` completely. Preserve ALL JavaScript exactly. Change only HTML and CSS.

Apply the Professional Dark theme (Theme B). Apply professional button animations. Add Google Fonts import (JetBrains Mono + Inter).

**Sidebar:**
- Logo text: `SmartPlate` in JetBrains Mono bold 13px, `Chef Station` in Inter 11px color var(--muted)
- Nav item font: Inter 13px
- Nav item hover + active styles from Theme B

**Content area:**
- Cards: border-radius 6px, shadow `0 1px 3px rgba(0,0,0,0.4)`
- Tables: alternating rows
- Action buttons: professional animation
- Font: Inter throughout, JetBrains Mono for IDs/numbers/codes

**Output:** Complete self-contained `chef-dashboard.html`. No explanation, just the file.

---

## TASK 4 — Rewrite `employee-dashboard.html` (Professional Dark)

**Input:** The current `employee-dashboard.html` content (paste it in full).

**Instructions:** Same as Task 3, except:
- Sidebar subtitle: `Employee Portal`
- Apply Professional Dark theme (Theme B)
- Preserve all JS exactly
- Apply professional button animations

**Output:** Complete self-contained `employee-dashboard.html`. No explanation, just the file.

---

## TASK 5 — Rewrite `supplier-dashboard.html` (Professional Dark)

**Input:** The current `supplier-dashboard.html` content (paste it in full).

**Instructions:** Same as Task 3, except:
- Sidebar subtitle: `Supplier Portal`
- Apply Professional Dark theme (Theme B)
- Preserve all JS exactly

**Output:** Complete self-contained `supplier-dashboard.html`. No explanation, just the file.

---

## TASK 6 — Rewrite `manager-dashboard.html` (Professional Dark)

**Input:** The current `manager-dashboard.html` content (paste it in full).

**Instructions:**

Rewrite `manager-dashboard.html` completely. Preserve ALL JavaScript exactly. Change only HTML and CSS.

Apply Professional Dark theme (Theme B). Apply professional button animations.

**Special handling for manager (large file):**
- This file is large. If DeepSeek truncates output, instruct it to output in two parts: PART 1 = everything from `<!DOCTYPE html>` to `</style>`, PART 2 = everything from `<body>` to end of file.
- Maintain the exact same panel IDs (`panel-overview`, `panel-menu`, etc.)
- Maintain the exact same button IDs and onclick attributes

**Button audit before rewriting:** Before rewriting, scan all `<button>` elements. If a button's `id` is referenced in the JS only by a commented-out line, or its `onclick` calls a function that does not exist in the `<script>` block, remove that button. Otherwise keep all buttons.

**Sidebar:**
- Subtitle: `Manager Console`
- Nav font: JetBrains Mono 12px (fits more items cleanly)
- All 12 nav items must be preserved

**Output:** Complete self-contained `manager-dashboard.html`. If outputting in two parts, label them clearly. No explanation, just the file(s).

---

## VERIFICATION CHECKLIST

After all 6 tasks, verify:

- [ ] `index.html` has no `.orb` divs, no `.role-badges` div
- [ ] `index.html` login JS is identical to original (compare `login()` function line by line)
- [ ] `customer-dashboard.html` has the pixel cat SVG in the sidebar
- [ ] `customer-dashboard.html` has no `#auth-guard` div
- [ ] `customer-dashboard.html` cat has `catBlink` and `tailWag` animations
- [ ] `customer-dashboard.html` all `btn` classes have café button animation (translate + hard shadow)
- [ ] `customer-dashboard.html` menu card prices use VT323 font
- [ ] `customer-dashboard.html` preserves `loadMenu()`, `placeOrder()`, `addToOrder()`, `loadOrders()`, `renderCart()`, `loadAlerts()` unchanged
- [ ] Chef/Employee/Supplier/Manager dashboards all use JetBrains Mono + Inter fonts
- [ ] All 5 dashboards preserve sessionStorage auth check and role-based redirect
- [ ] All buttons on all pages have a hover animation (either café or professional)
- [ ] No button has an empty `onclick=""` attribute
- [ ] `manager-dashboard.html` still has all 12 nav items

---

## ADDITIONAL INSTRUCTIONS FOR DEEPSEEK

- Output only the file content. No markdown code fences. No preamble. No "Sure, here is..." text.
- When I say "preserve JS exactly" I mean: do not rename variables, do not change API endpoint strings, do not reorder function definitions, do not add or remove fetch calls.
- If a CSS rule conflicts between the original file and these instructions, these instructions win.
- If you are unsure about a font size, default to the value in these instructions.
- Use only Google Fonts CDN (fonts.googleapis.com). No other external font CDNs.
- Do not add any new JavaScript features or API calls not in the original file.
- `Press Start 2P` has very limited characters per em — use it sparingly and only at small sizes (7–18px). Never use it for body text or long strings.
