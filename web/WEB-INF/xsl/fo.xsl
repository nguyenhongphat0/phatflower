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
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">
    <xsl:output method="xml"/>
    <xsl:param name="now"></xsl:param>
    <xsl:param name="root"></xsl:param>
    
    <xsl:template match="text()"></xsl:template>
    <xsl:template match="/">
        <fo:root font-family="Calibri">
            <fo:layout-master-set>
                <fo:simple-page-master master-name="A4">
                    <fo:region-body margin="2cm" margin-top="3.5cm"></fo:region-body>
                    <fo:region-before></fo:region-before>
                    <fo:region-after></fo:region-after>
                </fo:simple-page-master>
            </fo:layout-master-set>
            <fo:page-sequence master-reference="A4">
                <fo:static-content flow-name="xsl-region-before">
                    <fo:table>
                        <fo:table-column column-width="50%"></fo:table-column>
                        <fo:table-column column-width="50%"></fo:table-column>
                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell>
                                    <fo:block margin="1cm">
                                        <fo:external-graphic src="url({$root}/assets/img/logo.png)" content-height="2cm"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block margin="1cm">
                                        <fo:block font-weight="bold">phatflower.vn</fo:block>
                                        <fo:block>Student: NGUYEN HONG PHAT</fo:block>
                                        <fo:block>ID: SE63348</fo:block>
                                        <fo:block>Class: SE1262</fo:block>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>
                </fo:static-content>
                <fo:static-content flow-name="xsl-region-after">
                    <fo:block margin-top="-1.5cm" text-align="center">
                        © 2019 Phat Flower Inc.
                    </fo:block>
                </fo:static-content>
                <fo:flow flow-name="xsl-region-body">
                    <fo:block font-size="24pt">Danh sách sản phẩm</fo:block>
                    <fo:block>
                        <xsl:value-of select="$now"></xsl:value-of>
                    </fo:block>
                    <fo:table margin-top="0.5cm" border="solid 1px black" text-align="center">
                        <fo:table-column column-width="10%"></fo:table-column>
                        <fo:table-column column-width="20%"></fo:table-column>
                        <fo:table-column column-width="30%"></fo:table-column>
                        <fo:table-column column-width="15%"></fo:table-column>
                        <fo:table-column column-width="25%"></fo:table-column>
                        <fo:table-body>
                            <fo:table-row font-weight="bold">
                                <fo:table-cell>
                                    <fo:block>STT</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>Sản phẩm</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>Tên</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>Giá</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block>Vị trí</fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                            <xsl:apply-templates></xsl:apply-templates>
                        </fo:table-body>
                    </fo:table>
                    <fo:block text-align="right">
                        Tổng cộng: <xsl:value-of select="count(//*[name()='plant'])"></xsl:value-of> sản phẩm
                    </fo:block>
                    <fo:block>
                        Cảm ơn bạn đã sử dụng dịch vụ
                    </fo:block>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>
    <xsl:template match="*[name()='plant']">
        <fo:table-row border="solid 1px black">
            <fo:table-cell>
                <fo:block>
                    <xsl:number count="*[name()='plant']"></xsl:number>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block>
                    <xsl:variable name="image" select="*[name()='image']"></xsl:variable>
                    <fo:external-graphic src="url({$image})" content-height="2cm"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block>
                    <xsl:value-of select="*[name()='name']"></xsl:value-of>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block>
                    <xsl:value-of select="format-number(*[name()='price'], '###,###')"></xsl:value-of> vnđ
                </fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block>
                    <xsl:variable name="link" select="*[name()='link']"></xsl:variable>
                    <fo:basic-link external-destination="{$link}">
                        <xsl:value-of select="$link"></xsl:value-of>
                    </fo:basic-link>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>
</xsl:stylesheet>
