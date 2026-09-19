# Muhammad Saad Ahsan — Portfolio

Personal portfolio of a Full-Stack Mobile Engineer, built with Flutter for the web.

A one-page site (hero, projects, education, experience, about, contact) plus a case-study page for every project at `/projects/<id>`. The visual design lives in `plan/*.dc.html`: a black and gold palette set in Oswald, Playfair Display and JetBrains Mono.

## Tech stack

| Area | Choice |
| --- | --- |
| Framework | Flutter (web) |
| State | Riverpod |
| Routing | go_router, nested so the one-page shell stays mounted under case studies |
| Animation | flutter_animate |
| Contact form | Cloudflare Pages Function + Brevo transactional email |
| Hosting | Cloudflare Pages — https://saadahsan626.pages.dev |
| Fonts | google_fonts |

## Project structure

```
lib/
├── app.dart                  MaterialApp.router, theme, browser-tab title
├── core/
│   ├── constants/            breakpoints, contact links
│   ├── router/               routes and section navigation
│   ├── theme/                colour, type and spacing tokens
│   └── utils/                responsive helpers (fluid sizes, auto-fit grids)
├── data/
│   ├── models/               project, experience, skill
│   └── repositories/         loads assets/data/*.json
├── features/
│   ├── shell/                nav bar, drawer, footer, one-page scroll view
│   ├── home/  projects/  experience/  about/  contact/
│   └── project_detail/       case-study page
├── providers/                Riverpod providers
└── shared/widgets/           buttons, cards, section header, reveal-on-scroll
```

## Editing content

All copy that changes over time is data, not code:

- `assets/data/projects.json`: cards and full case studies (overview, architecture, features, screens, challenge and approach). The `id` is the URL slug. `metaDescription` is the snippet Google shows for the case study; keep it under about 155 characters. Set `githubUrl` to `null` for private repositories and the source button is hidden.
- `assets/data/education.json` and `assets/data/experience.json`: timeline entries, newest first.
- `assets/data/skills.json`: the Core Competencies pills.

To add case-study screenshots, drop WebP files in `assets/projects-images/` and list them under the project's `screens`.

## Running

```bash
flutter pub get
flutter run -d chrome
```

`flutter run` is a debug build and loads far slower than the real site. Judge load time from a release build.

```bash
flutter test
```

## Building for production

```bash
python tool/build_site.py
```

```bash
python tool/serve_web.py
```

`tool/build_site.py` runs `flutter build web --wasm` and then adds the SEO layer (see [Search engines](#search-engines)). Always build with it rather than calling `flutter build web` directly, or the deployed site loses its search text, structured data, case-study pages and sitemap.

`--wasm` compiles to WebAssembly. Browsers with WasmGC (Chrome, Edge, Firefox) get the faster skwasm renderer, and the rest fall back to JavaScript and CanvasKit automatically. `tool/serve_web.py` previews the build at http://localhost:8080, gzip-compressed with the headers below and with Cloudflare Pages' URL handling, so it shows the load time and routing you'll get in production.

### Load-time notes

- **Loading screen.** `web/index.html` renders a static copy of the nav and hero while Flutter starts, and crossfades to the app on its first frame. If you change the hero copy or layout in `home_section.dart`, update the preview to match.
- **Icons.** Brand logos come from `assets/fonts/BrandIcons.ttf`, a 3 KB subset of Simple Icons. Flutter downloads app fonts before the first frame, so avoid adding whole icon packages.
- **Hosting headers.** Cross-origin isolation lets skwasm render on multiple threads. Without it the site still works, single-threaded. `web/_headers` covers Netlify and Cloudflare Pages. On Firebase Hosting, add this to `firebase.json`:

  ```json
  "headers": [{
    "source": "**",
    "headers": [
      { "key": "Cross-Origin-Opener-Policy", "value": "same-origin" },
      { "key": "Cross-Origin-Embedder-Policy", "value": "credentialless" }
    ]
  }]
  ```

  On Vercel, put the same two headers in `vercel.json` under `"headers"`.

## Search engines

Flutter draws the page on a canvas, so on its own a crawler finds almost no text. `tool/build_site.py` fixes that after each build, using the same JSON the app reads:

- **Text version of the page.** A visually hidden copy of the content (name, about, projects, education, experience, skills, contact) replaces the `<!-- seo:content -->` marker in `index.html`. Search engines and screen readers read it; visitors see the Flutter app.
- **Structured data.** JSON-LD for `ProfilePage`, `Person` and `WebSite` replaces `<!-- seo:head -->`. The `Person` lists the name variants, job title, portrait, GitHub and LinkedIn (`sameAs`), UET Lahore and Codrax, which is what connects searches for "Saad Ahsan" to this site.
- **A page per case study.** `build/web/projects/<id>.html` has its own title, `metaDescription`, canonical URL, social tags, breadcrumb data and text. Cloudflare Pages serves it at `/projects/<id>`, where Flutter takes over and routes to the same case study.
- **`sitemap.xml`**, listed in `web/robots.txt`.

The site uses path URLs (`/projects/campus-pulse`, not `/#/projects/campus-pulse`) because search engines ignore everything after `#`. The browser-tab title follows the route (`lib/app.dart`).

The hero and About paragraphs are written in Dart, so the script keeps its own copy (`HERO_LINE`, `ABOUT_TEXT`). Update both when you change that copy.

### Google Search Console (one time)

1. Open [Search Console](https://search.google.com/search-console), **Add property** → **URL prefix** → `https://saadahsan626.pages.dev/`.
2. Choose **HTML tag** verification and copy the `content` value of the tag Google shows.
3. Add the tag to `web/index.html`, next to the other `<meta>` tags, then rebuild and deploy:

   ```html
   <meta name="google-site-verification" content="YOUR-TOKEN">
   ```

4. Click **Verify**, then **Sitemaps** → submit `sitemap.xml`.
5. **URL inspection** → paste `https://saadahsan626.pages.dev/` → **Request indexing**. Repeat for each case study.

Optionally, in [Bing Webmaster Tools](https://www.bing.com/webmasters), **Import from Google Search Console** covers Bing, DuckDuckGo and Yahoo.

Links from other sites decide how fast and how high the site appears. Put `https://saadahsan626.pages.dev` in the GitHub profile's **Website** field, the portfolio repository's **About → Website**, LinkedIn's **Contact info → Website** and the CV.

## Contact form

The form posts to `/api/contact`, a Cloudflare Pages Function in [`functions/api/contact.js`](functions/api/contact.js). It validates the input again on the server, refuses requests from other sites, and emails the message to `CONTACT_EMAIL` through Brevo with **Reply-To set to the visitor**. The Brevo API key is a Pages secret and never reaches the browser. The Flutter form keeps its own validation, field limits and one-send-per-minute cooldown.

`/api/contact` only exists on Cloudflare (or under `npx wrangler pages dev`), so sending from `flutter run` shows "Couldn't send".

### One-time Brevo setup

1. **Verify the sender:** Senders, Domains & Dedicated IPs → Senders → add `saadahsan039@gmail.com` (the `CONTACT_EMAIL` in `wrangler.toml`) and confirm it.
2. **Create an API key:** Settings → SMTP & API → API Keys → generate `portfolio-contact`. It is shown once.
3. **Allow Cloudflare's IPs:** Security → Authorised IPs → turn off IP blocking. Cloudflare Functions call from changing IPs, and Brevo rejects unknown ones otherwise.

## Deploying (Cloudflare Pages)

The site is the Pages project **`saadahsan626`**, configured in [`wrangler.toml`](wrangler.toml). Deploy with Wrangler rather than the dashboard's drag-and-drop upload, which does not include the `functions/` folder.

First time only:

```bash
npx wrangler login
```

```bash
npx wrangler pages project create saadahsan626 --production-branch main
```

```bash
npx wrangler pages secret put BREVO_API_KEY
```

Every release:

```bash
python tool/build_site.py
```

```bash
npx wrangler pages deploy
```

### Testing the contact form locally

Copy `.dev.vars.example` to `.dev.vars` (git-ignored) and add your Brevo key, then:

```bash
python tool/build_site.py
```

```bash
npx wrangler pages dev
```

Open the local URL Wrangler prints and send a test message. It should arrive from "Portfolio Contact", and **Reply** should address the visitor.
