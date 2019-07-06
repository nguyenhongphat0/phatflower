<%-- 
    Document   : admin
    Created on : Jun 17, 2019, 11:49:23 PM
    Author     : nguyenhongphat0
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Flower Admin</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/grid.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/theme.css">
        <style>
            body > div {
                height: 100%;
            }
            body > .grid > .d-2 {
                position: fixed;
                background-color: #151b26;
                box-shadow: 0 0 5px #151b26;
                height: 100%;
            }
            body > .grid > .d-2 * {
                color: white;
            }
            body > .grid > .d-8 {
                margin-left: 20%;
                padding: 20px 40px;
            }
            .admin-logo {
                width: 100%;
            }
            .admin-menu .logout {
                position: absolute;
                bottom: 30px;
            }
            .admin-menu .wave {
                display: block;
                width: 100%;
                box-sizing: border-box;
                cursor: pointer;
            }
            .cautions {
                font-style: italic;
                font-size: 12px;
            }
            #result {
                font-size: 16px;
                font-weight: bold;
            }
            #notification {
                position: fixed;
                right: 40px;
                bottom: 20px;
                width: 200px;
                height: 50px;
                background-color: #151b26;
                padding: 10px 20px;
                box-shadow: 0 0 5px #151b26;
                color: white;
            }
            pre {
                white-space: pre-wrap;
            }
        </style>
    </head>
    <body>
        <div class="grid">
            <div class="d-2">
                <a href="${pageContext.request.contextPath}"><img class="admin-logo" src="${pageContext.request.contextPath}/assets/img/logo.png" title="Phat Flower"/></a>
                <div class="admin-menu d-pt-4">
                    <a onclick="show('analytics'); analizeAll();" class="wave">Tổng quan</a>
                    <a onclick="show('crawl')" class="wave">Cào sản phẩm</a>
                    <a onclick="show('categorize'); fetchCategories();" class="wave">Phân loại sản phẩm</a>
                    <a onclick="show('logs'); fetchLogs()" class="wave">Nhật ký hệ thống</a>
                    <a class="wave logout" href="index.jsp">&lt; Đăng xuất</a>
                </div>
            </div>
            <div class="d-8">
                <div id="notification" class="hidden"></div>
                <div id="analytics">
                    <h1>Tổng quan</h1>
                    <div class="grid">
                        <div class="d-5">
                            <h3>Lượt xem thời gian thực</h3>
                            <canvas id="real-time-view-canvas"></canvas>
                        </div>
                        <div class="d-5">
                            <h3>Lượt xem theo ngày</h3>
                            <canvas id="daily-view-canvas"></canvas>
                        </div>
                    </div>
                    <div class="grid">
                        <div class="d-5">
                            <h3>Các trang được quan tâm nhất</h3>
                            <table id="urls-table">
                                <thead>
                                    <tr>
                                        <th width="50">STT</th>
                                        <th>Trang</th>
                                        <th width="100" style="text-align: left">Số lượt</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="d-5">
                            <h3>Trình duyệ̣t, thiết bị</h3>
                            <table id="user-agent-table">
                                <thead>
                                    <tr>
                                        <th width="50">STT</th>
                                        <th>User Agent</th>
                                        <th width="100" style="text-align: left">Số lượt</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div id="crawl">
                    <h1>Cào sản phẩm</h1>
                    <h2>Nhập đường dẫn để cào</h2>
                    <form name="crawl">
                        <input type="text" name="url" placeholder="https://cayvahoa.net/hoa-chau"/>
                        <button class="wave" type="submit" value="crawl" name="action">Cào ngay</button>
                    </form>
                    <p>
                        <div>Lưu ý:</div>
                        <ul class="cautions">
                            <li>Đường dẫn phải thuộc 1 trong 3 trang "cayvahoa.net", "vuoncayviet.com" hoặc "webcaycanh.com"</li>
                            <li>Hãy nhập đường dẫn những trang danh mục, vì nơi đó có nhiều sản phẩm nhất.</li>
                            <li>Đường dẫn phải bao gồm domain (có hay không có https:// đều được)</li>
                        </ul>
                    </p>
                    <div class="result"></div>
                </div>
                <div id="categorize">
                    <h1>Phân loại sản phẩm</h1>
                    <div class="cautions">
                        Thuật toán đánh danh mục sản phẩm sẽ dựa vào tên sản phẩm để phân loại. Ví dụ sản phẩm "Sen đá đỏ" sẽ được phân rã thành các ký tự "Sen", "Đá", "Sen Đá", "Đỏ", "Đá đỏ", "Sen đá đỏ". Các chuỗi ký tự nào có tần suất xuất hiện nhiều nhất sẽ được ưu tiên chọn làm danh mục.<br/>
                        Vui lòng nhập số chữ tối đa của 1 danh mục. Số càng lớn sẽ mất càng lâu để thực hiện.
                    </div>
                    <p>
                        Độ dài tối đa của danh mục: <input style="width: 50px;" id="maxCategoryWords" type="number" name="max" value="3"/>
                        <button class="wave" onclick="categorize()">Phân loại ngay</button>
                        <div class="result"></div>
                    </p>
                    <table id="categories-table">
                        <thead>
                            <tr>
                                <th>Danh mục</th>
                                <th>Số sản phẩm</th>
                                <th>Hiện trên sidebar</th>
                                <th>Hiện trên menu</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                <div id="logs">
                    <h1>NHẬT KÝ HỆ THỐNG</h1>
                    <button class="wave" onclick="fetchLogs()">Làm mới</button>
                    <button class="wave" onclick="cleanLogs()">Dọn dẹp log</button>
                    <pre id="logs-container"></pre>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/charts.js"></script>
        <script>
            function hide(id) {
                document.getElementById(id).classList.add('hidden');
            }
            function show(id) {
                hide('analytics');
                hide('crawl');
                hide('categorize');
                hide('logs');
                document.getElementById(id).classList.remove('hidden');
            }
            show('analytics');
            function popup(content, timeout) {
                var notification = document.getElementById('notification');
                notification.innerHTML = content;
                notification.classList.remove('hidden');
                setTimeout(function() {
                    notification.classList.add('hidden');
                }, timeout);
            }
            document.forms.crawl.addEventListener('submit', crawl);
            function crawl(e) {
                var result = document.querySelector('#crawl .result');
                result.innerHTML = "<i>Đang cào sản phẩm...</i>";
                request({
                    action: 'admin',
                    task: 'crawl',
                    url: document.forms.crawl.url.value
                }, function(res) {
                    var res = res.responseText;
                    switch (res) {
                        case '-2':
                            result.innerHTML = 'Đường dẫn không hợp lệ, vui lòng kiểm tra lại!';
                            break;
                        case '-1':
                            result.innerHTML = 'Đường dẫn phải thuộc 1 trong 3 trang "cayvahoa.net", "vuoncayviet.com" hoặc "webcaycanh.com"̣, vui lòng kiểm tra lại!';
                            break;
                        case '0':
                            result.innerHTML = 'Rất tiếc, không cào được sản phẩm nào. Thử lại với trang nào nhiều sản phẩm hơn thử xem!';
                            break;
                        default:
                            result.innerHTML = res + "<div class='d-pt-4'></div><a class='wave' href='FrontController?action=list&hot=true' target='_blank'>Xem các sản phẩm đã cào được</a>";
                            break;
                    }
                    
                });
                e.preventDefault();
                return false;
            }
            categoriesTable = document.querySelector('#categories-table tbody');
            function categorize() {
                categoriesTable.innerHTML = '';
                var result = document.querySelector('#categorize .result');
                result.innerHTML = "<i>Đang đánh danh mục sản phẩm...</i>";
                var max = document.querySelector('#maxCategoryWords');
                request({
                    action: 'admin',
                    task: 'categorize',
                    max: max.value
                }, function(res) {
                    result.innerHTML = res.responseText;
                    fetchCategories();
                });
            }
            function updateCategory(that) {
                request({
                    action: 'admin',
                    task: 'updateCategory',
                    id: that.id.replace(/\D*/, ''),
                    field: that.name,
                    value: that.checked
                }, function(res) {
                    popup(res.responseText, 2000)
                });
            }
            function fetchCategories() {
                request({
                    action: 'admin',
                    task: 'fetchCategories'
                }, function(res) {
                    window.res = res;
                    categoriesTable.innerHTML = '';
                    var xml = res.responseXML;
                    var categories = xml.getElementsByTagName('category');
                    for (i = 0; i < categories.length; i++) {
                        var category = categories[i];
                        var id = category.getElementsByTagName('id')[0].textContent;
                        var row = document.createElement('tr');
                        var name = document.createElement('td');
                        name.innerHTML = '<b class="capitalize">' + category.getElementsByTagName('name')[0].textContent + '</b>';
                        row.appendChild(name);
                        var count = document.createElement('td');
                        count.innerHTML = category.getElementsByTagName('count')[0].textContent;
                        row.appendChild(count);
                        var enable = document.createElement('td');
                        var enableValue = category.getElementsByTagName('enable')[0].textContent;
                        enable.innerHTML = '<div class="checkbox"><input onclick="updateCategory(this)" name="enable" id="is-enable-category-' + id + '" type="checkbox" ' + (enableValue === 'true' ? 'checked' : '') + '><label for="is-enable-category-' + id + '"></label></div>';
                        row.appendChild(enable);
                        var onmenu = document.createElement('td');
                        var onmenuValue = category.getElementsByTagName('onmenu')[0].textContent;
                        onmenu.innerHTML = '<div class="checkbox"><input onclick="updateCategory(this)" name="onmenu" id="is-onmenu-category-' + id + '" type="checkbox" ' + (onmenuValue === 'true' ? 'checked' : '') + '><label for="is-onmenu-category-' + id + '"></label></div>';
                        row.appendChild(onmenu);
                        categoriesTable.appendChild(row);
                    }
                });
            }
            function fetchLogs() {
                var container = document.getElementById('logs-container');
                container.innerHTML = "Đang tải nhật ký hệ thống";
                request({
                    action: 'admin',
                    task: 'logs'
                }, function(res) {
                    container.innerHTML = res.responseText;
                });
            }
            function cleanLogs() {
                request({
                    action: 'admin',
                    task: 'cleanLogs'
                }, function(res) {
                    fetchLogs();
                });
            }
            function analizeUserAgent() {
                request({
                    action: 'admin',
                    task: 'analizeUserAgent'
                }, function(res) {
                    var table = document.querySelector('#user-agent-table tbody');
                    table.innerHTML = '';
                    var analytics = res.responseXML.getElementsByTagName('analytic');
                    for (var i = 0; i < analytics.length; i++) {
                        var analytic = analytics[i];
                        var value = analytic.querySelector('value').textContent;
                        var count = analytic.querySelector('count').textContent;
                        table.innerHTML += '<tr><td>' + (i + 1) + '</td><td>' + value + '</td><td>' + count + '</td></tr>';
                    }
                });
            }
            function analizePageUrl() {
                request({
                    action: 'admin',
                    task: 'analizePageUrl'
                }, function(res) {
                    var table = document.querySelector('#urls-table tbody');
                    table.innerHTML = '';
                    var analytics = res.responseXML.getElementsByTagName('analytic');
                    for (var i = 0; i < analytics.length; i++) {
                        var analytic = analytics[i];
                        var value = analytic.querySelector('value').textContent;
                        var count = analytic.querySelector('count').textContent;
                        table.innerHTML += '<tr><td>' + (i + 1) + '</td><td style="word-break: break-word"><a href="FrontController?' + value + '" target="_blank">' + value + '</a></td><td>' + count + '</td></tr>';
                    }
                });
            }
            function analizeDailyViews() {
                request({
                    action: 'admin',
                    task: 'analizeDailyViews'
                }, function(res) {
                    drawLineChart(res, 'daily-view-canvas');
                });
            }
            function analizeRealTimeViews() {
                request({
                    action: 'admin',
                    task: 'analizeRealTimeViews'
                }, function(res) {
                    drawLineChart(res, 'real-time-view-canvas');
                });
                setTimeout(analizeRealTimeViews, 1000);
            }
            function analizeAll() {
                analizeRealTimeViews();
                analizeDailyViews();
                analizePageUrl();
                analizeUserAgent();
            }
            analizeAll();
        </script>
    </body>
</html>