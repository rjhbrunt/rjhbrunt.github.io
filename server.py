import sys
import os
from glob import iglob

from flask import (Flask, render_template, request, send_from_directory,
render_template_string, Markup)
from flask_bootstrap import Bootstrap
from flask_flatpages import FlatPages, pygmented_markdown, pygments_style_defs
from flask_frozen import Freezer
import markdown

FLATPAGES_MARKDOWN_EXTENSIONS = ['codehilite', 'fenced_code', 'extra']
def prerender_jinja(text):
    pre = render_template_string(Markup(text))
    return markdown.markdown(pre, FLATPAGES_MARKDOWN_EXTENSIONS) 

DEBUG = True
FLATPAGES_AUTO_RELOAD = DEBUG
FLATPAGES_EXTENSION = ['.md']
FLATPAGES_HTML_RENDERER = prerender_jinja
FLATPAGES_MARKDOWN_EXTENSIONS = ['codehilite', 'fenced_code', 'extra']
FREEZER_DESTINATION = os.path.dirname(os.path.abspath(__file__))
FREEZER_REMOVE_EXTRA_FILES = False

app = Flask(__name__)
app.config.from_object(__name__)
pages=FlatPages(app)
Bootstrap(app)
freezer = Freezer(app)

@app.route("/pygments.css")
def pygments_css():
    return pygments_style_defs('tango'), 200, {'Content-Type': 'text/css'}

@freezer.register_generator
def paper():
    for i in iglob("static/papers/*"):
        yield '/'+i+'/'
    

@app.route("/<path:path>/")
def page(path):
    if path.startswith("papers"):
        return send_from_directory("papers", "vdos.pdf")
    page = pages.get_or_404(path)
    return render_template('page.html', page=page)

@app.route("/blog/")
def blog():
    posts = [p for p in pages if p.path.startswith("blog")]
    sorted_posts = sorted(posts, reverse=True, key=lambda post: post.meta['date'])
    return render_template("blog.html", posts=sorted_posts)

@app.route("/papers/<path:path>/")
def paper(path):
    return send_from_directory("papers",path)

@app.route("/")
def index():
    return render_template("index.html")


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == 'build':
        freezer.freeze()
    else:
        app.run()
