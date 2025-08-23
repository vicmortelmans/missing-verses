<?xml version="1.0"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes"/>
  <xsl:variable name="eoi18n" select="doc('Catholic Liturgical Days - extraordinary form.xml')/data/*"/>
  <xsl:variable name="ofi18n" select="doc('Catholic Liturgical Days - ordinary form.xml')/data/*"/>

  <xsl:template match="/">
      <xsl:apply-templates select="data/book/chapter"/><!-- testing limited number of books -->
  </xsl:template>
  <xsl:template match="chapter">
      <xsl:variable name="book" select="bibleref[1]/osisbook"/>
      <xsl:variable name="book-long" select="bibleref[1]/spoken"/>
      <xsl:result-document href="html/{$book}-{@chapter}.html" method="html">
        <html>
          <head>
            <title>Lees de Bijbel in de Mis</title>
            <link rel="stylesheet" href="style-chapters.css"/>
          </head>
          <body>
            <xsl:variable name="ofdays">
                <xsl:for-each-group select="bibleref/form[@form='of']/in[skipped='n']" group-by="reading_id">
                    <xsl:sort select="reading"/>
                    <xsl:sequence select="current-group()[1]"/>
                </xsl:for-each-group>
            </xsl:variable>
            <xsl:variable name="eodays">
                <xsl:for-each-group select="bibleref/form[@form='eo']/in" group-by="reading_id">
                    <xsl:sort select="reading"/>
                    <xsl:sequence select="current-group()[1]"/>
                </xsl:for-each-group>
            </xsl:variable>
            <div class="buttons">
                <h2>Selecteer een lezing</h2>
                <xsl:if test="exists($ofdays/in)">
                    <p>Lectionarium:</p>
                </xsl:if>
                <xsl:variable name="chapter" select="."/>
                <xsl:for-each select="$ofdays/in">
                    <!--xsl:sort select="position()" data-type="number" order="descending"/-->
                    <button data-view="{reading_id}">
                        <xsl:if test="obligation='n'">
                            <xsl:attribute name="class">optional</xsl:attribute>
                        </xsl:if>
                        <xsl:variable name="day">
                          <xsl:variable name="ref">
                            <xsl:choose>
                              <xsl:when test="contains(liturgical_day,'.')">
                                <xsl:value-of select="concat('of.',substring-before(liturgical_day,'.'))"/>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select="concat('of.',liturgical_day)"/>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:variable>
                          <xsl:variable name="i18n" select="$ofi18n[ref=$ref]"/>
                          <xsl:choose>
                            <xsl:when test="$i18n">
                              <xsl:value-of select="$i18n/nl"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:message>no nl for <xsl:value-of select="$ref"/></xsl:message>
                              <xsl:value-of select="day"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:variable>
                        <xsl:value-of select="$day"/> (<xsl:value-of select="chapterversereference"/>)
                    </button>
                </xsl:for-each>
                <xsl:if test="exists($eodays/in)">
                    <p>Tridentijnse mis:</p>
                </xsl:if>
                <xsl:for-each select="$eodays/in">
                    <!--xsl:sort select="position()" data-type="number" order="descending"/-->
                    <button data-view="{reading_id}">
                        <xsl:if test="obligation='n'">
                            <xsl:attribute name="class">optional</xsl:attribute>
                        </xsl:if>
                        <xsl:variable name="day">
                          <xsl:variable name="ref">
                            <xsl:choose>
                              <xsl:when test="contains(liturgical_day,'.')">
                                <xsl:value-of select="concat('eo.',substring-before(liturgical_day,'.'))"/>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select="concat('eo.',liturgical_day)"/>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:variable>
                          <xsl:variable name="i18n" select="$eoi18n[ref=$ref]"/>
                          <xsl:choose>
                            <xsl:when test="$i18n">
                              <xsl:value-of select="$i18n/nl"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:message>no nl for <xsl:value-of select="$ref"/></xsl:message>
                              <xsl:value-of select="day"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:variable>
                        <xsl:value-of select="$day"/> (<xsl:value-of select="chapterversereference"/>)
                    </button>
                </xsl:for-each>
                <h2>Legende</h2>
                <p class="legenda"><span class="any">Komt voor in een lezing</span> | <span class="censored">Komt voor in Tridentijnse Mis, maar niet in Lectionarium</span> | <span class="highlight-green">Tekst van de geselecteerde lezing</span> | <span class="highlight-orange">Tekst van de geselecteerde lezing die wegvalt in de korte versie</span> | <span class="highlight-red">Tekst die in de lezing wordt overgeslagen</span>.</p>
                <p>De lezingen die worden gemarkeerd in geel, vallen op weekdagen.</p>
            </div>
            <div class="content">
                <div>
                  <p class="title">De Bijbel<br/>Vertaling Petrus Canisius</p>
                </div>
                <!-- Book title -->
                <h2 id="{$book}" class="page">
                    <xsl:value-of select="$book-long"/>, hoofdstuk <xsl:value-of select="bibleref[1]/chapter"/>
                </h2>
                <p>
                    <xsl:variable name="previous-chapter" select="preceding::chapter[bibleref][1]"/>
                    <xsl:variable name="next-chapter" select="following::chapter[bibleref][1]"/>
                    <xsl:if test="$previous-chapter">
                        <a href="{$previous-chapter/bibleref[1]/osisbook}-{$previous-chapter/bibleref[1]/chapter}.html">Vorig hoofdstuk</a>
                    </xsl:if>
                    <xsl:if test="$previous-chapter or $next-chapter"> — </xsl:if>
                    <xsl:if test="$next-chapter">
                        <a href="{$next-chapter/bibleref[1]/osisbook}-{$next-chapter/bibleref[1]/chapter}.html">Volgend hoofdstuk</a>
                    </xsl:if>
                </p>
                <!-- Verses -->
                <xsl:for-each select="bibleref">
                  <xsl:sort select="verse" data-type="number"/>
                  <sup><xsl:value-of select="verse"/><xsl:text> </xsl:text></sup>
                  <span class="sentence">
                      <xsl:variable name="views">
                          <xsl:if test="form/in[not(skipped='y')]">any </xsl:if>
                          <xsl:if test="form[@form='eo']/in and not(form[@form='of']/in[not(skipped='y')])">censored </xsl:if>
                          <xsl:for-each select="form[@form='of']/in">
                              <xsl:variable name="color">
                                  <xsl:choose>
                                      <xsl:when test="skipped='y'">red</xsl:when>
                                      <xsl:when test="abridged='y'">orange</xsl:when>
                                      <xsl:when test="optional='y'">yellow</xsl:when>
                                      <xsl:otherwise>green</xsl:otherwise>
                                  </xsl:choose>
                              </xsl:variable>
                              <xsl:value-of select="concat(reading_id,':',$color,' ')"/>
                          </xsl:for-each>
                          <xsl:for-each select="form[@form='eo']/in">
                              <xsl:variable name="color">
                                  <xsl:choose>
                                      <xsl:when test="skipped='y'">red</xsl:when>
                                      <xsl:when test="optional='y'">yellow</xsl:when>
                                      <xsl:otherwise>green</xsl:otherwise>
                                  </xsl:choose>
                              </xsl:variable>
                              <xsl:value-of select="concat(reading_id,':',$color,' ')"/>
                          </xsl:for-each>
                      </xsl:variable>
                      <xsl:attribute name="data-views" select="$views"/>
                      <xsl:value-of select="text"/>
                  </span>
                  <xsl:text> </xsl:text>
                </xsl:for-each>
                <p><a href="http://www.gelovenleren.net">gelovenleren.net</a></p>
            </div>
            <script>
                  const sentences = document.querySelectorAll(".sentence");
                  const buttons = document.querySelectorAll("button[data-view]");

                  sentences.forEach(s => {
                    // look through all view:color pairs
                    const mappings = s.dataset.views.split(" ");
                    mappings.forEach(m => {
                      if (m === "any") {
                        s.classList.add("any");
                      }
                      if (m === "censored") {
                        s.classList.add("censored");
                      }
                    });
                  });

                  buttons.forEach(btn => {
                    btn.addEventListener("click", () => {
                      const targetView = btn.dataset.view;

                      // Highlight the clicked button
                      buttons.forEach(b => b.classList.remove("active"));
                      btn.classList.add("active");

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
                          if (m === "any") {
                            s.classList.add("any");
                          }
                          if (m === "censored") {
                            s.classList.add("censored");
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


