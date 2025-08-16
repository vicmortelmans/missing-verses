<?xml version="1.0"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="@*|node()"/>
  <xsl:template match="data">
      <xsl:copy>
          <xsl:apply-templates/>
      </xsl:copy>
  </xsl:template>
  <xsl:template match="data/*">
      <xsl:message>Parsing passage <xsl:value-of select="ref"/></xsl:message>
      <xsl:variable name="verses" select="doc(concat('http://localhost:8080/yql/bibleref?language=nl&amp;xml=true&amp;bibleref=',ref))/query/results/biblerefs/bibleref"/>
      <xsl:apply-templates select="$verses">
          <xsl:with-param name="data" select="."/>
          <xsl:with-param name="skipped" select="'n'"/>
      </xsl:apply-templates>
      <xsl:if test="skipped != ''">
          <xsl:message>Parsing skipped passage <xsl:value-of select="skipped"/></xsl:message>
          <xsl:variable name="verses" select="doc(concat('http://localhost:8080/yql/bibleref?language=nl&amp;xml=true&amp;bibleref=',skipped))/query/results/biblerefs/bibleref"/>
          <xsl:apply-templates select="$verses">
              <xsl:with-param name="data" select="."/>
              <xsl:with-param name="skipped" select="'y'"/>
          </xsl:apply-templates>
      </xsl:if>
  </xsl:template>
  <xsl:template match="bibleref">
      <xsl:param name="data"/>
      <xsl:param name="skipped"/>
      <xsl:copy>
          <xsl:copy-of select="$data/liturgical_day"/>
          <xsl:copy-of select="$data/day"/>
          <xsl:copy-of select="$data/form"/>
          <xsl:copy-of select="$data/reading"/>
          <xsl:copy-of select="$data/obligation"/>
          <xsl:copy-of select="$data/abridged"/>
          <skipped><xsl:value-of select="$skipped"/></skipped>
          <xsl:copy-of select="osisbook"/>
          <xsl:copy-of select="canbook"/>
          <xsl:copy-of select="chapter"/>
          <xsl:copy-of select="verse"/>
          <xsl:copy-of select="osisref"/>
      </xsl:copy>
  </xsl:template>
</xsl:stylesheet>

