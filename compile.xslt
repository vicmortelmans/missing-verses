<?xml version="1.0"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes"/>
  <xsl:variable name="can" select="doc('canisius-with-daniel-fill-from-w95.xml')/data/*"/>
  <xsl:variable name="biblerefs" select="/data/bibleref"/>
  <xsl:template match="@*|node()"/>
  <xsl:template match="/">
      <data>
          <xsl:apply-templates select="$can" mode="verse"/>
      </data>
  </xsl:template>
  <xsl:template match="*" mode="verse">
      <xsl:variable name="biblerefs-chapter" select="$biblerefs[canbook=current()/Book_ID][chapter=current()/Chapter]"/>
      <xsl:variable name="biblerefs-verse" select="$biblerefs[canbook=current()/Book_ID][chapter=current()/Chapter][verse=current()/Verse]"/>
      <xsl:if test="$biblerefs-chapter">
          <bibleref>
            <xsl:copy-of select="$biblerefs-chapter[1]/osisbook"/>
            <xsl:copy-of select="$biblerefs-chapter[1]/spoken"/>
            <xsl:copy-of select="$biblerefs-chapter[1]/localbook"/>
            <canbook><xsl:value-of select="Book_ID"/></canbook>
            <chapter><xsl:value-of select="Chapter"/></chapter>
            <verse><xsl:value-of select="Verse"/></verse>
            <text><xsl:value-of select="Scripture"/></text>
            <xsl:if test="$biblerefs-verse">
                <form form="of">
                    <xsl:for-each select="$biblerefs-verse[form='of']" >
                        <xsl:sort select="skipped"/>
                        <in>
                            <xsl:copy-of select="reading_id"/>
                            <xsl:copy-of select="chapterversereference"/>
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
                <form form="eo">
                    <xsl:for-each select="$biblerefs-verse[form='eo']" >
                        <xsl:sort select="skipped"/>
                          <in>
                              <xsl:copy-of select="reading_id"/>
                              <xsl:copy-of select="chapterversereference"/>
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
              </xsl:if>
          </bibleref>
      </xsl:if>
  </xsl:template>
</xsl:stylesheet>


