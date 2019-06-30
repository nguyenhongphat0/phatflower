<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : to-fo.xsl
    Created on : June 30, 2019, 7:19 PM
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
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="Calibri">
            <fo:layout-master-set>
                <fo:simple-page-master master-name="A4">
                    <fo:region-body margin="2cm" margin-top="3cm"></fo:region-body>
                    <fo:region-before></fo:region-before>
                </fo:simple-page-master>
            </fo:layout-master-set>
            <fo:page-sequence master-reference="A4">
                <fo:static-content flow-name="xsl-region-before">
                    <fo:block margin="2cm">
                        PhatFlower
                    </fo:block>
                </fo:static-content>
                <fo:flow flow-name="xsl-region-body">
                    <fo:block>
                        <xsl:apply-templates></xsl:apply-templates>
                    </fo:block>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
            
    </xsl:template>
    <xsl:template match="*[name()='plant']">
        <xsl:value-of select="*[name()='name']"></xsl:value-of>
    </xsl:template>
</xsl:stylesheet>
