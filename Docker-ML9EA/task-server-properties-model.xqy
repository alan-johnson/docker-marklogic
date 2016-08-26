xquery version "1.0-ml";

(: Copyright 2011-2016 MarkLogic Corporation.  All Rights Reserved. :)

module namespace tpmod="http://marklogic.com/manage/task-server-properties";

import module namespace admin="http://marklogic.com/xdmp/admin"
      at "/MarkLogic/admin.xqy";

import module namespace gmod="http://marklogic.com/manage/group"
    at "/MarkLogic/manage/models/group-model.xqy";

import module namespace tsmod="http://marklogic.com/manage/task-server"
    at "task-server-model.xqy";

import module namespace spmod="http://marklogic.com/manage/server-properties"
    at "server-properties-model.xqy";

declare namespace tprop="http://marklogic.com/manage/task-server/properties";

import module namespace config-lock="http://marklogic.com/config-lock"
    at "/MarkLogic/Admin/config-lock.xqy";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare namespace manage = "http://marklogic.com/manage";

declare option xdmp:mapping "false";

declare %private %manage:trace variable $trace-event := "manage-task-server-properties-model";

declare variable $admin-standard-functions :=
  (
    xs:QName("tprop:threads"),
    xs:QName("tprop:debug-threads"),
    xs:QName("tprop:max-time-limit"),
    xs:QName("tprop:default-time-limit"),
    xs:QName("tprop:max-inference-size"),
    xs:QName("tprop:default-inference-size"),
    xs:QName("tprop:queue-size"),
    xs:QName("tprop:pre-commit-trigger-depth"),
    xs:QName("tprop:post-commit-trigger-depth"),
    xs:QName("tprop:pre-commit-trigger-limit"),
    xs:QName("tprop:log-errors"),
    xs:QName("tprop:debug-allow"),
    xs:QName("tprop:profile-allow")
  );

declare function tpmod:get-group-name(
  $context as map:map,
  $server as element()
) as xs:string
{
  spmod:get-group-name($context, $server)
};

declare function tpmod:get-properties(
  $context as map:map,
  $grpid as xs:unsignedLong
) as element()
{
  xdmp:security-assert("http://marklogic.com/xdmp/privileges/manage",
                       "execute"),
  let $view := tsmod:get-config-view($context, $grpid)
  let $prop := xdmp:xslt-invoke("tsconfig-to-tsprop.xsl", document { $view })/*
  return
    validate strict { $prop }
};

declare function tpmod:strip-wrappers(
  $prop as element()
) as element()
{
  $prop
};

declare function tpmod:update-task-server-properties(
  $gname as xs:string,
  $prop as element(tprop:task-server-properties)
) as xs:unsignedLong*
{
  tpmod:update-task-server-properties($gname, $prop, function() { true() })
};

declare function tpmod:update-task-server-properties(
  $gname as xs:string,
  $prop as element(tprop:task-server-properties),
  $condition as xdmp:function
) as xs:unsignedLong*
{
  xdmp:security-assert("http://marklogic.com/xdmp/privileges/manage-admin",
                       "execute"),
  config-lock:lock-config(
    function() {
      if ($condition())
      then
        tpmod:update-group-properties-locked($gname, $prop)
      else
        error((),"MANAGE-CONTENTWRONGVERSION","Version of resource has changed.")
    })
};

declare private function tpmod:update-group-properties-locked(
  $gname as xs:string,
  $prop as element(tprop:task-server-properties)
) as xs:unsignedLong*
{
  let $gid    := gmod:identify($gname)
  let $admcfg := admin:get-configuration()
  let $admcfg := tpmod:apply-task-server-children($admcfg, $gid, $prop/*)
  return
    admin:save-configuration-without-restart($admcfg)
};

declare private function tpmod:apply-task-server-children(
  $admcfg as element(configuration),
  $gid as xs:unsignedLong,
  $children as element()*
) as element(configuration)
{
  let $first := $children[1]
  let $rest := subsequence($children,2)
  return
    if (empty($first))
    then
      $admcfg
    else
      if (node-name($first) = $admin-standard-functions)
      then
        tpmod:apply-task-server-children(
          tpmod:apply-standard($admcfg, $gid, $first),
          $gid, $rest)
      else
        (xdmp:log("Unexpected child in task-server properties: "
                  || node-name($first)),
         tpmod:apply-task-server-children($admcfg, $gid, $rest))
};

declare private function tpmod:apply-standard(
  $admcfg as element(configuration),
  $gid as xs:unsignedLong,
  $child as element()
) as element(configuration)
{
  let $type  := sc:type(sc:element-decl($child))
  let $fname := fn:QName("http://marklogic.com/xdmp/admin",
                         concat("taskserver-set-", local-name($child)))
  let $f     := xdmp:function($fname)
  return
    $f($admcfg, $gid, sc:type-apply($type, $child/data()))
};
