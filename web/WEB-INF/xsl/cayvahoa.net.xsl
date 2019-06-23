<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : cayvahoa.xsl
    Created on : June 11, 2019, 7:35 PM
    Author     : nguyenhongphat0
    Description:
        Purpose of transformation follows.
-->
<xsl:stylesheet xmlns="http://phatflower.vn"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
    <xsl:output method="xml"/>
    
    <xsl:template match="text()"></xsl:template>
    <xsl:template match="/">
        <xsl:element name="plants">
            <xsl:apply-templates></xsl:apply-templates>
        </xsl:element>
    </xsl:template>
    <xsl:template match="//div[contains(@class, 'sp-show')]">
        <xsl:element name="plant">
            <xsl:element name="name">
                <xsl:value-of select=".//h3"></xsl:value-of>
            </xsl:element>
            <xsl:element name="price">
                <xsl:variable name="price" select=".//span[contains(@class, 'amount')]"></xsl:variable>
                <xsl:value-of select="translate($price, translate($price, '0123456789', ''), '')"></xsl:value-of>
            </xsl:element>
            <xsl:element name="link">
                <xsl:value-of select="./a/@href"></xsl:value-of>
            </xsl:element>
            <xsl:element name="image">
                <xsl:value-of select=".//img/@data-lazy-src"></xsl:value-of>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
