<?xml version="1.0"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="@*|node()"/>
  <xsl:template match="data">
      <xsl:copy>
        <xsl:for-each-group select="bibleref" group-by="canbook">
            <xsl:sort select="canbook" data-type="number"/>
            <book canbook="{current-grouping-key()}">
                <xsl:for-each-group select="current-group()" group-by="chapter">
                    <xsl:sort select="chapter" data-type="number"/>
                    <chapter chapter="{current-grouping-key()}">
                        <xsl:copy-of select="current-group()"/>
                    </chapter>
                </xsl:for-each-group>
            </book>
        </xsl:for-each-group>
      </xsl:copy>
  </xsl:template>
</xsl:stylesheet>


