Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A93C433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Nov 2021 15:26:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED23560F70
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Nov 2021 15:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhKDP3g (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Nov 2021 11:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhKDP3f (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Nov 2021 11:29:35 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71112C061714
        for <linux-cifs@vger.kernel.org>; Thu,  4 Nov 2021 08:26:57 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id o18so12674516lfu.13
        for <linux-cifs@vger.kernel.org>; Thu, 04 Nov 2021 08:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iOXldVxzLtbRIhteh1ApLZocCTZ9MNhmde1aowQWZ64=;
        b=D/EX3XAUTn/23h5TbohplD8zMpdXcec0lT+j6xe9akKAFwUJyZfiRDQ4WKxjD8+ez8
         6bBonZPgWuubPK1fKievyIcI5B3gaRd+B6svMiKQfi3WeoVcq8bBlLRf+QSRCJfL4rTc
         4g2zNW5ZCoNp7eIAYSTAy79RN5eGy64jd+aQqZwN8X+bYg3h/iGGVUbLtXw3NBvXPx5x
         uRsZ4ncjSNYAHeUryyNgyZbJ7zWkz0klC9PhDptYYbmx+qCdzw97PW/wAZN05buYOCP4
         HTNi+a0E2rVaytFmGiQY2SpfTp+3hAXXmtHJTnXsqN+WVO5YBrl+6DG1WQdYrzEuOFrg
         BCTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iOXldVxzLtbRIhteh1ApLZocCTZ9MNhmde1aowQWZ64=;
        b=joYO8vu25ESdptJcxDWfCYKdWn0e2qBmz/P4Oxn9eNSL+OksYMCH/HhpltYFCKEjwd
         WziYGltlNOi5db1nGkoxSdWNXM7kLGgi3XalgxzOqopvE/DjjuRX3g9PtB0V9hXQ30cf
         hJ3idlEuOtUwgtpMrApus6QBSZrphbwyL8+EkpagcvW86+aO3ZqtbQo5LT24qJUd/313
         Hy2viYDFo7AosLYum6kS6zOSs4IMDky8VkrAVAiJWvZvTC9psbkZjArjr7BfbRu4aw7Y
         k6TJmN48QvFUzC+PXqM/AexSSdwS/L5HpRXPzRtenk+VLrS6EknfJvkOcRT4t8Y76Iyt
         C27A==
X-Gm-Message-State: AOAM531deqQascyRrFKhcr/xSltHUH4edbyp8FlPoPgDo96cXMGTWw4F
        7d8FismwsMbPNDRqvImaSYcqOcdAJf6EK+sOJjE=
X-Google-Smtp-Source: ABdhPJyodp0p6mVNt2Y+/2xxnz/0NwbIeNF23UFu4Hp18V4qJPuTAH3AkYk+JpS3qUST/F7l0TY8+Xog9Xv2RCXbJX8=
X-Received: by 2002:a05:6512:3fa4:: with SMTP id x36mr49025756lfa.320.1636039615693;
 Thu, 04 Nov 2021 08:26:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtoz_droUOS-Uats_WL6MwFY5-pkHRVZo0nUwLdRjOvcA@mail.gmail.com>
 <9030fdb1-5555-1adf-7140-64eb1f0f23b7@samba.org> <CAH2r5mu2f2=rRn_wH=yh5q=rY=KhE8709fpC=j71_rogDaZySQ@mail.gmail.com>
In-Reply-To: <CAH2r5mu2f2=rRn_wH=yh5q=rY=KhE8709fpC=j71_rogDaZySQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 4 Nov 2021 10:26:44 -0500
Message-ID: <CAH2r5muCJJhK+fRCUEc7hgTne4PEW5UgjRDY8iWFv-d-UGEQTw@mail.gmail.com>
Subject: Re: trace point to print ip address we are trying to connect to
To:     Stefan Metzmacher <metze@samba.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

changing it to __kernel_sockaddr_storage the build error is:

                 from /home/smfrench/cifs-2.6/fs/cifs/trace.c:8:
/home/smfrench/cifs-2.6/fs/cifs/./trace.h:867:32: error: conversion to
non-scalar type requested
  867 |                 __field(struct __kernel_sockaddr_storage, dst_addr)
      |                                ^~~~~~~~~~~~~~~~~~~~~~~~~
./include/trace/trace_events.h:477:9: note: in definition of macro
=E2=80=98DECLARE_EVENT_CLASS=E2=80=99
  477 |         tstruct
         \
      |         ^~~~~~~
/home/smfrench/cifs-2.6/fs/cifs/./trace.h:864:9: note: in expansion of
macro =E2=80=98TP_STRUCT__entry=E2=80=99
  864 |         TP_STRUCT__entry(

On Thu, Nov 4, 2021 at 10:09 AM Steve French <smfrench@gmail.com> wrote:
>
> That looked like a good suggestion and will make the code cleaner but
> with that change ran into this unexpected build error.   Ideas?
>
>   CC [M]  /home/smfrench/cifs-2.6/fs/cifs/file.o
> In file included from ./include/trace/define_trace.h:102,
>                  from /home/smfrench/cifs-2.6/fs/cifs/trace.h:977,
>                  from /home/smfrench/cifs-2.6/fs/cifs/trace.c:8:
> ./include/linux/socket.h:42:26: error: conversion to non-scalar type requ=
ested
>    42 | #define sockaddr_storage __kernel_sockaddr_storage
>       |                          ^~~~~~~~~~~~~~~~~~~~~~~~~
> ./include/trace/trace_events.h:477:9: note: in definition of macro
> =E2=80=98DECLARE_EVENT_CLASS=E2=80=99
>   477 |         tstruct
>          \
>       |         ^~~~~~~
> /home/smfrench/cifs-2.6/fs/cifs/./trace.h:864:9: note: in expansion of
> macro =E2=80=98TP_STRUCT__entry=E2=80=99
>   864 |         TP_STRUCT__entry(
>       |         ^~~~~~~~~~~~~~~~
> ./include/trace/trace_events.h:439:22: note: in expansion of macro
> =E2=80=98is_signed_type=E2=80=99
>   439 |         .is_signed =3D is_signed_type(_type), .filter_type =3D
> _filter_type },
>       |                      ^~~~~~~~~~~~~~
> ./include/trace/trace_events.h:448:33: note: in expansion of macro =E2=80=
=98__field_ext=E2=80=99
>   448 | #define __field(type, item)     __field_ext(type, item, FILTER_OT=
HER)
>       |                                 ^~~~~~~~~~~
> /home/smfrench/cifs-2.6/fs/cifs/./trace.h:867:17: note: in expansion
> of macro =E2=80=98__field=E2=80=99
>   867 |                 __field(struct sockaddr_storage, dst_addr)
>       |                 ^~~~~~~
> /home/smfrench/cifs-2.6/fs/cifs/./trace.h:867:32: note: in expansion
> of macro =E2=80=98sockaddr_storage=E2=80=99
>   867 |                 __field(struct sockaddr_storage, dst_addr)
>
> On Thu, Nov 4, 2021 at 2:14 AM Stefan Metzmacher <metze@samba.org> wrote:
> >
> > Hi Steve,
> >
> > you should made this generic (not ipv4/ipv6 specific) and use something=
 like this:
> >
> > TP_PROTO(const char *hostname, __u64 conn_id, const struct sockaddr_sto=
rage *dst_addr)
> >
> > TP_STRUCT__entry(
> > __string(hostname, hostname)
> > __field(__u64, conn_id)
> > __field(struct sockaddr_storage, dst_addr)
> >
> > TP_fast_assign(
> > __entry->conn_id =3D conn_id;
> > __entry->dst_addr =3D *dst_addr;
> > __assign_str(hostname, hostname);
> > ),
> >
> > With that you should be able to use this:
> >
> > TP_printk("conn_id=3D0x%llx server=3D%s addr=3D%pISpsfc",
> > __entry->conn_id,
> > __get_str(hostname),
> > &__entry->dst_addr)
> >
> > I hope that helps.
> >
> > metze
> >
> > Am 04.11.21 um 07:09 schrieb Steve French:
> > > It wasn't obvious to me the best way to pass in a pointer to the ipv4
> > > (and ipv6 address) to a dynamic trace point (unless I create a temp
> > > string first in generic_ip_connect and do the conversion (via "%pI4"
> > > and "%pI6" with sprintf) e.g.
> > >
> > >         sprintf(ses->ip_addr, "%pI4", &addr->sin_addr);
> > >
> > > The approach I tried passing in the pointer to sin_addr (the
> > > ipv4_address) caused an oops on loading it the first time and the
> > > warning:
> > >
> > > [14928.818532] event smb3_ipv4_connect has unsafe dereference of argu=
ment 3
> > > [14928.818534] print_fmt: "conn_id=3D0x%llx server=3D%s addr=3D%pI4:%=
d",
> > > REC->conn_id, __get_str(hostname), REC->ipaddr, REC->port
> > >
> > >
> > > What I tried was the following (also see attached diff) to print the
> > > ipv4 address that we were trying to connect to
> > >
> > > DECLARE_EVENT_CLASS(smb3_connect_class,
> > > TP_PROTO(char *hostname,
> > > __u64 conn_id,
> > > __u16 port,
> > > struct in_addr *ipaddr),
> > > TP_ARGS(hostname, conn_id, port, ipaddr),
> > > TP_STRUCT__entry(
> > > __string(hostname, hostname)
> > > __field(__u64, conn_id)
> > > __field(__u16, port)
> > > __field(const void *, ipaddr)
> > > ),
> > > TP_fast_assign(
> > > __entry->port =3D port;
> > > __entry->conn_id =3D conn_id;
> > > __entry->ipaddr =3D ipaddr;
> > > __assign_str(hostname, hostname);
> > > ),
> > > TP_printk("conn_id=3D0x%llx server=3D%s addr=3D%pI4:%d",
> > > __entry->conn_id,
> > > __get_str(hostname),
> > > __entry->ipaddr,
> > > __entry->port)
> > > )
> > >
> > > #define DEFINE_SMB3_CONNECT_EVENT(name)        \
> > > DEFINE_EVENT(smb3_connect_class, smb3_##name,  \
> > > TP_PROTO(char *hostname, \
> > > __u64 conn_id, \
> > > __u16 port, \
> > > struct in_addr *ipaddr), \
> > > TP_ARGS(hostname, conn_id, port, ipaddr))
> > >
> > > DEFINE_SMB3_CONNECT_EVENT(ipv4_connect);
> > >
> > > Any ideas how to pass in the ipv4 address - or is it better to conver=
t
> > > it to a string before we call the trace point (which seems wasteful t=
o
> > > me but there must be examples of how to pass in structs to printks in
> > > trace in Linux)
> > >
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
