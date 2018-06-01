local htmldef = {}

htmldef["begin"] =
[[<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script type="text/javascript" src="MathJax/MathJax.js?config=AM_SVG"></script>
    <style>
        .math 
        { 
            text-align: center; 
        }
        img 
        { 
            max-width: 100%; 
            height: auto; 
        }
        div.img0
        {
            text-align: center;
        }
        div.img1
        {
            width: auto;
            background-color: white;
            box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
            display: inline-block;
            text-align: left; 
        }
        div.img2 
        {
            text-align: center;
            padding: 10px 20px;
        }
    </style>
    <link rel="stylesheet" href="Highlight/styles/default.css">
    <script src="Highlight/highlight.pack.js"></script>
    <script>hljs.initHighlightingOnLoad();</script>
    <link type="text/css" rel="stylesheet" href="MarkdownCSS/markdown.css">
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