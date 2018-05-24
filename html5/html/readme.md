
### Element Categories ###

* [MDN Reference](https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/Content_categories#Flow_content)
* [relevant portions of the HTML specification](https://html.spec.whatwg.org/multipage/dom.html#kinds-of-content)

#### Text Element ####
* 生成到其他文档的超级链接或者到本文档某元素的超级链接[a](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-a-element)
  - ```css
    a:link, a:visited {
      color: blue;
      text-decoration: underline;
      cursor: auto;
    }
    a:link:active, a:visited:active {
      color: blue;
    }
    ```
  - link to an external location
    ```html
      <!-- anchor linking to external file -->
        <a href="https://www.mozilla.com/">
        External Link
      </a>
    ```
  - link to another element of the same document
    ```html
      <!-- links to element on this page with id="attr-href" -->
      <a href="#attr-href">
        Description of Same-Page Links
      </a>
    ```
  - make image link to external location
    ```html
      <a href="https://developer.mozilla.org/en-US/" target="_blank">
        <img src="https://mdn.mozillademos.org/files/6851/mdn_logo.png"
             alt="MDN logo" />
      </a>
    ```
  - attributes
    - target: specifies where to display the linked URL
* 不附带任何重要性含义地表示一段文本[b](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-b-element)或者[u](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-u-element)
  - ```css
    b { font-weight: bolder; }
    u { text-decoration: underline; }
    ```
  - 用户往往会把下划线的文字误认为超级链接，应该尽可能的避免使用ｕ元素
  - Perfer to use CSS [font-weight](https://developer.mozilla.org/en-US/docs/Web/CSS/font-weight) instead of `<b>`, if there is no semantic purpose to use `<b>` element, 
* 表示强调[em](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-em-element)
  - ```css
    em { font-style: italic; }
    ```
* 表示科学术语或者外文词汇[i](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-i-element)
  - ```css
    i { font-style: italic; }
    ```
* 表示不精确或者不正确的内容[s](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-s-element)
  - ```css
    s { text-decoration: line-through; }
    ```
* 表示重要[strong](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-strong-element)
  - ```css
    strong { font-weight: bolder; }
    ```
  - [`<b> vs <strong>, <em> vs <strong>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/strong)
* 表示小号字体部分[small](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-small-element)
  - ```css
    small { font-size: smaller; }
    ```
  - 常用于免责和澄清说明
* 表示上标和下标[sub and sup](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-sub-and-sup-elements)
  - ```css
    sub { font-size: smaller; vertical-align: sub; }
    sup { font-size: smaller; vertical-align: super; }
    ```
* 表示换行[br](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-br-element)和适合换行处[wbr](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-wbr-element)
  - br只宜用在换行也是内容的一部分情况下。使用`<br/>`风格，尽量不使用`<br>`风格
* 表示计算机代码、程序输出、变量或者用户输入[code](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-code-element), [var](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-var-element), [samp](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-samp-element), [kbd](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-kbd-element)
  - ```css
    code { font-family: monospace; }
    var { font-style: italic; }
    samp { font-family: monospace; }
    kbd { font-family: monospace; }
    ```
* 在科学计算领域经常用到的缩写[abbr](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-abbr-element)， 
  标题引用[cite](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-cite-element), 引用内容[q](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-q-element), 和术语定义[dfn](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-dfn-element)
  - ```css
    abbr {}
    cite { font-style: italic; }
    q { display: inline; } 
    q:before { content: open-quote; }
    q:after { content: close-quote; }
    dfn {}
    ```
* 对一段内容应用全局属性[span](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-span-element)
  - ```css
    span {}
    ```
* 表示与另一段上下文有关的内容，并被突出显示[mask](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-mark-element)
  - ```css
    mask { background-color: yellow; color: black; }
    ```
* 表示添加的内容[ins](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/ins)和删除的内容[del](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/del)
  - ```css
    ins { text-decoration: underline; }
    del { text-decoration: line-through; }
    ```
* 表示日期和时间[time](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-time-element)
  - ```css
    time {}
    ```
  - ```html
    <p>The concert took place on <time
    datetime="2001-05-15T19:00">May 15</time>.</p>
    ```

