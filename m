Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 584B9C433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Nov 2021 07:14:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 305B461056
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Nov 2021 07:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhKDHRX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Nov 2021 03:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbhKDHRV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Nov 2021 03:17:21 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1641DC061714
        for <linux-cifs@vger.kernel.org>; Thu,  4 Nov 2021 00:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=UN71shBCdbY8yQpPSwIFaHbkEhhwHXpzzdSv3DjvK74=; b=E61gDR6sABXMbKFT1hxr4quQKu
        4yS+PBbMKW3+D1VPzB8f1ru6pNe0IixJEB6bzcSJ5qHTCsvSqXgOVFBt5F5Eg3E3z7vaK2tER54Kh
        C74JGK9mM85wNtux0PKdAXLr4X3Avl3bF1PTRTnUyHq6QghlEYJOwPkyZAWXR5iHP2NIpUIk3A+dE
        F5k9WfskzTMmblVNWh0kqCTflJrol+MKplugyKp2V19rORW8FNyt+5umXm/T86N+tQQ6Df7H68/nS
        dLjanwqgr9QdYMhOX+EJ5rFpSae7FoEz9MlinQyKRXTd1g5Iuf60fR6f+xSNP1HlgwQ4wX5dveXre
        Hv3VLshQgfeyCB81sHJvmyrqDrGQLLQ6bsonOyqJktRo7BhMPeuWEYHAfhrMWS5468m19S2RRjVp2
        kjm1oWfvz8uLVPAVWHu59pVQ/KmJon/Wr7FTd5OSmxjJ/b+LB3qZMGbAtJWAa82ei0gmJfBDfAqiR
        LbPB3xi31xReKEFSthyZrel4;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1miWxM-0055RT-01; Thu, 04 Nov 2021 07:14:40 +0000
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>
References: <CAH2r5mtoz_droUOS-Uats_WL6MwFY5-pkHRVZo0nUwLdRjOvcA@mail.gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: trace point to print ip address we are trying to connect to
Message-ID: <9030fdb1-5555-1adf-7140-64eb1f0f23b7@samba.org>
Date:   Thu, 4 Nov 2021 08:14:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAH2r5mtoz_droUOS-Uats_WL6MwFY5-pkHRVZo0nUwLdRjOvcA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

you should made this generic (not ipv4/ipv6 specific) and use something like this:

TP_PROTO(const char *hostname, __u64 conn_id, const struct sockaddr_storage *dst_addr)

TP_STRUCT__entry(
__string(hostname, hostname)
__field(__u64, conn_id)
__field(struct sockaddr_storage, dst_addr)

TP_fast_assign(
__entry->conn_id = conn_id;
__entry->dst_addr = *dst_addr;
__assign_str(hostname, hostname);
),

With that you should be able to use this:

TP_printk("conn_id=0x%llx server=%s addr=%pISpsfc",
__entry->conn_id,
__get_str(hostname),
&__entry->dst_addr)

I hope that helps.

metze

Am 04.11.21 um 07:09 schrieb Steve French:
> It wasn't obvious to me the best way to pass in a pointer to the ipv4
> (and ipv6 address) to a dynamic trace point (unless I create a temp
> string first in generic_ip_connect and do the conversion (via "%pI4"
> and "%pI6" with sprintf) e.g.
> 
>         sprintf(ses->ip_addr, "%pI4", &addr->sin_addr);
> 
> The approach I tried passing in the pointer to sin_addr (the
> ipv4_address) caused an oops on loading it the first time and the
> warning:
> 
> [14928.818532] event smb3_ipv4_connect has unsafe dereference of argument 3
> [14928.818534] print_fmt: "conn_id=0x%llx server=%s addr=%pI4:%d",
> REC->conn_id, __get_str(hostname), REC->ipaddr, REC->port
> 
> 
> What I tried was the following (also see attached diff) to print the
> ipv4 address that we were trying to connect to
> 
> DECLARE_EVENT_CLASS(smb3_connect_class,
> TP_PROTO(char *hostname,
> __u64 conn_id,
> __u16 port,
> struct in_addr *ipaddr),
> TP_ARGS(hostname, conn_id, port, ipaddr),
> TP_STRUCT__entry(
> __string(hostname, hostname)
> __field(__u64, conn_id)
> __field(__u16, port)
> __field(const void *, ipaddr)
> ),
> TP_fast_assign(
> __entry->port = port;
> __entry->conn_id = conn_id;
> __entry->ipaddr = ipaddr;
> __assign_str(hostname, hostname);
> ),
> TP_printk("conn_id=0x%llx server=%s addr=%pI4:%d",
> __entry->conn_id,
> __get_str(hostname),
> __entry->ipaddr,
> __entry->port)
> )
> 
> #define DEFINE_SMB3_CONNECT_EVENT(name)        \
> DEFINE_EVENT(smb3_connect_class, smb3_##name,  \
> TP_PROTO(char *hostname, \
> __u64 conn_id, \
> __u16 port, \
> struct in_addr *ipaddr), \
> TP_ARGS(hostname, conn_id, port, ipaddr))
> 
> DEFINE_SMB3_CONNECT_EVENT(ipv4_connect);
> 
> Any ideas how to pass in the ipv4 address - or is it better to convert
> it to a string before we call the trace point (which seems wasteful to
> me but there must be examples of how to pass in structs to printks in
> trace in Linux)
> 

