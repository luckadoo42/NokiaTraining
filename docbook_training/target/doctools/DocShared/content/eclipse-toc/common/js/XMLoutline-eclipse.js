/**********************************
          GLOBAL VARIABLES
***********************************/
// pre-cache art files and sizes for widget styles and spacers
// (all images must have same height/width)
var collapsedWidget = new Image(20, 16);
collapsedWidget.src = "common/images/oplus.gif";
var collapsedWidgetStart = new Image(20, 16);
collapsedWidgetStart.src = "common/images/oplusStart.gif";
var collapsedWidgetEnd = new Image(20, 16);
collapsedWidgetEnd.src = "common/images/oplusEnd.gif";
var expandedWidget = new Image(20, 16);
expandedWidget.src = "common/images/ominus.gif";
var expandedWidgetStart = new Image(20, 16);
expandedWidgetStart.src = "common/images/ominusStart.gif";
var expandedWidgetEnd = new Image(20, 16);
expandedWidgetEnd.src = "common/images/ominusEnd.gif";
var nodeWidget = new Image(20, 16);
nodeWidget.src = "common/images/onode.gif";
var nodeWidgetEnd = new Image(20, 16);
nodeWidgetEnd.src = "common/images/onodeEnd.gif";
var emptySpace = new Image(20, 16);
emptySpace.src = "common/images/oempty.gif";
var chainSpace = new Image(20, 16);
chainSpace.src = "common/images/ochain.gif";
// miscellaneous globals
var widgetWidth = "20";
var widgetHeight = "16";
var currState = "";
var displayTarget = "contentFrame";
// XML document object
var xDoc;
/**********************************
  TOGGLE DISPLAY AND ICONS
***********************************/
// invert item state (expanded to/from collapsed)
function swapState(currState, currVal, n) {
    var newState = currState.substring(0,n);
    newState += currVal ^ 1 // Bitwise XOR item n;
    newState += currState.substring(n+1,currState.length);
    return newState;
}
// retrieve matching version of 'minus' images
function getExpandedWidgetState(imgURL) {
    if (imgURL.indexOf("Start") != -1) {
        return expandedWidgetStart.src;
    }
    if (imgURL.indexOf("End") != -1) {
        return expandedWidgetEnd.src;
    }
    return expandedWidget.src;
}
// retrieve matching version of 'plus' images
function getCollapsedWidgetState(imgURL) {
    if (imgURL.indexOf("Start") != -1) {
        return collapsedWidgetStart.src;
    }
    if (imgURL.indexOf("End") != -1) {
        return collapsedWidgetEnd.src;
    }
    return collapsedWidget.src;
}
// toggle an outline mother entry, storing new state value;
// invoked by onclick event handlers of widget image elements
function toggle(img, blockNum) {
    var newString = "";
    var expanded, n;
    // modify state string based on parameters from IMG
    expanded = currState.charAt(blockNum);
    currState = swapState(currState, expanded, blockNum);
    // dynamically change display style
    if (expanded == "0") {
        document.getElementById("OLBlock" + blockNum).style.display = "block";
        img.src = getExpandedWidgetState(img.src);
    } else {
        document.getElementById("OLBlock" + blockNum).style.display = "none";
        img.src = getCollapsedWidgetState(img.src);
    }
}
function expandAll() {
    var newState = "";
    while (newState.length < currState.length) {
        newState += "1";
    }
    currState = newState;
    initExpand();
}
function collapseAll() {
    var newState = "";
    while (newState.length < currState.length) {
        newState += "0";
    }
    currState = newState;
    initExpand();
}
/*********************************
   OUTLINE HTML GENERATION
**********************************/
// apply default expansion state from outline's header
// info to the expanded state for one element to help 
// initialize currState variable
function calcBlockState(n) {
    var ol = xDoc.getElementsByTagName("toc")[0];
    var outlineLen = ol.getElementsByTagName("topic").length;
    // get OPML expansionState data
    var expandElem = xDoc.getElementsByTagName("expansionState")[0];
//    var expandedData = (expandElem.childNodes.length) ? expandElem.firstChild.nodeValue.split(",") : null;
 var expandedData = null;
    if (expandedData) {
        for (var j = 0; j < expandedData.length; j++) {
            if (n == expandedData[j] - 1) {
                return "1";
            }
        }
    }
    return "0";
}
// counters for reflexive calls to drawOutline()
var currID = 0;
var blockID = 0;
// generate HTML for outline
function drawOutline(ol, prefix) {
    var output = "";
    var nestCount, link, nestPrefix, lastInnerNode;
    ol = (ol) ? ol : xDoc.getElementsByTagName("toc")[0];
    prefix = (prefix) ? prefix : "";
    if (ol.childNodes[ol.childNodes.length - 1].nodeType == 3) {
        ol.removeChild(ol.childNodes[ol.childNodes.length - 1]);
    }
    for (var i = 0; i < ol.childNodes.length ; i++) {
        if (ol.childNodes[i].nodeType == 3) {
            continue;
        }
        if (ol.childNodes[i].childNodes.length > 0 && ol.childNodes[i].childNodes[ol.childNodes[i].childNodes.length - 1].nodeType == 3) {
             ol.childNodes[i].removeChild(ol.childNodes[i].childNodes[ol.childNodes[i].childNodes.length - 1]);
        }
        nestCount = ol.childNodes[i].childNodes.length;
        output += "<div class='OLRow' id='line" + currID++ + "'>\n";
        if (nestCount > 0) {
            output += prefix;
            output += "<img id='widget" + (currID-1) + "' src='" + ((i== ol.childNodes.length-1) ? collapsedWidgetEnd.src : (blockID==0) ? collapsedWidgetStart.src : collapsedWidget.src);
            output += "' height=" + widgetHeight + " width=" + widgetWidth;
            output += " title='Click to expand/collapse nested items.' onClick='toggle(this," + blockID + ")'>";
            link =  (ol.childNodes[i].getAttribute("href")) ? ol.childNodes[i].getAttribute("href") : "";
            if (link) {
                output += "&nbsp;<a href='content/" + link + "' class='itemTitle' title='" + 
                link + "' target='" + displayTarget + "'>" ;
            } else {
                output += "&nbsp;<a class='itemTitle' title='" + link + "'>";
            }
            output += "<span style='position:relative; top:-3px; height:11px'>&nbsp;" + ol.childNodes[i].getAttribute("label") + "</span></a>";
            currState += calcBlockState(currID-1);
            output += "<span class='OLBlock' blocknum='" + blockID + "' id='OLBlock" + blockID++ + "'>";
            nestPrefix = prefix;
            nestPrefix += (i == ol.childNodes.length - 1) ? 
                       "<img src='" + emptySpace.src + "' height=" + widgetHeight + " width=" + widgetWidth + ">" :
                       "<img src='" + chainSpace.src + "' height=" + widgetHeight + " width=" + widgetWidth + ">"
            output += drawOutline(ol.childNodes[i], nestPrefix);
            output += "</span></div>\n";
        } else {
            output += prefix;
            output += "<img id='widget" + (currID-1) + "' src='" + ((i == ol.childNodes.length - 1) ? nodeWidgetEnd.src : nodeWidget.src);
            output += "' height=" + widgetHeight + " width=" + widgetWidth + ">";
            link =  (ol.childNodes[i].getAttribute("href")) ? ol.childNodes[i].getAttribute("href") : "";
            if (link) {
                output += "&nbsp;<a href='content/" + link + "' class='itemTitle' title='" + 
                link + "' target='" + displayTarget + "'>";
            } else {
                output += "&nbsp;<a class='itemTitle' title='" + link + "'>";
            }
            output +="<span style='position:relative; top:-3px; height:11px'>&nbsp;" +  ol.childNodes[i].getAttribute("label") + "</span></a>";
            output += "</div>\n";
        }
    }
    return output;
}
/*********************************
     OUTLINE INITIALIZATIONS
**********************************/
// expand items set in expansionState OPML tag, if any
function initExpand() {
    for (var i = 0; i < currState.length; i++) {
        if (currState.charAt(i) == 1) {
            document.getElementById("OLBlock" + i).style.display = "block";
        } else {
            document.getElementById("OLBlock" + i).style.display = "none";
        }
    }
}
function finishInit() {
        // get outline body elements for iteration and conversion to HTML
        var ol = xDoc.getElementsByTagName("toc")[0];
        // wrap whole outline HTML in a span
        var olHTML = "<span id='renderedOL'>" + drawOutline(ol) + "</span>";
        // throw HTML into 'content' div for display
        document.getElementById("content").innerHTML = olHTML;
        initExpand();
}
function continueLoad(xFile) {
    xDoc.load(escape(xFile));
    // IE needs this delay to let loading complete before reading its content
    setTimeout("finishInit()", 300);
}
// verify that browser supports XML features and load external .xml file
function loadXMLDoc(xFile) {
    if (document.implementation && document.implementation.createDocument) {
        // this is the W3C DOM way, supported so far only in NN6
        xDoc = document.implementation.createDocument("", "theXdoc", null);
    } else if (typeof ActiveXObject != "undefined") {
        // make sure real object is supported (sorry, IE5/Mac)
        if (document.getElementById("msxml").async) {
            xDoc = new ActiveXObject("Msxml.DOMDocument");
        }
    }
    if (xDoc && typeof xDoc.load != "undefined") {
        // Netscape 6+ needs this delay for loading; start two-stage sequence
        setTimeout("continueLoad('" + xFile + "')", 50);
    } else {
        var reply = confirm("This example requires a browser with XML support, such as IE5+/Windows or Netscape 6+.\n \nGo back to previous page?");
        if (reply) {
            history.back();
        }
    }
}
// initialize first time -- invoked onload
function initXMLOutline(xFile) {
    loadXMLDoc(xFile);
}
