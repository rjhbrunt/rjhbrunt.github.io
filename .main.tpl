{%- extends 'full.tpl' -%}

{%- block header -%}

<title>Ryan Brunt</title>
{{ super() }}


{%- endblock header -%}


{%- block body -%}
{{ super () }}

<script>
$('.input').slideToggle(duration=0);
</script>

{%- endblock body -%}
