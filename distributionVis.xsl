<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="#all" version="2.0">

<!-- Author: Dot Porter -->
<!-- December 5, 2014 -->
<!-- Written to enable comparison of the distribution of illustrations in manuscripts from the Digital Walters (http://thedigitalwalters.org/) -->

    <xsl:template match="/">

    <!-- Set a variable to count all the relevant surface tags in the manuscript description -->
    <xsl:variable name="count-all" select="count(//tei:surface[starts-with(@n,'fol.') and (ends-with(@n,'r') or ends-with(@n,'v'))])"/>
    
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Visualize Distribution of Illustrations in Walters Manuscripts</title>
            </head>
            <body>
                <!-- identifies the manuscript by title, and place and date of origin -->
                <div style="position:absolute; top: 22px"><xsl:value-of select="//tei:title[@type='common']"/>. <xsl:value-of select="//tei:origDate"/>, <xsl:value-of select="//tei:origPlace"/></div>
                <!-- creates the border around the bar for this manuscript -->
                <!-- the "top" value for this and the divs following should be the top value of the div above, plus 18 -->
                <!-- for additional manuscripts on the same html page (as in the example), add 40 to the top values -->
                <div title="MS 1" class="ms"
                    style="height: 20px; border-style: solid; border-width: 1px; width: 90%; position: absolute; left: 20px; top: 40px; z-index: -1"></div>
                
                <!-- select all the relevant surface values -->
                <xsl:for-each select="//tei:surface[starts-with(@n,'fol.') and (ends-with(@n,'r') or ends-with(@n,'v'))]">   
                    <!-- grab the @n value, ("fol. 1v") -->
                    <xsl:variable name="folio" select="@n"/>
                    <!-- count the preceding siblings to find the number of this one in the complete list -->
                    <xsl:variable name="count" select="count(preceding-sibling::tei:surface[starts-with(@n,'fol.') and ends-with(@n,'r') or ends-with(@n,'v')])+1"/>
                    <!-- figure the z-index (larger z-index numbers will be on top in the output) -->
                    <xsl:variable name="z-index" select="$count-all - $count"></xsl:variable>
                    <!-- figure the percentage that this folio is along in the manuscript -->
                    <xsl:variable name="percentage" select="format-number(($count div $count-all) * .9, '#%')"/>
                    
                    <!-- now select all decoNotes -->
                    <xsl:for-each select="//tei:decoNote">
                        <!-- grab the title -->
                        <xsl:variable name="title" select="tei:title"/>
                        <!-- if the @n of a decoNote contains the value for this folio, grab it and give it a <div> in output-->
                        <xsl:if test="contains(@n,$folio)">
                            <!-- Here I've experimented with changing the color based on keywords, which could relate to format (initial) or content (Christ) -->
                            <xsl:choose>
                                <xsl:when test="contains($title,'Initial') or contains($title,'initial')"><div class="illus" title="{concat($folio,': ',$title)}"
                                    style="height: 20px; width: {$percentage}; border-right-style: solid; border-right-color: red; z-index: {$z-index}; position: absolute; left: 20px; top: 40px;"></div></xsl:when>
                                <xsl:when test="contains($title,'Christ')"><div class="illus" title="{concat($folio,': ',$title)}"
                                    style="height: 20px; width: {$percentage}; border-right-style: solid; border-right-color: yellow; z-index: {$z-index}; position: absolute; left: 20px; top: 40px;"></div></xsl:when>
                                <xsl:otherwise><div class="illus" title="{concat($folio,': ',$title)}"
                                    style="height: 20px; width: {$percentage}; border-right-style: solid; z-index: {$z-index}; position: absolute; left: 20px; top: 40px;"></div>
                                </xsl:otherwise>
                            </xsl:choose>
                            </xsl:if>
                    </xsl:for-each>
                </xsl:for-each>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
