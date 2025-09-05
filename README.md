# missing-verses
lectionary outline comparing novus ordo to tridentine mass

Build sequence:

Launch the standalone bibleref parser that is available here:
https://github.com/vicmortelmans/lectionarium-van-de-tridentijnse-mis/tree/master/missaal-eo/bibleref-standalone

java net.sf.saxon.Transform -xsl:expand.xslt -s:"catholic-resources.org - lectionary.xml" -o:expanded.xml

java net.sf.saxon.Transform -xsl:compile.xslt -s:expanded.xml -o:compiled.xml 

java net.sf.saxon.Transform -xsl:organize.xslt -s:compiled.xml -o:organized.xml

java net.sf.saxon.Transform -xsl:render.xslt -s:organized.xml -o:rendered.html

java net.sf.saxon.Transform -xsl:render-chapters.xslt -s:organized.xml -o:dummy.xml

java net.sf.saxon.Transform -xsl:missing-md.xslt -s:organized.xml -o:verdonkermaand.md

pandoc -f markdown -t pdf verdonkermaand.md > verdonkermaand.pdf

./deploy
