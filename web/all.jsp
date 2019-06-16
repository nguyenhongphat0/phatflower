<%-- 
    Document   : all
    Created on : Jun 16, 2019, 10:12:04 PM
    Author     : nguyenhongphat0
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="shared/header.jsp"/>
<div class="section">
    <div class="grid container">
        <div class="m-10 d-3 d-pr-4">
            <h3>Phân loại</h3>
            <div class="hr"></div>
            <p>
                <small><b>Màu sắc</b></small>
                <div>
                    <div class="a-color" style="background: #123456">
                        <div class="amount">10</div>
                    </div>
                    <div class="a-color" style="background: #fafafa">
                        <div class="amount">5</div>
                    </div>
                    <div class="a-color" style="background: #E84C3D">
                        <div class="amount">230</div>
                    </div>
                    <div class="a-color" style="background: #F39C11">
                        <div class="amount">3</div>
                    </div>
                    <div class="a-color" style="background: #dce3f7">
                        <div class="amount">2</div>
                    </div>
                    <div class="a-color" style="background: #861850">
                        <div class="amount">4</div>
                    </div>
                    <div class="a-color" style="background: #A0D468">
                        <div class="amount">171</div>
                    </div>
                    <div class="a-color" style="background: var(--accent)">
                        <div class="amount">33</div>
                    </div>
                </div>
            </p>
            <div class="hr"></div>
            <p>
                <small><b>Giống</b></small>
                <div>
                    <div class="checkbox">
                        <input id="type-senda" type="checkbox" name="type" value="senda">
                        <label for="type-senda">Sen đá</label>
                    </div>
                    <div class="checkbox">
                        <input id="type-thuysinh" type="checkbox" name="type" value="thuysinh">
                        <label for="type-thuysinh">Thuỷ sinh</label>
                    </div>
                    <div class="checkbox">
                        <input id="type-caytrongnha" type="checkbox" name="type" value="caytrongnha">
                        <label for="type-caytrongnha">Cây trong nhà</label>
                    </div>
                </div>
            </p>
        </div>
        <div class="m-10 d-7">
            <h3>Tất cả cây cảnh</h3>
            <div class="hr"></div>
            <div class="grid">
                <c:forEach items="${list}" var="item" varStatus="counter">
                    <div id="product-${counter.count}" class="a-product m-5 d-2">
                        <div class="overlay">
                            <div class="center">
                                <a target="_blank" href="${item.link}" class="wave">Go to site</a>
                                <div class="d-pb-2"></div>
                                <a href="#" class="wave">Show relevant</a>
                                <div class="d-pb-2"></div>
                                <a href="#" class="wave">View more</a>
                            </div>
                        </div>
                        <div class="preview">
                            <img src="${item.image}" alt="${item.name}">
                        </div>
                        <div class="meta">
                            <h4>${item.name}</h4>
                            <span class="price">${item.readablePrice} vnđ</span><br/>
                            <small class="handwriting">${item.domain}</small>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>
<jsp:include page="shared/footer.jsp"/>