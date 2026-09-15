# Muhammad Saad Ahsan — Portfolio

Personal portfolio of a Full-Stack Mobile Engineer, built with Flutter for the web.

A one-page site (hero, projects, experience, about, contact) plus a case-study page for every project at `/#/projects/<id>`. The visual design lives in `plan/*.dc.html`: a black and gold palette set in Oswald, Playfair Display and JetBrains Mono.

## Tech stack

| Area | Choice |
| --- | --- |
| Framework | Flutter (web) |
| State | Riverpod |
| Routing | go_router, nested so the one-page shell stays mounted under case studies |
| Animation | flutter_animate |
| Contact form | EmailJS REST API |
| Fonts | google_fonts |

## Project structure

```
lib/
├── app.dart                  MaterialApp.router + theme
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

- `assets/data/projects.json`: cards and full case studies (overview, architecture, features, screens, challenge and approach). The `id` is the URL slug. Set `githubUrl` to `null` for private repositories and the source button is hidden.
- `assets/data/experience.json`: timeline entries, newest first.
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
flutter build web --wasm
python tool/serve_web.py    # preview at http://localhost:8080
```

`--wasm` compiles to WebAssembly. Browsers with WasmGC (Chrome, Edge, Firefox) get the faster skwasm renderer, and the rest fall back to JavaScript and CanvasKit automatically. `tool/serve_web.py` serves the build gzip-compressed with the headers below, so it shows the load time you'll get in production.

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

## Contact form

Messages are sent from the browser through EmailJS. In the EmailJS dashboard, restrict the service to your production domain so the public keys can't be reused elsewhere. The form also validates input, limits field lengths and allows one send per minute.
