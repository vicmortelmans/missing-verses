<?xml version="1.0"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:f="http://functions">
  <xsl:output method="html" name="html" version="5.0" encoding="UTF-8" indent="yes" />
  <xsl:template match="/">
      <html>
          <head>
              <title>Lees de Bijbel in de Mis</title>
              <link rel="stylesheet" href="style.css"/>
          </head>
          <body>
              <xsl:apply-templates select="//bibleref[canbook &gt; 33][canbook &lt; 41]"/><!-- testing limited number of books -->
          </body>
      </html>
  </xsl:template>
  <xsl:template match="bibleref">
      <xsl:if test="verse=1">
          <xsl:if test="ancestor::chapter=ancestor::book/chapter[1]"><!-- test if this is the first chapter of a book that is printed, not necessarily chapter 1 -->
              <div class="book"><h1><xsl:value-of select="spoken"/></h1></div>
          </xsl:if>
          <a href="html/{osisbook}-{chapter}.html" target="_blank">
              <div class="chapter"><b><xsl:value-of select="chapter"/></b></div>
          </a>
      </xsl:if>
      <div class="verse">
          <div class="top-stack">
              <xsl:for-each select="form[@form='eo']/in">
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
              <xsl:for-each select="form[@form='of']/in">
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
          <i><xsl:value-of select="verse"/></i>
      </div>
  </xsl:template>
</xsl:stylesheet>
