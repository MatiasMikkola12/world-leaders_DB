
xquery version "1.0-ml";
declare namespace wl = "http://marklogic.com/mlu/world-leaders";
import module namespace co = "http://marklogic.com/mlu/world-leaders/common" at "modules/common-lib.xqy"; 
xdmp:set-response-content-type("text/html; charset=utf-8"),
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">',
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>World Leaders</title>
<link href="css/world-leaders.css" rel="stylesheet" type="text/css" />
</head>

<body>
<div id="wrapper">
  <a href="index.xqy"><img src="images/logo.gif" width="427" height="76" /></a><br />
  <span class="currently">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Currently in database:
    {fn:count(/wl:leader)} Present: {co:in-office()}
  </span><br />
  <br />
  <br />
  <br />
    <div id="tabs"><a href="index.xqy"><img src="images/byname.gif" width="121" height="30" /></a><a href="bycountry.xqy"><img src="images/bycountry_selected.gif" width="121" height="30" /></a><a href="bydate.xqy"><img src="images/bydate.gif" width="121" height="30" /></a><a href="search.xqy"><img src="images/search.gif" width="121" height="30" /></a></div>
  <div id="graybar">
        <form name="formsearch" method="get" action="bycountry.xqy" id="formsearch" value="{xdmp:get-request-field("country")}"> 
        <select name="country" id="country">
        <option>All</option>
       
        {for $leader in /wl:leader 
        let $yo := for $count in distinct-values($leader/wl:country)
        return $count
        let $x := $yo
        return (
        if(xdmp:get-request-field("country") = $x) then <option selected="selected">{$x}</option>
        else(<option>{$x}</option>)
        )}
		</select> 
		<input type="submit" name="submitbtn" id="submitbtn" value="Go" /> 
		</form>
  </div>
  <div id="content">
   <table cellspacing="0">
    <tr>
      <th>F Name</th>
      <th>L Name</th>
	  <th>Country</th>
      <th>Title</th>
	  <th>H of State</th>
      <th><p>H of Govt</p></th>
      <th>Start Date</th>
      <th>End Date</th>
      <th>Age</th>
      <th>Gender</th>
    </tr>

    <tr>
      <td colspan="10"><hr/></td>
    </tr>
    {
    let $leaders := if (xdmp:get-request-field("country") = "All") then 
                        /wl:leader else
                        /wl:leader[fn:contains(fn:lower-case(.), fn:lower-case(xdmp:get-request-field("country")))]
    for $leader in $leaders
    let $firstname := $leader//wl:firstname/text()
    let $lastname := $leader//wl:lastname/text()
    let $country := $leader//wl:country/text()
    let $title := $leader//wl:title/text()
    let $hos := $leader//wl:positions/wl:position[1]/@hos/string()
    let $hog := $leader//wl:positions/wl:position[1]/@hog/string()
    let $gender := $leader//wl:gender/text()
    let $position := $leader//wl:positions/wl:position[1]
    let $startdate := $position/wl:startdate/text()
    let $enddate := $position/wl:enddate/text()
    let $dob := $leader//wl:dob/text()
    let $summary :=  fn:tokenize(fn:string($leader//wl:summary), " ")[1 to 100]
    let $yearssincebirth := 
        xs:integer(fn:days-from-duration(fn:current-date() - xs:date($dob)) div 365.25)
    where $startdate <= "2005-01-01"
    order by $country ascending, $startdate descending, $lastname
    return
    (
    <tr>
        <td>{$firstname}</td>
        <td>{$lastname}</td>
        <td>{$country}</td>
        <td>{$title}</td>
        {if ($hos = "true") then 
            <td>True</td>
        else (
            <td></td>)}
        {if ($hog = "true") then
            <td>True</td>
        else (
            <td></td>)}
        <td>{$startdate}</td>
        <td>{$enddate}</td>
        <td>{$yearssincebirth}</td>
        <td>{$gender}</td>
        
    </tr>
    ,
    <tr>
        <td colspan="12">{$summary}...</td>
    </tr>
    ,
    <tr>
        <td colspan="12"><hr/></td>
    </tr>
    )
    }

    <tr>
      <td colspan="10" class="summary">&nbsp;</td>
    </tr>
	
  </table>
 </div>
</div>
</body>
</html>
