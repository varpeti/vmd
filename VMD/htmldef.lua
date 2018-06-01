local htmldef = {}

htmldef["begin"] =
[[<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script type="text/javascript" src="https://users.itk.ppke.hu/~varpe8/MathJax/MathJax.js?config=AM_SVG"></script>
    <link rel="stylesheet" href="https://users.itk.ppke.hu/~varpe8/Highlight/styles/default.css">
    <script src="https://users.itk.ppke.hu/~varpe8/Highlight/highlight.pack.js"></script>
    <script>hljs.initHighlightingOnLoad();</script>
    <link type="text/css" rel="stylesheet" href="https://users.itk.ppke.hu/~varpe8/MarkdownCSS/markdown.css">
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