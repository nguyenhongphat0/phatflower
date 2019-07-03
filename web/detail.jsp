<%-- 
    Document   : detail
    Created on : Jun 23, 2019, 7:38:48 AM
    Author     : nguyenhongphat0
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:if test="${empty param.quickview}">
    <jsp:include page="shared/header.jsp"/>
</c:if>
<c:if test="${not empty param.quickview}">
    <jsp:include page="shared/header-lite.jsp"/>
</c:if>
<div id="detail-summary">
    <div id="detail-overlay" style="background-image: url(${plant.image})"></div>
    <div class="grid container">
        <div class="m-2 d-1 d-pt-2">
            <div id="detail-thumbnails" class="thumbnail">
                <img src="${plant.image}"/>
            </div>
        </div>
        <div class="m-8 d-5 d-pl-4">
            <div id="previewer">
                <img src="${plant.image}"/>
            </div>
        </div>
        <div class="d-none m-block">
            <a class="no-underline" href="${plant.link}" target="_blank"><h1 class="accent-color">${plant.name}</h1></a>
            <span class="price">${dao.getReadablePrice(plant)} vnđ</span><br/>
            <small class="handwriting">${domain}</small>
        </div>
        <div class="m-none d-block d-4 d-pl-4 d-pr-4" id="detail-description">
            <a class="no-underline" href="${plant.link}" target="_blank"><h1 class="accent-color">${plant.name}</h1></a>
            <span class="price">${dao.getReadablePrice(plant)} vnđ</span><br/>
            <small class="handwriting">${domain}</small>
            <div class="small-text">
                <c:if test="${not empty content}">
                    <div id="real-content">${content}</div>
                </c:if>
                <c:if test="${not empty html}">
                    <div id="real-content"></div>
                    <script>
                        function mount() {
                            var origin = document.getElementById('origin-content');
                            var real = document.getElementById('real-content');
                            var description = '';
                            switch ('${domain}') {
                                case 'cayvahoa.net':
                                    description = origin.getElementsByClassName('entry-content')[0].innerHTML;
                                    break;
                                case 'vuoncayviet.com':
                                    var spans = origin.getElementsByTagName("span");
                                    for (i = 0; i < spans.length; i++) {
                                        if (spans[i]) {
                                            spans[i].style.removeProperty('font');
                                        }
                                    }
                                    description += origin.getElementsByClassName('ntv-price')[0].children[0].innerHTML;
                                    description += origin.getElementsByClassName('ntv-price')[0].children[1].innerHTML;
                                    description += origin.getElementsByClassName('ntv-price')[0].children[2].innerHTML;
                                    description += origin.getElementsByClassName('decription')[0].children[1].innerHTML;
                                    break;
                                case 'webcaycanh.com':
                                    var w100 = origin.getElementsByClassName("w100");
                                    var length = w100.length;
                                    for (i = 0; i < length; i++) {
                                        if (w100[0]) {
                                            w100[0].remove();
                                        }
                                    }
                                    origin.getElementsByClassName('kk-star-ratings')[0].remove();
                                    description = origin.getElementsByClassName('tab-content')[0].innerHTML;
                                    break;
                            }
                            real.innerHTML = description;
                        }
                        function loadImg() {
                            var imgs = document.getElementsByTagName('img');
                            for (i = 0; i < imgs.length; i++) {
                                var img = imgs[i];
                                var lazySrc = img.getAttribute('data-lazy-src')
                                if (lazySrc) {
                                    img.src = lazySrc;
                                }
                            }
                        }
                        function saveData() {
                            request({
                                action: 'admin',
                                task: 'saveContent',
                                id: ${param.id},
                                content: document.getElementById('real-content').innerHTML
                            }, function(res) {
                                console.log("Saving content to database successfully!")
                            });
                        }
                    </script>
                </c:if>
            </div>
        </div>
    </div>
</div>
<c:if test="${not empty dao.plantList}">
<div class="section">
    <div class="container">
        <h2>So với các sản phẩm khác</h2>
        <table border="0">
            <tbody>
                <c:forEach items="${dao.plantList}" var="item" varStatus="counter">
                    <tr>
                        <td width="120"><img src="${item.image}" alt="${item.name}" width="120"></td>
                        <td>
                            <a href="FrontController?action=detail&id=${item.id}" class="wave">${item.name}</a>
                        </td>
                        <td width="150" class="m-none"><small class="handwriting">${dao.getDomain(item)}</small></td>
                        <td class="right-text">
                            <span class="price">${dao.getReadablePrice(item)} vnđ</span>
                            <span class="diff-price">${dao.comparePrice(item, plant)}</span>
                        </td>
                        <td width="150" class="m-none"><a target="_blank" href="${item.link}" class="wave">Đến trang gốc</a></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</c:if>
<script>
    function loadThumbnail() {
        var container = document.getElementById('detail-thumbnails');
        container.children[0].onclick = viewThumbnail;
        var content = document.getElementById('real-content');
        var imgs = content.getElementsByTagName('img');
        var length = imgs.length;
        for (i = 0; i < length; i++) {
            var img = imgs[0];
            img.onclick = viewThumbnail;
            container.appendChild(img);
        }
    }
    function viewThumbnail() {
        var previewer = document.querySelector('#previewer img');
        var overlay = document.querySelector('#detail-overlay');
        previewer.src = this.src;
        overlay.style.backgroundImage = 'url(' + this.src + ')';
    }
    window.onload = function() {
        <c:if test="${not empty html}">
            mount();
            loadImg();
            saveData();
        </c:if>
        loadThumbnail();
    };
</script>
<c:if test="${empty param.quickview}">
    <jsp:include page="shared/footer.jsp"/>
</c:if>
<c:if test="${not empty param.quickview}">
        </body>
    </html>
</c:if>
<c:if test="${not empty html}">
    <!-- Because this section contains serious invalid html data, it should be at the very end of the page -->
    <div id="origin-content" style="display: none">${html}</div>
</c:if>