<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : cayvahoa.xsl
    Created on : June 11, 2019, 7:35 PM
    Author     : nguyenhongphat0
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml"/>
    
    <xsl:template match="/">
        <xsl:copy-of select="//div[contains(@class, 'sp-show')]"/>
    </xsl:template>
</xsl:stylesheet>
