Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC9A5C433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Nov 2021 17:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D44646103B
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Nov 2021 17:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbhKDRJx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Nov 2021 13:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbhKDRJx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Nov 2021 13:09:53 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA69CC061714
        for <linux-cifs@vger.kernel.org>; Thu,  4 Nov 2021 10:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:Cc:To:From;
        bh=Oj5WQoU9fNZ8QM15wN115G0+poDs8HiaSputILkXYsE=; b=u0g7lcFPzTo97LEE+yLeN9nMd1
        VEZyXQP+3K9eacbigPInHa7mEiXtwjLsCt2/G948lHT75EY9lqseF1oEoq4zg8Pwmsxf+jAJ3dVwc
        Imjbav26sF4ewHadd81XjV+xgYgRNxvDLHg1hs8AgbH97oAk16vVrX50b3gIroe8J/EM8uU/didNA
        GJP8r7LqgLknLLK6jBNaxjAW+y4W8UhymqsMgiqVcx9YRATVUiARk35PYLpucADoJOAmihmKJPUAA
        4fKH+Pv9hioLl613csEI2wHF+bGvl/RMJJ7ZUIBbL2UpMzwmQpGjqKHHf15fCSOePVzQydUM++u7n
        TycwunanNAc800eaxDfszBQ+dJOI62bK71J/HvjlN1yd7XfzTaW9/dB2CLL6kMo7a4MN031Pri5fw
        X2tqamxspJq2sgxHPMAIyq4BfuEy8BwT+kIyDqCCqHwyZPtFuuTw7fulV7OpdCrCxkAgntFwxN3WF
        /nWhWzb1+0RO/ckKr/7sJlbf;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1migCn-005C2c-2u; Thu, 04 Nov 2021 17:07:13 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>
References: <CAH2r5mtoz_droUOS-Uats_WL6MwFY5-pkHRVZo0nUwLdRjOvcA@mail.gmail.com>
 <9030fdb1-5555-1adf-7140-64eb1f0f23b7@samba.org>
 <CAH2r5mu2f2=rRn_wH=yh5q=rY=KhE8709fpC=j71_rogDaZySQ@mail.gmail.com>
 <CAH2r5muCJJhK+fRCUEc7hgTne4PEW5UgjRDY8iWFv-d-UGEQTw@mail.gmail.com>
 <b9ce06c6-22c1-a4fa-006f-2747d8a5f38b@samba.org>
Subject: Re: trace point to print ip address we are trying to connect to
Message-ID: <4cc497e1-8eaf-fd01-276c-95bec6adcef6@samba.org>
Date:   Thu, 4 Nov 2021 18:07:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <b9ce06c6-22c1-a4fa-006f-2747d8a5f38b@samba.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2D1D9wkbG9k3qpNyByzdgfDlDtTlDHNo8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2D1D9wkbG9k3qpNyByzdgfDlDtTlDHNo8
Content-Type: multipart/mixed; boundary="CmrgbnfUoMuoygkFbm3dJXqylnZsL9Ug7";
 protected-headers="v1"
From: Stefan Metzmacher <metze@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, Shyam Prasad N
 <nspmangalore@gmail.com>, Paulo Alcantara <pc@cjr.nz>
Message-ID: <4cc497e1-8eaf-fd01-276c-95bec6adcef6@samba.org>
Subject: Re: trace point to print ip address we are trying to connect to
References: <CAH2r5mtoz_droUOS-Uats_WL6MwFY5-pkHRVZo0nUwLdRjOvcA@mail.gmail.com>
 <9030fdb1-5555-1adf-7140-64eb1f0f23b7@samba.org>
 <CAH2r5mu2f2=rRn_wH=yh5q=rY=KhE8709fpC=j71_rogDaZySQ@mail.gmail.com>
 <CAH2r5muCJJhK+fRCUEc7hgTne4PEW5UgjRDY8iWFv-d-UGEQTw@mail.gmail.com>
 <b9ce06c6-22c1-a4fa-006f-2747d8a5f38b@samba.org>
In-Reply-To: <b9ce06c6-22c1-a4fa-006f-2747d8a5f38b@samba.org>

--CmrgbnfUoMuoygkFbm3dJXqylnZsL9Ug7
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 04.11.21 um 18:02 schrieb Stefan Metzmacher:
> I looked at my smbdirect dirver code and there I use:
>=20
>         TP_STRUCT__entry(
>                 ...
>                 __array(__u8, addr, sizeof(struct sockaddr_storage))
>         ),
>         TP_fast_assign(

Here I missed the 'struct sockaddr_storage *pss =3D NULL;' helper variabl=
e...
>                 pss =3D (struct sockaddr_storage *)__entry->addr;
>                 *pss =3D *addr;
>         ),
>         TP_printk("... %pISp",
>                   __entry->addr)

My full example is here:

https://git.samba.org/?p=3Dmetze/linux/smbdirect.git;a=3Dblob;f=3Dsmbdire=
ct_trace.h;hb=3Drefs/heads/smbdirect-work-in-progress#l100

metze

> Am 04.11.21 um 16:26 schrieb Steve French:
>> changing it to __kernel_sockaddr_storage the build error is:
>>
>>                  from /home/smfrench/cifs-2.6/fs/cifs/trace.c:8:
>> /home/smfrench/cifs-2.6/fs/cifs/./trace.h:867:32: error: conversion to=

>> non-scalar type requested
>>   867 |                 __field(struct __kernel_sockaddr_storage, dst_=
addr)
>>       |                                ^~~~~~~~~~~~~~~~~~~~~~~~~
>> ./include/trace/trace_events.h:477:9: note: in definition of macro
>> =E2=80=98DECLARE_EVENT_CLASS=E2=80=99
>>   477 |         tstruct
>>          \
>>       |         ^~~~~~~
>> /home/smfrench/cifs-2.6/fs/cifs/./trace.h:864:9: note: in expansion of=

>> macro =E2=80=98TP_STRUCT__entry=E2=80=99
>>   864 |         TP_STRUCT__entry(
>>
>> On Thu, Nov 4, 2021 at 10:09 AM Steve French <smfrench@gmail.com> wrot=
e:
>>>
>>> That looked like a good suggestion and will make the code cleaner but=

>>> with that change ran into this unexpected build error.   Ideas?
>>>
>>>   CC [M]  /home/smfrench/cifs-2.6/fs/cifs/file.o
>>> In file included from ./include/trace/define_trace.h:102,
>>>                  from /home/smfrench/cifs-2.6/fs/cifs/trace.h:977,
>>>                  from /home/smfrench/cifs-2.6/fs/cifs/trace.c:8:
>>> ./include/linux/socket.h:42:26: error: conversion to non-scalar type =
requested
>>>    42 | #define sockaddr_storage __kernel_sockaddr_storage
>>>       |                          ^~~~~~~~~~~~~~~~~~~~~~~~~
>>> ./include/trace/trace_events.h:477:9: note: in definition of macro
>>> =E2=80=98DECLARE_EVENT_CLASS=E2=80=99
>>>   477 |         tstruct
>>>          \
>>>       |         ^~~~~~~
>>> /home/smfrench/cifs-2.6/fs/cifs/./trace.h:864:9: note: in expansion o=
f
>>> macro =E2=80=98TP_STRUCT__entry=E2=80=99
>>>   864 |         TP_STRUCT__entry(
>>>       |         ^~~~~~~~~~~~~~~~
>>> ./include/trace/trace_events.h:439:22: note: in expansion of macro
>>> =E2=80=98is_signed_type=E2=80=99
>>>   439 |         .is_signed =3D is_signed_type(_type), .filter_type =3D=

>>> _filter_type },
>>>       |                      ^~~~~~~~~~~~~~
>>> ./include/trace/trace_events.h:448:33: note: in expansion of macro =E2=
=80=98__field_ext=E2=80=99
>>>   448 | #define __field(type, item)     __field_ext(type, item, FILTE=
R_OTHER)
>>>       |                                 ^~~~~~~~~~~
>>> /home/smfrench/cifs-2.6/fs/cifs/./trace.h:867:17: note: in expansion
>>> of macro =E2=80=98__field=E2=80=99
>>>   867 |                 __field(struct sockaddr_storage, dst_addr)
>>>       |                 ^~~~~~~
>>> /home/smfrench/cifs-2.6/fs/cifs/./trace.h:867:32: note: in expansion
>>> of macro =E2=80=98sockaddr_storage=E2=80=99
>>>   867 |                 __field(struct sockaddr_storage, dst_addr)
>>>
>>> On Thu, Nov 4, 2021 at 2:14 AM Stefan Metzmacher <metze@samba.org> wr=
ote:
>>>>
>>>> Hi Steve,
>>>>
>>>> you should made this generic (not ipv4/ipv6 specific) and use someth=
ing like this:
>>>>
>>>> TP_PROTO(const char *hostname, __u64 conn_id, const struct sockaddr_=
storage *dst_addr)
>>>>
>>>> TP_STRUCT__entry(
>>>> __string(hostname, hostname)
>>>> __field(__u64, conn_id)
>>>> __field(struct sockaddr_storage, dst_addr)
>>>>
>>>> TP_fast_assign(
>>>> __entry->conn_id =3D conn_id;
>>>> __entry->dst_addr =3D *dst_addr;
>>>> __assign_str(hostname, hostname);
>>>> ),
>>>>
>>>> With that you should be able to use this:
>>>>
>>>> TP_printk("conn_id=3D0x%llx server=3D%s addr=3D%pISpsfc",
>>>> __entry->conn_id,
>>>> __get_str(hostname),
>>>> &__entry->dst_addr)
>>>>
>>>> I hope that helps.
>>>>
>>>> metze
>>>>
>>>> Am 04.11.21 um 07:09 schrieb Steve French:
>>>>> It wasn't obvious to me the best way to pass in a pointer to the ip=
v4
>>>>> (and ipv6 address) to a dynamic trace point (unless I create a temp=

>>>>> string first in generic_ip_connect and do the conversion (via "%pI4=
"
>>>>> and "%pI6" with sprintf) e.g.
>>>>>
>>>>>         sprintf(ses->ip_addr, "%pI4", &addr->sin_addr);
>>>>>
>>>>> The approach I tried passing in the pointer to sin_addr (the
>>>>> ipv4_address) caused an oops on loading it the first time and the
>>>>> warning:
>>>>>
>>>>> [14928.818532] event smb3_ipv4_connect has unsafe dereference of ar=
gument 3
>>>>> [14928.818534] print_fmt: "conn_id=3D0x%llx server=3D%s addr=3D%pI4=
:%d",
>>>>> REC->conn_id, __get_str(hostname), REC->ipaddr, REC->port
>>>>>
>>>>>
>>>>> What I tried was the following (also see attached diff) to print th=
e
>>>>> ipv4 address that we were trying to connect to
>>>>>
>>>>> DECLARE_EVENT_CLASS(smb3_connect_class,
>>>>> TP_PROTO(char *hostname,
>>>>> __u64 conn_id,
>>>>> __u16 port,
>>>>> struct in_addr *ipaddr),
>>>>> TP_ARGS(hostname, conn_id, port, ipaddr),
>>>>> TP_STRUCT__entry(
>>>>> __string(hostname, hostname)
>>>>> __field(__u64, conn_id)
>>>>> __field(__u16, port)
>>>>> __field(const void *, ipaddr)
>>>>> ),
>>>>> TP_fast_assign(
>>>>> __entry->port =3D port;
>>>>> __entry->conn_id =3D conn_id;
>>>>> __entry->ipaddr =3D ipaddr;
>>>>> __assign_str(hostname, hostname);
>>>>> ),
>>>>> TP_printk("conn_id=3D0x%llx server=3D%s addr=3D%pI4:%d",
>>>>> __entry->conn_id,
>>>>> __get_str(hostname),
>>>>> __entry->ipaddr,
>>>>> __entry->port)
>>>>> )
>>>>>
>>>>> #define DEFINE_SMB3_CONNECT_EVENT(name)        \
>>>>> DEFINE_EVENT(smb3_connect_class, smb3_##name,  \
>>>>> TP_PROTO(char *hostname, \
>>>>> __u64 conn_id, \
>>>>> __u16 port, \
>>>>> struct in_addr *ipaddr), \
>>>>> TP_ARGS(hostname, conn_id, port, ipaddr))
>>>>>
>>>>> DEFINE_SMB3_CONNECT_EVENT(ipv4_connect);
>>>>>
>>>>> Any ideas how to pass in the ipv4 address - or is it better to conv=
ert
>>>>> it to a string before we call the trace point (which seems wasteful=
 to
>>>>> me but there must be examples of how to pass in structs to printks =
in
>>>>> trace in Linux)
>>>>>
>>>>
>>>
>>>
>>> --
>>> Thanks,
>>>
>>> Steve
>>
>>
>>
>=20
>=20



--CmrgbnfUoMuoygkFbm3dJXqylnZsL9Ug7--

--2D1D9wkbG9k3qpNyByzdgfDlDtTlDHNo8
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQT7piwqO01BwrlU3LLHuFQ7rrL7egUCYYQTOgAKCRDHuFQ7rrL7
emnjAQDZsnjfu3boLLWj7WWgvMBncaftL9IvW3UWD3CSEEybKgD/XqoDRXHJc87P
HCSTJKFfqE5/gzj1Of0vL0B6PgJZbws=
=h3+d
-----END PGP SIGNATURE-----

--2D1D9wkbG9k3qpNyByzdgfDlDtTlDHNo8--
