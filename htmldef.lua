local htmldef = {}

htmldef["begin"] =
[[<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script type="text/javascript" src="MathJax/MathJax.js?config=AM_SVG"></script>
    <style>
        .math { text-align: center; }
    </style>
    <link rel="stylesheet" href="Highlight/styles/default.css">
    <script src="Highlight/highlight.pack.js"></script>
    <script>hljs.initHighlightingOnLoad();</script>
</head>
<body>
    </p>]]

htmldef["end"] =
[[
    </p>
</body>
</html>
]]

return htmldef