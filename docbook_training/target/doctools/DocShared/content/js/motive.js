// Copyright (c) 2006-2010 Motive, Inc. All Rights Reserved.


function requestComments(type, issuetype, component, assignee, project, version, jirahostname, doctitle, timestamp, email) {
	//this function will call a different subfunction for each type of comment, to support comments of type 'jira', per JCBG-480

	//document.write('*requestComments*'); //debug


  // make subject, which both subfunctions need
  var subject = document.title.replace(/"/g,"") + ' - ' + doctitle + ' (Doc Feedback)'; 

    // make url and urlfixed, which both subfunctions need

        // urlfixed trims off anything after ? in the URL, so that params are trimmed away; this removes, for ex, cp= values
	url = document.URL;
	if(url.indexOf("?")!=-1){
		urlfixed = url.substring(0,url.indexOf("?"));
	}else{
	    urlfixed = url;
	}

       //choose a subfunction to call

	if(type=='jira'){
	    requestCommentsJira(issuetype, component, assignee, project, version, jirahostname, subject,urlfixed);
	}else{
	    requestCommentsEmail(doctitle,timestamp,email,subject,urlfixed);
	}


}

function requestCommentsJira(issuetype, component, assignee, project, version, jirahostname, subject, urlfixed) {

	//document.write('*requestCommentsJira*'); //debug

//Per JCBG-1277, encoding the inputs to this function, to protect against XSS. Make sure any thing that is written out via document.write, that came in as an input, is encoded.

    document.write('<a target=\"_blank\" href=\"https://');

    //jirahostname, taken from feedback.jirahostname property

    document.write(encodeURI(jirahostname) + '/secure/CreateIssueDetails!init.jspa');

    // project, taken from feedback.project property
    document.write('?pid=' + encodeURI(project));

    // issuetype, taken from feedback.issuetype property
    document.write('&issuetype=' + encodeURI(issuetype));
    
    // version, taken from feedback.version property: needs to be optional... on -1, we don't write out a version
    //   which forces the end user to choose one
    if (version != -1) {
	document.write('&versions='+encodeURI(version));		
	}

    // making this chunk separate so that it's ok if the above is NOT written out
    document.write('&priority=4');

//component, taken from feedback.component property
document.write('&components=' + encodeURI(component));

//assignee, taken from feedback.assignee (which defaults to -1 to cause 'automatic'
document.write('&assignee=' + encodeURI(assignee));

// subject
document.write('&summary=' + encodeURI(subject));

document.write('&description=URL: ' + encodeURI(urlfixed) + '   %0d%0dAdd your comments. You can use Confluence markup in this field. For example, you can paste in text from the source document and mark items to delete as -DELETED- and add as %2BADDED%2B. ');

document.write('\">Feedback</a>');

}

function requestCommentsEmail(doctitle, timestamp,email,subject,urlfixed) {

	//document.write('*requestCommentsEmail*'); //debug

//Per JCBG-1277, encoding the inputs to this function, to protect against XSS. Make sure any thing that is written out via document.write, that came in as an input, is encoded.
//Per JCBG-1577, where & in page title was an issue, I changed encodeURI to encodeURIComponent() in places where we are writing out the subject (which contains the title) or the document.title, because encodeURI doesn't encode & but encodeURIComponent() does do that. Be aware we may need to add more uses of that function if we discover other cases where & leaks through.

	var body = "Topic title: " + encodeURIComponent(document.title.replace(/"/g,"")) + "%0D%0ADocument title: " + encodeURI(doctitle) + "%0D%0ATopic location: <" + encodeURI(urlfixed) + ">%0D%0ADocument Generated: " + encodeURI(timestamp) + "%0D%0A*============================================================================================*%0D%0A%0D%0AIs this content helpful (Yes / Somewhat / No)? %0D%0A%0D%0AComments:%0D%0A" ;
    document.write('<a href=\"mailto:' + encodeURI(email) + '?subject=' + encodeURIComponent(subject) + '&body=' + body + '\" title=\"Is this content helpful\?\">');
	document.write('Feedback</a>');
}


	 
// The following is used by the related topics button:
 
	  function ReverseContentDisplay(d,e) {
	  curHeight = document.documentElement.clientHeight;

	  if(d.length < 1) { return; }
	  if(document.getElementById(d).style.display == "none") { 

	  document.getElementById(d).style.display = "block"; 

	  ID = document.getElementById('related-topics-inner');
	  offset = ID.offsetHeight;
	  var y;
	  y = e.clientY;
	  myTop = getTopPos(offset, y);
	  ID.style.top = ( myTop + 'px');

	  }
	  else{
	  document.getElementById(d).style.display = "none"; 
	  }
	  }

	function getTopPos(offset, y) { 
	  var adjust = 5;
		if (y + offset <= curHeight) {
			//return y;
	        return 0 - adjust;
		}
		else {
            return 0 - offset - adjust;
			//return y - offset;
		}
	}
