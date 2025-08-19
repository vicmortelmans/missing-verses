<?xml version="1.0"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:f="http://functions">
  <xsl:output method="html" name="html" version="5.0" encoding="UTF-8" indent="yes" />
  <xsl:variable name="can" select="doc('canisius-with-daniel-fill-from-w95.xml')/data/*"/>
  <xsl:variable name="books" select="/data/book"/>
  <xsl:template match="/">
      <html>
          <head>
              <title>Lees de Bijbel in de Mis</title>
              <link rel="stylesheet" href="style.css"/>
          </head>
          <body>
              <xsl:apply-templates select="$can[Book_ID &gt; 33][Book_ID &lt; 41]" mode="verse"/><!-- testing limited number of books -->
          </body>
      </html>
  </xsl:template>
  <xsl:template match="*" mode="verse"><!-- active element is from canisius! -->
      <xsl:variable name="chapter" select="$books[@canbook=current()/Book_ID]/chapter[@chapter=current()/Chapter]"/><!-- empty if the chapter isn't printed -->
      <xsl:variable name="verse" select="$chapter/bibleref[verse=current()/Verse]"/><!-- empty if the verse isn't in a printed chapter -->
      <xsl:if test="$chapter/bibleref/form/in"><!-- complete chapter is printed if any verse is in a reading -->
          <xsl:message><xsl:value-of select="$chapter/bibleref[1]/osisbook"/> <xsl:value-of select="Chapter"/>:<xsl:value-of select="Verse"/></xsl:message>
          <xsl:if test="Verse=1">
              <xsl:if test="$chapter=$chapter/../*[1]"><!-- test if this is the first chapter of a book that is printed, not necessarily chapter 1 -->
                  <div class="book"><h1><xsl:value-of select="$chapter/bibleref[1]/spoken"/></h1></div>
              </xsl:if>
              <a href="html/{$chapter/bibleref[1]/osisbook}-{Chapter}.html" target="_blank">
                  <div class="chapter"><b><xsl:value-of select="Chapter"/></b></div>
              </a>
          </xsl:if>
          <div class="verse">
              <div class="top-stack">
                  <xsl:for-each select="$verse/form[@form='eo']/in">
                      <div>
                          <xsl:attribute name="class">
                              <xsl:text>band</xsl:text>
                              <xsl:if test="obligation='n'"> optional</xsl:if>
                              <xsl:if test="abridged='y'"> abridged</xsl:if>
                              <xsl:if test="skipped='y'"> skipped</xsl:if>
                          </xsl:attribute>
                      </div>
                  </xsl:for-each>
              </div>
              <div class="bottom-stack">
                  <xsl:for-each select="$verse/form[@form='of']/in">
                      <div>
                          <xsl:attribute name="class">
                              <xsl:text>band</xsl:text>
                              <xsl:if test="obligation='n'"> optional</xsl:if>
                              <xsl:if test="abridged='y'"> abridged</xsl:if>
                              <xsl:if test="skipped='y'"> skipped</xsl:if>
                          </xsl:attribute>
                      </div>
                  </xsl:for-each>
              </div>
              <i><xsl:value-of select="Verse"/></i>
          </div>
          <!--div>
              <xsl:attribute name="class">
                  <xsl:text>text </xsl:text>
                  <xsl:value-of select="concat(Book_ID,'-',Chapter)"/>
              </xsl:attribute>
              <xsl:value-of select="Scripture"/>
          </div-->
      </xsl:if>
  </xsl:template>
</xsl:stylesheet>
