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
  <!-- yql api returns records like:

      <bibleref>
        <book>Mt</book>
        <localbook>mt</localbook>
        <osisbook>Matt</osisbook>
        <canbook>40</canbook>
        <chapterversereference>1:1-2</chapterversereference>
        <verseinbook>1</verseinbook>
        <chapter>1</chapter>
        <verse>1</verse>
        <phrase></phrase>
        <osisref>Matt.1.1</osisref>
        <sequence>Matt1001001</sequence>
        <remainingverses>23</remainingverses>
        <spoken>het evangelie volgens matte&#252;s</spoken>
      </bibleref>
  -->
  <xsl:template match="data/*">
      <xsl:message>Parsing passage <xsl:value-of select="ref"/></xsl:message>
      <xsl:variable name="verses" select="doc(concat('http://localhost:8080/yql/bibleref?language=nl&amp;xml=true&amp;bibleref=',ref))/query/results/biblerefs/bibleref"/>
      <xsl:variable name="abridged-verses">
          <xsl:if test="abridged != ''">
              <xsl:copy-of select="doc(concat('http://localhost:8080/yql/bibleref?language=nl&amp;xml=true&amp;bibleref=',abridged))/query/results/biblerefs/bibleref"/>
          </xsl:if>
      </xsl:variable>
      <xsl:apply-templates select="$verses">
          <xsl:with-param name="data" select="."/>
          <xsl:with-param name="skipped" select="'n'"/>
          <xsl:with-param name="readingreference" select="ref"/>
          <xsl:with-param name="abridged-verses" select="$abridged-verses"/>
      </xsl:apply-templates>
      <xsl:if test="skipped != ''">
          <xsl:message>Parsing skipped passage <xsl:value-of select="skipped"/></xsl:message>
          <xsl:variable name="verses" select="doc(concat('http://localhost:8080/yql/bibleref?language=nl&amp;xml=true&amp;bibleref=',skipped))/query/results/biblerefs/bibleref"/>
          <xsl:apply-templates select="$verses">
              <xsl:with-param name="data" select="."/>
              <xsl:with-param name="skipped" select="'y'"/>
              <xsl:with-param name="readingreference" select="ref"/>
          </xsl:apply-templates>
      </xsl:if>
  </xsl:template>
  <xsl:template match="bibleref">
      <xsl:param name="data"/>
      <xsl:param name="skipped"/>
      <xsl:param name="readingreference"/>
      <xsl:param name="abridged-verses"/>
      <xsl:copy>
          <xsl:copy-of select="$data/liturgical_day"/>
          <xsl:copy-of select="$data/day"/>
          <xsl:copy-of select="$data/form"/>
          <xsl:copy-of select="$data/reading"/>
          <xsl:copy-of select="$data/obligation"/>
          <abridged>
              <xsl:message><xsl:copy-of select="$abridged-verses"/></xsl:message>
              <xsl:choose>
                  <xsl:when test="$skipped='n' and $abridged-verses/* and not($abridged-verses/bibleref[canbook=current()/canbook][chapter=current()/chapter][verse=current()/verse])">y</xsl:when>
                  <xsl:otherwise>n</xsl:otherwise>
              </xsl:choose>
          </abridged>
          <skipped><xsl:value-of select="$skipped"/></skipped>
          <xsl:copy-of select="osisbook"/>
          <xsl:copy-of select="canbook"/>
          <xsl:copy-of select="chapter"/>
          <xsl:copy-of select="verse"/>
          <xsl:copy-of select="osisref"/>
          <xsl:copy-of select="spoken"/>
          <xsl:copy-of select="localbook"/>
          <xsl:copy-of select="chapterversereference"/>
          <reading_id>
            <xsl:call-template name="string-to-slug">
              <xsl:with-param name="text" select="concat($data/form,'-',$data/liturgical_day,'-',$readingreference)"/>
            </xsl:call-template>            
          </reading_id>
      </xsl:copy>
  </xsl:template>

  <xsl:template name="string-to-lowercase">
    <xsl:param name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:param>
    <xsl:param name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:param>
    <xsl:param name="text"/>
    <xsl:value-of select="translate($text,$ucletters,$lcletters)"/>
  </xsl:template>

  <xsl:template name="string-to-slug">
    <xsl:param name="text" select="''" />
    <xsl:variable name="dodgyChars" select="' ,.#_-!?*:;=+'" />
    <xsl:variable name="replacementChar" select="'------------'" />
    <xsl:variable name="lowercased"><xsl:call-template name="string-to-lowercase"><xsl:with-param name="text" select="$text" /></xsl:call-template></xsl:variable>
    <xsl:variable name="escaped"><xsl:value-of select="translate( $lowercased, $dodgyChars, $replacementChar )" /></xsl:variable>
    <xsl:variable name="ampRemoved"><xsl:value-of select="replace( $escaped, '&amp;', 'and' )" /></xsl:variable>
    <xsl:variable name="cleaned"><xsl:value-of select="replace( $ampRemoved, '--', '-' )" /></xsl:variable>
    <xsl:variable name="cleaned2"><xsl:value-of select="replace( $cleaned, '--', '-' )" /></xsl:variable>
    <xsl:value-of select="$cleaned2" />
  </xsl:template>

</xsl:stylesheet>

