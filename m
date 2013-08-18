From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: DFS referrals
Date: Sun, 18 Aug 2013 08:57:46 -0700
Message-ID: <CACyXjPw9_DT=nzznniZS_A6_whkvyUp4WQPm07bAWqmUtKfKhA@mail.gmail.com>
References: <51DBD032.10305@gmx.ch>
	<20130709054702.15550964@tlielax.poochiereds.net>
	<51DBDDEA.9040702@gmx.ch>
	<20130709081027.450b1849@corrin.poochiereds.net>
	<51F664FB.5090507@gmx.ch>
	<20130729090759.62d15e2e@corrin.poochiereds.net>
	<51F6720C.3060500@gmx.ch>
	<20130729103445.6629cece@tlielax.poochiereds.net>
	<51F67EB0.40502@gmx.ch>
	<51F75300.9000703@gmx.ch>
	<51F7A513.1090806@gmx.ch>
	<20130730080116.76df98db@corrin.poochiereds.net>
	<51F7C67A.6020009@gmx.ch>
	<20130730101730.71549ec8@tlielax.poochiereds.net>
	<5209F598.1000101@gmx.ch>
	<CACyXjPyu+uKW5THRRimpJMLS35KFJRoi_Ck6QLqUP2LZ7nh1+w@mail.gmail.com>
	<20130813113210.649866dd@tlielax.poochiereds.net>
	<CACyXjPy69oa02aDp7ZLZx2WbJkXifxnp8yyfSHuBNSw5nBRTYw@mail.gmail.com>
	<20130818091011.7c2cc8b1@tlielax.poochiereds.net>
	<CACyXjPzY8bi_m7iJ52RwvFNLYic+YyW_YenBmrirQmG0kS0Y9g@mail.gmail.com>
	<5210E7AD.1030408@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcus Moeller <marcus.moeller-OI3hZJvNYWs@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5210E7AD.1030408-OI3hZJvNYWs@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Aug 18, 2013 at 8:26 AM, Marcus Moeller <marcus.moeller-OI3hZJvNYWs@public.gmane.org>=
 wrote:
> Am 18.08.2013 17:14, schrieb Richard Sharpe:
>>>>>>
>>>>>> No, it is not possible to set the same SPN on more than one comp=
uter
>>>>>> object in AD.
>>>>>>
>>>>>> What happens here is a combination of DNS magic (there are multi=
ple
>>>>>> SRV records) and replication of the DFS info between DCs in the =
AD
>>>>>> domain.
>>>>>>
>>>>>> A client can query any DC for the translation of a DNS namespace=
=2E
>>>>>>
>>>>>> My use case lives below that level and it is all pretty much wor=
king
>>>>>> (except for XP, which will not do multiple levels of DFS referra=
ls, it
>>>>>> seems.)
>>>>>>
>>>>>> In any event, I might eventually have to use a shared secrets fi=
le,
>>>>>> which overcomes the issue of SPNs.
>>>>>>
>>>>>
>>>>> What SRV records are used? Should we fix mount.cifs to try and qu=
ery
>>>>> for an SRV record first and then try to resolve that hostname bef=
ore
>>>>> attempting to mount?
>>>>
>>>>
>>>> Those are just for finding the namespace, and I am not sure exactl=
y
>>>> how it is handled, but if you have a namespace of
>>>> \\domain.realm\namespace1, I think any DC in that domain can be us=
ed
>>>> to get to the first level.
>>>>
>>>
>>> Bear with me, as I'm pretty clueless as to how AD stuff works.
>>>
>>> If all I have is \\domain.realm\namespace1 what should I be doing t=
o
>>> connect to it at that point? Currently we just treat "domain.realm"=
 as
>>> a hostname, but evidently that's not quite the right thing to do. I=
s it?
>>
>>
>> Let me check.
>>
>> It might be that Windows returns the IP addresses of all the DCs in
>> that domain in that case (and, if Sites and Services has been set up
>> properly, returns them with the closest ones to you first in the
>> list.) That is, my mentioning of SRV records might be a red herring.
>>
>> In that case, if the first one fails, you should simply try the next
>> one until you find one that responds.
>
>
> Yes, that's how it works. It then tries to reverse lookup the ip addr=
ess in
> order to mount the share. As our reverse DNS Setup is somewhat broken=
, that
> part fails. I thought that removing the -t option could be a workarou=
nd for
> that, but as the cifs/domain SPN can only be set on one DC, that's no=
 option
> to.

Well, more precisely, it needs the name in order to generate a service
ticket. I don't think Windows cares these days what the called-name
is.

--=20
Regards,
Richard Sharpe
(=A6=F3=A5H=B8=D1=BC~=A1H=B0=DF=A6=B3=A7=F9=B1d=A1C--=B1=E4=BE=DE)
