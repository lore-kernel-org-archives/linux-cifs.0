Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C466C433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Nov 2021 15:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5352E61216
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Nov 2021 15:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbhKDPMb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Nov 2021 11:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231380AbhKDPMb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Nov 2021 11:12:31 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5092C061714
        for <linux-cifs@vger.kernel.org>; Thu,  4 Nov 2021 08:09:52 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id j5so10044835lja.9
        for <linux-cifs@vger.kernel.org>; Thu, 04 Nov 2021 08:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TtxQCxaA+w7hR6AeDNeF5TSxohUYkVWWWxB3zqQxajQ=;
        b=LbWTe6Sz4TDm/4c1v1T7JUnfN+9VPgY7HZ5WU1Vmwp9CoXvbccbqUZknF4Vyps/r9k
         +TfPT5tDsLLTXqhPFJosTtw0La6aBBwEIiTc+m6mkDqJ/HLG+eF8ctnjd3Nmz2Jq5Dnf
         cBWF2dBNhl5cKrDxKBulqMHWqI7DDSui0IQuflweX5fpR7gO/Tm1exNAEuLrLdc1jbOB
         wCmmqvnAhleWD0gaqrgqS6l63kcHsGI6cDdFaToVoOGJRmu5WUW16b0zRbg69tFkbwg8
         QvnaI2FFt7nBwk6JkB5mbrExXKYzKvF2kCTU60MoaNO1cdRX8VA8k3bXwSHX3+8n9WRI
         0PNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TtxQCxaA+w7hR6AeDNeF5TSxohUYkVWWWxB3zqQxajQ=;
        b=ejrEpf+HyyL4jTYoDf95u/KCNENc3xSeVNEUEoMQRUrLud3DUhYckXK3spWZG2zSTk
         Sy8fX01ufi0SPKllENrItFm2BASSs8oZDNw1qX2BecH0aP7j/dZDNnbJLmzmbCMrJcsQ
         cAnrDPTGILV/7WUDowW35iR0buUdXJIxCq4kh5lQIfTe+0WHBWcHzxdTOeb4yTT1UlZr
         DdkHshquV+i4s+qz8KpqBhQ7ZLi8mFDEXLUymyZ5zl0mIQ81Eq3APwNfgHWRdwemmw6V
         SRSj6riRvIvdlPwtwKmVjoKR4/+z9eZc+Tmt3+W3PZfHk54cLxvlqwf5I5BgGMGFAuHK
         jpMQ==
X-Gm-Message-State: AOAM5336cDXbfsRg8VLW8YsDdMYd3jAkIjWl6zG9s38a9wYIIZKxf02t
        IPKNF7va1mbw4BYc4oLM73SjD9XcCkXXMF2qmzE=
X-Google-Smtp-Source: ABdhPJxTTjD9sekZ9IH33rxaNEYMJTR4j9jNXG8phcMg1qnb0tR7pzhMq06xgrlsmIaHgeTqsa380h9wonT+7qOm/qQ=
X-Received: by 2002:a2e:9119:: with SMTP id m25mr139645ljg.229.1636038590971;
 Thu, 04 Nov 2021 08:09:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtoz_droUOS-Uats_WL6MwFY5-pkHRVZo0nUwLdRjOvcA@mail.gmail.com>
 <9030fdb1-5555-1adf-7140-64eb1f0f23b7@samba.org>
In-Reply-To: <9030fdb1-5555-1adf-7140-64eb1f0f23b7@samba.org>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 4 Nov 2021 10:09:39 -0500
Message-ID: <CAH2r5mu2f2=rRn_wH=yh5q=rY=KhE8709fpC=j71_rogDaZySQ@mail.gmail.com>
Subject: Re: trace point to print ip address we are trying to connect to
To:     Stefan Metzmacher <metze@samba.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>
Content-Type: multipart/mixed; boundary="0000000000000e30f605cff7eb3f"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000000e30f605cff7eb3f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

That looked like a good suggestion and will make the code cleaner but
with that change ran into this unexpected build error.   Ideas?

  CC [M]  /home/smfrench/cifs-2.6/fs/cifs/file.o
In file included from ./include/trace/define_trace.h:102,
                 from /home/smfrench/cifs-2.6/fs/cifs/trace.h:977,
                 from /home/smfrench/cifs-2.6/fs/cifs/trace.c:8:
./include/linux/socket.h:42:26: error: conversion to non-scalar type reques=
ted
   42 | #define sockaddr_storage __kernel_sockaddr_storage
      |                          ^~~~~~~~~~~~~~~~~~~~~~~~~
./include/trace/trace_events.h:477:9: note: in definition of macro
=E2=80=98DECLARE_EVENT_CLASS=E2=80=99
  477 |         tstruct
         \
      |         ^~~~~~~
/home/smfrench/cifs-2.6/fs/cifs/./trace.h:864:9: note: in expansion of
macro =E2=80=98TP_STRUCT__entry=E2=80=99
  864 |         TP_STRUCT__entry(
      |         ^~~~~~~~~~~~~~~~
./include/trace/trace_events.h:439:22: note: in expansion of macro
=E2=80=98is_signed_type=E2=80=99
  439 |         .is_signed =3D is_signed_type(_type), .filter_type =3D
_filter_type },
      |                      ^~~~~~~~~~~~~~
./include/trace/trace_events.h:448:33: note: in expansion of macro =E2=80=
=98__field_ext=E2=80=99
  448 | #define __field(type, item)     __field_ext(type, item, FILTER_OTHE=
R)
      |                                 ^~~~~~~~~~~
/home/smfrench/cifs-2.6/fs/cifs/./trace.h:867:17: note: in expansion
of macro =E2=80=98__field=E2=80=99
  867 |                 __field(struct sockaddr_storage, dst_addr)
      |                 ^~~~~~~
/home/smfrench/cifs-2.6/fs/cifs/./trace.h:867:32: note: in expansion
of macro =E2=80=98sockaddr_storage=E2=80=99
  867 |                 __field(struct sockaddr_storage, dst_addr)

On Thu, Nov 4, 2021 at 2:14 AM Stefan Metzmacher <metze@samba.org> wrote:
>
> Hi Steve,
>
> you should made this generic (not ipv4/ipv6 specific) and use something l=
ike this:
>
> TP_PROTO(const char *hostname, __u64 conn_id, const struct sockaddr_stora=
ge *dst_addr)
>
> TP_STRUCT__entry(
> __string(hostname, hostname)
> __field(__u64, conn_id)
> __field(struct sockaddr_storage, dst_addr)
>
> TP_fast_assign(
> __entry->conn_id =3D conn_id;
> __entry->dst_addr =3D *dst_addr;
> __assign_str(hostname, hostname);
> ),
>
> With that you should be able to use this:
>
> TP_printk("conn_id=3D0x%llx server=3D%s addr=3D%pISpsfc",
> __entry->conn_id,
> __get_str(hostname),
> &__entry->dst_addr)
>
> I hope that helps.
>
> metze
>
> Am 04.11.21 um 07:09 schrieb Steve French:
> > It wasn't obvious to me the best way to pass in a pointer to the ipv4
> > (and ipv6 address) to a dynamic trace point (unless I create a temp
> > string first in generic_ip_connect and do the conversion (via "%pI4"
> > and "%pI6" with sprintf) e.g.
> >
> >         sprintf(ses->ip_addr, "%pI4", &addr->sin_addr);
> >
> > The approach I tried passing in the pointer to sin_addr (the
> > ipv4_address) caused an oops on loading it the first time and the
> > warning:
> >
> > [14928.818532] event smb3_ipv4_connect has unsafe dereference of argume=
nt 3
> > [14928.818534] print_fmt: "conn_id=3D0x%llx server=3D%s addr=3D%pI4:%d"=
,
> > REC->conn_id, __get_str(hostname), REC->ipaddr, REC->port
> >
> >
> > What I tried was the following (also see attached diff) to print the
> > ipv4 address that we were trying to connect to
> >
> > DECLARE_EVENT_CLASS(smb3_connect_class,
> > TP_PROTO(char *hostname,
> > __u64 conn_id,
> > __u16 port,
> > struct in_addr *ipaddr),
> > TP_ARGS(hostname, conn_id, port, ipaddr),
> > TP_STRUCT__entry(
> > __string(hostname, hostname)
> > __field(__u64, conn_id)
> > __field(__u16, port)
> > __field(const void *, ipaddr)
> > ),
> > TP_fast_assign(
> > __entry->port =3D port;
> > __entry->conn_id =3D conn_id;
> > __entry->ipaddr =3D ipaddr;
> > __assign_str(hostname, hostname);
> > ),
> > TP_printk("conn_id=3D0x%llx server=3D%s addr=3D%pI4:%d",
> > __entry->conn_id,
> > __get_str(hostname),
> > __entry->ipaddr,
> > __entry->port)
> > )
> >
> > #define DEFINE_SMB3_CONNECT_EVENT(name)        \
> > DEFINE_EVENT(smb3_connect_class, smb3_##name,  \
> > TP_PROTO(char *hostname, \
> > __u64 conn_id, \
> > __u16 port, \
> > struct in_addr *ipaddr), \
> > TP_ARGS(hostname, conn_id, port, ipaddr))
> >
> > DEFINE_SMB3_CONNECT_EVENT(ipv4_connect);
> >
> > Any ideas how to pass in the ipv4 address - or is it better to convert
> > it to a string before we call the trace point (which seems wasteful to
> > me but there must be examples of how to pass in structs to printks in
> > trace in Linux)
> >
>


--=20
Thanks,

Steve

--0000000000000e30f605cff7eb3f
Content-Type: application/octet-stream; name=build-fail-out
Content-Disposition: attachment; filename=build-fail-out
Content-Transfer-Encoding: base64
Content-ID: <f_kvl2yk4w1>
X-Attachment-Id: f_kvl2yk4w1

bWFrZTogRW50ZXJpbmcgZGlyZWN0b3J5ICcvdXNyL3NyYy9saW51eC1oZWFkZXJzLTUuMTUuMC0w
NTE1MDAtZ2VuZXJpYycKICBDQyBbTV0gIC9ob21lL3NtZnJlbmNoL2NpZnMtMi42L2ZzL2NpZnMv
dHJhY2UubwogIENDIFtNXSAgL2hvbWUvc21mcmVuY2gvY2lmcy0yLjYvZnMvY2lmcy9jb25uZWN0
Lm8KICBDQyBbTV0gIC9ob21lL3NtZnJlbmNoL2NpZnMtMi42L2ZzL2NpZnMvZGlyLm8KICBDQyBb
TV0gIC9ob21lL3NtZnJlbmNoL2NpZnMtMi42L2ZzL2NpZnMvZmlsZS5vCkluIGZpbGUgaW5jbHVk
ZWQgZnJvbSAuL2luY2x1ZGUvdHJhY2UvZGVmaW5lX3RyYWNlLmg6MTAyLAogICAgICAgICAgICAg
ICAgIGZyb20gL2hvbWUvc21mcmVuY2gvY2lmcy0yLjYvZnMvY2lmcy90cmFjZS5oOjk3NSwKICAg
ICAgICAgICAgICAgICBmcm9tIC9ob21lL3NtZnJlbmNoL2NpZnMtMi42L2ZzL2NpZnMvdHJhY2Uu
Yzo4OgouL2luY2x1ZGUvbGludXgvc29ja2V0Lmg6NDI6MjY6IGVycm9yOiBjb252ZXJzaW9uIHRv
IG5vbi1zY2FsYXIgdHlwZSByZXF1ZXN0ZWQKICAgNDIgfCAjZGVmaW5lIHNvY2thZGRyX3N0b3Jh
Z2UgX19rZXJuZWxfc29ja2FkZHJfc3RvcmFnZQogICAgICB8ICAgICAgICAgICAgICAgICAgICAg
ICAgICBefn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+Ci4vaW5jbHVkZS90cmFjZS90cmFjZV9ldmVu
dHMuaDo0Nzc6OTogbm90ZTogaW4gZGVmaW5pdGlvbiBvZiBtYWNybyDigJhERUNMQVJFX0VWRU5U
X0NMQVNT4oCZCiAgNDc3IHwgICAgICAgICB0c3RydWN0ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXAogICAgICB8ICAgICAgICAgXn5+fn5+
fgovaG9tZS9zbWZyZW5jaC9jaWZzLTIuNi9mcy9jaWZzLy4vdHJhY2UuaDo4NjI6OTogbm90ZTog
aW4gZXhwYW5zaW9uIG9mIG1hY3JvIOKAmFRQX1NUUlVDVF9fZW50cnnigJkKICA4NjIgfCAgICAg
ICAgIFRQX1NUUlVDVF9fZW50cnkoCiAgICAgIHwgICAgICAgICBefn5+fn5+fn5+fn5+fn5+Ci4v
aW5jbHVkZS90cmFjZS90cmFjZV9ldmVudHMuaDo0Mzk6MjI6IG5vdGU6IGluIGV4cGFuc2lvbiBv
ZiBtYWNybyDigJhpc19zaWduZWRfdHlwZeKAmQogIDQzOSB8ICAgICAgICAgLmlzX3NpZ25lZCA9
IGlzX3NpZ25lZF90eXBlKF90eXBlKSwgLmZpbHRlcl90eXBlID0gX2ZpbHRlcl90eXBlIH0sCiAg
ICAgIHwgICAgICAgICAgICAgICAgICAgICAgXn5+fn5+fn5+fn5+fn4KLi9pbmNsdWRlL3RyYWNl
L3RyYWNlX2V2ZW50cy5oOjQ0ODozMzogbm90ZTogaW4gZXhwYW5zaW9uIG9mIG1hY3JvIOKAmF9f
ZmllbGRfZXh04oCZCiAgNDQ4IHwgI2RlZmluZSBfX2ZpZWxkKHR5cGUsIGl0ZW0pICAgICBfX2Zp
ZWxkX2V4dCh0eXBlLCBpdGVtLCBGSUxURVJfT1RIRVIpCiAgICAgIHwgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBefn5+fn5+fn5+fgovaG9tZS9zbWZyZW5jaC9jaWZzLTIuNi9mcy9j
aWZzLy4vdHJhY2UuaDo4NjU6MTc6IG5vdGU6IGluIGV4cGFuc2lvbiBvZiBtYWNybyDigJhfX2Zp
ZWxk4oCZCiAgODY1IHwgICAgICAgICAgICAgICAgIF9fZmllbGQoc3RydWN0IHNvY2thZGRyX3N0
b3JhZ2UsIGRzdF9hZGRyKQogICAgICB8ICAgICAgICAgICAgICAgICBefn5+fn5+Ci9ob21lL3Nt
ZnJlbmNoL2NpZnMtMi42L2ZzL2NpZnMvLi90cmFjZS5oOjg2NTozMjogbm90ZTogaW4gZXhwYW5z
aW9uIG9mIG1hY3JvIOKAmHNvY2thZGRyX3N0b3JhZ2XigJkKICA4NjUgfCAgICAgICAgICAgICAg
ICAgX19maWVsZChzdHJ1Y3Qgc29ja2FkZHJfc3RvcmFnZSwgZHN0X2FkZHIpCiAgICAgIHwgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5+fn5+fn5+fn5+fn5+fn4KLi9pbmNsdWRlL2xp
bnV4L3NvY2tldC5oOjQyOjI2OiBlcnJvcjogY29udmVyc2lvbiB0byBub24tc2NhbGFyIHR5cGUg
cmVxdWVzdGVkCiAgIDQyIHwgI2RlZmluZSBzb2NrYWRkcl9zdG9yYWdlIF9fa2VybmVsX3NvY2th
ZGRyX3N0b3JhZ2UKICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICAgXn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fgouL2luY2x1ZGUvdHJhY2UvdHJhY2VfZXZlbnRzLmg6NDc3Ojk6IG5vdGU6
IGluIGRlZmluaXRpb24gb2YgbWFjcm8g4oCYREVDTEFSRV9FVkVOVF9DTEFTU+KAmQogIDQ3NyB8
ICAgICAgICAgdHN0cnVjdCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIFwKICAgICAgfCAgICAgICAgIF5+fn5+fn4KL2hvbWUvc21mcmVuY2gv
Y2lmcy0yLjYvZnMvY2lmcy8uL3RyYWNlLmg6ODYyOjk6IG5vdGU6IGluIGV4cGFuc2lvbiBvZiBt
YWNybyDigJhUUF9TVFJVQ1RfX2VudHJ54oCZCiAgODYyIHwgICAgICAgICBUUF9TVFJVQ1RfX2Vu
dHJ5KAogICAgICB8ICAgICAgICAgXn5+fn5+fn5+fn5+fn5+fgouL2luY2x1ZGUvdHJhY2UvdHJh
Y2VfZXZlbnRzLmg6NDM5OjIyOiBub3RlOiBpbiBleHBhbnNpb24gb2YgbWFjcm8g4oCYaXNfc2ln
bmVkX3R5cGXigJkKICA0MzkgfCAgICAgICAgIC5pc19zaWduZWQgPSBpc19zaWduZWRfdHlwZShf
dHlwZSksIC5maWx0ZXJfdHlwZSA9IF9maWx0ZXJfdHlwZSB9LAogICAgICB8ICAgICAgICAgICAg
ICAgICAgICAgIF5+fn5+fn5+fn5+fn5+Ci4vaW5jbHVkZS90cmFjZS90cmFjZV9ldmVudHMuaDo0
NDg6MzM6IG5vdGU6IGluIGV4cGFuc2lvbiBvZiBtYWNybyDigJhfX2ZpZWxkX2V4dOKAmQogIDQ0
OCB8ICNkZWZpbmUgX19maWVsZCh0eXBlLCBpdGVtKSAgICAgX19maWVsZF9leHQodHlwZSwgaXRl
bSwgRklMVEVSX09USEVSKQogICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
Xn5+fn5+fn5+fn4KL2hvbWUvc21mcmVuY2gvY2lmcy0yLjYvZnMvY2lmcy8uL3RyYWNlLmg6ODY1
OjE3OiBub3RlOiBpbiBleHBhbnNpb24gb2YgbWFjcm8g4oCYX19maWVsZOKAmQogIDg2NSB8ICAg
ICAgICAgICAgICAgICBfX2ZpZWxkKHN0cnVjdCBzb2NrYWRkcl9zdG9yYWdlLCBkc3RfYWRkcikK
ICAgICAgfCAgICAgICAgICAgICAgICAgXn5+fn5+fgovaG9tZS9zbWZyZW5jaC9jaWZzLTIuNi9m
cy9jaWZzLy4vdHJhY2UuaDo4NjU6MzI6IG5vdGU6IGluIGV4cGFuc2lvbiBvZiBtYWNybyDigJhz
b2NrYWRkcl9zdG9yYWdl4oCZCiAgODY1IHwgICAgICAgICAgICAgICAgIF9fZmllbGQoc3RydWN0
IHNvY2thZGRyX3N0b3JhZ2UsIGRzdF9hZGRyKQogICAgICB8ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBefn5+fn5+fn5+fn5+fn5+Cm1ha2VbMV06ICoqKiBbc2NyaXB0cy9NYWtlZmls
ZS5idWlsZDoyNzc6IC9ob21lL3NtZnJlbmNoL2NpZnMtMi42L2ZzL2NpZnMvdHJhY2Uub10gRXJy
b3IgMQptYWtlWzFdOiAqKiogV2FpdGluZyBmb3IgdW5maW5pc2hlZCBqb2JzLi4uLgogIENIRUNL
ICAgL2hvbWUvc21mcmVuY2gvY2lmcy0yLjYvZnMvY2lmcy9kaXIuYwogIENIRUNLICAgL2hvbWUv
c21mcmVuY2gvY2lmcy0yLjYvZnMvY2lmcy9jb25uZWN0LmMKICBDSEVDSyAgIC9ob21lL3NtZnJl
bmNoL2NpZnMtMi42L2ZzL2NpZnMvZmlsZS5jCm1ha2U6ICoqKiBbTWFrZWZpbGU6MTg3NDogL2hv
bWUvc21mcmVuY2gvY2lmcy0yLjYvZnMvY2lmc10gRXJyb3IgMgptYWtlOiBMZWF2aW5nIGRpcmVj
dG9yeSAnL3Vzci9zcmMvbGludXgtaGVhZGVycy01LjE1LjAtMDUxNTAwLWdlbmVyaWMnCg==
--0000000000000e30f605cff7eb3f
Content-Type: text/x-patch; charset="US-ASCII"; name="add-ip-connect-tracepoint.diff"
Content-Disposition: attachment; filename="add-ip-connect-tracepoint.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_kvl2yk4d0>
X-Attachment-Id: f_kvl2yk4d0

ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lmcy9jb25uZWN0LmMKaW5kZXgg
ZTZlMjYxZGZkMTA3Li5mZDk2ZGU1OWI5NjggMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY29ubmVjdC5j
CisrKyBiL2ZzL2NpZnMvY29ubmVjdC5jCkBAIC0yNTkyLDYgKzI1OTIsOCBAQCBnZW5lcmljX2lw
X2Nvbm5lY3Qoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKQogCQkJCW50b2hzKHNwb3J0
KSk7CiAJfQogCisJdHJhY2Vfc21iM19jb25uZWN0KHNlcnZlci0+aG9zdG5hbWUsIHNlcnZlci0+
Y29ubl9pZCwgJnNlcnZlci0+ZHN0YWRkcik7CisKIAlpZiAoc29ja2V0ID09IE5VTEwpIHsKIAkJ
cmMgPSBfX3NvY2tfY3JlYXRlKGNpZnNfbmV0X25zKHNlcnZlciksIHNmYW1pbHksIFNPQ0tfU1RS
RUFNLAogCQkJCSAgIElQUFJPVE9fVENQLCAmc29ja2V0LCAxKTsKZGlmZiAtLWdpdCBhL2ZzL2Np
ZnMvdHJhY2UuaCBiL2ZzL2NpZnMvdHJhY2UuaAppbmRleCBkYWZjYjZhYjA1MGQuLmEyMGVjZTAw
NzMzZiAxMDA2NDQKLS0tIGEvZnMvY2lmcy90cmFjZS5oCisrKyBiL2ZzL2NpZnMvdHJhY2UuaApA
QCAtMTEsNiArMTEsNyBAQAogI2RlZmluZSBfQ0lGU19UUkFDRV9ICiAKICNpbmNsdWRlIDxsaW51
eC90cmFjZXBvaW50Lmg+CisjaW5jbHVkZSA8bGludXgvaW5ldC5oPgogCiAvKgogICogUGxlYXNl
IHVzZSB0aGlzIDMtcGFydCBhcnRpY2xlIGFzIGEgcmVmZXJlbmNlIGZvciB3cml0aW5nIG5ldyB0
cmFjZXBvaW50czoKQEAgLTg1NCw2ICs4NTUsMzYgQEAgREVGSU5FX0VWRU5UKHNtYjNfbGVhc2Vf
ZXJyX2NsYXNzLCBzbWIzXyMjbmFtZSwgIFwKIAogREVGSU5FX1NNQjNfTEVBU0VfRVJSX0VWRU5U
KGxlYXNlX2Vycik7CiAKK0RFQ0xBUkVfRVZFTlRfQ0xBU1Moc21iM19jb25uZWN0X2NsYXNzLAor
CVRQX1BST1RPKGNoYXIgKmhvc3RuYW1lLAorCQlfX3U2NCBjb25uX2lkLAorCQljb25zdCBzdHJ1
Y3Qgc29ja2FkZHJfc3RvcmFnZSAqZHN0X2FkZHIpLAorCVRQX0FSR1MoaG9zdG5hbWUsIGNvbm5f
aWQsIGRzdF9hZGRyKSwKKwlUUF9TVFJVQ1RfX2VudHJ5KAorCQlfX3N0cmluZyhob3N0bmFtZSwg
aG9zdG5hbWUpCisJCV9fZmllbGQoX191NjQsIGNvbm5faWQpCisJCV9fZmllbGQoc3RydWN0IHNv
Y2thZGRyX3N0b3JhZ2UsIGRzdF9hZGRyKQorCSksCisJVFBfZmFzdF9hc3NpZ24oCisJCV9fZW50
cnktPmNvbm5faWQgPSBjb25uX2lkOworCQlfX2VudHJ5LT5kc3RfYWRkciA9ICpkc3RfYWRkcjsK
KwkJX19hc3NpZ25fc3RyKGhvc3RuYW1lLCBob3N0bmFtZSk7CisJKSwKKwlUUF9wcmludGsoImNv
bm5faWQ9MHglbGx4IHNlcnZlcj0lcyBhZGRyPSVwSVNwc2ZjIiwKKwkJX19lbnRyeS0+Y29ubl9p
ZCwKKwkJX19nZXRfc3RyKGhvc3RuYW1lKSwKKwkJJl9fZW50cnktPmRzdF9hZGRyKQorKQorCisj
ZGVmaW5lIERFRklORV9TTUIzX0NPTk5FQ1RfRVZFTlQobmFtZSkgICAgICAgIFwKK0RFRklORV9F
VkVOVChzbWIzX2Nvbm5lY3RfY2xhc3MsIHNtYjNfIyNuYW1lLCAgXAorCVRQX1BST1RPKGNoYXIg
Kmhvc3RuYW1lLAkJXAorCQlfX3U2NCBjb25uX2lkLAkJCVwKKwkJY29uc3Qgc3RydWN0IHNvY2th
ZGRyX3N0b3JhZ2UgKmFkZHIpLAlcCisJVFBfQVJHUyhob3N0bmFtZSwgY29ubl9pZCwgYWRkcikp
CisKK0RFRklORV9TTUIzX0NPTk5FQ1RfRVZFTlQoY29ubmVjdCk7CisKIERFQ0xBUkVfRVZFTlRf
Q0xBU1Moc21iM19yZWNvbm5lY3RfY2xhc3MsCiAJVFBfUFJPVE8oX191NjQJY3Vycm1pZCwKIAkJ
X191NjQgY29ubl9pZCwK
--0000000000000e30f605cff7eb3f--
