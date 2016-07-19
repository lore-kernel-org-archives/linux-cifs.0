From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Making shares unaccessible at root level mountable (aka
 solving bsc#8950 ...again)
Date: Tue, 19 Jul 2016 22:21:26 +0300
Message-ID: <CAKywueRFMu9nvwi_01Yz0HpOqhrK2yZVaLT2JMqw4622irQzNw@mail.gmail.com>
References: <20160527194346.08416d79@aaptelpc> <20160609185027.7349f260@aaptelpc>
 <5759C326.5040508@fu-berlin.de> <20160610171649.3e12b95c@aaptelpc>
 <CAKywueRMvJ4B6ojqA1TduS4nGFTr5m4wLO2=0M_EVv=vw2T1pw@mail.gmail.com> <20160718163847.68ea0d86@aaptelpc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Marcus Hoffmann <marcus.hoffmann-j/7cz5qe3tpn68oJJulU0Q@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160718163847.68ea0d86@aaptelpc>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2016-07-18 17:38 GMT+03:00 Aur=C3=A9lien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>:
> On Sat, 2 Jul 2016 10:02:36 +0300 Pavel Shilovsky
> <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>> Please remove this unnecessary change - probably it will go to stabl=
e
>> some day and may cause extra conflicts.
>
>> The above code should check for possible memory allocation failure.
>
> I've added (new patch attached) NULL checks and removed the gratuitou=
s
> empty line.
>
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (=
AG
> N=C3=BCrnberg)

I suggest you to run scripts/checkpatch.pl against your patch - it has
several warnings like {} braces for single statement blocks. Also the
patch from the attachment still has an empty line in fs/cifs/cifsfs.c.

--=20
Best regards,
Pavel Shilovsky
