From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Linux 2.6.36-rc3
Date: Mon, 30 Aug 2010 12:14:53 -0500
Message-ID: <AANLkTi=S3E80edLwAAAOwehrakYVgeKzC+yKptwJJZLc@mail.gmail.com>
References: <AANLkTinRRiW1VUzS+3T82=q8PsoRn78Cgn_X8gSduM0U@mail.gmail.com>
	<i5fr6h$ih6$1@dough.gmane.org>
	<4C7BE3AE.8020204@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Miguel Calleja <mcalleja1-bK70e7QAd3DmLYrVJihF6Q@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish S Pargaonkar <shirishp-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C7BE3AE.8020204-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Aug 30, 2010 at 12:00 PM, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>=
 wrote:
> (Cc linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
>
> Couldn't get a chance to check this, but I guess this is perhaps due =
to
> the recent crypto patches..

Suresh, yes, cifs auth and signing code using kernel crypto (shash) api=
s.

fs/cifs/Kconfig

        select CRYPTO_MD5
        select CRYPTO_ARC4


>
> On 08/30/2010 02:17 PM, Miguel Calleja wrote:
>> CIFS does not build without CRYPTO selected.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kern=
el" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at =A0http://www.tux.org/lkml/
>
>
> --
> Suresh Jayaraman
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
