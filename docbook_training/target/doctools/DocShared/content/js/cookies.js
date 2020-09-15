// Copyright (c) 2000-2010 Alcatel-Lucent. All Rights Reserved.

var showToc="../common/images/restore.gif";//"Show TOC>>";
var showTocAlt="Show the table of contents pane."
var hideToc="../common/images/maximize.gif";//"<<Hide TOC";
var hideTocAlt="Hide the table of contents pane."

function getExpDate(days, hours, minutes) {
    var expDate = new Date();
    if (typeof days == "number" && typeof hours == "number" && typeof hours == "number") {
        expDate.setDate(expDate.getDate() + parseInt(days));
        expDate.setHours(expDate.getHours() + parseInt(hours));
        expDate.setMinutes(expDate.getMinutes() + parseInt(minutes));
        return expDate.toGMTString();
    }
}

function getCookieVal(offset) {
    var endstr = document.cookie.indexOf (";", offset);
    if (endstr == -1) {
        endstr = document.cookie.length;
    }
    return unescape(document.cookie.substring(offset, endstr));
}

function getCookie(name) {
    var arg = name + "=";
    var alen = arg.length;
    var clen = document.cookie.length;
    var i = 0;
    while (i < clen) {
        var j = i + alen;
        if (document.cookie.substring(i, j) == arg) {
            return getCookieVal(j);
        }
        i = document.cookie.indexOf(" ", i) + 1;
        if (i == 0) break; 
    }
    return null;
}

function setCookie(name, value, expires, path, domain, secure) {
    document.cookie = name + "=" + escape (value) +
        ((expires) ? "; expires=" + expires : "") +
        ((path) ? "; path=" + path : "") +
        ((domain) ? "; domain=" + domain : "") +
        ((secure) ? "; secure" : "");
}

function deleteCookie(name,path,domain) {
    if (getCookie(name)) {
        document.cookie = name + "=" +
            ((path) ? "; path=" + path : "") +
            ((domain) ? "; domain=" + domain : "") +
            "; expires=Thu, 01-Jan-70 00:00:01 GMT";
    }
}

function setToggleUI() {
// Force the page to open in the frameset.
var isNav4 = (navigator.appName == "Netscape" && parseInt(navigator.appVersion) == 4);
if (parent == window) {
    // Don't do anything if NN4 is printing frame
    if (!isNav4 || (isNav4 && window.innerWidth != 0)) {
        if (location.replace) {
           // Use replace(), if available, to keep current page out of history
           location.replace("../index.html?content=" + escape(location.href));
        } else {
           location.href = "../index.html?content=" + escape(location.href);
        }
    }
}
    var label = hideToc;
	var labelAlt = hideTocAlt;
    if (document.getElementById) {
        if (getCookie("frameHidden") == "true") {
            label = showToc;
			labelAlt = showTocAlt;
        }
        var newElem = document.createElement("a");
        newElem.onclick = initiateToggle;
		newElem.setAttribute("id","showHideAnchor");
        //var newText = document.createTextNode("_");
	    var newImg = document.createElement("img");
	    newImg.setAttribute("src",label);
	    // Todo: i18nize me.
	    newImg.setAttribute("alt",labelAlt);
	    newElem.appendChild(newImg);
        //newElem.appendChild(newText);
        document.getElementById("togglePlaceholder").appendChild(newElem);
    }
}
function initiateToggle(evt) {
    evt = (evt) ? evt : event;
    var elem = (evt.target) ? evt.target : evt.srcElement;
    if (elem.nodeType == 1) {
        elem = elem.parentNode;
    }
    parent.toggleFrame(elem);
}
// =====================================
var origCols;
function toggleFrame(elem) {
    if (origCols) {
        elem.firstChild.setAttribute("src",hideToc);
	    // Todo: i18nize me.
	    elem.firstChild.setAttribute("alt",hideTocAlt);	
        setCookie("frameHidden", "false", getExpDate(180, 0, 0));
        showFrame();
    } else {
        elem.firstChild.setAttribute("src",showToc);
	    // Todo: i18nize me.	
	    elem.firstChild.setAttribute("alt",showTocAlt);	
        setCookie("frameHidden", "true", getExpDate(180, 0, 0));
        hideFrame();
    }
}
function hideFrame() {
    var frameset = document.getElementById("masterFrameset");
    origCols = frameset.cols;
    frameset.cols = "0, *";
}
function showFrame() {
    document.getElementById("masterFrameset").cols = origCols;
    origCols = null;
}
// set frame visibility based on previous cookie setting
function setFrameVis() {
	checkHideTocParam(); 
	loadFrame();
}
// ==============================
function getSearchData() {
    var results = new Object();
    if (location.search.substr) {
        var input = unescape(location.search.substr(1));
        if (input) {
            var srchArray = input.split("&");
            var tempArray = new Array();
            for (var i = 0; i < srchArray.length; i++) {
                tempArray = srchArray[i].split("=");
                results[tempArray[0]] = tempArray[1];
            }
        }
    }
    return results;
}
function loadFrame() {
   if (location.search) {
        var srchArray = getSearchData();
     	var validation = /content\/([A-Za-z0-9\-\_\.\!\~\*\'\(\)\%\/]+\.html)(#\w+)?$/;
		if(srchArray["content"] != null){
	    var match = srchArray["content"].match(validation);
		}
        if ( validation.test(srchArray["content"])  ) {	
            self.contentFrame.location.href = match[0];
        }
		// Here's yet another way to get to the target page:
		if(srchArray["content"] == null && srchArray["hideToc"] == null && location.search.substr(1) != null) {
		    targetPage  = "content/" + unescape(location.search.substr(1)) + location.hash;
	      	self.contentFrame.location.href = targetPage;		
		}
    }
   if (getCookie("frameHidden") == "true" ) {
	   var showHideAnchor = self.contentFrame.document.getElementById("showHideAnchor");
	   showHideAnchor.firstChild.setAttribute("src","../common/images/restore.gif");
	   hideFrame();
   }	
}
function checkHideTocParam(){
	if(location.search){
		var searchArray = getSearchData();
		if(searchArray["hideToc"] == "true"){
			setCookie("frameHidden", "true", getExpDate(180, 0, 0));
	 		var showHideAnchor = self.contentFrame.document.getElementById("showHideAnchor");
			showHideAnchor.firstChild.setAttribute("src","../common/images/restore.gif");
		}else if(searchArray["hideToc"] == "false"){
		  setCookie("frameHidden", "false", getExpDate(180, 0, 0));
		  var showHideAnchor = self.contentFrame.document.getElementById("showHideAnchor");
		  showHideAnchor.firstChild.setAttribute("src","../common/images/maximize.gif");
		}
	}
}
