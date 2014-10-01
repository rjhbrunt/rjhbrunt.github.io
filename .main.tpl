{%- extends 'full.tpl' -%}

{%- block header -%}

{{ super() }}
<title>Ryan Brunt</title>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>

<style type="text/css">
//div.output_wrapper{
// margin-top: 0px;
//}
</style>

<script>
$('.input').slideToggle();
</script>

{%- endblock header -%}
