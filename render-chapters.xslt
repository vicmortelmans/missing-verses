<?xml version="1.0"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes"/>

  <xsl:variable name="can" select="doc('canisius-with-daniel-fill-from-w95.xml')/data/*"/>
  <xsl:variable name="books" select="/data/book"/>

  <xsl:template match="/">
      <xsl:apply-templates select="data/book[@canbook &gt; 39][@canbook &lt; 41]/chapter[@chapter=18]"/><!-- testing limited number of books -->
  </xsl:template>
  <xsl:template match="chapter">
      <xsl:variable name="book" select="bibleref[1]/osisbook"/>
      <xsl:variable name="book-long" select="bibleref[1]/spoken"/>
      <xsl:result-document href="html/{$book}-{@chapter}.html" method="html">
        <html>
          <head>
            <title>Lees de Bijbel in de Mis</title>
            <link rel="stylesheet" href="../style-chapters.css"/>
          </head>
          <body>
            <div>
              <p class="title">De Bijbel<br/>Vertaling Petrus Canisius</p>
              <p>De Heilige Schrift, vertaling uit de grondtekst in opdracht van de Apologetische Vereniging 'Petrus Canisius' ondernomen met goedkeuring van de hoogwaardige bisschoppen van Nederland</p>
              <p>Oorspronkelijke uitgave 1939</p>
              <p><a href="http://www.gelovenleren.net">gelovenleren.net</a></p>
            </div>
            <!-- Book title -->
            <h1 id="{$book}" class="page">
                <xsl:value-of select="$book-long"/>, hoofdstuk <xsl:value-of select="bibleref[1]/chapter"/>
            </h1>
            <!-- Highlighting buttons -->
            <xsl:variable name="ofdays">
                <xsl:for-each-group select="bibleref/form[@form='of']/in" group-by="reading">
                    <xsl:sort select="reading"/>
                    <xsl:sequence select="current-group()[1]"/>
                </xsl:for-each-group>
            </xsl:variable>
            <xsl:message>of: <xsl:copy-of select="$ofdays"/></xsl:message>
            <xsl:variable name="eodays">
                <xsl:for-each-group select="bibleref/form[@form='eo']/in" group-by="reading">
                    <xsl:sort select="reading"/>
                    <xsl:sequence select="current-group()[1]"/>
                </xsl:for-each-group>
            </xsl:variable>
            <xsl:message>eo: <xsl:copy-of select="$eodays"/></xsl:message>
            <div class="buttons">
                <xsl:if test="exists($ofdays/in)">
                    <h2>Lezingen in het lectionarium:</h2>
                </xsl:if>
                <xsl:variable name="chapter" select="."/>
                <xsl:for-each select="$ofdays/in">
                    <!--xsl:sort select="position()" data-type="number" order="descending"/-->
                    <button data-view="of{position()}">
                        <xsl:if test="obligation='n'">
                            <xsl:attribute name="class">optional</xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="day"/> (<xsl:value-of select="chapterversereference"/>)
                    </button>
                </xsl:for-each>
                <xsl:if test="exists($eodays/in)">
                    <h2>Lezingen in het missaal van de tridentijnse mis:</h2>
                </xsl:if>
                <xsl:for-each select="$eodays/in">
                    <!--xsl:sort select="position()" data-type="number" order="descending"/-->
                    <button data-view="eo{position()}">
                        <xsl:value-of select="day"/> (<xsl:value-of select="chapterversereference"/>)
                    </button>
                </xsl:for-each>
            </div>
            <!-- Verses -->
            <xsl:for-each select="bibleref">
              <xsl:sort select="verse" data-type="number"/>
              <sup><xsl:value-of select="verse"/><xsl:text> </xsl:text></sup>
              <xsl:message>verse: <xsl:value-of select="verse"/>;</xsl:message>
              <span class="sentence">
                  <xsl:variable name="views">
                      <xsl:for-each select="form[@form='of']/in">
                          <xsl:variable name="reading" select="reading"/>
                          <xsl:message><xsl:copy-of select="."/>; <xsl:copy-of select="$ofdays/in[reading=$reading]"/></xsl:message>
                          <xsl:variable name="in" select="concat('of',index-of($ofdays/in,$ofdays/in[reading=$reading]))"/>
                          <xsl:variable name="color">
                              <xsl:choose>
                                  <xsl:when test="abridged='y'">palegreen</xsl:when>
                                  <xsl:when test="optional='y'">palegreen</xsl:when>
                                  <xsl:when test="skipped='y'">red</xsl:when>
                                  <xsl:otherwise>green</xsl:otherwise>
                              </xsl:choose>
                          </xsl:variable>
                          <xsl:value-of select="concat($in,':',$color,' ')"/>
                      </xsl:for-each>
                      <xsl:for-each select="form[@form='eo']/in">
                          <xsl:variable name="liturgical_day" select="liturgical_day"/>
                          <xsl:variable name="in" select="concat('eo',index-of($eodays/in,$eodays/in[liturgical_day=$liturgical_day]))"/>
                          <xsl:variable name="color">
                              <xsl:choose>
                                  <xsl:when test="optional='y'">palegreen</xsl:when>
                                  <xsl:when test="skipped='y'">red</xsl:when>
                                  <xsl:otherwise>green</xsl:otherwise>
                              </xsl:choose>
                          </xsl:variable>
                          <xsl:value-of select="concat($in,':',$color,' ')"/>
                      </xsl:for-each>
                  </xsl:variable>
                  <xsl:attribute name="data-views" select="$views"/>
                  <xsl:value-of select="text"/>
              </span>
              <xsl:text> </xsl:text>
            </xsl:for-each>
            <script>
                  const sentences = document.querySelectorAll(".sentence");
                  const buttons = document.querySelectorAll("button[data-view]");

                  buttons.forEach(btn => {
                    btn.addEventListener("click", () => {
                      const targetView = btn.dataset.view;

                      sentences.forEach(s => {
                        // clear old highlights
                        s.className = "sentence";

                        // look through all view:color pairs
                        const mappings = s.dataset.views.split(" ");
                        mappings.forEach(m => {
                          const [view, color] = m.split(":");
                          if (view === targetView) {
                            s.classList.add("highlight-" + color);
                          }
                        });
                      });
                    });
                  });
            </script>
          </body>
        </html>
      </xsl:result-document>
  </xsl:template>

</xsl:stylesheet>


