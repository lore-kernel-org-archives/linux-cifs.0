From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Making shares unaccessible at root level mountable (aka
 solving bsc#8950 ...again)
Date: Tue, 26 Jul 2016 13:04:44 -0500
Message-ID: <CAH2r5mviretFGDaHOre8BiZLmKhqwnfv9sdaiqoAG1xahbVjKA@mail.gmail.com>
References: <20160527194346.08416d79@aaptelpc> <20160609185027.7349f260@aaptelpc>
 <5759C326.5040508@fu-berlin.de> <20160610171649.3e12b95c@aaptelpc>
 <CAKywueRMvJ4B6ojqA1TduS4nGFTr5m4wLO2=0M_EVv=vw2T1pw@mail.gmail.com>
 <20160718163847.68ea0d86@aaptelpc> <CAKywueRFMu9nvwi_01Yz0HpOqhrK2yZVaLT2JMqw4622irQzNw@mail.gmail.com>
 <20160720125702.43df577e@aaptelpc> <20160720141613.6a91e293@aaptelpc> <CAKywueTOSD0G1k+EU-Qo_9D7S5bBw6g6T=dbQpWYWdOhr5Lsrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>,
	Marcus Hoffmann <marcus.hoffmann-j/7cz5qe3tpn68oJJulU0Q@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueTOSD0G1k+EU-Qo_9D7S5bBw6g6T=dbQpWYWdOhr5Lsrg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

thoughts on stable?

On Wed, Jul 20, 2016 at 1:28 PM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =
wrote:
> 2016-07-20 15:16 GMT+03:00 Aur=C3=A9lien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>:
>> On Wed, 20 Jul 2016 12:57:02 +0200 Aur=C3=A9lien Aptel <aaptel@suse.=
com>
>> wrote:
>>> Oops. Okay this time checkpatch.pl only complains about a quoted
>>> string split across lines wich I'm not really sure how to fix so I'=
m
>>> leaving that as is.
>>
>> ...because not splitting it would make the line >80 chars. The whole
>> point of doing this is AFAIU to be able to grep the message so using=
 "\"
>> wouldn't fix it really.
>>
>> --
>> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
>> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
>> SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
>> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 =
(AG
>> N=C3=BCrnberg)
>
> The quoted string should not be split even if it is >80 chars.
>
> Anyway, the patch looks good. Thanks for fixing this long-term issue.
>
> Reviewed-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>
> --
> Best regards,
> Pavel Shilovsky



--=20
Thanks,

Steve
