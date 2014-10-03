{%- extends 'full.tpl' -%}

{%- block header -%}

<title>Ryan Brunt</title>
{{ super() }}


{%- endblock header -%}


{%- block body -%}
<h1 class='main-title'>Ryan Joseph Harman Brunt</h1>
<nav>
    <div class="container">
        <ul>
            <li><a href="#">Home</a></li>
            <li><a href="#" onclick="$('.input').slideToggle();">Toggle Code</a></li>
            <li><a href="https://github.com/rjhbrunt/rjhbrunt.github.io" target="_blank">See Source</a></li>
            <li><a href="#">Site Map</a>
                <ul>
                    <li><a href="/about">About</a></li>
                    <li><a href="/projects">Projects</a></li>
                </ul>
            </li>
        </ul>
    </div>
</nav>
{{ super () }}

<script>
$('.input').slideToggle(duration=0);
</script>

{%- endblock body -%}
