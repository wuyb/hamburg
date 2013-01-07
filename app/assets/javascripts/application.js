// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery.ui.all
//= require twitter/bootstrap
//= require jquery_ujs
//= require_tree .
//= require_self

function formatDate(d, fmt) {
    if (typeof d.strftime == "function") {
        return d.strftime(fmt);
    }
    var leftPad = function(n, pad) {
        n = "" + n;
        pad = "" + (pad == null ? "0" : pad);
        return n.length == 1 ? pad + n : n;
    };
    
    var r = [];
    var escape = false;
    var hours = d.getHours();
    var isAM = hours < 12;

    var hours12;
    if (hours > 12) {
        hours12 = hours - 12;
    } else if (hours == 0) {
        hours12 = 12;
    } else {
        hours12 = hours;
    }

    for (var i = 0; i < fmt.length; ++i) {
        var c = fmt.charAt(i);
        
        if (escape) {
            switch (c) {
                case 'd': c = leftPad(d.getDate()); break;
                case 'e': c = leftPad(d.getDate(), " "); break;
                case 'H': c = leftPad(hours); break;
                case 'I': c = leftPad(hours12); break;
                case 'l': c = leftPad(hours12, " "); break;
                case 'm': c = leftPad(d.getMonth() + 1); break;
                case 'M': c = leftPad(d.getMinutes()); break;
                case 'S': c = leftPad(d.getSeconds()); break;
                case 'y': c = leftPad(d.getFullYear() % 100); break;
                case 'Y': c = "" + d.getFullYear(); break;
                case 'p': c = (isAM) ? ("" + "am") : ("" + "pm"); break;
                case 'P': c = (isAM) ? ("" + "AM") : ("" + "PM"); break;
                case 'w': c = "" + d.getDay(); break;
            }
            r.push(c);
            escape = false;
        }
        else {
            if (c == "%")
                escape = true;
            else
                r.push(c);
        }
    }
    return r.join("");
}
