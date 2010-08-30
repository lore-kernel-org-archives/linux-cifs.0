From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Linux 2.6.36-rc3
Date: Mon, 30 Aug 2010 16:27:34 -0500
Message-ID: <AANLkTikqKG0Fp=BzXcBW9JCuLF07X6sbD8HVxWxqkRnD@mail.gmail.com>
References: <AANLkTinRRiW1VUzS+3T82=q8PsoRn78Cgn_X8gSduM0U@mail.gmail.com>
	<i5fr6h$ih6$1@dough.gmane.org>
	<4C7BE3AE.8020204@suse.de>
	<AANLkTi=S3E80edLwAAAOwehrakYVgeKzC+yKptwJJZLc@mail.gmail.com>
	<20100830102527.17d5e1f1.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Miguel Calleja <mcalleja1-bK70e7QAd3DmLYrVJihF6Q@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish S Pargaonkar <shirishp-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>,
	ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Randy Dunlap <randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
	Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100830102527.17d5e1f1.randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Aug 30, 2010 at 12:25 PM, Randy Dunlap <randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org=
> wrote:
> On Mon, 30 Aug 2010 12:14:53 -0500 Shirish Pargaonkar wrote:
>
>> On Mon, Aug 30, 2010 at 12:00 PM, Suresh Jayaraman <sjayaraman@suse.=
de> wrote:
>> > (Cc linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
>> >
>> > Couldn't get a chance to check this, but I guess this is perhaps d=
ue to
>> > the recent crypto patches..
>>
>> Suresh, yes, cifs auth and signing code using kernel crypto (shash) =
apis.
>>
>> fs/cifs/Kconfig
>>
>> =A0 =A0 =A0 =A0 select CRYPTO_MD5
>> =A0 =A0 =A0 =A0 select CRYPTO_ARC4
>>
>
> Either CIFS should depend on CRYPTO:
> change
> =A0 =A0 =A0 =A0depends on INET
> to
> =A0 =A0 =A0 =A0depends on INET && CRYPTO
>
> or it can also select CRYPTO.
>
>>
>> >
>> > On 08/30/2010 02:17 PM, Miguel Calleja wrote:
>> >> CIFS does not build without CRYPTO selected.

OK - will fix this for cifs.   Looks like ecryptfs chose "depends on CR=
YPTO"
and ubifs chose "select CRYPTO" - but for network file system seems lik=
e
"select CRYPTO" (rather than depends on) makes more sense.

The ceph file system seems like it has the same type of problem.
fs/ceph/Kconfig
has "select CRYPTO_AES" but not "select CRYPTO"



--=20
Thanks,

Steve
