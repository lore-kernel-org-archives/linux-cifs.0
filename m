Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B01EC433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Nov 2021 21:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 452656124A
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Nov 2021 21:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbhKDVIH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Nov 2021 17:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231998AbhKDVID (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Nov 2021 17:08:03 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8EDC061714
        for <linux-cifs@vger.kernel.org>; Thu,  4 Nov 2021 14:05:24 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id h11so11718858ljk.1
        for <linux-cifs@vger.kernel.org>; Thu, 04 Nov 2021 14:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vt8X+9AbDjSfGelTaCAFuq+yURMxskU/momDmNiamug=;
        b=PlCSbWymAyyb73rs48rQ6U1xEGNtXttOoUKPyGHB54DEO3BQlJBtpGaFeV5AtnWEMN
         QU1Ue/2ySKQKRK/hq9/SGsehtAfVB60xDhnsDnqZPP7sn3+D7cUox1pKIourS+nsLPod
         qYh/QgJ5YR1aahAq3wgj1QkOtQelj859n3odbdFlCxGvVz79wMJwQcIvfjqTwoO/DLfB
         QtiObCLRCirK/LfTaDY7m/Cwlty8BZZi48gtO2rx/b+W90aelZe3dZHETO1jPoCu2TzO
         iUSyxb64t/9/C7+FJ8rYyiNycHAN9LZsonLbxxGzPxmQnbIfeZNFJKx9wg/9A9SalSM+
         d2aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vt8X+9AbDjSfGelTaCAFuq+yURMxskU/momDmNiamug=;
        b=Kv3a6f6aWndfHe9nWKgCkf1AFIaxBBkLhYMI+JUFlMzNozpa8pi/H/MyZYAc9phfCe
         sFlhUkGH8blZUh0lt+bPJlXv/SLPi1d1ODRftUtOTTHFnofbKAKG9mzIZscmUr1yw64U
         tMGx6fMGBlO+QG0eyETGRpmHm/RQ0OELLSBPYZ7jT6POf/1oPqSJcnfX3PxrnXaZScEv
         F7qsyZS3+vTXQehIDTBdTgy83GLtre9nTObdb/71qDGzSe9sJll4Ow14kh5vEvdRjQ2u
         A4AVe1+i8PzXkB+z0eGghB+TwFiRiMktZMkjf9jOmZLRdLYXDGEgv11Dl4AgXS101HR9
         53zA==
X-Gm-Message-State: AOAM531ZBjZd7Tmh70vlYPqTceAyv4ZbtzfUHTAWd+2UCvEsR7C3AVta
        CS/BOfP1imqfIZTWwxXf9DfACEN1IrwwrELSH7U=
X-Google-Smtp-Source: ABdhPJzCZ3oa6qw0E9oO5xrc2e1mY3tDCSdqP6fjXbh0kMb5aTuXyXmAhuJYDPcebUTTMHA0jj0s/EKO4ppRXpS+Po0=
X-Received: by 2002:a2e:9119:: with SMTP id m25mr1941269ljg.229.1636059922615;
 Thu, 04 Nov 2021 14:05:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtoz_droUOS-Uats_WL6MwFY5-pkHRVZo0nUwLdRjOvcA@mail.gmail.com>
 <9030fdb1-5555-1adf-7140-64eb1f0f23b7@samba.org> <CAH2r5mu2f2=rRn_wH=yh5q=rY=KhE8709fpC=j71_rogDaZySQ@mail.gmail.com>
 <CAH2r5muCJJhK+fRCUEc7hgTne4PEW5UgjRDY8iWFv-d-UGEQTw@mail.gmail.com>
 <b9ce06c6-22c1-a4fa-006f-2747d8a5f38b@samba.org> <4cc497e1-8eaf-fd01-276c-95bec6adcef6@samba.org>
In-Reply-To: <4cc497e1-8eaf-fd01-276c-95bec6adcef6@samba.org>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 4 Nov 2021 16:05:11 -0500
Message-ID: <CAH2r5mtimtXhaET_Uqq8JHY75Tx4JwzVXnzypdCXDmwUEJdr4w@mail.gmail.com>
Subject: Re: trace point to print ip address we are trying to connect to
To:     Stefan Metzmacher <metze@samba.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>
Content-Type: multipart/mixed; boundary="00000000000085907905cffce2a2"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000085907905cffce2a2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Here is the updated patch - seems to work. See attached.

#                              |||| /     delay
#           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
#              | |         |   |||||     |         |
      mount.cifs-14551   [005] .....  7636.547906: smb3_connect_done:
conn_id=3D0x1 server=3Dlocalhost addr=3D127.0.0.1:445
      mount.cifs-14558   [004] .....  7642.405413: smb3_connect_done:
conn_id=3D0x2 server=3Dsmfrench.file.core.windows.net
addr=3D52.239.158.232:445
      mount.cifs-14741   [005] .....  7818.490716: smb3_connect_done:
conn_id=3D0x3 server=3D::1 addr=3D[::1]:445/0%0
      mount.cifs-14810   [000] .....  7966.380337: smb3_connect_err:
rc=3D-101 conn_id=3D0x4 server=3D::2 addr=3D[::2]:445/0%0
      mount.cifs-14810   [000] .....  7966.380356: smb3_connect_err:
rc=3D-101 conn_id=3D0x4 server=3D::2 addr=3D[::2]:139/0%0
      mount.cifs-14818   [003] .....  7986.771992: smb3_connect_done:
conn_id=3D0x5 server=3D127.0.0.9 addr=3D127.0.0.9:445
      mount.cifs-14825   [008] .....  8008.178109: smb3_connect_err:
rc=3D-115 conn_id=3D0x6 server=3D124.23.0.9 addr=3D124.23.0.9:445
      mount.cifs-14825   [008] .....  8013.298085: smb3_connect_err:
rc=3D-115 conn_id=3D0x6 server=3D124.23.0.9 addr=3D124.23.0.9:139
           cifsd-14553   [006] .....  8036.735615: smb3_reconnect:
conn_id=3D0x1 server=3Dlocalhost current_mid=3D32
           cifsd-14743   [010] .....  8036.735644: smb3_reconnect:
conn_id=3D0x3 server=3D::1 current_mid=3D29
           cifsd-14743   [010] .....  8036.735686: smb3_connect_err:
rc=3D-111 conn_id=3D0x3 server=3D::1 addr=3D[::1]:445/0%0
           cifsd-14553   [008] .....  8036.737867: smb3_connect_err:
rc=3D-111 conn_id=3D0x1 server=3Dlocalhost addr=3D127.0.0.1:445
           cifsd-14743   [010] .....  8039.921740: smb3_connect_err:
rc=3D-111 conn_id=3D0x3 server=3D::1 addr=3D[::1]:445/0%0
           cifsd-14553   [008] .....  8039.921743: smb3_connect_err:
rc=3D-111 conn_id=3D0x1 server=3Dlocalhost addr=3D127.0.0.1:445
           cifsd-14553   [008] .....  8042.993894: smb3_connect_err:
rc=3D-111 conn_id=3D0x1 server=3Dlocalhost addr=3D127.0.0.1:445
           cifsd-14743   [010] .....  8042.993894: smb3_connect_err:
rc=3D-111 conn_id=3D0x3 server=3D::1 addr=3D[::1]:445/0%0
           cifsd-14553   [008] .....  8046.065824: smb3_connect_err:
rc=3D-111 conn_id=3D0x1 server=3Dlocalhost addr=3D127.0.0.1:445
           cifsd-14743   [010] .....  8046.065824: smb3_connect_err:
rc=3D-111 conn_id=3D0x3 server=3D::1 addr=3D[::1]:445/0%0
           cifsd-14553   [008] .....  8049.137796: smb3_connect_done:
conn_id=3D0x1 server=3Dlocalhost addr=3D127.0.0.1:445
           cifsd-14743   [010] .....  8049.137796: smb3_connect_done:
conn_id=3D0x3 server=3D::1 addr=3D[::1]:445/0%0

On Thu, Nov 4, 2021 at 12:07 PM Stefan Metzmacher <metze@samba.org> wrote:
>
> Am 04.11.21 um 18:02 schrieb Stefan Metzmacher:
> > I looked at my smbdirect dirver code and there I use:
> >
> >         TP_STRUCT__entry(
> >                 ...
> >                 __array(__u8, addr, sizeof(struct sockaddr_storage))
> >         ),
> >         TP_fast_assign(
>
> Here I missed the 'struct sockaddr_storage *pss =3D NULL;' helper variabl=
e...
> >                 pss =3D (struct sockaddr_storage *)__entry->addr;
> >                 *pss =3D *addr;
> >         ),
> >         TP_printk("... %pISp",
> >                   __entry->addr)
>
> My full example is here:
>
> https://git.samba.org/?p=3Dmetze/linux/smbdirect.git;a=3Dblob;f=3Dsmbdire=
ct_trace.h;hb=3Drefs/heads/smbdirect-work-in-progress#l100
>
> metze
>
> > Am 04.11.21 um 16:26 schrieb Steve French:
> >> changing it to __kernel_sockaddr_storage the build error is:
> >>
> >>                  from /home/smfrench/cifs-2.6/fs/cifs/trace.c:8:
> >> /home/smfrench/cifs-2.6/fs/cifs/./trace.h:867:32: error: conversion to
> >> non-scalar type requested
> >>   867 |                 __field(struct __kernel_sockaddr_storage, dst_=
addr)
> >>       |                                ^~~~~~~~~~~~~~~~~~~~~~~~~
> >> ./include/trace/trace_events.h:477:9: note: in definition of macro
> >> =E2=80=98DECLARE_EVENT_CLASS=E2=80=99
> >>   477 |         tstruct
> >>          \
> >>       |         ^~~~~~~
> >> /home/smfrench/cifs-2.6/fs/cifs/./trace.h:864:9: note: in expansion of
> >> macro =E2=80=98TP_STRUCT__entry=E2=80=99
> >>   864 |         TP_STRUCT__entry(
> >>
> >> On Thu, Nov 4, 2021 at 10:09 AM Steve French <smfrench@gmail.com> wrot=
e:
> >>>
> >>> That looked like a good suggestion and will make the code cleaner but
> >>> with that change ran into this unexpected build error.   Ideas?
> >>>
> >>>   CC [M]  /home/smfrench/cifs-2.6/fs/cifs/file.o
> >>> In file included from ./include/trace/define_trace.h:102,
> >>>                  from /home/smfrench/cifs-2.6/fs/cifs/trace.h:977,
> >>>                  from /home/smfrench/cifs-2.6/fs/cifs/trace.c:8:
> >>> ./include/linux/socket.h:42:26: error: conversion to non-scalar type =
requested
> >>>    42 | #define sockaddr_storage __kernel_sockaddr_storage
> >>>       |                          ^~~~~~~~~~~~~~~~~~~~~~~~~
> >>> ./include/trace/trace_events.h:477:9: note: in definition of macro
> >>> =E2=80=98DECLARE_EVENT_CLASS=E2=80=99
> >>>   477 |         tstruct
> >>>          \
> >>>       |         ^~~~~~~
> >>> /home/smfrench/cifs-2.6/fs/cifs/./trace.h:864:9: note: in expansion o=
f
> >>> macro =E2=80=98TP_STRUCT__entry=E2=80=99
> >>>   864 |         TP_STRUCT__entry(
> >>>       |         ^~~~~~~~~~~~~~~~
> >>> ./include/trace/trace_events.h:439:22: note: in expansion of macro
> >>> =E2=80=98is_signed_type=E2=80=99
> >>>   439 |         .is_signed =3D is_signed_type(_type), .filter_type =
=3D
> >>> _filter_type },
> >>>       |                      ^~~~~~~~~~~~~~
> >>> ./include/trace/trace_events.h:448:33: note: in expansion of macro =
=E2=80=98__field_ext=E2=80=99
> >>>   448 | #define __field(type, item)     __field_ext(type, item, FILTE=
R_OTHER)
> >>>       |                                 ^~~~~~~~~~~
> >>> /home/smfrench/cifs-2.6/fs/cifs/./trace.h:867:17: note: in expansion
> >>> of macro =E2=80=98__field=E2=80=99
> >>>   867 |                 __field(struct sockaddr_storage, dst_addr)
> >>>       |                 ^~~~~~~
> >>> /home/smfrench/cifs-2.6/fs/cifs/./trace.h:867:32: note: in expansion
> >>> of macro =E2=80=98sockaddr_storage=E2=80=99
> >>>   867 |                 __field(struct sockaddr_storage, dst_addr)
> >>>
> >>> On Thu, Nov 4, 2021 at 2:14 AM Stefan Metzmacher <metze@samba.org> wr=
ote:
> >>>>
> >>>> Hi Steve,
> >>>>
> >>>> you should made this generic (not ipv4/ipv6 specific) and use someth=
ing like this:
> >>>>
> >>>> TP_PROTO(const char *hostname, __u64 conn_id, const struct sockaddr_=
storage *dst_addr)
> >>>>
> >>>> TP_STRUCT__entry(
> >>>> __string(hostname, hostname)
> >>>> __field(__u64, conn_id)
> >>>> __field(struct sockaddr_storage, dst_addr)
> >>>>
> >>>> TP_fast_assign(
> >>>> __entry->conn_id =3D conn_id;
> >>>> __entry->dst_addr =3D *dst_addr;
> >>>> __assign_str(hostname, hostname);
> >>>> ),
> >>>>
> >>>> With that you should be able to use this:
> >>>>
> >>>> TP_printk("conn_id=3D0x%llx server=3D%s addr=3D%pISpsfc",
> >>>> __entry->conn_id,
> >>>> __get_str(hostname),
> >>>> &__entry->dst_addr)
> >>>>
> >>>> I hope that helps.
> >>>>
> >>>> metze
> >>>>
> >>>> Am 04.11.21 um 07:09 schrieb Steve French:
> >>>>> It wasn't obvious to me the best way to pass in a pointer to the ip=
v4
> >>>>> (and ipv6 address) to a dynamic trace point (unless I create a temp
> >>>>> string first in generic_ip_connect and do the conversion (via "%pI4=
"
> >>>>> and "%pI6" with sprintf) e.g.
> >>>>>
> >>>>>         sprintf(ses->ip_addr, "%pI4", &addr->sin_addr);
> >>>>>
> >>>>> The approach I tried passing in the pointer to sin_addr (the
> >>>>> ipv4_address) caused an oops on loading it the first time and the
> >>>>> warning:
> >>>>>
> >>>>> [14928.818532] event smb3_ipv4_connect has unsafe dereference of ar=
gument 3
> >>>>> [14928.818534] print_fmt: "conn_id=3D0x%llx server=3D%s addr=3D%pI4=
:%d",
> >>>>> REC->conn_id, __get_str(hostname), REC->ipaddr, REC->port
> >>>>>
> >>>>>
> >>>>> What I tried was the following (also see attached diff) to print th=
e
> >>>>> ipv4 address that we were trying to connect to
> >>>>>
> >>>>> DECLARE_EVENT_CLASS(smb3_connect_class,
> >>>>> TP_PROTO(char *hostname,
> >>>>> __u64 conn_id,
> >>>>> __u16 port,
> >>>>> struct in_addr *ipaddr),
> >>>>> TP_ARGS(hostname, conn_id, port, ipaddr),
> >>>>> TP_STRUCT__entry(
> >>>>> __string(hostname, hostname)
> >>>>> __field(__u64, conn_id)
> >>>>> __field(__u16, port)
> >>>>> __field(const void *, ipaddr)
> >>>>> ),
> >>>>> TP_fast_assign(
> >>>>> __entry->port =3D port;
> >>>>> __entry->conn_id =3D conn_id;
> >>>>> __entry->ipaddr =3D ipaddr;
> >>>>> __assign_str(hostname, hostname);
> >>>>> ),
> >>>>> TP_printk("conn_id=3D0x%llx server=3D%s addr=3D%pI4:%d",
> >>>>> __entry->conn_id,
> >>>>> __get_str(hostname),
> >>>>> __entry->ipaddr,
> >>>>> __entry->port)
> >>>>> )
> >>>>>
> >>>>> #define DEFINE_SMB3_CONNECT_EVENT(name)        \
> >>>>> DEFINE_EVENT(smb3_connect_class, smb3_##name,  \
> >>>>> TP_PROTO(char *hostname, \
> >>>>> __u64 conn_id, \
> >>>>> __u16 port, \
> >>>>> struct in_addr *ipaddr), \
> >>>>> TP_ARGS(hostname, conn_id, port, ipaddr))
> >>>>>
> >>>>> DEFINE_SMB3_CONNECT_EVENT(ipv4_connect);
> >>>>>
> >>>>> Any ideas how to pass in the ipv4 address - or is it better to conv=
ert
> >>>>> it to a string before we call the trace point (which seems wasteful=
 to
> >>>>> me but there must be examples of how to pass in structs to printks =
in
> >>>>> trace in Linux)
> >>>>>
> >>>>
> >>>
> >>>
> >>> --
> >>> Thanks,
> >>>
> >>> Steve
> >>
> >>
> >>
> >
> >
>
>


--=20
Thanks,

Steve

--00000000000085907905cffce2a2
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-dynamic-trace-points-for-socket-connection.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-dynamic-trace-points-for-socket-connection.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kvlftsqo0>
X-Attachment-Id: f_kvlftsqo0

RnJvbSA5NWZjMDk1ZTFmNDdhZWU0NjU1MGQyNjIzMWJiMmQ3OWMyNmY0NDcwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgNCBOb3YgMjAyMSAxNTo1NjozNyAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGFkZCBkeW5hbWljIHRyYWNlIHBvaW50cyBmb3Igc29ja2V0IGNvbm5lY3Rpb24KCkluIGRl
YnVnZ2luZyB1c2VyIHByb2JsZW1zIHdpdGggaXAgYWRkcmVzcy9ETlMgaXNzdWVzIHdpdGgKc21i
MyBtb3VudHMsIHdlIHNvbWV0aW1lcyBuZWVkZWQgYWRkaXRpb25hbCBpbmZvIG9uIHRoZSBob3N0
bmFtZQphbmQgaXAgYWRkcmVzcy4KCkFkZCB0d28gdHJhY2Vwb2ludHMsIG9uZSB0byBzaG93IHNv
Y2tldCBjb25uZWN0aW9uIHN1Y2Nlc3MKYW5kIG9uZSBmb3IgZmFpbHVyZXMgdG8gY29ubmVjdCB0
byB0aGUgc29ja2V0LgoKU2FtcGxlIG91dHB1dDoKICAgICAgbW91bnQuY2lmcy0xNDU1MSAgIFsw
MDVdIC4uLi4uICA3NjM2LjU0NzkwNjogc21iM19jb25uZWN0X2RvbmU6IGNvbm5faWQ9MHgxIHNl
cnZlcj1sb2NhbGhvc3QgYWRkcj0xMjcuMC4wLjE6NDQ1CiAgICAgIG1vdW50LmNpZnMtMTQ1NTgg
ICBbMDA0XSAuLi4uLiAgNzY0Mi40MDU0MTM6IHNtYjNfY29ubmVjdF9kb25lOiBjb25uX2lkPTB4
MiBzZXJ2ZXI9c21mcmVuY2guZmlsZS5jb3JlLndpbmRvd3MubmV0IGFkZHI9NTIuMjM5LjE1OC4y
MzI6NDQ1CiAgICAgIG1vdW50LmNpZnMtMTQ3NDEgICBbMDA1XSAuLi4uLiAgNzgxOC40OTA3MTY6
IHNtYjNfY29ubmVjdF9kb25lOiBjb25uX2lkPTB4MyBzZXJ2ZXI9OjoxIGFkZHI9Wzo6MV06NDQ1
LzAlMAogICAgICBtb3VudC5jaWZzLTE0ODEwICAgWzAwMF0gLi4uLi4gIDc5NjYuMzgwMzM3OiBz
bWIzX2Nvbm5lY3RfZXJyOiByYz0tMTAxIGNvbm5faWQ9MHg0IHNlcnZlcj06OjIgYWRkcj1bOjoy
XTo0NDUvMCUwCiAgICAgIG1vdW50LmNpZnMtMTQ4MTAgICBbMDAwXSAuLi4uLiAgNzk2Ni4zODAz
NTY6IHNtYjNfY29ubmVjdF9lcnI6IHJjPS0xMDEgY29ubl9pZD0weDQgc2VydmVyPTo6MiBhZGRy
PVs6OjJdOjEzOS8wJTAKICAgICAgbW91bnQuY2lmcy0xNDgxOCAgIFswMDNdIC4uLi4uICA3OTg2
Ljc3MTk5Mjogc21iM19jb25uZWN0X2RvbmU6IGNvbm5faWQ9MHg1IHNlcnZlcj0xMjcuMC4wLjkg
YWRkcj0xMjcuMC4wLjk6NDQ1CiAgICAgIG1vdW50LmNpZnMtMTQ4MjUgICBbMDA4XSAuLi4uLiAg
ODAwOC4xNzgxMDk6IHNtYjNfY29ubmVjdF9lcnI6IHJjPS0xMTUgY29ubl9pZD0weDYgc2VydmVy
PTEyNC4yMy4wLjkgYWRkcj0xMjQuMjMuMC45OjQ0NQogICAgICBtb3VudC5jaWZzLTE0ODI1ICAg
WzAwOF0gLi4uLi4gIDgwMTMuMjk4MDg1OiBzbWIzX2Nvbm5lY3RfZXJyOiByYz0tMTE1IGNvbm5f
aWQ9MHg2IHNlcnZlcj0xMjQuMjMuMC45IGFkZHI9MTI0LjIzLjAuOToxMzkKICAgICAgICAgICBj
aWZzZC0xNDU1MyAgIFswMDZdIC4uLi4uICA4MDM2LjczNTYxNTogc21iM19yZWNvbm5lY3Q6IGNv
bm5faWQ9MHgxIHNlcnZlcj1sb2NhbGhvc3QgY3VycmVudF9taWQ9MzIKICAgICAgICAgICBjaWZz
ZC0xNDc0MyAgIFswMTBdIC4uLi4uICA4MDM2LjczNTY0NDogc21iM19yZWNvbm5lY3Q6IGNvbm5f
aWQ9MHgzIHNlcnZlcj06OjEgY3VycmVudF9taWQ9MjkKICAgICAgICAgICBjaWZzZC0xNDc0MyAg
IFswMTBdIC4uLi4uICA4MDM5LjkyMTc0MDogc21iM19jb25uZWN0X2VycjogcmM9LTExMSBjb25u
X2lkPTB4MyBzZXJ2ZXI9OjoxIGFkZHI9Wzo6MV06NDQ1LzAlMAogICAgICAgICAgIGNpZnNkLTE0
NTUzICAgWzAwOF0gLi4uLi4gIDgwNDIuOTkzODk0OiBzbWIzX2Nvbm5lY3RfZXJyOiByYz0tMTEx
IGNvbm5faWQ9MHgxIHNlcnZlcj1sb2NhbGhvc3QgYWRkcj0xMjcuMC4wLjE6NDQ1CiAgICAgICAg
ICAgY2lmc2QtMTQ3NDMgICBbMDEwXSAuLi4uLiAgODA0Mi45OTM4OTQ6IHNtYjNfY29ubmVjdF9l
cnI6IHJjPS0xMTEgY29ubl9pZD0weDMgc2VydmVyPTo6MSBhZGRyPVs6OjFdOjQ0NS8wJTAKICAg
ICAgICAgICBjaWZzZC0xNDU1MyAgIFswMDhdIC4uLi4uICA4MDQ2LjA2NTgyNDogc21iM19jb25u
ZWN0X2VycjogcmM9LTExMSBjb25uX2lkPTB4MSBzZXJ2ZXI9bG9jYWxob3N0IGFkZHI9MTI3LjAu
MC4xOjQ0NQogICAgICAgICAgIGNpZnNkLTE0NzQzICAgWzAxMF0gLi4uLi4gIDgwNDYuMDY1ODI0
OiBzbWIzX2Nvbm5lY3RfZXJyOiByYz0tMTExIGNvbm5faWQ9MHgzIHNlcnZlcj06OjEgYWRkcj1b
OjoxXTo0NDUvMCUwCiAgICAgICAgICAgY2lmc2QtMTQ1NTMgICBbMDA4XSAuLi4uLiAgODA0OS4x
Mzc3OTY6IHNtYjNfY29ubmVjdF9kb25lOiBjb25uX2lkPTB4MSBzZXJ2ZXI9bG9jYWxob3N0IGFk
ZHI9MTI3LjAuMC4xOjQ0NQogICAgICAgICAgIGNpZnNkLTE0NzQzICAgWzAxMF0gLi4uLi4gIDgw
NDkuMTM3Nzk2OiBzbWIzX2Nvbm5lY3RfZG9uZTogY29ubl9pZD0weDMgc2VydmVyPTo6MSBhZGRy
PVs6OjFdOjQ0NS8wJTAKClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWlj
cm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2Nvbm5lY3QuYyB8ICAzICstCiBmcy9jaWZzL3RyYWNl
LmggICB8IDcxICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
CiAyIGZpbGVzIGNoYW5nZWQsIDczIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYg
LS1naXQgYS9mcy9jaWZzL2Nvbm5lY3QuYyBiL2ZzL2NpZnMvY29ubmVjdC5jCmluZGV4IGU2ZTI2
MWRmZDEwNy4uMTQ0ZjBiYjUwOThmIDEwMDY0NAotLS0gYS9mcy9jaWZzL2Nvbm5lY3QuYworKysg
Yi9mcy9jaWZzL2Nvbm5lY3QuYwpAQCAtMjY0OSwxMSArMjY0OSwxMiBAQCBnZW5lcmljX2lwX2Nv
bm5lY3Qoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKQogCQlyYyA9IDA7CiAJaWYgKHJj
IDwgMCkgewogCQljaWZzX2RiZyhGWUksICJFcnJvciAlZCBjb25uZWN0aW5nIHRvIHNlcnZlclxu
IiwgcmMpOworCQl0cmFjZV9zbWIzX2Nvbm5lY3RfZXJyKHNlcnZlci0+aG9zdG5hbWUsIHNlcnZl
ci0+Y29ubl9pZCwgJnNlcnZlci0+ZHN0YWRkciwgcmMpOwogCQlzb2NrX3JlbGVhc2Uoc29ja2V0
KTsKIAkJc2VydmVyLT5zc29ja2V0ID0gTlVMTDsKIAkJcmV0dXJuIHJjOwogCX0KLQorCXRyYWNl
X3NtYjNfY29ubmVjdF9kb25lKHNlcnZlci0+aG9zdG5hbWUsIHNlcnZlci0+Y29ubl9pZCwgJnNl
cnZlci0+ZHN0YWRkcik7CiAJaWYgKHNwb3J0ID09IGh0b25zKFJGQzEwMDFfUE9SVCkpCiAJCXJj
ID0gaXBfcmZjMTAwMV9jb25uZWN0KHNlcnZlcik7CiAKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvdHJh
Y2UuaCBiL2ZzL2NpZnMvdHJhY2UuaAppbmRleCBkYWZjYjZhYjA1MGQuLjZjZWNmMzAyZGNmZCAx
MDA2NDQKLS0tIGEvZnMvY2lmcy90cmFjZS5oCisrKyBiL2ZzL2NpZnMvdHJhY2UuaApAQCAtMTEs
NiArMTEsOCBAQAogI2RlZmluZSBfQ0lGU19UUkFDRV9ICiAKICNpbmNsdWRlIDxsaW51eC90cmFj
ZXBvaW50Lmg+CisjaW5jbHVkZSA8bGludXgvbmV0Lmg+CisjaW5jbHVkZSA8bGludXgvaW5ldC5o
PgogCiAvKgogICogUGxlYXNlIHVzZSB0aGlzIDMtcGFydCBhcnRpY2xlIGFzIGEgcmVmZXJlbmNl
IGZvciB3cml0aW5nIG5ldyB0cmFjZXBvaW50czoKQEAgLTg1NCw2ICs4NTYsNzUgQEAgREVGSU5F
X0VWRU5UKHNtYjNfbGVhc2VfZXJyX2NsYXNzLCBzbWIzXyMjbmFtZSwgIFwKIAogREVGSU5FX1NN
QjNfTEVBU0VfRVJSX0VWRU5UKGxlYXNlX2Vycik7CiAKK0RFQ0xBUkVfRVZFTlRfQ0xBU1Moc21i
M19jb25uZWN0X2NsYXNzLAorCVRQX1BST1RPKGNoYXIgKmhvc3RuYW1lLAorCQlfX3U2NCBjb25u
X2lkLAorCQljb25zdCBzdHJ1Y3QgX19rZXJuZWxfc29ja2FkZHJfc3RvcmFnZSAqZHN0X2FkZHIp
LAorCVRQX0FSR1MoaG9zdG5hbWUsIGNvbm5faWQsIGRzdF9hZGRyKSwKKwlUUF9TVFJVQ1RfX2Vu
dHJ5KAorCQlfX3N0cmluZyhob3N0bmFtZSwgaG9zdG5hbWUpCisJCV9fZmllbGQoX191NjQsIGNv
bm5faWQpCisJCV9fYXJyYXkoX191OCwgZHN0X2FkZHIsIHNpemVvZihzdHJ1Y3Qgc29ja2FkZHJf
c3RvcmFnZSkpCisJKSwKKwlUUF9mYXN0X2Fzc2lnbigKKwkJc3RydWN0IHNvY2thZGRyX3N0b3Jh
Z2UgKnBzcyA9IE5VTEw7CisKKwkJX19lbnRyeS0+Y29ubl9pZCA9IGNvbm5faWQ7CisJCXBzcyA9
IChzdHJ1Y3Qgc29ja2FkZHJfc3RvcmFnZSAqKV9fZW50cnktPmRzdF9hZGRyOworCQkqcHNzID0g
KmRzdF9hZGRyOworCQlfX2Fzc2lnbl9zdHIoaG9zdG5hbWUsIGhvc3RuYW1lKTsKKwkpLAorCVRQ
X3ByaW50aygiY29ubl9pZD0weCVsbHggc2VydmVyPSVzIGFkZHI9JXBJU3BzZmMiLAorCQlfX2Vu
dHJ5LT5jb25uX2lkLAorCQlfX2dldF9zdHIoaG9zdG5hbWUpLAorCQlfX2VudHJ5LT5kc3RfYWRk
cikKKykKKworI2RlZmluZSBERUZJTkVfU01CM19DT05ORUNUX0VWRU5UKG5hbWUpICAgICAgICBc
CitERUZJTkVfRVZFTlQoc21iM19jb25uZWN0X2NsYXNzLCBzbWIzXyMjbmFtZSwgIFwKKwlUUF9Q
Uk9UTyhjaGFyICpob3N0bmFtZSwJCVwKKwkJX191NjQgY29ubl9pZCwJCQlcCisJCWNvbnN0IHN0
cnVjdCBfX2tlcm5lbF9zb2NrYWRkcl9zdG9yYWdlICphZGRyKSwJXAorCVRQX0FSR1MoaG9zdG5h
bWUsIGNvbm5faWQsIGFkZHIpKQorCitERUZJTkVfU01CM19DT05ORUNUX0VWRU5UKGNvbm5lY3Rf
ZG9uZSk7CisKK0RFQ0xBUkVfRVZFTlRfQ0xBU1Moc21iM19jb25uZWN0X2Vycl9jbGFzcywKKwlU
UF9QUk9UTyhjaGFyICpob3N0bmFtZSwgX191NjQgY29ubl9pZCwKKwkJY29uc3Qgc3RydWN0IF9f
a2VybmVsX3NvY2thZGRyX3N0b3JhZ2UgKmRzdF9hZGRyLCBpbnQgcmMpLAorCVRQX0FSR1MoaG9z
dG5hbWUsIGNvbm5faWQsIGRzdF9hZGRyLCByYyksCisJVFBfU1RSVUNUX19lbnRyeSgKKwkJX19z
dHJpbmcoaG9zdG5hbWUsIGhvc3RuYW1lKQorCQlfX2ZpZWxkKF9fdTY0LCBjb25uX2lkKQorCQlf
X2FycmF5KF9fdTgsIGRzdF9hZGRyLCBzaXplb2Yoc3RydWN0IHNvY2thZGRyX3N0b3JhZ2UpKQor
CQlfX2ZpZWxkKGludCwgcmMpCisJKSwKKwlUUF9mYXN0X2Fzc2lnbigKKwkJc3RydWN0IHNvY2th
ZGRyX3N0b3JhZ2UgKnBzcyA9IE5VTEw7CisKKwkJX19lbnRyeS0+Y29ubl9pZCA9IGNvbm5faWQ7
CisJCV9fZW50cnktPnJjID0gcmM7CisJCXBzcyA9IChzdHJ1Y3Qgc29ja2FkZHJfc3RvcmFnZSAq
KV9fZW50cnktPmRzdF9hZGRyOworCQkqcHNzID0gKmRzdF9hZGRyOworCQlfX2Fzc2lnbl9zdHIo
aG9zdG5hbWUsIGhvc3RuYW1lKTsKKwkpLAorCVRQX3ByaW50aygicmM9JWQgY29ubl9pZD0weCVs
bHggc2VydmVyPSVzIGFkZHI9JXBJU3BzZmMiLAorCQlfX2VudHJ5LT5yYywKKwkJX19lbnRyeS0+
Y29ubl9pZCwKKwkJX19nZXRfc3RyKGhvc3RuYW1lKSwKKwkJX19lbnRyeS0+ZHN0X2FkZHIpCisp
CisKKyNkZWZpbmUgREVGSU5FX1NNQjNfQ09OTkVDVF9FUlJfRVZFTlQobmFtZSkgICAgICAgIFwK
K0RFRklORV9FVkVOVChzbWIzX2Nvbm5lY3RfZXJyX2NsYXNzLCBzbWIzXyMjbmFtZSwgIFwKKwlU
UF9QUk9UTyhjaGFyICpob3N0bmFtZSwJCVwKKwkJX191NjQgY29ubl9pZCwJCQlcCisJCWNvbnN0
IHN0cnVjdCBfX2tlcm5lbF9zb2NrYWRkcl9zdG9yYWdlICphZGRyLAlcCisJCWludCByYyksCQkJ
XAorCVRQX0FSR1MoaG9zdG5hbWUsIGNvbm5faWQsIGFkZHIsIHJjKSkKKworREVGSU5FX1NNQjNf
Q09OTkVDVF9FUlJfRVZFTlQoY29ubmVjdF9lcnIpOworCiBERUNMQVJFX0VWRU5UX0NMQVNTKHNt
YjNfcmVjb25uZWN0X2NsYXNzLAogCVRQX1BST1RPKF9fdTY0CWN1cnJtaWQsCiAJCV9fdTY0IGNv
bm5faWQsCi0tIAoyLjMyLjAKCg==
--00000000000085907905cffce2a2--
