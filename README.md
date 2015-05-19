# Hexo Landscape 主题修改优化 #
by C17   2015-05-18 Monday 16-56-15 

---
这几天用 Hexo 搭了个静态博客。觉得默认的 Landscape 主题挺好看，但有些地方很奇怪。别人改好的 Landscape-plus 和 Landscape-f 改动太大，用着不爽，就决定自己从头造个轮子修改一下。


基于 [Landscape](https://github.com/hexojs/hexo-theme-landscape)，修改添加了部分功能。部分参考了[Landscape-F](https://github.com/howiefh/hexo-theme-landscape-f) 和 [Landscape-plus](https://github.com/xiangming/landscape-plus)。
文章参考来源以链接形式放在各节小标题上。有基于原文完善或修改的地方不再另行注明。

### 1. [Google jQuery 库的优化](http://kuangqi.me/tricks/hexo-optimizations-for-mainland-china/) ###
 
`layout\_partial\after-footer.ejs` 17行

```html
<script src="//ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js"></script>
```
<!-- more -->

替换为如下代码：

```html
<script src="http://lib.sinaapp.com/js/jquery/2.0.3/jquery-2.0.3.min.js"></script>
<script type="text/javascript">
//<![CDATA[
if (typeof jQuery == 'undefined') {
  document.write(unescape("%3Cscript src='/js/jquery-2.0.3.min.js' type='text/javascript'%3E%3C/script%3E"));
}
// ]]>
</script>
```
这里不但将 Google 的 jQuery 替换成了 SAE 的，随后还进行了一个判断，如果获取新浪的 jQuery 失败，则使用本网站自己的 jQuery。为了让这段代码有效，我们要去 jQuery 官方下载合适版本的 jQuery 并将其放到 `source\js\ ` 目录下，命名为 `jquery-2.0.3.min.js`。
还有一点需要特别注意，那就是 jQuery 这个文件在 hexo 生成博客时会被解析，因此一定要将 jQuery 文件开头处的 `//@ sourceMappingURL=jquery-2.0.3.min.map` 这一行代码删去，否则会导致博客无法生成。

### 2. [跨平台字体优化](http://kuangqi.me/tricks/hexo-optimizations-for-mainland-china/)

为了能在各个平台上都显示令人满意的字体，我们要修改CSS文件中的字体设置，列出多个备选的字体，操作系统会依次尝试，使用系统中已安装的字体。我们要修改的是`source\css\_variables.styl`这一文件，将其中第22行
```
font-sans = "Helvetica Neue", Helvetica, Arial, sans-serif
```
改成如下内容：
```
font-sans = "Helvetica Neue", Helvetica, Verdana, "Hiragino Sans GB", "Microsoft YaHei", "Source Han Sans CN", "WenQuanYi Micro Hei", sans-serif
```
其中 Helvetica、Verdana 是英文字体，前者一般存在于苹果电脑和移动设备上，后者一般存在于 Windows 系统中。冬青黑体（Hiragino Sans GB）、思源黑体（Source Han Sans CN）、文泉驿米黑（WenQuanYi Micro Hei）是中文字体，冬青黑体从 OS X 10.6 开始集成在苹果系统中，文泉驿米黑在Linux的各大发行版中均较为常见，而思源黑体是近期 Google 和 Adobe 合作推出的一款开源字体，很多电脑上也安装了这一字体。这样一来，在绝大部分操作系统中就可以显示美观的字体了。

### 3.[代码块等宽字体优化](https://www.snip2code.com/Snippet/466525/replace-the-google-link%28css-js%29-to-baidu) ###

`layout\_partial\head.ejs` 第31行
```html
<link href="http://fonts.googleapis.com/css?family=Source+Code+Pro" rel="stylesheet" type="text/css">
```
改为
```html
<link href="http://fonts.lug.ustc.edu.cn/css?family=Source+Code+Pro" rel="stylesheet" type="text/css">
```

### 4.修改添加分享链接 ###
####4.1 [百度分享框](http://share.baidu.com/code)####

在百度分享获取代码后，代码可分为两部分。
在`layout\_partial\article.ejs`中第26行插入第一段代码并添加判断条件，若当前页为文章展开页则显示百度分享框，若是缩略则采用原生分享链接，避免百度分享框获取的 URL 错误：
```
<% if ((page.layout == 'post'|| page.layout == 'page')){ %>
  <div class="bdsharebuttonbox"><a href="<%- post.permalink %>">分享到：</a><a href="#" class="bds_tsina" data-cmd="tsina" title="分享到新浪微博">新浪微博</a><a href="#" class="bds_renren" data-cmd="renren" title="分享到人人网">人人网</a><a href="#" class="bds_qzone" data-cmd="qzone" title="分享到QQ空间">QQ空间</a><a href="#" class="bds_weixin" data-cmd="weixin" title="分享到微信">微信</a><a href="#" class="bds_fbook" data-cmd="fbook" title="分享到Facebook">Facebook</a><a href="#" class="bds_twi" data-cmd="twi" title="分享到Twitter">Twitter</a><a href="#" class="bds_more" data-cmd="more">其他平台</a></div>
<% } else { %>
  <a data-url="<%- post.permalink %>" data-id="<%= post._id %>" class="article-share-link">分享</a>
<% } %>
```

在`layout\_partial\after-footer.ejs`末尾添加第二部分代码
```
<!-- Baidu Share Start --->
<script>window._bd_share_config={"common":{"bdSnsKey":{"tsina":"1483801509"},"bdWbuid":3904642734,"bdText":"","bdMini":"2","bdMiniList":["douban","kaixin001","tieba","tsohu","sqq","youdao","qingbiji","mail","linkedin","mshare","copy","print"],"bdPic":"http://c17.co/SharePic.png","bdStyle":"1","bdSize":"24"},"share":{"bdSize":16}};with(document)0[(getElementsByTagName('head')[0]||body).appendChild(createElement('script')).src='http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion='+~(-new Date()/36e5)];</script>
<!--- Baidu Share End --->
```
其中`1483801509`为我申请的微博开放平台的 App Key，申请后分享可以显示尾巴。`3904642734`是我的微博ID，作用是在文本框里自动艾特我的微博。
注意保存时将编码改为 UTF-8，否则会乱码。

####4.2 [原生分享的修改](http://blanboom.org/hack-hexo-theme-landscape.html) ####
在 `source\js\script.js` 中，57行 `'<div class="article-share-links">'`,，下面的四个链接就是 Facebook 等社交网站的分享链接。将其替换或添加如下代码，即可实现分享到国内社交网站：
```html
'<a href="http://service.weibo.com/share/share.php?appkey=1483801509&pic=http%3A%2F%2Fc17.co%2FSharePic.png&ralateUid=3904642734&searchPic=true&url=' + encodedUrl + '" class="article-share-sina" target="_blank" title="微博"></a>',
'<a href="http://share.renren.com/share/buttonshare.do?link=' + encodedUrl + '" class="article-share-renren" target="_blank" title="人人"></a>',
'<a href="http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey?url=' + encodedUrl + '" class="article-share-qq" target="_blank" title="QQ空间"></a>',
'<a href="http://qr.liantu.com/api.php?text=' + encodedUrl + '" class="article-share-wechat" target="_blank" title="微信"></a>',
```
注意，微博中`“3904642734”`是我的微博ID，作用是在文本框里自动艾特我的微博。
微信分享中 `http://qr.liantu.com/api.php?text=` 这个地址是 [联图网](http://www.liantu.com/pingtai/) 提供的二维码 API ，用微信扫描后分享。

同时，还需要替换图标。本主题使用 Font Awesome 来显示图标，但内置的 Font Awesome 版本较旧，无法显示 QQ、腾讯微博等图标，所以，需要下载最新版 [Font Awesome](http://fortawesome.github.io/Font-Awesome/)，替换掉 `source\css\fonts` 中相关文件，并在` source\css\_variables.styl` 中27行的 `font-icon-version` 修改为最新的 Font Awesome 版本号。

然后，在 `source\css\_partial\article.styl` 中，找到四段以 `.article-share-***` 开头的代码（273行起），添加如下内容：

```
.article-share-sina
  @extend $article-share-link
  &:before
    content: "\f18a"
  &:hover
    background: color-sina
    text-shadow: 0 1px darken(color-sina, 20%)

.article-share-qq
  @extend $article-share-link
  &:before
    content: "\f1d6"
  &:hover
    background: color-qq
    text-shadow: 0 1px darken(color-qq, 20%)

.article-share-renren
  @extend $article-share-link
  &:before
    content: "\f18b"
  &:hover
    background: color-renren
    text-shadow: 0 1px darken(color-renren, 20%)

.article-share-wechat
  @extend $article-share-link
  &:before
    content: "\f1d7"
  &:hover
    background: color-wechat
    text-shadow: 0 1px darken(color-wechat, 20%)
```
最后，找到 `source\css\_variables.styl` 中 `Colors` 部分（16行），最后四行分别为社交网站图标的背景色，可根据这些网站的主题色修改。
```
color-sina = #ff8140
color-qq = #ffcc33
color-renren = #227dc5
color-wechat = #44b549
```

### 5.[安装 RSS 和 sitemap 插件](http://starsky.gitcafe.io/2015/05/05/Hexo%E4%B8%BB%E9%A2%98%E9%85%8D%E7%BD%AE%E4%B8%8E%E4%BC%98%E5%8C%96%EF%BC%88%E4%B8%80%EF%BC%89/)

```
$ npm install hexo-generator-feed --save
$ npm install hexo-generator-sitemap --save
```
修改 `hexo\_config.yml` 站点配置，添加：
```
# Extensions
Plugins:
  hexo-generator-feed
  hexo-generator-sitemap

#Feed Atom
feed:
  type: atom
  path: atom.xml
  limit: 20

#sitemap
sitemap:
  path: sitemap.xml
```
然后注意再修改`_config.yml`主题配置：
`menu:`里添加网站地图:` /sitemap.xml`
下面也添加`rss: /atom.xml`（如果有就不用添加了）。

部署后就能看到“首页”那一栏多了个“网站地图”，点击后有内容且第一行为
`This XML file does not appear to have any style information associated with it. The document tree is shown below.`
就说明成功了。
RSS也是一样。

### 6. 卡片增加阴影 ###
`source/css/_partial/header.styl`第5行添加：
```
-webkit-box-shadow: 2px 4px 5px rgba(3,3,3,0.2)
box-shadow: 2px 4px 5px rgba(3,3,3,0.2)
```
### 7. 坑：试图将侧栏放到左面 ###
在`config.yml`中可以配置 Sidebar 为 left。但如此配置后页面在移动端（窄屏）下会错位，文章卡片跑到屏幕外面了。经文件比对后发现修改了该选项仅使`css\style.css`中190行处添加了 right 从右向左的布局。该布局虽使文章列与侧栏列交换，但窄屏时因为右对齐所以左边界会超出屏幕。尝试将 index.html 中两栏位置互换，错位问题解决，但窄屏下侧栏在文章上方。

遂弃坑。

### 8. 补救：将文章卡片页面宽度缩窄 ###
之所以想将侧栏放到左面是因为屏宽超过1024时若文章换行较多中部会很空。于是可以限制文章页面宽度。
在`source\css\_variables.styl`中将47行`main-column`的值由默认的9改为8即比较合适。

### 9. [代码块修改](http://blog.sunnyxx.com/2014/03/07/hexo_customize/) ###
`source\css\_partial\highlight.styl` 17行改为
```
margin: auto
```
使代码块不再左右撑开
22行添加
```
border-radius: 8px
```
圆角。

### 10. 页尾版权信息修改 ###
原生的好丑啊！
`layout\_partial\footer.ejs`
添加一个表格，实现分散对齐。添加了网站地图等链接。
```
<div class="outer">
    <div id="footer-info" class="inner" style="text-align:center;">
	  <table width="100%" border="0">
        <tr>
          <td style="text-align:left">
            Copyright &copy; 2014-<%= date(new Date(), 'YYYY') %> <%= config.author || config.title %> &nbsp &nbsp
            Powered by <a href="http://hexo.io/" target="_blank">Hexo</a><br>
	        Theme <a href="https://github.com/HKEY-C17/hexo-theme-hic17" target="_blank">HiC17</a> by Sykie Chen &nbsp &nbsp
	        Hosted on <a href="http://gitcafe.com/" target="_blank">Git Cafe</a>
		  </td>
		  <td style="text-align:right">
		    <a style="font-family: FontAwesome;font-size: 20px;" href="http://weibo.com/3904642734">&#61834;</a>&nbsp
			<a style="font-family: FontAwesome;font-size: 20px;" href="http://www.renren.com/287137027">&#61835;</a>&nbsp
			<a style="font-family: FontAwesome;font-size: 20px;" href="http://user.qzone.qq.com/525969441">&#61910;</a>&nbsp
			<a style="font-family: FontAwesome;font-size: 20px;" href="https://www.facebook.com/sykiechencixi">&#62000;</a>&nbsp
			<a style="font-family: FontAwesome;font-size: 20px;" href="https://twitter.com/HKEY_C17">&#61593;</a>&nbsp
			<a style="font-family: FontAwesome;font-size: 20px;" href="http://cn.linkedin.com/in/sykiechen">&#61665;</a>&nbsp
			<a style="font-family: FontAwesome;font-size: 20px;" href="https://github.com/HKEY-C17">&#61595;</a>&nbsp
			<a style="font-family: FontAwesome;font-size: 20px;" href="https://plus.google.com/118157846818083514683">&#61653;</a><br>
		    <a href="/sitemap.xml">网站地图</a>&nbsp &nbsp
			<a href="/atom.xml">订阅本站</a>&nbsp &nbsp
			<a href="mailto:c17@c17.co" target="_blank">联系博主</a>&nbsp &nbsp
			ICP 备案你妹
		  </td>
        </tr>
      </table>
    </div>
  </div>
```
此处使用了 Font Awesome 字体中的图标。官网介绍的使用方法是包含一个 css 文件进去。然而 Landscape 主题已经使用过该字体，所以该 css 文件的内容应已包含在 style.css 内。故将 html a 标签的 font 指定为该字体，内容处填写~~&#`UTF编码的十进制值`; 可用计算器将官网给出的十六进制 UTF 区位码转换为十进制。~~ &#x`UTF十六进制值`;。

### 11. [多说评论框](http://howiefh.github.io/2014/04/20/hexo-optimize-and-my-theme-landscape-f/) ###

在`layout\_partial\article.ejs`中将中部 dis 评论按钮代码替换为：
```
<% if (post.comments){ %>
  <a href="<%- post.permalink %>#ds-thread" class="ds-thread-count article-comment-link" data-thread-key="<%- post.path%>">评论</a>
<% } %>
```
底部评论框替换为：
```
<% if (!index && post.comments){ %>
<section id="comments">
<!-- 多说评论框 start -->
	<div id="ds-thread" class="ds-thread" data-thread-key="<%= post.path%>" data-title="<%= post.title %>" data-url="<%= post.permalink %>"></div>
<!-- 多说评论框 end -->
</section>
<% } %>
```
`layout\_partial\after-footer.ejs`中 dis 评论框 js 替换为从多说获得的代码：
```
<!-- 多说公共JS代码 start (一个网页只需插入一次) -->
<script type="text/javascript">
var duoshuoQuery = {short_name:"hkeyc17"};
	(function() {
		var ds = document.createElement('script');
		ds.type = 'text/javascript';ds.async = true;
		ds.src = (document.location.protocol == 'https:' ? 'https:' : 'http:') + '//static.duoshuo.com/embed.js';
		ds.charset = 'UTF-8';
		(document.getElementsByTagName('head')[0] 
		 || document.getElementsByTagName('body')[0]).appendChild(ds);
	})();
	</script>
<!-- 多说公共JS代码 end -->
```
坑：
http://howiefh.github.io/2014/04/20/hexo-optimize-and-my-theme-landscape-f/
返回顶部
侧边栏目录
多说评论
百度分享
友链
微信弹框分享（参考 landscape-plus）
