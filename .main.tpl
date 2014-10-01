{%- extends 'full.tpl' -%}

{%- block header -%}

<title>Ryan Brunt</title>
{{ super() }}


{%- endblock header -%}


{%- block body -%}
{{ super () }}

<script>
$('.input').slideToggle();
</script>

{%- endblock body -%}
