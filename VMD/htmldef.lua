local htmldef = {}

htmldef["begin"] =
[[<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script type="text/javascript" src="/home/itep/Dokumentumok/Lua/vmd/MathJax/MathJax.js?config=AM_SVG"></script>
    <link rel="stylesheet" href="/home/itep/Dokumentumok/Lua/vmd/Highlight/styles/default.css">
    <script src="/home/itep/Dokumentumok/Lua/vmd/Highlight/highlight.pack.js"></script>
    <script>hljs.initHighlightingOnLoad();</script>
    <link type="text/css" rel="stylesheet" href="/home/itep/Dokumentumok/Lua/vmd/MarkdownCSS/markdown.css">
</head>
<body>
<article class="markdown-body">
    <p>]]

htmldef["end"] =
[[
    </p>
</article>
</body>
</html>
]]

return htmldef