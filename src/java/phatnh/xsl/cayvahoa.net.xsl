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
    
    <xsl:template match="text()"></xsl:template>
    <xsl:template match="/">
        <products>
            <xsl:apply-templates></xsl:apply-templates>
        </products>
    </xsl:template>
    <xsl:template match="//div[contains(@class, 'sp-show')]">
        <product>
            <name>
                <xsl:value-of select=".//h3"></xsl:value-of>
            </name>
            <price>
                <xsl:value-of select=".//span[contains(@class, 'amount')]"></xsl:value-of>
            </price>
            <link>
                <xsl:value-of select="./a/@href"></xsl:value-of>
            </link>
            <image>
                <xsl:value-of select=".//img/@data-lazy-src"></xsl:value-of>
            </image>
        </product>
    </xsl:template>
</xsl:stylesheet>
