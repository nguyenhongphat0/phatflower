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
                        <span>Tên: </span><b>NGUYEN HONG PHAT</b><br/>
                        <span>MSSV: </span><b>SE63348</b><br/>
                        <span>Lớp: </span><b>SE1262</b>
                    </p>
                </div>
            </div>
        </div>
        <div class="m-10 d-3">
            <div class="parallax">
                <img class="parallax-background" src="${pageContext.request.contextPath}/assets/img/parallax.jpg" alt="">
                <div class="parallax-content center">
                    <h3>- Thông tin dự án -</h3>
                    <p>
                        <a class="wave white-text" href="#project-information">Chi tiết +</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="section">
    <div class="grid container">
        <div class="d-10">
            <div class="center">
                <h1 class="light">Tôi muốn mua <b id="running-text"></b></h1>
                <p>
                <form action="FrontController?action=list" method="POST">
                    <input type="text" name="category" placeholder="nhập tên hoặc thể loại...">
                    <button class="wave" type="submit">Tìm ngay</button>
                </form>
                </p>
            </div>
        </div>
    </div>
    <script>
        textes = [
            'CÂY KIỂNG',
            'HOA',
            'CHẬU',
            'SEN ĐÁ',
            'GIỐNG',
            'ĐẤT TRỒNG'
        ];
        function appendTextAfter(text, c, timeout) {
            setTimeout(function () {
                text.innerHTML += c;
            }, timeout);
        }
        function runningText(i) {
            var text = document.getElementById('running-text');
            if (i === textes.length) {
                i = 0;
            }
            var chars = textes[i].split('');
            for (var j = 0; j < chars.length; j++) {
                appendTextAfter(text, chars[j], 100 * j);
            }
            i++;
            setTimeout(function () {
                clearText(i);
            }, 3000);
        }
        function clearText(i) {
            var text = document.getElementById('running-text');
            for (var j = 0; j < text.innerHTML.length; j++) {
                setTimeout(function () {
                    text.innerHTML = text.innerHTML.substring(0, text.innerHTML.length - 1);
                }, 50 * j);
            }
            setTimeout(function () {
                runningText(i);
            }, 1000);
        }
        runningText(0);
    </script>
</div>
<div>
    <div class="grid">
        <div class="d-10">
            <div class="parallax">
                <img class="parallax-background" src="${pageContext.request.contextPath}/assets/img/parallax.jpg" alt="">
                <div class="parallax-content center">
                    <h3>- Các từ khoá phổ biến -</h3>
                    <p id="popular-keywords"></p>
                </div>
            </div>
        </div>
    </div>
    <script>
        function fetchKeywords() {
            request({
                action: 'admin',
                task: 'fetchCategories'
            }, function(res) {
                var container = document.getElementById('popular-keywords');
                var keywords = res.responseXML.getElementsByTagName('category');
                for (var i = 0; i < keywords.length && i < 20; i++) {
                    var keyword = keywords[i];
                    var name = keyword.querySelector('name').textContent;
                    var count = keyword.querySelector('count').textContent;
                    container.innerHTML += '<a class="wave" href="FrontController?action=list&category=' + name + '">' + name + '(' + count + ')' + '</a>';
                }
            });
        }
        fetchKeywords();
    </script>
</div>
<div class="section">
    <div class="container">
        <h1 class="light">Các sản phẩm được quan tâm nhất</h1>
        <div class="grid" id="top-5-container"></div>
    </div>
    <script>
        function fetchTop5() {
            request({
                action: 'admin',
                task: 'mostViewedPlants',
                limit: 5
            }, function (res) {
                var container = document.getElementById('top-5-container');
                var plants = res.responseXML.getElementsByTagName('plant');
                for (var i = 0; i < plants.length; i++) {
                    var plant = plants[i];
                    container.innerHTML += plant2HTML(plant, true);
                }
            });
        }
        fetchTop5();
    </script>
</div>
<div id="project-information">
    <div class="grid">
        <div class="d-10">
            <div class="parallax">
                <img class="parallax-background" src="${pageContext.request.contextPath}/assets/img/colorful.jpg" alt="">
                <div class="parallax-content center">
                    <h3>- Thông tin dự án -</h3>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="section">
    <div class="grid container">
        <div class="m-10 d-5">
            <h3 class="light">Required</h3>
            <p>
                <div class="checkbox">
                    <input type="checkbox" checked="true">
                    <label>Using XML, XML combining JSP (1)</label>
                </div>
                <div class="checkbox">
                    <input type="checkbox" checked="true">
                    <label>Using DTD, or Schema for validating after processed (1)</label>
                </div>
                <div class="checkbox">
                    <input type="checkbox" checked="true">
                    <label>Using Parser API (1)</label>
                </div>
                <div class="checkbox">
                    <input type="checkbox" checked="true">
                    <label>Using JAXB (1)</label>
                </div>
                <div class="checkbox">
                    <input type="checkbox" checked="true">
                    <label>Using XSL, PDF (1)</label>
                </div>
            </p>
        </div>
        <div class="m-10 d-5">
            <h3 class="light">Additional</h3>
            <h4 class="light">Processing in client side, restricting post back server, RIA on clients (2)</h4>
            <p>
                <div class="checkbox">
                    <input type="checkbox" checked="true">
                    <label>Live search on header</label>
                </div>
                <div class="checkbox">
                    <input type="checkbox" checked="true">
                    <label>Search, filter, pagination on client</label>
                </div>
                <div class="checkbox">
                    <input type="checkbox" checked="true">
                    <label>Load results using XML Request</label>
                </div>
            </p>
            <h4 class="light">Project contents, new ideas (3)</h4>
            <p>
                <div class="checkbox">
                    <input type="checkbox" checked="true">
                    <label><b>Responsive</b> on mobile devices</label>
                </div>
                <div class="checkbox">
                    <input type="checkbox" checked="true">
                    <label>Compatible with 99% browsers that support JS</label>
                </div>
                <div class="checkbox">
                    <input type="checkbox" checked="true">
                    <label>Categorize products by its name</label>
                </div>
                <div class="checkbox">
                    <input type="checkbox" checked="true">
                    <label>Useful analytics information</label>
                </div>
            </p>
        </div>
    </div>
</div>
<jsp:include page="shared/footer.jsp"/>