<%-- 
    Document   : header
    Created on : Jun 16, 2019, 10:06:53 PM
    Author     : nguyenhongphat0
--%>

<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Phat Flower</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/grid.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/theme.css">
        <script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
</head>
<body>
	<div class="header">
		<div class="container">
			<div class="grid">
				<div class="m-10 d-3 left">
                                    <a href="${pageContext.request.contextPath}"><img src="${pageContext.request.contextPath}/assets/img/logo.png" title="Phat Flower" height="80"/></a>
				</div>
				<div class="m-10 d-7 right menu">
                                    <span class="menu-item"><a href="FrontController?action=list" class="wave">Tất cả</a></span>
                                    <c:import var="xml" url="WEB-INF/xml/categories.xml" charEncoding="UTF-8"></c:import>
                                    <x:parse var="doc" doc="${xml}"></x:parse>
                                    <x:set var="categories" select="$doc//*[name()='category' and (*[name()='onmenu']='true')]"></x:set>
                                    <x:forEach select="$categories" var="category">
                                        <x:set var="name" select="$category/*[name()='name']"></x:set>
                                        <span class="menu-item">
                                            <a href="FrontController?action=list&category=<x:out select="$name"></x:out>" class="wave">
                                                <x:out select="$name"></x:out>
                                            </a>
                                        </span>
                                    </x:forEach>
                                    <span class="menu-item"><a href="admin.jsp" class="wave">Quản lý</a></span>
				</div>
			</div>
		</div>
	</div>