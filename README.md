# Hexo Landscape 主题修改优化 #
by C17   2015-05-18 Monday 16-56-15 

---
### 1. [Google jQuery库的优化](http://kuangqi.me/tricks/hexo-optimizations-for-mainland-china/) ###
 
`themes/landscape/layout/_partial/after-footer.ejs` 17行

```html
<script src="//ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js"></script>
```
替换为如下代码：

```html
<script src="http://apps.bdimg.com/libs/jquery/2.0.3/jquery.min.js"></script>
<script type="text/javascript">
//<![CDATA[
if (typeof jQuery == 'undefined') {
  document.write(unescape("%3Cscript src='/js/jquery-2.0.3.min.js' type='text/javascript'%3E%3C/script%3E"));
}
// ]]>
</script>
```
这里不但将Google的jQuery替换成了百度的，随后还进行了一个判断，如果获取百度的jQuery失败，则使用本网站自己的jQuery。为了让这段代码有效，我们要去jQuery官方下载合适版本的jQuery并将其放到`themes/landscape/source/js/`目录下，我将其命名为`jquery-2.0.3.min.js`。还有一点需要特别注意，那就是 jQuery 这个文件在 hexo 生产博客时会被解析，因此一定要将 jQuery 文件开头处的 `//@ sourceMappingURL=jquery-2.0.3.min.map` 这一行代码删去，否则会导致博客无法生成。

### 2. [跨平台字体优化](http://kuangqi.me/tricks/hexo-optimizations-for-mainland-china/)

