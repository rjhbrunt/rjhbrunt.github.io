title: Newton's Method  
date: 2017-11-15

The problem I will discuss in this post is finding the zeros, or roots, of a function. This is a problem most algebra students are familiar with. Given a function $f(x)$ find all $x$ such that $f(x)=0$. This is a simple problem for polynomials with powers less than 5. Most people are familiar with the quadratic formula:

$$
\dfrac{-b\pm \sqrt{b^2-4ac}}{2a}
$$

For an polynomial of the form $ax^2+bx+c$ we can find all the roots using this formula. Similar formulas exist for cubic and quartic functions, but interestingly no such formula exists for quintic or higher order polynomials. See [Fred Akalin's post](https://www.akalin.com/quintic-unsolvability) for an awesome explanation for why quintic polynomials are unsolvable.

So how do we find the roots of these functions? Enter the Newton-Raphson method. As you may recall, the derivative of a function at a point $x$ is the rate at which the function is changing at that point. An intuitive example of this is distance and velocity. Velocity is the rate of change in distance. The derivative can also be defined as the slope of the tangent line at a given point. I was going to try to explain what a tangent line is, but I think it is easier with pictures. Let's talk about the tangent line of $f(x)=x^2-1$ at the point $(2,3)$.


```python
from IPython.display import HTML, display
import pandas as pd
import numpy as np
import bokeh.plotting as bp
from bokeh.models import Label
```


```python
def show(p, filename='plot.html'):
    bp.output_file(filename)
    bp.save(p)
    display(HTML(filename))


def f(x):
    return (x)**2-1

def tangent(x):
    #y-y0=m(x-x0) => y=mx-mx0+y0
    # m = 2*2 = 4
    return 4*x +(3-4*2)

x = np.linspace(-5,5,100)
p = bp.figure(title="f(x)=x\u00b2-1",
              x_axis_label="x",
              y_axis_label="f(x)")
p.line(x, f(x))
p.line(x[50:], tangent(x)[50:], color='red')
label = Label(x=5/4,y=-.5,text="<- x-intercept")
p.add_layout(label)
show(p)
```



<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Bokeh Plot</title>
        
<link rel="stylesheet" href="https://cdn.pydata.org/bokeh/release/bokeh-0.12.10.min.css" type="text/css" />
        
<script type="text/javascript" src="https://cdn.pydata.org/bokeh/release/bokeh-0.12.10.min.js"></script>
<script type="text/javascript">
    Bokeh.set_log_level("info");
</script>
        
<div class="bk-root">
    <div class="bk-plotdiv" id="b06c7c76-a522-4f62-a58f-7e875c796aa6"></div>
</div>

<script type="text/javascript">
    (function() {
  var fn = function() {
    Bokeh.safely(function() {
      (function(root) {
        function embed_document(root) {
          var docs_json = {"65600698-1a47-41bc-b044-0b06043673ca":{"roots":{"references":[{"attributes":{"plot":null,"text":"f(x)=x\u00b2-1"},"id":"5d78e3e5-3d82-4522-bb19-7db0473a8621","type":"Title"},{"attributes":{"axis_label":"x","formatter":{"id":"93bc1fe6-65d1-4c1a-a3c0-fda1643f3ed7","type":"BasicTickFormatter"},"plot":{"id":"b60c9ed0-d541-4302-9bb6-473915d7375b","subtype":"Figure","type":"Plot"},"ticker":{"id":"7f270d4b-5fec-4f7e-ace1-cd156630633a","type":"BasicTicker"}},"id":"d082f235-c14e-4123-9c85-4a9b394aefd5","type":"LinearAxis"},{"attributes":{},"id":"93bc1fe6-65d1-4c1a-a3c0-fda1643f3ed7","type":"BasicTickFormatter"},{"attributes":{"source":{"id":"bcf646bb-45d6-43e5-b495-5aed34eaf8b5","type":"ColumnDataSource"}},"id":"ae6cf27c-eb54-44c9-9872-fed138e93a0f","type":"CDSView"},{"attributes":{"callback":null,"column_names":["x","y"],"data":{"x":{"__ndarray__":"AAAAAAAAFMBDYt7OkJgTwIbEvJ0hMRPAyiabbLLJEsANiXk7Q2ISwFDrVwrU+hHAk0022WSTEcDXrxSo9SsRwBoS83aGxBDAXXTRRRddEMBArV8pUOsPwMdxHMdxHA/ATjbZZJNNDsDU+pUCtX4NwFq/UqDWrwzA4YMPPvjgC8BoSMzbGRILwO4MiXk7QwrAdNFFF110CcD7lQK1fqUIwIFav1Kg1gfACB988MEHB8CO4ziO4zgGwBWo9SsFagXAm2yyySabBMAiMW9nSMwDwKj1KwVq/QLAL7rooosuAsC1fqVArV8BwDxDYt7OkADAhA8++OCD/7+SmLczJOb9v54hMW9nSPy/qqqqqqqq+r+4MyTm7Qz5v8S8nSExb/e/0kUXXXTR9b/ezpCYtzP0v+xXCtT6lfK/+OCDDz748L8I1PqVArXuvyjm7QyJeeu/QPjggw8+6L9YCtT6lQLlv3Acx3Ecx+G/IF100UUX3b9QgVq/UqDWv4ClQK1fKdC/YJNNNtlkw78Ab2dIzNupvwBvZ0jM26k/YJNNNtlkwz+ApUCtXynQP1CBWr9SoNY/EF100UUX3T9wHMdxHMfhP1gK1PqVAuU/QPjggw8+6D8g5u0MiXnrPwjU+pUCte4/+OCDDz748D/sVwrU+pXyP9zOkJi3M/Q/0EUXXXTR9T/EvJ0hMW/3P7gzJObtDPk/rKqqqqqq+j+cITFvZ0j8P5CYtzMk5v0/hA8++OCD/z88Q2LezpAAQLR+pUCtXwFALrrooosuAkCo9SsFav0CQCIxb2dIzANAmmyyySabBEAUqPUrBWoFQI7jOI7jOAZACB988MEHB0CAWr9SoNYHQPyVArV+pQhAdNFFF110CUDsDIl5O0MKQGhIzNsZEgtA4IMPPvjgC0Bcv1Kg1q8MQNT6lQK1fg1ATDbZZJNNDkDIcRzHcRwPQECtXylQ6w9AXHTRRRddEEAaEvN2hsQQQNavFKj1KxFAlE022WSTEUBQ61cK1PoRQAyJeTtDYhJAyiabbLLJEkCGxLydITETQERi3s6QmBNAAAAAAAAAFEA=","dtype":"float64","shape":[100]},"y":{"__ndarray__":"AAAAAAAAOEDAQMmvBgA3QLAXzbRGBTZA0oQLD8APNUAjiIS+ch80QKQhOMNeNDNAVVEmHYROMkA5F0/M4m0xQEtzstB6kjBAHMugVJh4L0AA3FGyrdYtQEgZeLo1PyxA8YITbTCyKkD4GCTKnS8pQGDbqdF9tydAK8qkg9BJJkBW5RTgleYkQOAs+ubNjSNAy6BUmHg/IkAXQST0lfsgQIYb0vRLhB9ApA1GVlEmHUB+WKQMPN0aQB387BcMqRhAevgfeMGJFkCbTT0tXH8UQHv7RDfciRJAHwI3lkGpEEACwyaUGLsNQE4ztKV4TQpAGVUWYaMJB0BqKE3GmO8DQDqtWNVY/wBAGsdxHMdx/D/MltvhcTj3P3zJ7vqxUvI/bL5Wzw6B6z/iryJQ5APjP9jOgvDIW9Y/sCeXPXr4vz+gu0YM2kS0v4yb40Y20tC/OPwPvOBE279maEvxmjTiv6YMPN2aH+a/1OrZIXBj6b//AiW/GgDsvyBVHbWa9e2/NeHCA/BD778/pxWrGuvvvz+nFasa6++/NeHCA/BD778gVR21mvXtv/8CJb8aAOy/2+rZIXBj6b+mDDzdmh/mv2ZoS/GaNOK/OPwPvOBE27+mm+NGNtLQv6C7RgzaRLS/sCeXPXr4vz/YzoLwyFvWP9ivIlDkA+M/Yr5Wzw6B6z98ye76sVLyP8yW2+FxOPc/IMdxHMdx/D83rVjVWP8AQGcoTcaY7wNAGVUWYaMJB0BOM7SleE0KQP7CJpQYuw1AHAI3lkGpEEB7+0Q33IkSQJtNPS1cfxRAd/gfeMGJFkAa/OwXDKkYQH5YpAw83RpApA1GVlEmHUCEG9L0S4QfQBlBJPSV+yBAy6BUmHg/IkDdLPrmzY0jQFblFOCV5iRAKcqkg9BJJkBk26nRfbcnQPgYJMqdLylA7YITbTCyKkBKGXi6NT8sQADcUbKt1i1AGMugVJh4L0BLc7LQepIwQDcXT8zibTFAWFEmHYROMkCkITjDXjQzQCGIhL5yHzRA0oQLD8APNUCwF820RgU2QMJAya8GADdAAAAAAAAAOEA=","dtype":"float64","shape":[100]}}},"id":"bcf646bb-45d6-43e5-b495-5aed34eaf8b5","type":"ColumnDataSource"},{"attributes":{},"id":"5fd2f357-3edd-4611-b2c7-06aa50f03ec6","type":"LinearScale"},{"attributes":{},"id":"873285b8-748d-423e-a5ba-cfa0a9243d98","type":"ResetTool"},{"attributes":{"active_drag":"auto","active_inspect":"auto","active_scroll":"auto","active_tap":"auto","tools":[{"id":"a8160872-7c5b-401c-aa8b-f9b22edebda3","type":"PanTool"},{"id":"7b98983d-d12f-4b20-8310-d0d66f4728cc","type":"WheelZoomTool"},{"id":"6b0330bd-2ce3-4b45-9fdf-6b0935d1f9b7","type":"BoxZoomTool"},{"id":"31604425-2be5-4447-9682-98753c044fa2","type":"SaveTool"},{"id":"873285b8-748d-423e-a5ba-cfa0a9243d98","type":"ResetTool"},{"id":"6415697c-2349-40bb-aedd-24e4abff1a8c","type":"HelpTool"}]},"id":"b8752adc-8372-4a50-93ee-5bbb3a3c0c53","type":"Toolbar"},{"attributes":{"axis_label":"f(x)","formatter":{"id":"1120ae27-f11e-4299-bf61-2d11a6fc8dcb","type":"BasicTickFormatter"},"plot":{"id":"b60c9ed0-d541-4302-9bb6-473915d7375b","subtype":"Figure","type":"Plot"},"ticker":{"id":"596a6a98-909a-4c56-9ff1-029120b8ff6a","type":"BasicTicker"}},"id":"6d7f2d56-51d7-4765-8f32-77bab087825f","type":"LinearAxis"},{"attributes":{"below":[{"id":"d082f235-c14e-4123-9c85-4a9b394aefd5","type":"LinearAxis"}],"left":[{"id":"6d7f2d56-51d7-4765-8f32-77bab087825f","type":"LinearAxis"}],"renderers":[{"id":"d082f235-c14e-4123-9c85-4a9b394aefd5","type":"LinearAxis"},{"id":"a4c9ed99-63e7-419b-9bd8-1ca62310a34a","type":"Grid"},{"id":"6d7f2d56-51d7-4765-8f32-77bab087825f","type":"LinearAxis"},{"id":"eef6bad4-3489-4f38-a08b-7740a2c7d573","type":"Grid"},{"id":"2ba7d890-ca7d-44ac-a3f6-340bfcbb708d","type":"BoxAnnotation"},{"id":"fe5e1dc8-3a2a-47d8-b0ab-acf7425a7dff","type":"GlyphRenderer"},{"id":"d5ddac7a-d95f-45da-88d5-161ea22c5442","type":"GlyphRenderer"},{"id":"eb5c3bf8-26fd-4016-a86d-b263c7ec5857","type":"Label"}],"title":{"id":"5d78e3e5-3d82-4522-bb19-7db0473a8621","type":"Title"},"toolbar":{"id":"b8752adc-8372-4a50-93ee-5bbb3a3c0c53","type":"Toolbar"},"x_range":{"id":"330875ab-e244-4a54-9e71-edebf4676aeb","type":"DataRange1d"},"x_scale":{"id":"5fd2f357-3edd-4611-b2c7-06aa50f03ec6","type":"LinearScale"},"y_range":{"id":"0963ac78-509a-489b-bc4d-4f443e71f70f","type":"DataRange1d"},"y_scale":{"id":"3eadf0eb-2a57-4c28-8a0b-1f3494c0acd3","type":"LinearScale"}},"id":"b60c9ed0-d541-4302-9bb6-473915d7375b","subtype":"Figure","type":"Plot"},{"attributes":{"line_color":{"value":"red"},"x":{"field":"x"},"y":{"field":"y"}},"id":"3e31ea89-ac65-4077-b703-37e08a5450b9","type":"Line"},{"attributes":{"callback":null},"id":"0963ac78-509a-489b-bc4d-4f443e71f70f","type":"DataRange1d"},{"attributes":{},"id":"7b98983d-d12f-4b20-8310-d0d66f4728cc","type":"WheelZoomTool"},{"attributes":{"bottom_units":"screen","fill_alpha":{"value":0.5},"fill_color":{"value":"lightgrey"},"left_units":"screen","level":"overlay","line_alpha":{"value":1.0},"line_color":{"value":"black"},"line_dash":[4,4],"line_width":{"value":2},"plot":null,"render_mode":"css","right_units":"screen","top_units":"screen"},"id":"2ba7d890-ca7d-44ac-a3f6-340bfcbb708d","type":"BoxAnnotation"},{"attributes":{"plot":{"id":"b60c9ed0-d541-4302-9bb6-473915d7375b","subtype":"Figure","type":"Plot"},"text":"<- x-intercept","x":1.25,"y":-0.5},"id":"eb5c3bf8-26fd-4016-a86d-b263c7ec5857","type":"Label"},{"attributes":{"callback":null,"column_names":["x","y"],"data":{"x":{"__ndarray__":"AG9nSMzbqT9gk0022WTDP4ClQK1fKdA/UIFav1Kg1j8QXXTRRRfdP3Acx3Ecx+E/WArU+pUC5T9A+OCDDz7oPyDm7QyJees/CNT6lQK17j/44IMPPvjwP+xXCtT6lfI/3M6QmLcz9D/QRRdddNH1P8S8nSExb/c/uDMk5u0M+T+sqqqqqqr6P5whMW9nSPw/kJi3MyTm/T+EDz744IP/PzxDYt7OkABAtH6lQK1fAUAuuuiiiy4CQKj1KwVq/QJAIjFvZ0jMA0CabLLJJpsEQBSo9SsFagVAjuM4juM4BkAIH3zwwQcHQIBav1Kg1gdA/JUCtX6lCEB00UUXXXQJQOwMiXk7QwpAaEjM2xkSC0Dggw8++OALQFy/UqDWrwxA1PqVArV+DUBMNtlkk00OQMhxHMdxHA9AQK1fKVDrD0BcdNFFF10QQBoS83aGxBBA1q8UqPUrEUCUTTbZZJMRQFDrVwrU+hFADIl5O0NiEkDKJptssskSQIbEvJ0hMRNARGLezpCYE0AAAAAAAAAUQA==","dtype":"float64","shape":[50]},"y":{"__ndarray__":"iMS8nSExE8CUTTbZZJMRwECtXylQ6w/AWL9SoNavDMB40UUXXXQJwJDjOI7jOAbAqPUrBWr9AsCADz744IP/v8AzJObtDPm/8FcK1PqV8r9A+OCDDz7ov0CBWr9SoNa/AG5nSMzbqT8AXXTRRRfdPyDm7QyJees/4M6QmLcz9D+wqqqqqqr6PzhDYt7OkABAIDFvZ0jMA0AIH3zwwQcHQPAMiXk7QwpA0PqVArV+DUBcdNFFF10QQFDrVwrU+hFARGLezpCYE0A02WSTTTYVQChQ61cK1BZAHMdxHMdxGEAQPvjggw8aQAC1fqVArRtA+CsFav1KHUDooosuuugeQOwMiXk7QyBAaEjM2xkSIUDggw8++OAhQFy/UqDWryJA1PqVArV+I0BMNtlkk00kQMhxHMdxHCVAQK1fKVDrJUC46KKLLromQDQk5u0MiSdArF8pUOtXKEAom2yyySYpQKDWrxSo9SlAGBLzdobEKkCUTTbZZJMrQAyJeTtDYixAiMS8nSExLUAAAAAAAAAuQA==","dtype":"float64","shape":[50]}}},"id":"872f9e1f-e44c-42c3-a555-ed5c8ede06fc","type":"ColumnDataSource"},{"attributes":{},"id":"a8160872-7c5b-401c-aa8b-f9b22edebda3","type":"PanTool"},{"attributes":{},"id":"31604425-2be5-4447-9682-98753c044fa2","type":"SaveTool"},{"attributes":{"line_alpha":{"value":0.1},"line_color":{"value":"#1f77b4"},"x":{"field":"x"},"y":{"field":"y"}},"id":"39d48a33-0a0f-4a72-ba0c-7516d0b65897","type":"Line"},{"attributes":{"source":{"id":"872f9e1f-e44c-42c3-a555-ed5c8ede06fc","type":"ColumnDataSource"}},"id":"93e535fb-1935-4274-9a77-5108fff53481","type":"CDSView"},{"attributes":{},"id":"596a6a98-909a-4c56-9ff1-029120b8ff6a","type":"BasicTicker"},{"attributes":{},"id":"7f270d4b-5fec-4f7e-ace1-cd156630633a","type":"BasicTicker"},{"attributes":{},"id":"3eadf0eb-2a57-4c28-8a0b-1f3494c0acd3","type":"LinearScale"},{"attributes":{"callback":null},"id":"330875ab-e244-4a54-9e71-edebf4676aeb","type":"DataRange1d"},{"attributes":{"overlay":{"id":"2ba7d890-ca7d-44ac-a3f6-340bfcbb708d","type":"BoxAnnotation"}},"id":"6b0330bd-2ce3-4b45-9fdf-6b0935d1f9b7","type":"BoxZoomTool"},{"attributes":{},"id":"1120ae27-f11e-4299-bf61-2d11a6fc8dcb","type":"BasicTickFormatter"},{"attributes":{"plot":{"id":"b60c9ed0-d541-4302-9bb6-473915d7375b","subtype":"Figure","type":"Plot"},"ticker":{"id":"7f270d4b-5fec-4f7e-ace1-cd156630633a","type":"BasicTicker"}},"id":"a4c9ed99-63e7-419b-9bd8-1ca62310a34a","type":"Grid"},{"attributes":{"line_alpha":{"value":0.1},"line_color":{"value":"#1f77b4"},"x":{"field":"x"},"y":{"field":"y"}},"id":"9b60739d-962a-4600-aec9-4c7b07bbd2a7","type":"Line"},{"attributes":{},"id":"6415697c-2349-40bb-aedd-24e4abff1a8c","type":"HelpTool"},{"attributes":{"line_color":{"value":"#1f77b4"},"x":{"field":"x"},"y":{"field":"y"}},"id":"0c53a274-a961-4193-862c-8e390fd86c57","type":"Line"},{"attributes":{"data_source":{"id":"872f9e1f-e44c-42c3-a555-ed5c8ede06fc","type":"ColumnDataSource"},"glyph":{"id":"3e31ea89-ac65-4077-b703-37e08a5450b9","type":"Line"},"hover_glyph":null,"muted_glyph":null,"nonselection_glyph":{"id":"9b60739d-962a-4600-aec9-4c7b07bbd2a7","type":"Line"},"selection_glyph":null,"view":{"id":"93e535fb-1935-4274-9a77-5108fff53481","type":"CDSView"}},"id":"d5ddac7a-d95f-45da-88d5-161ea22c5442","type":"GlyphRenderer"},{"attributes":{"data_source":{"id":"bcf646bb-45d6-43e5-b495-5aed34eaf8b5","type":"ColumnDataSource"},"glyph":{"id":"0c53a274-a961-4193-862c-8e390fd86c57","type":"Line"},"hover_glyph":null,"muted_glyph":null,"nonselection_glyph":{"id":"39d48a33-0a0f-4a72-ba0c-7516d0b65897","type":"Line"},"selection_glyph":null,"view":{"id":"ae6cf27c-eb54-44c9-9872-fed138e93a0f","type":"CDSView"}},"id":"fe5e1dc8-3a2a-47d8-b0ab-acf7425a7dff","type":"GlyphRenderer"},{"attributes":{"dimension":1,"plot":{"id":"b60c9ed0-d541-4302-9bb6-473915d7375b","subtype":"Figure","type":"Plot"},"ticker":{"id":"596a6a98-909a-4c56-9ff1-029120b8ff6a","type":"BasicTicker"}},"id":"eef6bad4-3489-4f38-a08b-7740a2c7d573","type":"Grid"}],"root_ids":["b60c9ed0-d541-4302-9bb6-473915d7375b"]},"title":"Bokeh Application","version":"0.12.10"}};
          var render_items = [{"docid":"65600698-1a47-41bc-b044-0b06043673ca","elementid":"b06c7c76-a522-4f62-a58f-7e875c796aa6","modelid":"b60c9ed0-d541-4302-9bb6-473915d7375b"}];
      
          root.Bokeh.embed.embed_items(docs_json, render_items);
        }
      
        if (root.Bokeh !== undefined) {
          embed_document(root);
        } else {
          var attempts = 0;
          var timer = setInterval(function(root) {
            if (root.Bokeh !== undefined) {
              embed_document(root);
              clearInterval(timer);
            }
            attempts++;
            if (attempts > 100) {
              console.log("Bokeh: ERROR: Unable to embed document because BokehJS library is missing")
              clearInterval(timer);
            }
          }, 10, root)
        }
      })(window);
    });
  };
  if (document.readyState != "loading") fn();
  else document.addEventListener("DOMContentLoaded", fn);
})();

</script>
</html>


The tangent line just touches the function at the given point. If you zoom in on the point $(2,3)$, you will see that the tangent line is a decent approximation of the function in a neighborhood around the point, but it only touches at that point (Actually if you zoom in far enough you'll see that the lines don't touch due to rounding error, but hey it is close enough). That is because the rate of change (the slope) of the function at that point matches the slope of the line. 

So what does this have to do with finding roots? What do you notice about the x-intercept of the red line? It gets closer to a root, $(1,0)$, of the function. We can repeat this process using x-intercept as our new guess for the root. As we continue to iterate, we will converge on the root. There are exceptions, where this method will not converge, but I won't cover them here. 

So, we need a few things before we get to the algorithm. First, we need to be able to calculate the derivative of a function to get the slope of the tangent line. The derivative of a function is defined as 

$$
\lim_{h\rightarrow 0}{\dfrac{f(x+h)-f(x)}{h}}
$$

Limits are tricky on computers. We can only approximate them, and care should be taken to account for edge cases where the derivative may not exist, etc. But here we are looking at nice continuous, differentiable functions. So the following function will work nicely


```python
def f_prime(f, x, h=0.000000001):
    return (f(x+h) - f(x))/h
```

This function takes another function $f$ and a point $x$ as inputs. (along with an optional argument $h$ which defaults to something close to 0). It evaulates the limit with an $h$ that approaches 0. If we want the approximation to be more exact we can make $h$ smaller. Bear in mind eventually you will get an error if you keep reducing $h$, since the expression will overflow. 

Next, we need the equation of the tangent line. You may remember the standard form for the equation of a line

$$
y=mx+b
$$

There is another way to represent a line called the point-slope form. Given the slope $m$ and a point $(x_0,y_0)$

$$
(y-y_0)=m(x-x_0)
$$

Rearranging this gives us the equation of the line in standard form. 

$$
y = mx+(y_0-mx_0)
$$

By evaluating the function and the derivative at the point $(x_0)$, we get $y_0$ and $m$ respectively. This is enough information to get the equation of the tangent line. We then update our guess, by finding the x-intercept. This is done by setting $y=0$ in the above equation and solving for $x$

$$\begin{align}
0  &= mx+(y_0-mx_0)\\
-mx &= y_0-mx_0 \\
x &= -\dfrac{y_0-mx_0}{m} \\
x &= \dfrac{mx_0}{m}-\dfrac{y_0}{m} \\
x &= x_0-\dfrac{y_0}{m} \\
\end{align}$$

This looks a lot like a recursive sequence, and it is :D We can write the sequence as follows 

$$x_{n+1}=x_n-\dfrac{f(x_n)}{f'(x_n)}$$

I know I changed things up, but it is the same as before. $f(x_0)=y_0$ and $f'(x_0)=m$ or the slope of the tangent line at $x_0$.

Now we are finally ready to look at the algorithm for the Newton-Raphson method. I should note that this method is actually quite different from the ones originally proposed by Newton and Raphson. They used algebraic methods as opposed to calculus. Just a fun fact. 

Okay, so here it is Newton's Method for finding roots:


```python
MAX_DEPTH = 1000
def newtons_method(f, x0, tol=1e-20, depth=0):
    if np.absolute(f(x0)) < tol:
        return x0
    elif depth >= MAX_DEPTH:
        return "Failed to converge"
    else:
        return newtons_method(f, x0-(f(x0)/f_prime(f,x0)), depth=depth+1)
```

We input a function f, and an initial guess x0. The tolerance and depth arguments are to check for convergance. We recursively iterate using our equation from above as the updated guess. So let's test it out. We know the roots of $x^2-1$ are 1 and -1. 


```python
newtons_method(f,2)
```




    1.0



Great! How do we find the other root? Well, in a nutshell, we guess and check. 


```python
newtons_method(f,-25)
```




    -1.0



We use different starting points, until we find all of the roots. This aspect of the algorithm creates the concept of *basins of attraction*, meaning certain ranges of x will converge to one root as opposed to another. I was going to make graphs of this, but I want to get this published, so maybe in a later post.  

This algorithm was my first introduction to mathematical programming while I was an undergrad studying math, and it is what set me on the course to study computer science in graduate school. So I enjoyed remembering this little algorithm, and I hope you enjoyed reading about it. 
