Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54DF8C433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Nov 2021 17:02:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31C6160FD7
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Nov 2021 17:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbhKDRFb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Nov 2021 13:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbhKDRFa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Nov 2021 13:05:30 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F7FC061714
        for <linux-cifs@vger.kernel.org>; Thu,  4 Nov 2021 10:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=V26AOMwbA/0JRbxmrJu1geAIfTx3v/s3ojVV8s3+FJo=; b=fXzk9TEcM3C+ecNqxbdW8p/YPH
        POGhff7FQitWkDNf+pC+5emO0S3MMGmY3DOVmbBj3T6BCsd84+7ZK7F4BJa0ROO1MvTeIQjPnLMgt
        oCdRPx57QQrG/iSzCU0yfFIC8Ao9QkmhVfo1x+SwKLSCvw69E8PkQOjD52oH9KzHQ4OoBwhPelEL+
        DMg025CHOXXBRWV+5fNzkBpmNtvFnwRIPwjGil/USf4YCIAYA8tO2tKbnrmmSGYT4msB9CstxLpPk
        kUQaq1OZOoKjWGrBHr9dF1eZ6yxxc8MlPfxvc9zimP7Ii5TP+onkstqWP9+7sIe8G6vbR9AxIGsr2
        T9HgajuTGihOExJFo9QmKkS/oGtnmteGqkQAstrWtJbuklFxK7EGp16jRJKyVetF1EiCeD9c2+oL0
        jlFIUNlfLtGbrl0y2r1O6cqxhNDs9QNdVonyowU7bJZNwShvTfuvZch8kOnFS1GVxQio/yG3F5D7v
        wgkexkrPLycNZ4K91zaO5Esy;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mig8Y-005BvY-DS; Thu, 04 Nov 2021 17:02:50 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>
References: <CAH2r5mtoz_droUOS-Uats_WL6MwFY5-pkHRVZo0nUwLdRjOvcA@mail.gmail.com>
 <9030fdb1-5555-1adf-7140-64eb1f0f23b7@samba.org>
 <CAH2r5mu2f2=rRn_wH=yh5q=rY=KhE8709fpC=j71_rogDaZySQ@mail.gmail.com>
 <CAH2r5muCJJhK+fRCUEc7hgTne4PEW5UgjRDY8iWFv-d-UGEQTw@mail.gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: trace point to print ip address we are trying to connect to
Message-ID: <b9ce06c6-22c1-a4fa-006f-2747d8a5f38b@samba.org>
Date:   Thu, 4 Nov 2021 18:02:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAH2r5muCJJhK+fRCUEc7hgTne4PEW5UgjRDY8iWFv-d-UGEQTw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UC3sj7l5U49DsqCbf4wwTCOeR7mqZjRIk"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UC3sj7l5U49DsqCbf4wwTCOeR7mqZjRIk
Content-Type: multipart/mixed; boundary="OaC2hyhhcvKKLvpjSppdVlCKsJBV5ay2z";
 protected-headers="v1"
From: Stefan Metzmacher <metze@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, Shyam Prasad N
 <nspmangalore@gmail.com>, Paulo Alcantara <pc@cjr.nz>
Message-ID: <b9ce06c6-22c1-a4fa-006f-2747d8a5f38b@samba.org>
Subject: Re: trace point to print ip address we are trying to connect to
References: <CAH2r5mtoz_droUOS-Uats_WL6MwFY5-pkHRVZo0nUwLdRjOvcA@mail.gmail.com>
 <9030fdb1-5555-1adf-7140-64eb1f0f23b7@samba.org>
 <CAH2r5mu2f2=rRn_wH=yh5q=rY=KhE8709fpC=j71_rogDaZySQ@mail.gmail.com>
 <CAH2r5muCJJhK+fRCUEc7hgTne4PEW5UgjRDY8iWFv-d-UGEQTw@mail.gmail.com>
In-Reply-To: <CAH2r5muCJJhK+fRCUEc7hgTne4PEW5UgjRDY8iWFv-d-UGEQTw@mail.gmail.com>

--OaC2hyhhcvKKLvpjSppdVlCKsJBV5ay2z
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

I looked at my smbdirect dirver code and there I use:

        TP_STRUCT__entry(
                ...
                __array(__u8, addr, sizeof(struct sockaddr_storage))
        ),
        TP_fast_assign(
                pss =3D (struct sockaddr_storage *)__entry->addr;
                *pss =3D *addr;
        ),
        TP_printk("... %pISp",
                  __entry->addr)

metze

Am 04.11.21 um 16:26 schrieb Steve French:
> changing it to __kernel_sockaddr_storage the build error is:
>=20
>                  from /home/smfrench/cifs-2.6/fs/cifs/trace.c:8:
> /home/smfrench/cifs-2.6/fs/cifs/./trace.h:867:32: error: conversion to
> non-scalar type requested
>   867 |                 __field(struct __kernel_sockaddr_storage, dst_a=
ddr)
>       |                                ^~~~~~~~~~~~~~~~~~~~~~~~~
> ./include/trace/trace_events.h:477:9: note: in definition of macro
> =E2=80=98DECLARE_EVENT_CLASS=E2=80=99
>   477 |         tstruct
>          \
>       |         ^~~~~~~
> /home/smfrench/cifs-2.6/fs/cifs/./trace.h:864:9: note: in expansion of
> macro =E2=80=98TP_STRUCT__entry=E2=80=99
>   864 |         TP_STRUCT__entry(
>=20
> On Thu, Nov 4, 2021 at 10:09 AM Steve French <smfrench@gmail.com> wrote=
:
>>
>> That looked like a good suggestion and will make the code cleaner but
>> with that change ran into this unexpected build error.   Ideas?
>>
>>   CC [M]  /home/smfrench/cifs-2.6/fs/cifs/file.o
>> In file included from ./include/trace/define_trace.h:102,
>>                  from /home/smfrench/cifs-2.6/fs/cifs/trace.h:977,
>>                  from /home/smfrench/cifs-2.6/fs/cifs/trace.c:8:
>> ./include/linux/socket.h:42:26: error: conversion to non-scalar type r=
equested
>>    42 | #define sockaddr_storage __kernel_sockaddr_storage
>>       |                          ^~~~~~~~~~~~~~~~~~~~~~~~~
>> ./include/trace/trace_events.h:477:9: note: in definition of macro
>> =E2=80=98DECLARE_EVENT_CLASS=E2=80=99
>>   477 |         tstruct
>>          \
>>       |         ^~~~~~~
>> /home/smfrench/cifs-2.6/fs/cifs/./trace.h:864:9: note: in expansion of=

>> macro =E2=80=98TP_STRUCT__entry=E2=80=99
>>   864 |         TP_STRUCT__entry(
>>       |         ^~~~~~~~~~~~~~~~
>> ./include/trace/trace_events.h:439:22: note: in expansion of macro
>> =E2=80=98is_signed_type=E2=80=99
>>   439 |         .is_signed =3D is_signed_type(_type), .filter_type =3D=

>> _filter_type },
>>       |                      ^~~~~~~~~~~~~~
>> ./include/trace/trace_events.h:448:33: note: in expansion of macro =E2=
=80=98__field_ext=E2=80=99
>>   448 | #define __field(type, item)     __field_ext(type, item, FILTER=
_OTHER)
>>       |                                 ^~~~~~~~~~~
>> /home/smfrench/cifs-2.6/fs/cifs/./trace.h:867:17: note: in expansion
>> of macro =E2=80=98__field=E2=80=99
>>   867 |                 __field(struct sockaddr_storage, dst_addr)
>>       |                 ^~~~~~~
>> /home/smfrench/cifs-2.6/fs/cifs/./trace.h:867:32: note: in expansion
>> of macro =E2=80=98sockaddr_storage=E2=80=99
>>   867 |                 __field(struct sockaddr_storage, dst_addr)
>>
>> On Thu, Nov 4, 2021 at 2:14 AM Stefan Metzmacher <metze@samba.org> wro=
te:
>>>
>>> Hi Steve,
>>>
>>> you should made this generic (not ipv4/ipv6 specific) and use somethi=
ng like this:
>>>
>>> TP_PROTO(const char *hostname, __u64 conn_id, const struct sockaddr_s=
torage *dst_addr)
>>>
>>> TP_STRUCT__entry(
>>> __string(hostname, hostname)
>>> __field(__u64, conn_id)
>>> __field(struct sockaddr_storage, dst_addr)
>>>
>>> TP_fast_assign(
>>> __entry->conn_id =3D conn_id;
>>> __entry->dst_addr =3D *dst_addr;
>>> __assign_str(hostname, hostname);
>>> ),
>>>
>>> With that you should be able to use this:
>>>
>>> TP_printk("conn_id=3D0x%llx server=3D%s addr=3D%pISpsfc",
>>> __entry->conn_id,
>>> __get_str(hostname),
>>> &__entry->dst_addr)
>>>
>>> I hope that helps.
>>>
>>> metze
>>>
>>> Am 04.11.21 um 07:09 schrieb Steve French:
>>>> It wasn't obvious to me the best way to pass in a pointer to the ipv=
4
>>>> (and ipv6 address) to a dynamic trace point (unless I create a temp
>>>> string first in generic_ip_connect and do the conversion (via "%pI4"=

>>>> and "%pI6" with sprintf) e.g.
>>>>
>>>>         sprintf(ses->ip_addr, "%pI4", &addr->sin_addr);
>>>>
>>>> The approach I tried passing in the pointer to sin_addr (the
>>>> ipv4_address) caused an oops on loading it the first time and the
>>>> warning:
>>>>
>>>> [14928.818532] event smb3_ipv4_connect has unsafe dereference of arg=
ument 3
>>>> [14928.818534] print_fmt: "conn_id=3D0x%llx server=3D%s addr=3D%pI4:=
%d",
>>>> REC->conn_id, __get_str(hostname), REC->ipaddr, REC->port
>>>>
>>>>
>>>> What I tried was the following (also see attached diff) to print the=

>>>> ipv4 address that we were trying to connect to
>>>>
>>>> DECLARE_EVENT_CLASS(smb3_connect_class,
>>>> TP_PROTO(char *hostname,
>>>> __u64 conn_id,
>>>> __u16 port,
>>>> struct in_addr *ipaddr),
>>>> TP_ARGS(hostname, conn_id, port, ipaddr),
>>>> TP_STRUCT__entry(
>>>> __string(hostname, hostname)
>>>> __field(__u64, conn_id)
>>>> __field(__u16, port)
>>>> __field(const void *, ipaddr)
>>>> ),
>>>> TP_fast_assign(
>>>> __entry->port =3D port;
>>>> __entry->conn_id =3D conn_id;
>>>> __entry->ipaddr =3D ipaddr;
>>>> __assign_str(hostname, hostname);
>>>> ),
>>>> TP_printk("conn_id=3D0x%llx server=3D%s addr=3D%pI4:%d",
>>>> __entry->conn_id,
>>>> __get_str(hostname),
>>>> __entry->ipaddr,
>>>> __entry->port)
>>>> )
>>>>
>>>> #define DEFINE_SMB3_CONNECT_EVENT(name)        \
>>>> DEFINE_EVENT(smb3_connect_class, smb3_##name,  \
>>>> TP_PROTO(char *hostname, \
>>>> __u64 conn_id, \
>>>> __u16 port, \
>>>> struct in_addr *ipaddr), \
>>>> TP_ARGS(hostname, conn_id, port, ipaddr))
>>>>
>>>> DEFINE_SMB3_CONNECT_EVENT(ipv4_connect);
>>>>
>>>> Any ideas how to pass in the ipv4 address - or is it better to conve=
rt
>>>> it to a string before we call the trace point (which seems wasteful =
to
>>>> me but there must be examples of how to pass in structs to printks i=
n
>>>> trace in Linux)
>>>>
>>>
>>
>>
>> --
>> Thanks,
>>
>> Steve
>=20
>=20
>=20



--OaC2hyhhcvKKLvpjSppdVlCKsJBV5ay2z--

--UC3sj7l5U49DsqCbf4wwTCOeR7mqZjRIk
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQT7piwqO01BwrlU3LLHuFQ7rrL7egUCYYQSMQAKCRDHuFQ7rrL7
elpnAQCQ8sk5Z+H/Pl/WXDakx9LpYsCPtbvOfCZcWCZxu1T2VAEAyrLGWtrYIy27
xFsG1ZPttp4WszstWvqbJvSEziyRxAk=
=UGY5
-----END PGP SIGNATURE-----

--UC3sj7l5U49DsqCbf4wwTCOeR7mqZjRIk--
