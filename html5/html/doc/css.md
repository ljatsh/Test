
## Selectors ##

### Best Practice ###

* 组合选择器貌似可以级联，最好不写级联格式

### Basic Selectors ###

* [universal selector](https://developer.mozilla.org/en-US/docs/Web/CSS/Universal_selectors)
  - 慎用，CSS3起可以同namespace一起使用(TODO), 譬如ns|*
  - ```
    * { style properties }
    ```
  - ```css
    /* Selects all elements */
    * { color: green; }
    ```

* [type selector](https://developer.mozilla.org/en-US/docs/Web/CSS/Type_selectors) matches elements of the given type within a document
  - ```
    element { style properties }
    ```
  - ```html
    <head>
    <style>
      a{
        border: thin black solid; padding: 4px;
      }
    </style>
    </head>
    <body>
    <a href="http://apress.com">Visit the Apress website</a>
    <p>I like <span>apples</span> and oranges.</p>
    <a href="http://w3c.org">Visit the W3C website</a>
    </body>
    ```
  - ![实例图](css_selector_basic_type_01.png)

* [attribute selector](https://developer.mozilla.org/en-US/docs/Web/CSS/Attribute_selectors) matches elements based on the presence or value of a given attribute
  - attribute may contain multiple values
  - The string comparision is case-sensitive. Avoid to use `[attr operator "value" i]`.
  - Syntax
    - `<element>[attr]` elements with attribute "attr" defined
    - `<element>[attr="value"]` elements with attribute "attr" whose value is "value"
    - `<element>[attr~="value"]` elements with attribute "attr" whose value continas multiple values and one of which is "value"
    - `<element>[attr|="value"]` elements with attribute "attr" whose value is a hyphen- seperated value("en-Us", etc), the first of which is "value"
    - `<element>[attr^="value"]` elements with attribute "attr" whose value starts with "value"
    - `<element>[attr$="value"]` elements with attribute "attr" whose value ends with "value"
    - `<element>[atrr*="value"]` elements with attribute "attr" whose value contains string "value"
  - ```html
    <head>
      <style>
        [href] {
          border: thin black solid;
          padding: 4px;
        }
      </style>
    </head>
    <body>
      <a id="apressanchor" class="class1 class2" href="http://apress.com">
        Visit the Apress website
      </a>
      <p>I like <span class="class2">apples</span> and oranges.</p>
      <a id="w3canchor" href="http://w3c.org">Visit the W3C website</a>
    </body>
    ```
  - ![实例图](css_selector_basic_attribute_01.png)

* [class selector](https://developer.mozilla.org/en-US/docs/Web/CSS/Class_selectors) matches elements based on the content of their class attribute
  - ```
    <element>.class_name { style properties }

    it is equivalent to
    [class~="class_name"]
    ```
  - ```html
    <head>
      <style>
        .classy { background-color: skyblue; }
      </style>
    </head>
    <body>
      <div class="classy">This div has a special class on it!</div>
      <div class="foo classy bar">Elements can have multiple classes and the class selector still works!</div>
      <div>This is just a regular div.</div>
    </body>
    ```
  - ![实例图](css_selector_basic_class_01.png)

* [id selector](https://developer.mozilla.org/en-US/docs/Web/CSS/ID_selectors) matches elements based on the value of its id attribute
  - ```
    <element>#id_value { style properties }

    it is equivalent to
    [id=value] { style properties }
    ```
  - ```html
    <head>
      <style>
        #identified { background-color: skyblue; }
      </style>
    </head>
    <body>
      <div id="identified">This div has a special ID on it!</div>
      <div>This is just a regular div.</div>
    </body>
    ```
  - ![实例图](css_selector_basic_id_01.png)

### Combining Sectors ###
* *union selector*(TODO), matches union of all the elements that each of the individual selectors matches.
  - ```
    <selector>, <selector> ... { style properties }
    ```
  - ```html
    <head>
      <style>
        a, [lang|="en"] { border: thin black solid; padding: 4px;}
      </style>
    </head>
    <body>
      <a id="apressanchor" class="class1 class2" href="http://apress.com">
        Visit the Apress website
      </a>
      <p>I like <span lang="en-uk" class="class2">apples</span> and oranges.</p>
      <a id="w3canchor" href="http://w3c.org">Visit the W3C website</a>
      </body>
    ```
  - ![实例图](css_selector_combining_union_01.png)

* [descendant selector](https://developer.mozilla.org/en-US/docs/Web/CSS/Descendant_selectors) matches elements that match the 2nd selector and are descendants of the elements match the 1st selector
  - ```
    <selector1> <selector2> { style properties }
    ```
  - ```html
    <head>
      <style>
        #mytable td {
          border: thin black solid;
          padding: 4px;
        }

        li {
          list-style-type: disc;
        }

        li li {
          list-style-type: circle;
        }
      </style>
    </head>
    <body>
      <table id="mytable">
        <tr><th>Name</th><th>City</th></tr>
        <tr><td>Adam Freeman</td><td>London</td></tr>
        <tr><td>Joe Smith</td><td>New York</td></tr>
        <tr><td>Anne Jones</td><td>Paris</td></tr>
      </table>
      <p>I like <span lang="en-uk" class="class2">apples</span> and oranges.</p>
      <table id="othertable">
        <tr><th>Name</th><th>City</th></tr>
        <tr><td>Peter Pererson</td><td>Boston</td></tr>
        <tr><td>Chuck Fellows</td><td>Paris</td></tr>
        <tr><td>Jane Firth</td><td>Paris</td></tr>
      </table>

      <ul>
        <li>
          <div>Item 1</div>
          <ul>
            <li>Subitem A</li>
            <li>Subitem B
              <ul>
                <li> item1 </li>
                <li> item2 </li>
              </ul>
            </li>
          </ul>
        </li>
        <li>
          <div>Item 2</div>
          <ul>
            <li>Subitem A</li>
            <li>Subitem B</li>
          </ul>
        </li>
      </ul>
    </body>
    ```
  - ![实例图](css_selector_combining_descendant_01.png)

* [child selector](https://developer.mozilla.org/en-US/docs/Web/CSS/Child_selectors) matches elements that match the 2nd selector and are *immediate* descendants of the elements match the 1st selector
  - ```
    <selector1> > <selector2> { style properties }
    ```
  - ```html
    <head>
      <style>
        body > * > span, tr > th {
          border: thin black solid;
          padding: 4px;
        }
      </style>
    </head>
    <body>
      <table id="mytable">
        <tr><th>Name</th><th>City</th></tr>
        <tr><td>Adam Freeman</td><td>London</td></tr>
        <tr><td>Joe Smith</td><td>New York</td></tr>
        <tr><td>Anne Jones</td><td>Paris</td></tr>
      </table>
      <p>I like <span lang="en-uk" class="class2">apples</span> and oranges.</p>
      <table id="othertable">
        <tr><th>Name</th><th>City</th></tr>
        <tr><td>Peter Pererson</td><td>Boston</td></tr>
        <tr><td>Chuck Fellows</td><td>Paris</td></tr>
        <tr><td>Jane Firth</td><td>Paris</td></tr>
      </table>
    </body>
    ```
  - ![实例图](css_selector_combining_child_01.png)

* *[adjacent silbing selector](https://developer.mozilla.org/en-US/docs/Web/CSS/Adjacent_sibling_selectors) matches elements that match the 2nd element and immediately follow an element that matches the 1st selector  
  [general silbing selector](https://developer.mozilla.org/en-US/docs/Web/CSS/General_sibling_selectors) matches elemments that match the 2nd element and follow an element that matches the 1st selector
  - ```
    <selector1> + <selector2> { style properties }
    <selector1> ~ <selector2> { style properties }
    ```
  - ```html
    <head>
      <style>
        p + a {
          border: thin black solid; padding: 4px;
        }
      </style>
    </head>
    <body>
      <a href="http://apress.com">Visit the Apress website</a>
      <p>I like <span lang="en-uk" class="class2">apples</span> and oranges.</p>
      <a href="http://w3c.org">Visit the W3C website</a>
      <a href="http://google.com">Visit Google</a>
    </body>
    ```
  - ![实例图](css_selector_combining_silbing_01.png)
  - ```html
    <head>
      <style>
        p ~ a {
          border: thin black solid; padding: 4px;
        }
      </style>
    </head>
    <body>
      <a href="http://apress.com">Visit the Apress website</a>
      <p>I like <span lang="en-uk" class="class2">apples</span> and oranges.</p>
      <a href="http://w3c.org">Visit the W3C website</a>
      <a href="http://google.com">Visit Google</a>
    </body>
    ```
  - ![实例图](css_selector_combining_silbing_02.png)

## References ##

* [CSS Specification?](https://drafts.csswg.org/selectors/#syntax)
* [MDN CSS Reference](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference)
