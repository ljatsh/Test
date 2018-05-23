
### Element Categories ###

* [MDN Reference](https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/Content_categories#Flow_content)
* [relevant portions of the HTML specification](https://html.spec.whatwg.org/multipage/dom.html#kinds-of-content)

#### Text Element ####
* 生成到其他文档的超级链接或者到本文档某元素的超级链接[a](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-a-element)
  - 常用属性href, target
* 不附带任何重要性含义地表示一段文本[b](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-b-element)或者[u](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-u-element)
  - 用户往往会把下划线的文字误认为超级链接，应该尽可能的避免使用ｕ元素
* 表示强调[em](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-em-element)
* 表示科学术语或者外文词汇[i](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-i-element)
* 表示不精确或者不正确的内容[s](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-s-element)
* 表示重要[strong](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-strong-element)
* 表示小号字体部分[small](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-small-element)
  - 常用于免责和澄清说明
* 表示上标和下标[sub and sup](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-sub-and-sup-elements)
* 表示换行[br](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-br-element)和适合换行处[wbr](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-wbr-element)
  - br只宜用在换行也是内容的一部分情况下。　使用&lt;br/&gt;风格，　尽量不使用&lt;br&gt;风格
