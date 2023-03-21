## 开始

### iframe介绍

iframe是HTML中的一个标签，可以在一个网页中嵌入另一个网页。通过使用iframe标签，可以将其他网页的内容嵌入到当前网页中的一个独立的区域中。

使用iframe的主要优点包括：

1. 网站开发者可以将其他网站的内容嵌入到自己的网站中，以提供更丰富的内容和功能，例如嵌入Google地图或社交媒体插件等。
2. 在单个页面中，可以同时显示多个网页的内容，例如在一个新闻网站中，可以在页面中嵌入多个不同的文章。
3. 可以将广告或其他内容嵌入到页面中的一个特定区域，以便更好地控制页面布局和内容。

使用iframe时，需要注意以下几点：

1. 同源策略的限制：默认情况下，嵌入到iframe中的网页被视为不同的源，因此它们之间的跨窗口通信受到同源策略的限制。
2. 与父页面的交互：在iframe中的网页可以通过`postMessage API`向其父页面发送消息，或者通过`JavaScript`获取其父页面的信息。
3. 安全问题：在嵌入到iframe中的网页中，可能会存在恶意代码或安全漏洞，因此需要谨慎选择嵌入的网页，并在可能的情况下对其进行安全审查。
4. 页面性能：在同一个页面中嵌入多个iframe会增加页面的加载时间和资源消耗，因此需要根据需要谨慎使用。此外，在移动设备上使用iframe可能会影响用户体验，因为它们可能需要进行缩放或滚动。

## iframe常用属性

下面介绍一下iframe常用的属性：

- `height & width`：iframe宽高，建议使用css进行设置。

- `frameborder`：边框，设置为0可以隐藏iframe边框。
- `scrolling`：yes、no、auto，是否显示滚动条。
- `allowfullscreen`：true、false，是否允许全屏显示。
- `sandbox`：沙箱机制，记录iframe支持的行为，默认限制所有行为，通过输入允许的行为来开启，使用空格隔开多种行为：
  - `allow-forms`：允许在iframe中提交表单。
  - `allow-pointer-lock`：允许使用Pointer Lock API，从而禁止鼠标在iframe之外移动。
  - `allow-popups`：允许在iframe中弹出新窗口。
  - `allow-same-origin`：允许iframe中的网页与其父页面共享同一来源（同源），具体来说，就是允许iframe中的网页可以访问父网页的内容，反过来则不行，后文会详细解释。
  - `allow-scripts`：允许在iframe中执行JavaScript脚本。
  - `allow-top-navigation`：允许在iframe中通过top对象导航到其他页面。

后期待续...