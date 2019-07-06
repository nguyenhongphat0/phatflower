/* 
 * Author: nguyenhongphat0
 */
function drawLineChart(res, id) {
    var canvas = document.getElementById(id);
    var context = canvas.getContext('2d');
    var width = canvas.parentNode.clientWidth;
    var height = 200;
    var analytics = res.responseXML.getElementsByTagName('analytic');
    var length = analytics.length;
    var unit = (width - 70) / length;
    var left = 30;
    var top = height - 20;
    var max = maxY(analytics);
    
    canvas.width = width;
    canvas.height = height;
    context.moveTo(left, 0);
    context.lineTo(left, top);
    context.lineTo(width, top);
    context.textAlign = 'right';
    for (var i = 0; i < max; i += 100) {
        var y = calcTop(i, max, height);
        context.fillText(i, 20, y);
    }
    context.stroke();
    context.beginPath();
    context.strokeStyle = '#f88db1';
    context.lineWidth = 3;
    context.textAlign = 'center';
    context.moveTo(left, top);
    for (var i = 0; i < length; i++) {
        var analytic = analytics[i];
        var value = analytic.querySelector('value').textContent;
        var count = analytic.querySelector('count').textContent;
        left += unit;
        top = calcTop(count, max, height);
        context.lineTo(left, top);
        context.fillText(value, left, height);
        context.fillText(count, left, top - 10);
    }
    context.stroke();
}

function maxY(analytics) {
    var max = 0;
    for (var i = 0; i < analytics.length; i++) {
        var analytic = analytics[i];
        var count = analytic.querySelector('count').textContent;
        if (Number(count) > max) {
            max = count;
        }
    }
    return max;
}

function calcTop(count, max, height) {
    return height - 20 - (height - 40)*count/max;
}