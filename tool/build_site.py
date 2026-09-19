"""Build the production site: `flutter build web --wasm`, then the SEO layer.

Flutter draws the whole page on a canvas, so search engines see almost no
text. After the Flutter build this script adds, from the same JSON the app
reads (assets/data/*.json):

  * a crawlable text version of the page (visually hidden, readable by search
    engines and screen readers) in place of `<!-- seo:content -->`;
  * structured data (ProfilePage + Person + WebSite) in place of
    `<!-- seo:head -->`, which is what Google uses for name searches;
  * one prerendered page per case study at /projects/<id>.html with its own
    title, description, canonical URL and breadcrumb data (Cloudflare Pages
    serves it at /projects/<id>);
  * sitemap.xml.

    python tool/build_site.py              # WebAssembly build + SEO
    python tool/build_site.py --skip-build # SEO only, on an existing build

Hero and About copy live in Dart (home_section.dart, about_section.dart);
keep HERO_LINE and ABOUT_TEXT below in sync with them.
"""

import argparse
import datetime
import html
import json
import os
import re
import shutil
import subprocess
import sys

SITE = 'https://saadahsan626.pages.dev'
NAME = 'Muhammad Saad Ahsan'
SHORT_NAME = 'Saad Ahsan'
JOB_TITLE = 'Full-Stack Mobile Engineer'
EMAIL = 'saadahsan039@gmail.com'
GITHUB = 'https://github.com/Saad-Ahsan626'
LINKEDIN = 'https://www.linkedin.com/in/saad-ahsan-55201336a/'
PORTRAIT = f'{SITE}/assets/assets/images/saad.jpg'
OG_IMAGE = f'{SITE}/icons/og-image.png'

HERO_LINE = (
    'I am Muhammad Saad Ahsan, a Full-Stack Mobile Engineer building scalable '
    'products, from intuitive Flutter interfaces to resilient backend systems.'
)
ABOUT_TEXT = (
    'I am a Full-Stack Mobile Engineer and Computer Science student at UET Lahore. '
    'I build production-ready Flutter apps with clean architecture and offline-first '
    'data, and design the secure, well-structured APIs behind them with TypeScript, '
    'NestJS and Prisma. Right now I\'m focused on system design: software that scales, '
    'stays reliable under load and remains easy to evolve. I\'m available for freelance '
    'projects and collaborations.'
)

ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), '..'))
BUILD = os.path.join(ROOT, 'build', 'web')
DATA = os.path.join(ROOT, 'assets', 'data')

HEAD_MARKER = '<!-- seo:head — structured data, filled in by tool/build_site.py -->'
CONTENT_MARKER = '<!-- seo:content — text version of the page, filled in by tool/build_site.py -->'

e = html.escape


def load(name):
    with open(os.path.join(DATA, name), encoding='utf-8') as f:
        return json.load(f)


def write(path, text):
    with open(path, 'w', encoding='utf-8', newline='\n') as f:
        f.write(text)


def clip(text, limit=158):
    """Trims a meta description at a word boundary."""
    text = ' '.join(text.split())
    if len(text) <= limit:
        return text
    return text[: text.rfind(' ', 0, limit - 1)].rstrip(',;:—-') + '…'


def jsonld(graph):
    data = json.dumps({'@context': 'https://schema.org', '@graph': graph}, ensure_ascii=False, indent=2)
    data = data.replace('</', '<\\/')  # '</' must not appear inside a <script> block
    return '<script type="application/ld+json">\n' + data + '\n</script>'


def person(skills, experience, education):
    current = experience[0] if experience else None
    node = {
        '@type': 'Person',
        '@id': f'{SITE}/#person',
        'name': NAME,
        'alternateName': [SHORT_NAME, 'Saad-Ahsan626'],
        'givenName': 'Muhammad Saad',
        'familyName': 'Ahsan',
        'jobTitle': JOB_TITLE,
        'description': HERO_LINE,
        'url': f'{SITE}/',
        'image': PORTRAIT,
        'email': f'mailto:{EMAIL}',
        'sameAs': [GITHUB, LINKEDIN],
        'knowsAbout': [s['name'] for s in skills],
        'address': {'@type': 'PostalAddress', 'addressRegion': 'Punjab', 'addressCountry': 'PK'},
    }
    if education:
        node['alumniOf'] = {'@type': 'CollegeOrUniversity', 'name': education[0]['institution']}
    if current and 'Present' in current['duration']:
        node['worksFor'] = {'@type': 'Organization', 'name': current['company']}
    return node


def website():
    return {
        '@type': 'WebSite',
        '@id': f'{SITE}/#website',
        'url': f'{SITE}/',
        'name': NAME,
        'inLanguage': 'en',
        'publisher': {'@id': f'{SITE}/#person'},
    }


def links(label=True):
    items = [
        f'<li><a tabindex="-1" href="mailto:{EMAIL}">Email: {EMAIL}</a></li>',
        f'<li><a tabindex="-1" href="{GITHUB}">GitHub: Saad-Ahsan626</a></li>',
        f'<li><a tabindex="-1" href="{LINKEDIN}">LinkedIn: {SHORT_NAME}</a></li>',
    ]
    return ('<h2>Contact</h2>' if label else '') + '<ul>' + ''.join(items) + '</ul>'


def home_content(projects, experience, education, skills):
    parts = [
        '<div id="seo-content" class="sr-only">',
        f'<header><h1>{e(NAME)} — {e(JOB_TITLE)}</h1><p>{e(HERO_LINE)}</p></header>',
        f'<section><h2>About</h2><p>{e(ABOUT_TEXT)}</p></section>',
        '<section><h2>Selected projects</h2><ul>',
    ]
    for p in projects:
        parts.append(
            f'<li><h3><a tabindex="-1" href="/projects/{e(p["id"])}">{e(p["title"])}</a></h3>'
            f'<p>{e(p["description"])}</p><p>Built with {e(", ".join(p["techStack"]))}.</p></li>'
        )
    parts.append('</ul></section><section><h2>Education</h2><ul>')
    for ed in education:
        parts.append(
            f'<li><h3>{e(ed["title"])}, {e(ed["institution"])}</h3><p>{e(ed["duration"])}</p>'
            f'<p>{e(ed["description"])}</p><p>Subjects: {e(", ".join(ed["subjects"]))}.</p></li>'
        )
    parts.append('</ul></section><section><h2>Work experience</h2><ul>')
    for x in experience:
        parts.append(
            f'<li><h3>{e(x["role"])} at {e(x["company"])}</h3><p>{e(x["duration"])}</p>'
            f'<p>{e(x["description"])}</p><p>Stack: {e(", ".join(x["techStack"]))}.</p></li>'
        )
    parts.append('</ul></section><section><h2>Skills</h2><ul>')
    parts.extend(f'<li>{e(s["name"])}</li>' for s in skills)
    parts.append(f'</ul></section><section>{links()}</section></div>')
    return '\n'.join(parts)


def project_content(p, index, projects):
    others = [q for q in projects if q['id'] != p['id']]
    parts = [
        '<div id="seo-content" class="sr-only">',
        '<nav aria-label="Breadcrumb"><a tabindex="-1" href="/">Muhammad Saad Ahsan</a> / Projects</nav>',
        f'<header><p>Project {index + 1:02d} · {e(p["kind"])} · {e(p["year"])}</p>'
        f'<h1>{e(p["title"])}</h1><p>{e(p["description"])}</p></header>',
        '<dl>' + ''.join(f'<dt>{e(f["label"])}</dt><dd>{e(f["value"])}</dd>' for f in p['facts']) + '</dl>',
        f'<section><h2>Overview</h2><h3>{e(p["headline"])}</h3><p>{e(p["overview"])}</p>'
        f'<p>Stack: {e(", ".join(p["techStack"]))}.</p></section>',
        '<section><h2>Architecture</h2><ol>' + ''.join(f'<li>{e(a)}</li>' for a in p['architecture']) + '</ol></section>',
        '<section><h2>Key features</h2><ul>'
        + ''.join(f'<li><h3>{e(f["title"])}</h3><p>{e(f["body"])}</p></li>' for f in p['features'])
        + '</ul></section>',
        f'<section><h2>The challenge</h2><p>{e(p["challenge"])}</p>'
        f'<h2>The approach</h2><p>{e(p["approach"])}</p></section>',
        f'<section><h2>Screens</h2><ul>' + ''.join(f'<li>{e(s["label"])}</li>' for s in p['screens']) + '</ul></section>',
        '<section><h2>More projects</h2><ul>'
        + ''.join(f'<li><a tabindex="-1" href="/projects/{e(q["id"])}">{e(q["title"])}</a></li>' for q in others)
        + '</ul></section>',
    ]
    if p.get('githubUrl'):
        parts.append(f'<p><a tabindex="-1" href="{e(p["githubUrl"])}">Source code on GitHub</a></p>')
    parts.append(f'<section>{links()}</section></div>')
    return '\n'.join(parts)


def project_graph(p):
    url = f'{SITE}/projects/{p["id"]}'
    return [
        {
            '@type': 'WebPage',
            '@id': url,
            'url': url,
            'name': f'{p["title"]} — Case Study',
            'description': p['description'],
            'isPartOf': {'@id': f'{SITE}/#website'},
            'about': {'@id': f'{url}#project'},
            'breadcrumb': {'@id': f'{url}#breadcrumb'},
        },
        {
            '@type': 'CreativeWork',
            '@id': f'{url}#project',
            'name': p['title'],
            'description': p['description'],
            'url': url,
            'image': f'{SITE}/assets/{p["imageUrl"]}' if p.get('imageUrl') else OG_IMAGE,
            'keywords': ', '.join(p['techStack']),
            'dateCreated': p['year'],
            'creator': {'@id': f'{SITE}/#person'},
            **({'codeRepository': p['githubUrl']} if p.get('githubUrl') else {}),
        },
        {
            '@type': 'BreadcrumbList',
            '@id': f'{url}#breadcrumb',
            'itemListElement': [
                {'@type': 'ListItem', 'position': 1, 'name': NAME, 'item': f'{SITE}/'},
                {'@type': 'ListItem', 'position': 2, 'name': p['title'], 'item': url},
            ],
        },
    ]


def set_meta(page, *, title, description, url):
    """Rewrites the title, description and canonical/social URLs of a page."""
    subs = [
        (r'<title>.*?</title>', f'<title>{e(title)}</title>'),
        (r'(<meta name="description"\s+content=")[^"]*(")', rf'\g<1>{e(description)}\g<2>'),
        (r'(<link rel="canonical" href=")[^"]*(")', rf'\g<1>{url}\g<2>'),
        (r'(<meta property="og:url" content=")[^"]*(")', rf'\g<1>{url}\g<2>'),
        (r'(<meta name="twitter:url" content=")[^"]*(")', rf'\g<1>{url}\g<2>'),
        (r'(<meta property="og:title" content=")[^"]*(")', rf'\g<1>{e(title)}\g<2>'),
        (r'(<meta name="twitter:title" content=")[^"]*(")', rf'\g<1>{e(title)}\g<2>'),
        (r'(<meta property="og:description"\s+content=")[^"]*(")', rf'\g<1>{e(description)}\g<2>'),
        (r'(<meta name="twitter:description"\s+content=")[^"]*(")', rf'\g<1>{e(description)}\g<2>'),
        (r'<meta property="og:type" content="profile">', '<meta property="og:type" content="article">'),
    ]
    for pattern, replacement in subs:
        page, count = re.subn(pattern, replacement, page, count=1, flags=re.S)
        if count != 1 and 'og:type' not in pattern:
            sys.exit(f'build_site: could not update {pattern!r} in index.html')
    # Profile-only tags don't belong on a case study.
    return re.sub(r'\s*<meta property="profile:[^>]*>', '', page)


def case_study_preview(page, p, index):
    """Swaps the home hero in the loading preview for the case-study header."""
    header = (
        '<main class="pv-hero" style="display:block">'
        '<div class="pv-copy">'
        f'<p class="pv-caption" style="text-align:left;margin:0">PROJECT {index + 1:02d} · '
        f'{e(p["kind"].upper())} · {e(p["year"])}</p>'
        f'<p class="pv-role" style="color:var(--text);text-transform:uppercase">{e(p["title"])}</p>'
        f'<p class="pv-lead" style="max-width:720px;color:var(--muted)">{e(p["description"])}</p>'
        '</div></main>'
    )
    page, count = re.subn(r'<main class="pv-hero">.*?</main>', header, page, count=1, flags=re.S)
    if count != 1:
        sys.exit('build_site: preview <main class="pv-hero"> not found in index.html')
    # The nav highlights Projects on a case study.
    return page.replace('<span class="active">ABOUT</span>', '<span>ABOUT</span>', 1).replace(
        '<span>PROJECTS</span>', '<span class="active">PROJECTS</span>', 1)


def sitemap(projects, today):
    urls = [(f'{SITE}/', '1.0')] + [(f'{SITE}/projects/{p["id"]}', '0.8') for p in projects]
    rows = ''.join(
        f'  <url>\n    <loc>{loc}</loc>\n    <lastmod>{today}</lastmod>\n    <priority>{prio}</priority>\n  </url>\n'
        for loc, prio in urls
    )
    return f'<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n{rows}</urlset>\n'


def main():
    parser = argparse.ArgumentParser(description='Build the site and add the SEO layer.')
    parser.add_argument('--skip-build', action='store_true', help='reuse the existing build/web')
    args = parser.parse_args()

    if not args.skip_build:
        # shell=True so Windows resolves flutter.bat.
        subprocess.run('flutter build web --wasm --release', shell=True, cwd=ROOT, check=True)

    index_path = os.path.join(BUILD, 'index.html')
    with open(index_path, encoding='utf-8') as f:
        template = f.read()
    if HEAD_MARKER not in template or CONTENT_MARKER not in template:
        sys.exit('build_site: SEO markers not found. Run a fresh build (without --skip-build).')

    projects = load('projects.json')
    experience = load('experience.json')
    education = load('education.json')
    skills = load('skills.json')
    today = datetime.date.today().isoformat()
    who = person(skills, experience, education)

    # ── Home page ──
    home_graph = [
        {
            '@type': 'ProfilePage',
            '@id': f'{SITE}/#profile',
            'url': f'{SITE}/',
            'name': f'{NAME} — {JOB_TITLE}',
            'dateModified': today,
            'mainEntity': {'@id': f'{SITE}/#person'},
            'isPartOf': {'@id': f'{SITE}/#website'},
        },
        who,
        website(),
    ]
    home = template.replace(HEAD_MARKER, jsonld(home_graph)).replace(
        CONTENT_MARKER, home_content(projects, experience, education, skills))
    write(index_path, home)

    # ── Case studies: /projects/<id> ──
    out_dir = os.path.join(BUILD, 'projects')
    shutil.rmtree(out_dir, ignore_errors=True)
    os.makedirs(out_dir)
    for i, p in enumerate(projects):
        url = f'{SITE}/projects/{p["id"]}'
        page = set_meta(
            template,
            title=f'{p["title"]} — Case Study | {NAME}',
            description=p.get('metaDescription') or clip(p['description']),
            url=url,
        )
        page = case_study_preview(page, p, i)
        page = page.replace(HEAD_MARKER, jsonld(project_graph(p) + [who, website()])).replace(
            CONTENT_MARKER, project_content(p, i, projects))
        write(os.path.join(out_dir, f'{p["id"]}.html'), page)

    write(os.path.join(BUILD, 'sitemap.xml'), sitemap(projects, today))

    print(f'SEO layer added: index.html, {len(projects)} case-study pages, sitemap.xml')


if __name__ == '__main__':
    main()
