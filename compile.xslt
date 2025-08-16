<?xml version="1.0"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes"/>
  <xsl:variable name="can" select="doc('canisius-with-daniel-fill-from-w95.xml')/data/*"/>
  <xsl:template match="@*|node()"/>
  <xsl:template match="data">
      <xsl:copy>
        <xsl:for-each-group select="bibleref" group-by="osisref">
            <xsl:variable name="bible" select="$can[Book_ID = current-group()[1]/canbook][Chapter = current-group()[1]/chapter][Verse = current-group()[1]/verse]"/>
            <xsl:if test="not($bible)"><xsl:message>No text for <xsl:value-of select="current-grouping-key()"/> (can <xsl:value-of select="current-group()[1]/canbook"/>)</xsl:message></xsl:if>
            <bibleref>
                <xsl:copy-of select="current-group()[1]/osisbook"/>
                <xsl:copy-of select="current-group()[1]/canbook"/>
                <xsl:copy-of select="current-group()[1]/chapter"/>
                <xsl:copy-of select="current-group()[1]/verse"/>
                <text><xsl:if test="$bible"><xsl:value-of select="$bible/Scripture"/></xsl:if></text>
                <form form="eo">
                    <xsl:for-each select="current-group()[form='eo']" >
                        <xsl:sort select="skipped"/>
                        <in>
                            <xsl:copy-of select="liturgical_day"/>
                            <xsl:copy-of select="day"/>
                            <xsl:copy-of select="form"/>
                            <xsl:copy-of select="reading"/>
                            <xsl:copy-of select="obligation"/>
                            <xsl:copy-of select="abridged"/>
                            <xsl:copy-of select="skipped"/>
                        </in>
                    </xsl:for-each>
                </form>
                <form form="of">
                    <xsl:for-each select="current-group()[form='of']" >
                        <xsl:sort select="skipped"/>
                        <in>
                            <xsl:copy-of select="liturgical_day"/>
                            <xsl:copy-of select="day"/>
                            <xsl:copy-of select="form"/>
                            <xsl:copy-of select="reading"/>
                            <xsl:copy-of select="obligation"/>
                            <xsl:copy-of select="abridged"/>
                            <xsl:copy-of select="skipped"/>
                        </in>
                    </xsl:for-each>
                </form>
            </bibleref>
        </xsl:for-each-group>
      </xsl:copy>
  </xsl:template>
</xsl:stylesheet>


