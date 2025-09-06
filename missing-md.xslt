<?xml version="1.0"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:strip-space elements="*" />
  <xsl:variable name="eoi18n" select="doc('Catholic Liturgical Days - extraordinary form.xml')/data/*"/>
  <xsl:variable name="ofi18n" select="doc('Catholic Liturgical Days - ordinary form.xml')/data/*"/>

  <xsl:template match="/">
      <xsl:text>---&#10;</xsl:text>
      <xsl:text>title: VERDONKER-MAANDE VERZEN&#10;</xsl:text>
      <xsl:text>author: gelovenleren.net&#10;</xsl:text>
      <xsl:text>lang: nl&#10;</xsl:text>
      <!--xsl:text>classoption:&#10;</xsl:text>
      <xsl:text>- twocolumn&#10;</xsl:text-->
      <xsl:text>geometry: twoside, paperheight=129mm, paperwidth=65mm, top=5.0mm, bottom=5.0mm, left=5.0mm, right=5.0mm&#10;</xsl:text>
      <xsl:text>toc: false&#10;</xsl:text>
      <!--xsl:text>header-includes: |&#10;</xsl:text>
      <xsl:text>    \usepackage{fancyhdr}&#10;</xsl:text>
      <xsl:text>    \pagestyle{fancy}&#10;</xsl:text>
      <xsl:text>    \fancyhead[CO,CE]{\leftmark}&#10;</xsl:text>
      <xsl:text>    \fancyfoot[CE,CO]{\thepage}&#10;</xsl:text>
      <xsl:text>    \fancyhead[LO,LE,RO,RE]{}&#10;</xsl:text>
      <xsl:text>    \fancyfoot[LO,LE,RO,RE]{}&#10;</xsl:text-->
      <xsl:text>...&#10;</xsl:text>
      <xsl:text>&#10;</xsl:text>
      <xsl:apply-templates select="data/book/chapter"/><!-- testing limited number of books -->
  </xsl:template>
  <xsl:template match="chapter">
    <xsl:if test="bibleref[form[@form='eo']/in[not(skipped='y')] and not(form[@form='of']/in[not(skipped='y')])]">
        <xsl:variable name="book" select="bibleref[1]/osisbook"/>
        <xsl:variable name="book-long" select="bibleref[1]/spoken"/>
        <!-- Book title -->
        <xsl:text>&#10;</xsl:text>
        <xsl:text># </xsl:text><xsl:value-of select="$book-long"/>, <xsl:value-of select="bibleref[1]/chapter"/>
        <xsl:text>&#10;&#10;</xsl:text>
        <!-- Verses -->
        <xsl:for-each select="bibleref">
          <xsl:sort select="verse" data-type="number"/>
          <xsl:if test="form[@form='eo']/in[not(skipped='y')] and not(form[@form='of']/in[not(skipped='y')])">
              <xsl:text>^</xsl:text><xsl:value-of select="verse"/><xsl:text></xsl:text><xsl:text>^ </xsl:text>
              <xsl:value-of select="text"/>
              <xsl:text>&#10;</xsl:text>
          </xsl:if>
        </xsl:for-each>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>


