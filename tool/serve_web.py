"""Serve build/web locally the way production should: gzip-compressed and
cross-origin isolated, so the WebAssembly renderer can use multiple threads.

    flutter build web --wasm
    python tool/serve_web.py            # http://localhost:8080

`python -m http.server` also works, but it sends neither compression nor the
COOP/COEP headers, so it shows a slower first load than real hosting.
"""

import argparse
import gzip
import http.server
import io
import os
import socketserver

COMPRESSIBLE = ('.js', '.mjs', '.wasm', '.json', '.html', '.css', '.svg', '.ttf', '.otf', '.symbols')


class Handler(http.server.SimpleHTTPRequestHandler):
    extensions_map = {
        **http.server.SimpleHTTPRequestHandler.extensions_map,
        '.wasm': 'application/wasm',
        '.mjs': 'text/javascript',
        '.js': 'text/javascript',
    }

    def end_headers(self):
        # Cross-origin isolation, required for multi-threaded skwasm.
        self.send_header('Cross-Origin-Opener-Policy', 'same-origin')
        self.send_header('Cross-Origin-Embedder-Policy', 'credentialless')
        super().end_headers()

    def send_head(self):
        path = self.translate_path(self.path)
        accepts_gzip = 'gzip' in self.headers.get('Accept-Encoding', '')
        if not (accepts_gzip and os.path.isfile(path) and path.endswith(COMPRESSIBLE)):
            return super().send_head()

        with open(path, 'rb') as f:
            body = gzip.compress(f.read(), compresslevel=6)
        self.send_response(200)
        self.send_header('Content-Type', self.guess_type(path))
        self.send_header('Content-Encoding', 'gzip')
        self.send_header('Content-Length', str(len(body)))
        self.end_headers()
        return io.BytesIO(body)


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument('--port', type=int, default=8080)
    parser.add_argument('--dir', default=os.path.join(os.path.dirname(__file__), '..', 'build', 'web'))
    args = parser.parse_args()

    os.chdir(args.dir)
    socketserver.ThreadingTCPServer.allow_reuse_address = True
    with socketserver.ThreadingTCPServer(('localhost', args.port), Handler) as server:
        print(f'Serving {os.getcwd()} at http://localhost:{args.port}')
        server.serve_forever()


if __name__ == '__main__':
    main()
