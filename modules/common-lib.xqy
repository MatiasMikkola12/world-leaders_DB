xquery version "1.0-ml";

module namespace co = "http://marklogic.com/mlu/world-leaders/common";
declare namespace wl = "http://marklogic.com/mlu/world-leaders";
declare function in-office() as xs:string
{
   let $enddate := /wl:leader/wl:positions/wl:position[1]
   let $count := count($enddate[wl:enddate eq "present"])
   return
   string($count)
};