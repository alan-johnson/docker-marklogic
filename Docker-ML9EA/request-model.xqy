xquery version "1.0-ml";

(: Copyright 2011-2016 MarkLogic Corporation.  All Rights Reserved. :)

module namespace rmod="http://marklogic.com/manage/request";

import module namespace dmod="http://marklogic.com/manage/database"
    at "/MarkLogic/manage/models/database-model.xqy";

import module namespace hmod="http://marklogic.com/manage/host"
    at "/MarkLogic/manage/models/host-model.xqy";

import module namespace gmod="http://marklogic.com/manage/group"
    at "/MarkLogic/manage/models/group-model.xqy";

import module namespace smod="http://marklogic.com/manage/server"
    at "/MarkLogic/manage/models/server-model.xqy";

import module namespace tmod="http://marklogic.com/manage/transaction"
    at "/MarkLogic/manage/models/transaction-model.xqy";

import module namespace reut = "http://marklogic.com/manage/lib/resource-util"
    at "/MarkLogic/manage/lib/resource-util.xqy";

import module namespace mout = "http://marklogic.com/manage/lib/model-util"
    at "/MarkLogic/manage/lib/model-util.xqy";

import module namespace conv = "http://marklogic.com/manage/converters/converter"
    at "/MarkLogic/manage/converters/converter.xqy";

import module namespace debug = "http://marklogic.com/debug"
    at "/MarkLogic/appservices/utils/debug.xqy";

declare namespace rqtman = "http://marklogic.com/manage/requests";

declare default function namespace "http://www.w3.org/2005/xpath-functions";
declare default element  namespace "http://marklogic.com/manage/requests";

declare namespace rsrc   = "http://marklogic.com/appservices/rest/resource";
declare namespace server = "http://marklogic.com/xdmp/status/server";
declare namespace manage = "http://marklogic.com/manage";

declare option xdmp:mapping "false";

declare variable $ns-uri      as xs:string := "http://marklogic.com/manage/requests";
declare variable $schema-file as xs:string := "manage-requests.xsd";

declare variable $CURRENT_REQUEST_IDENTIFIER as xs:string := '$ML-CURRENT-REQUEST';
declare variable $DEFAULT_SECONDS_MIN as xs:integer := 10;

declare %private %manage:trace variable $trace-event := "manage-request-model";

(: helpers :)
declare function rmod:get-id(
    $context as map:map?
) as xs:unsignedLong?
{
    let $request-id := reut:resource-id($context,'requests')
    return
        if (exists($request-id))
        then rmod:identify($request-id)
        else ()
};

declare function rmod:identify(
    $request-id as xs:string)
as xs:unsignedLong?
{
    if ($request-id castable as xs:unsignedLong)
    then xs:unsignedLong($request-id)
    else if ($request-id eq $CURRENT_REQUEST_IDENTIFIER)
    then rmod:get-current-request()
    else ()
};

declare function rmod:get-list-uri(
    $context as map:map?
) as xs:string
{
    rmod:get-list-uri($context,(),(),())
};

declare function rmod:get-list-uri(
    $context as map:map?,
    $gid     as item()?,
    $hid     as item()?,
    $sid     as item()?
) as xs:string
{
    rmod:get-constrained-uri(reut:get-list-uri($context,"requests"),$gid,$hid,$sid)
};

declare function rmod:get-item-uri(
    $context as map:map?,
    $rid     as item()
) as xs:string
{
    rmod:get-item-uri($context,$rid,(),(),())
};

declare function rmod:get-item-uri(
    $context as map:map?,
    $rid     as item(),
    $gid     as item()?,
    $hid     as item()?,
    $sid     as item()?
) as xs:string
{
    rmod:get-constrained-uri(reut:get-item-uri($context,'requests',$rid),$gid,$hid,$sid)
};

declare function rmod:get-constrained-uri(
    $base-uri as xs:string,
    $gid      as item()?,
    $hid      as item()?,
    $sid      as item()?
) as xs:string
{
    let $args := (
        if (empty($gid)) then ()
        else concat("group-id=",string($gid)),
        if (empty($sid)) then ()
        else concat("server-id=",string($sid)),
        if (empty($hid)) then ()
        else concat("host-id=",string($hid))
        )
    return
        if (exists($args))
        then concat($base-uri,"?",string-join($args,"&amp;"))
        else $base-uri
};


declare function rmod:get-seconds-min(
    $context as map:map?
) as xs:integer?
{
    let $seconds-min := map:get($context,'seconds-min')
    return
        if (string-length($seconds-min) lt 1) then
            ()
        else if ($seconds-min eq 'DEFAULT') then
            $DEFAULT_SECONDS_MIN
        else
            xs:integer($seconds-min)
};

(: representations - views with conversion to formats :)
declare function rmod:get-list-rep(
    $context as map:map?
) as item()*
{
    let $view-name := reut:view-name($context)
    return
        if ($view-name eq 'default') then
            rmod:get-list-default-view(
                $context,
                gmod:get-id($context),
                hmod:get-id($context),
                smod:get-id($context),
                rmod:get-seconds-min($context)
            )
        else if ($view-name eq 'schema') then
            mout:read-config-schema("manage-requests")
        else
            error((),"REST-INVALIDPARAM",("view",$view-name))
};

declare function rmod:get-default-rep(
    $context as map:map?
) as item()*
{

    rmod:get-default-view(
        $context,
        gmod:get-id($context),
        hmod:get-id($context),
        smod:get-id($context),
        rmod:get-id($context))
};

(: views over accessed data :)
declare function rmod:get-list-default-view(
    $context     as map:map?,
    $gid         as xs:unsignedLong?,
    $hid         as xs:unsignedLong?,
    $sid         as xs:unsignedLong?,
    $seconds-min as xs:integer?
) as element()?
{
    rmod:get-list-default-view(
        $context,
        true(),
        $ns-uri,
        $gid,
        $hid,
        $sid,
        $seconds-min
        )
};

declare function rmod:get-list-default-view(
    $context     as map:map?,
    $is-page     as xs:boolean,
    $ns-uri      as xs:string,
    $gid         as xs:unsignedLong?,
    $hid         as xs:unsignedLong?,
    $sid         as xs:unsignedLong?,
    $seconds-min as xs:integer?
) as element()?
{
    rmod:get-list-default-view(
        $context,
        $is-page,
        $ns-uri,
        $gid,
        $hid,
        $sid,
        rmod:get-requests($context,$ns-uri,$gid,$hid,$sid,()),
        $seconds-min
        )
};

declare function rmod:get-list-default-view(
    $context     as map:map?,
    $is-page     as xs:boolean,
    $ns-uri      as xs:string,
    $gid         as xs:unsignedLong?,
    $hid         as xs:unsignedLong?,
    $sid         as xs:unsignedLong?,
    $request-stats as element()*,
    $seconds-min as xs:integer?
) as element()?
{
    let $start-min :=
        if (empty($seconds-min)) then ()
        else (current-dateTime() - mout:seconds-to-duration($seconds-min))
    let $requests :=
        if (exists($start-min))
        then $request-stats[xs:dateTime(server:start-time) le xs:dateTime($start-min)]
        else $request-stats
    let $slowest := (
        for $request in $requests
        order by $request/start-time ascending
        return $request
        )[1 to 10]
    let $fullrefs := reut:get-fullrefs($context)
    return
        mout:make-element("request-default-list",$ns-uri,(
            if (not($is-page)) then ()
            else (
                attribute xsi:schemaLocation {concat($ns-uri," ",$schema-file)},
                mout:make-element("meta",$ns-uri,(
                    mout:get-original-uri($context,$ns-uri),
                    mout:get-current-time($ns-uri),
                    mout:get-elapsed-time($ns-uri),
                    if (empty($start-min)) then ()
                    else mout:make-property("start-min",$ns-uri,$start-min),

                    reut:get-view-errors($context)
                    )
                )
            ),

            mout:make-element("relations",$ns-uri,
                rmod:get-request-relations($context,$ns-uri,$slowest)
            ),

            mout:make-element("list-summary",$ns-uri,
                rmod:get-list-summary-head($context,$ns-uri,$requests,$seconds-min)
                ),

            mout:make-element("list-items",$ns-uri,(
                mout:make-property("list-count",$ns-uri,"quantity",
                    count($slowest)),
                for $request in $slowest
                let $rid := $request/server:request-id/data(.)
                return
                    mout:make-element("list-item",$ns-uri,(
                        attribute array {"true"},

                        rmod:get-request-qualifiers($context,$ns-uri,$fullrefs,$request),
                        mout:make-property("uriref",$ns-uri,rmod:get-item-uri($context,$rid,$gid,$hid,$sid)),
                        mout:make-property("idref",$ns-uri,$rid),

                        mout:make-element("item-properties",$ns-uri,
                            rmod:get-enhanced-status($context,$ns-uri,$request)
                            )
                        )
                    )
                )
            ),

            if (not($is-page)) then ()
            else
                mout:make-element("related-views",$ns-uri,
                    mout:get-root-view($context,$ns-uri)
                )
            )
        )
};

declare function rmod:get-list-summary-head(
    $context     as map:map?,
    $ns-uri      as xs:string,
    $requests    as element(server:request-status)*,
    $seconds-min as xs:integer?
) as element()*
{
    let $range := $requests/mout:seconds-from-start(
        server:start-time,
        ancestor::server:server-status[1]/server:current-time
        )
    return (
        mout:make-property("specified-seconds-min",$ns-uri,"sec",$seconds-min),
        if (empty($range)) then ()
        else (
            mout:make-property("max-seconds",                 $ns-uri,"sec",max($range)),
            mout:make-property("ninetieth-percentile-seconds",$ns-uri,"sec",
                mout:ninetieth-percentile($range)),
            mout:make-property("median-seconds",              $ns-uri,"sec",mout:median($range)),
            mout:make-property("mean-seconds",                $ns-uri,"sec",avg($range)),
            mout:make-property("standard-dev-seconds",        $ns-uri,"sec",mout:stdev($range)),
            mout:make-property("min-seconds",                 $ns-uri,"sec",min($range))
        ),
        mout:make-property("total-requests",$ns-uri,"quantity",count($requests)),
        mout:make-property("update-count",$ns-uri,"quantity",
            count($requests[server:update eq true()])),
        mout:make-property("query-count",$ns-uri,"quantity",
            count($requests[server:update eq false()]))
    )
};

(: status nodes from this request across all hosts and servers, if not limited :)
declare function rmod:get-default-view(
    $context as map:map?,
    $gid     as xs:unsignedLong?,
    $hid     as xs:unsignedLong?,
    $sid     as xs:unsignedLong?,
    $rid     as xs:unsignedLong
) as element(rqtman:request-default)
{
    rmod:get-default-view(
        $context,
        $gid,
        $hid,
        $sid,
        $rid,
        rmod:get-requests($context,$ns-uri,$gid,$hid,$sid,$rid)
        )
};

declare function rmod:get-default-view(
    $context as map:map?,
    $gid     as xs:unsignedLong?,
    $hid     as xs:unsignedLong?,
    $sid     as xs:unsignedLong?,
    $rid     as xs:unsignedLong,
    $requests   as element(server:request-status)*
) as element(rqtman:request-default)
{
    let $unique-hosts   := distinct-values($requests/server:host-id)
    let $unique-servers := distinct-values($requests/server:server-id)
    return
        <request-default xsi:schemaLocation="{$ns-uri} {$schema-file}">
            {mout:get-id($ns-uri,$rid)}
            <meta>{
                mout:get-original-uri($context,$ns-uri),
                mout:get-current-time($ns-uri),
                mout:get-elapsed-time($ns-uri),

                reut:get-view-errors($context)
            }</meta>
            <relations>{
                rmod:get-request-relations($context,$ns-uri,$requests)
            }</relations>
            <properties>{
                for $request in $requests
                return rmod:get-enhanced-status($context,$ns-uri,$request)
            }</properties>
            <related-views>{
                mout:related-view-link($ns-uri,"list","default",
                    rmod:get-list-uri($context,gmod:get-group-name($gid),hmod:get-host-name($hid),smod:get-server-name($sid))
                    )
            }</related-views>
        </request-default>
};

(: metadata and links shared by list and item summary views :)
declare function rmod:get-summary-header(
    $context as map:map?,
    $is-page as xs:boolean,
    $ns-uri as xs:string,
    $hid as xs:unsignedLong?,
    $sid as xs:unsignedLong?
)
as element()*
{
    if (not($is-page)) then ()
    else (
        mout:make-element("uri",$ns-uri,
            reut:get-original-path($context)),
        mout:make-element("current-time",$ns-uri,
            current-dateTime())
    ),
    if (empty($hid)) then ()
    else mout:make-element("filtered-by",$ns-uri,"host"),
    if (empty($sid)) then ()
    else mout:make-element("filtered-by",$ns-uri,"server")
};

declare function rmod:get-request-relations(
    $context       as map:map?,
    $ns-uri        as xs:string,
    $request-stats as element(server:request-status)*
) as element()*
{
    let $host-ids := distinct-values($request-stats/server:host-id/data(.))
    return (
        hmod:get-relation-group($context,$ns-uri,$host-ids),
        smod:get-relation-group($context,$ns-uri,
            distinct-values($request-stats/server:server-id/data(.))
        ),
        dmod:get-relation-group($context,$ns-uri,
            distinct-values($request-stats/server:database/data(.))
        ),
        mout:get-relation-group($ns-uri,"transactions",
            for $hid in $host-ids
            for $tid in distinct-values(
                $request-stats[server:host-id/data(.) eq $hid]/server:transaction-id/data(.)
                )
            return tmod:get-relation($context,$ns-uri,$hid,$tid,())
        )
    )
};

declare function rmod:get-request-qualifiers(
    $context        as map:map?,
    $ns-uri         as xs:string,
    $fullrefs       as xs:boolean,
    $request-status as element(server:request-status)?
) as element()*
{
    let $hid   := $request-status/server:host-id/data(.)
    let $sid   := $request-status/server:server-id/data(.)
    let $dbid  := $request-status/server:database/data(.)
    let $tid   := $request-status/server:transaction-id/data(.)
    return
        if ($fullrefs) then (
            hmod:get-relation($context,$ns-uri,$hid,true(),()),
            smod:get-relation($context,$ns-uri,$sid,true(),()),
            dmod:get-relation($context,$ns-uri,$dbid,true(),()),
            tmod:get-relation($context,$ns-uri,$hid,$tid,true(),())
        ) else (
            mout:make-property("relation-id",$ns-uri,$hid),
            mout:make-property("relation-id",$ns-uri,$sid),
            mout:make-property("relation-id",$ns-uri,$dbid),
            mout:make-property("relation-id",$ns-uri,$tid)
        )
};

(: Takes existing status output and injects metadata :)

declare function rmod:get-enhanced-status(
    $context        as map:map?,
    $ns-uri         as xs:string,
    $request-status as element(server:request-status)
) as element()*
{
    mout:make-property("seconds-elapsed",$ns-uri,"sec",
        $request-status/mout:seconds-from-start(
            server:start-time,
            ancestor::server:server-status[1]/server:current-time
            )
        ),
    mout:annotate-units(
        $smod:schema-registry,
        $ns-uri,
        $request-status/(* except (server:database|server:host-id|server:server-id|
            server:request-id|server:transaction-id|server:modules)),
        ()
        )
};

(: data accessors :)

(: get filtered (potentially empty) or unfiltered status list :)
declare function rmod:get-requests(
    $context as map:map,
    $ns-uri as xs:string,
    $gids   as xs:unsignedLong*,
    $hid    as xs:unsignedLong?,
    $sid    as xs:unsignedLong?,
    $rid    as xs:unsignedLong?
) as element(server:request-status)*
{
    let $server-stats := smod:get-server-status($context,$ns-uri,$gids,$hid,$sid)
    return
        if (exists($rid))
        then $server-stats/server:request-statuses/server:request-status
            [server:request-id eq $rid]
        else $server-stats/server:request-statuses/server:request-status
};

declare function rmod:get-current-request(
) as xs:unsignedLong
{
    xdmp:request()
};

declare function rmod:get-request-status(
    $context as map:map,
    $ns-uri as xs:string,
    $hid    as xs:unsignedLong,
    $sid    as xs:unsignedLong,
    $rid    as xs:unsignedLong
) as element(server:request-status)?
{
    xdmp:security-assert("http://marklogic.com/xdmp/privileges/manage", "execute"),
    if (empty($hid) or empty($sid) or empty($rid)) then ()
    else
    try {
        xdmp:request-status($hid,$sid,$rid)
    } catch($err) {
        mout:report-error($context,$ns-uri,"request-status",$err)
    }
};
