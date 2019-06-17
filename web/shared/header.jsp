<%-- 
    Document   : header
    Created on : Jun 16, 2019, 10:06:53 PM
    Author     : nguyenhongphat0
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Phat Flower</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/grid.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/theme.css">
</head>
<body>
	<div class="header">
		<div class="container">
			<div class="grid">
				<div class="d-5 left">
                                    <a href="${pageContext.request.contextPath}"><img src="${pageContext.request.contextPath}/assets/img/logo.png" title="Phat Flower" height="100"/></a>
				</div>
				<div class="d-5 right menu">
					<span class="menu-item"><a href="ViewAllController" class="wave">Hoa</a></span>
					<span class="menu-item"><a href="ViewAllController" class="wave">Cây kiểng</a></span>
					<span class="menu-item"><a href="ViewAllController" class="wave">Chậu</a></span>
					<span class="menu-item"><a href="ViewAllController" class="wave">Giới thiệu</a></span>
					<span class="menu-item"><a href="admin.jsp" class="wave">Quản lý</a></span>
				</div>
			</div>
		</div>
	</div>