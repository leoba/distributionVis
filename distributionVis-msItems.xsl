<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="#all" version="2.0">

<!-- Author: Dot Porter -->
<!-- December 5, 2014 -->
<!-- Written to enable comparison of the distribution of illustrations in manuscripts from the Digital Walters (http://thedigitalwalters.org/) -->

    <xsl:template match="/">

        <!-- Set a variable to the number of all pages in the manuscript -->
        <xsl:variable name="count-all" select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msContents/tei:msItem[1]/tei:locus/@to"/>
        <xsl:variable name="itemCount" select="number(tokenize($count-all,'v') [position() = 1]) * 2"></xsl:variable>
        
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <link rel="stylesheet" type="text/css" href="distributionVis.css"/>
                <title>Visualize Distribution of msItems in Walters Manuscripts</title>
            </head>
            <body>
                <!-- identifies the manuscript by title, and place and date of origin -->
                <div style="position:absolute; top: 22px"><xsl:value-of select="//tei:title[@type='common']"/>. <xsl:value-of select="//tei:origDate"/>, <xsl:value-of select="//tei:origPlace"/></div>
                <!-- creates the border around the bar for this manuscript -->
                <!-- the "top" value for this and the divs following should be the top value of the div above, plus 18 -->
                <!-- for additional manuscripts on the same html page (as in the example), add 40 to the top values -->
                <div title="MS 1" class="ms"
                    style="height: 20px; border-style: solid; border-width: 1px; width: 90%; position: absolute; left: 20px; top: 40px; z-index: -1"></div>
                
                
                <!-- select all the msItems -->
                <xsl:for-each select="//tei:msItem">   
                    <!-- grab the title, ("Gallican Psalter") -->
                    <xsl:variable name="title" select="tei:title"/>
                    <!-- grab the locus, ("2r - 7v") -->
                    <xsl:variable name="locus" select="tei:locus"/>
                    <!-- count the preceding siblings to find the number of this one in the complete list -->
                    <xsl:variable name="count" select="number(tokenize(tei:locus/@to,'v') [position() = 1]) * 2"></xsl:variable>
                    <!-- figure the z-index (larger z-index numbers will be on top in the output) -->
                    <xsl:variable name="z-index" select="$itemCount - $count"></xsl:variable>
                    <!-- figure the percentage that this folio is along in the manuscript -->
                    <xsl:variable name="percentage" select="format-number(($count div $itemCount) * .9, '#%')"/>
                    
                    <xsl:choose>
                        <xsl:when test="contains($title,'Calendar')"><div class="item" title="{concat($locus,': ',$title)}"
                            style="height: 20px; width: {$percentage}; border-right-style: solid; background-color: green; z-index: {$z-index}; position: absolute; left: 20px; top: 40px;"></div></xsl:when>
                        <xsl:when test="contains($title,'Psalter')"><div class="item" title="{concat($locus,': ',$title)}"
                                    style="height: 20px; width: {$percentage}; border-right-style: solid; background-color: red; z-index: {$z-index}; position: absolute; left: 20px; top: 40px;"></div></xsl:when>
                        <xsl:when test="contains($title,'Dead')"><div class="item" title="{concat($locus,': ',$title)}"
                                    style="height: 20px; width: {$percentage}; border-right-style: solid; background-color: yellow; z-index: {$z-index}; position: absolute; left: 20px; top: 40px;"></div></xsl:when>
                         <xsl:otherwise><div class="item" title="{concat($locus,': ',$title)}"
                                    style="height: 20px; width: {$percentage}; border-right-style: solid; background-color: black; z-index: {$z-index}; position: absolute; left: 20px; top: 40px;"></div>
                         </xsl:otherwise>
                            </xsl:choose>
                    </xsl:for-each>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
