<%-- 
    Document   : index
    Created on : Jun 16, 2019, 10:08:43 PM
    Author     : nguyenhongphat0
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="shared/header.jsp"/>
<div>
        <div class="grid">
                <div class="m-10 d-7 d-pr-2 m-pr-0 m-pb-2">
                        <div class="parallax">
                                <img class="parallax-background" src="${pageContext.request.contextPath}/assets/img/colorful.jpg" alt="">
                                <div class="parallax-content center">
                                        <h1 style="font-size: 64px">- PRX301 PROJECT -</h1>
                                        <p>
                                                <span>Student: </span><b>NGUYEN HONG PHAT</b><br/>
                                                <span>ID: </span><b>SE63348</b><br/>
                                                <span>Class: </span><b>SE1262</b>
                                        </p>
                                </div>
                        </div>
                </div>
                <div class="m-10 d-3">
                        <div class="parallax">
                                <img class="parallax-background" src="${pageContext.request.contextPath}/assets/img/parallax.jpg" alt="">
                                <div class="parallax-content center">
                                        <h3>- PROJECT INFORMATION -</h3>
                                        <p>
                                                <button class="wave white-text">View info +</button>
                                        </p>
                                </div>
                        </div>
                </div>
        </div>
</div>
<div class="section">
        <div class="grid container">
                <div class="m-10 d-5">
                        <div class="center">
                                <h1 class="light">Tôi muốn mua <b>HOA</b></h1>
                                <p>
                                        <input type="text" name="search">
                                        <button class="wave" type="submit">Tìm ngay</button>
                                </p>
                        </div>
                </div>
                <div class="m-10 d-5">
                        <div class="center">
                                <h1 class="light">Tôi muốn mua <b>CÂY KIỂNG</b></h1>
                                <p>
                                        <input type="text" name="search">
                                        <button class="wave" type="submit">Tìm ngay</button>
                                </p>
                        </div>
                </div>
        </div>
</div>
<jsp:include page="shared/footer.jsp"/>