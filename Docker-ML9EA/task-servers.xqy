xquery version "1.0-ml";

(: Copyright 2011-2016 MarkLogic Corporation.  All Rights Reserved. :)

module namespace ts="http://marklogic.com/manage/endpoints/task-servers";

(: model imports :)
import module namespace tsmod = "http://marklogic.com/manage/task-server"
    at "/MarkLogic/manage/models/task-server-model.xqy";

import module namespace gmod="http://marklogic.com/manage/group"
    at "/MarkLogic/manage/models/group-model.xqy";

import module namespace tpmod = "http://marklogic.com/manage/task-server-properties"
    at "/MarkLogic/manage/models/task-server-properties-model.xqy";

(: utility imports  :)
import module namespace res="http://marklogic.com/manage/resource"
    at "/MarkLogic/manage/endpoints/resource.xqy";
import module namespace resp = "http://marklogic.com/manage/lib/response-util"
    at "/MarkLogic/manage/lib/response-util.xqy";
import module namespace rest = "http://marklogic.com/appservices/rest"
    at "/MarkLogic/appservices/utils/rest.xqy";
import module namespace conv = "http://marklogic.com/manage/converters/converter"
    at "/MarkLogic/manage/converters/converter.xqy";
import module namespace reut = "http://marklogic.com/manage/lib/resource-util"
    at "/MarkLogic/manage/lib/resource-util.xqy";
import module namespace json = "http://marklogic.com/xdmp/json"
    at "/MarkLogic/json/json.xqy";

import module namespace propxml="http://marklogic.com/manage/converters/convert-property-xml"
    at "/MarkLogic/manage/converters/convert-property-xml.xqy";

import module namespace debug="http://marklogic.com/debug"
    at "/MarkLogic/appservices/utils/debug.xqy";

declare namespace manage = "http://marklogic.com/manage";

declare namespace tprop="http://marklogic.com/manage/task-server/properties";

(: declarations :)
declare default function namespace "http://www.w3.org/2005/xpath-functions";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option xdmp:mapping "false";

declare %private %manage:trace variable $trace-event := "manage-task-server-endpoint";

declare
%res:GET
%res:request-id("task-server-list")
%res:produces("application/xml","application/json","text/html")
%res:path('^/manage/(v2|LATEST)/task-servers/?$')
%res:params('name=group-id,default=Default')
%res:status(200)
%res:convert
function ts:get-task-server-list(
    $version as xs:string
)
{
    tsmod:get-list-default-view($res:context,gmod:get-id($res:context))
};

declare
%res:HEAD
%res:request-id("task-server-list")
%res:produces("application/xml","application/json","text/html")
%res:path('^/manage/(v2|LATEST)/task-servers/?$')
%res:params('name=group-id,default=Default')
%res:status(200)
function ts:head-task-server-list(
    $version as xs:string
)
{
    ()
};

declare
%res:OPTIONS
%res:request-id("task-server-list")
%res:produces("application/xml","application/json","text/html")
%res:path('^/manage/(v2|LATEST)/task-servers/?$')
%res:params('name=group-id,default=Default')
%res:status(200)
%res:convert
function ts:options-task-servers(
    $version as xs:string
)
{
    reut:make-options-response(
        $res:context,$res:requestdef,"task-servers",false())
};

declare
%res:POST
%res:request-id("task-server-list")
%res:produces("application/xml","application/json","text/html")
%res:path('^/manage/(v2|LATEST)/task-servers/?$')
%res:params('name=group-id,default=Default')
function ts:create-task-server(
    $version as xs:string
)
{
    error((),"REST-UNSUPPORTEDMETHOD")
};

declare
%res:GET
%res:request-id("task-server-item")
%res:produces("application/xml","application/json","text/html")
%res:path('^/manage/(v2|LATEST)/task-servers/([^/?&amp;]+)/?$')
%res:params('name=group-id,default=Default','name=server-id')
%res:status(200)
%res:convert
function ts:get-task-server(
    $version as xs:string,
    $task-server-name as xs:string
)
{
    let $context := $res:context
    let $_ := map:put($context,"server-id",$task-server-name)
    return tsmod:get-item-rep($context)
};

declare
%res:HEAD
%res:request-id("task-server-item")
%res:produces("application/xml","application/json","text/html")
%res:path('^/manage/(v2|LATEST)/task-servers/([^/?&amp;]+)/?$')
%res:params('name=group-id,default=Default','name=server-id')
%res:status(200)
function ts:head-task-server(
    $version as xs:string,
    $task-server-name as xs:string
)
{
    let $context := $res:context
    let $_ := map:put($context,"server-id",$task-server-name)
    let $task-server := tsmod:get-item-rep($context)
    return if(exists($task-server))
           then ()
           else ()
};

declare
%res:OPTIONS
%res:request-id("task-server-item")
%res:produces("application/xml","application/json","text/html")
%res:path('^/manage/(v2|LATEST)/task-servers/([^/?&amp;]+)/?$')
%res:params('name=group-id,default=Default','name=server-id')
%res:status(200)
%res:convert
function ts:options-task-server(
    $version as xs:string,
    $task-server-name as xs:string
)
{
    reut:make-options-response(
        $res:context,$res:requestdef,"task-server",false())
};

declare
%res:DELETE
%res:request-id("task-server-item")
%res:path('^/manage/(v2|LATEST)/task-servers/([^/?&amp;]+)/?$')
%res:params('name=group-id,default=Default','name=server-id')
%res:status(204)
function ts:delete-task-server(
    $version as xs:string,
    $task-server-name as xs:string
)
{
    error((),"REST-UNSUPPORTEDMETHOD")
};

declare
%res:POST
%res:request-id("task-server-item")
%res:produces("application/xml","application/json","text/html")
%res:consumes("application/json","application/xml")
%res:path('^/manage/(v2|LATEST)/task-servers/([^/?&amp;]+)/?$')
%res:params('name=group-id,default=Default','name=server-id')
%res:convert
function ts:post-task-server-item(
    $version as xs:string,
    $task-server-name as xs:string
)
{
    error((),"REST-UNSUPPORTEDMETHOD")
};

declare
%res:GET
%res:request-id("task-server-item-properties")
%res:produces("application/xml","application/json","text/html")
%res:path('^/manage/(v2|LATEST)/task-servers/([^/?&amp;]+)/properties/?$')
%res:params('name=group-id,default=Default','name=server-id')
%res:status(200)
function ts:get-task-server-properties(
    $version as xs:string,
    $task-server-name as xs:string
)
{
    let $context := $res:context
    let $_ := map:put($context,"server-id",$task-server-name)

    let $gid := gmod:get-id($context)
    let $raw-content := tpmod:get-properties($context, $gid)
    let $ETag := resp:generate-ETag-header($context,$raw-content)
    return
    if ($res:output-type eq "application/json")
    then conv:unwrap-json(tpmod:strip-wrappers($raw-content))
    else conv:convert($context,
        propxml:convert-to-manage-xml($raw-content,
            namespace-uri($raw-content)))
};

declare
%res:HEAD
%res:request-id("task-server-item-properties")
%res:produces("application/xml","application/json","text/html")
%res:path('^/manage/(v2|LATEST)/task-servers/([^/?&amp;]+)/properties/?$')
%res:params('name=group-id,default=Default','name=server-id')
%res:status(200)
function ts:head-task-server-properties(
    $version as xs:string,
    $task-server-name as xs:string
)
{
    let $context := $res:context
    let $_ := map:put($context,"server-id",$task-server-name)

    let $gid := gmod:get-id($context)
    let $raw-content := tpmod:get-properties($context, $gid)
    let $ETag := resp:generate-ETag-header($context,$raw-content)
    return ()
};

declare
%res:POST
%res:request-id("task-server-item-properties")
%res:produces("application/xml","application/json","text/html")
%res:consumes("application/json","application/xml")
%res:path('^/manage/(v2|LATEST)/task-servers/([^/?&amp;]+)/properties/?$')
%res:params('name=group-id,default=Default','name=server-id')
function ts:post-task-server-properties(
    $version as xs:string,
    $task-server-name as xs:string
)
{
    error((),"REST-UNSUPPORTEDMETHOD","POST")
};

declare
%res:PUT
%res:request-id("task-server-item-properties")
%res:produces("application/xml","application/json","text/html")
%res:consumes("application/json","application/xml")
%res:path('^/manage/(v2|LATEST)/task-servers/([^/?&amp;]+)/properties/?$')
%res:params('name=group-id,default=Default','name=server-id')
function ts:update-task-server-properties(
    $version as xs:string,
    $task-server-name as xs:string
)
{
    let $context := $res:context
    let $_ := map:put($context,"server-id",$task-server-name)
    let $body := $res:body
    let $prop := if ($body instance of text())
               then propxml:convert-task-server-json($body)
               else propxml:convert-task-server-xml($body)

    let $_:=xdmp:log($prop)
    let $name  := map:get($context, "group-id")
    let $body  := try {
                  validate strict { $prop }
                } catch ($e) {
                  debug:log("manage-task-server", $e),
                  debug:log("manage-task-server", $body),
                  error((),
                        "MANAGE-INVALIDPAYLOAD","Invalid payload.")}

    let $hosts := if (exists(xdmp:get-request-header("If-Match")))
                then
                  tpmod:update-task-server-properties($name, $body,
                        function() {
                          let $gid := gmod:get-id($context)
                          let $raw-content := tpmod:get-properties($context, $gid)
                          let $ETag := resp:generate-ETag($raw-content)
                          return
                            $ETag eq xdmp:get-request-header("If-Match")})
                else
                  tpmod:update-task-server-properties($name, $body)
    return
    if (empty($hosts))
    then resp:set-response-code(204)
    else
      let $output-type := resp:get-output-type($context,$reut:CONVERTERS)
      let $eheader     := map:map()
      let $_           := map:put($eheader,"Location",$resp:TIMESTAMP-LOCATION)
      let $json-config := json:config("custom")
      let $_           := map:put($json-config,"element-namespace",
                                  "http://marklogic.com/manage")
      let $_           := map:put($json-config,"array-element-names",
                                 "last-startup")
      let $_           := map:put($json-config,"text-value","value")
      return
        (resp:set-response(
           conv:convert($context,
             resp:host-restart-payload($context,$hosts),(),$json-config),
             $output-type,202,"Accepted",$eheader),gmod:restart-hosts($hosts))
};
