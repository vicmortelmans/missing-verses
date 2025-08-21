# missing-verses
lectionary outline comparing novus ordo to tridentine mass

Build sequence:

java net.sf.saxon.Transform -xsl:expand.xslt -s:"catholic-resources.org - lectionary.xml" -o:expanded.xml

java net.sf.saxon.Transform -xsl:compile.xslt -s:expanded.xml -o:compiled.xml 2> no-text.txt

java net.sf.saxon.Transform -xsl:organize.xslt -s:compiled.xml -o:organized.xml

java net.sf.saxon.Transform -xsl:render.xslt -s:organized.xml -o:rendered.html

java net.sf.saxon.Transform -xsl:render-chapters.xslt -s:organized.xml -o:dummy.xml


