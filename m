From: Randy Dunlap <randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: document 'fsc' mount option
Date: Tue, 27 Jul 2010 14:59:01 -0700
Message-ID: <20100727145901.e6c25800.randy.dunlap@oracle.com>
References: <4C4EE408.7070109@suse.de>
	<20100727103313.4b730ea8@tlielax.poochiereds.net>
	<AANLkTina2EyHkrgNAcrY8ZRK=fXQS71dekWc+kOA0+mz@mail.gmail.com>
	<20100727111517.4fe0859e@tlielax.poochiereds.net>
	<AANLkTik9JqtqAtKJQsaQR8aC8s0kwmrcU=_=QQei7U07@mail.gmail.com>
	<4C4F0A71.8020908@suse.de>
	<AANLkTi=+Y1XdFCT1UfWZW==qusXfs6t-vxa_CYo03TTT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=+Y1XdFCT1UfWZW==qusXfs6t-vxa_CYo03TTT-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 27 Jul 2010 11:38:20 -0500 Steve French wrote:

> On Tue, Jul 27, 2010 at 11:33 AM, Suresh Jayaraman <sjayaraman@suse.d=
e> wrote:
> > On 07/27/2010 08:51 PM, Steve French wrote:
> >> scripts/extract-ikconfig could be run against the image (or look a=
t
> >> /proc/config.gz) - but unless there is an easier way to view kerne=
l
> >> config options on particular distros via distro specific tools -
> >> probably easier just to note that CONFIG_FSCACHE must be selected =
in
> >> the kernel build (since it forces dependencies on the other kernel
> >> options being set)
> >
> > Does something like
> > =A0 =A0 =A0 =A0$zcat /proc/config.gz | grep CONFIG_CIFS_FSCACHE
> >
> > might work on all distros?
> >
> > But, Jeff's idea of having a features file in /proc sounds good. Ap=
art
> > from using them as a reference to check in documentation, it could =
be a
> > useful information while collecting debugging output as well..?
>=20
> Seems reasonable - but wondering if other file systems have run into =
the same
> problem - how to view their build/config options - and how they have
> solved it (if at all) so ccing fsdevel

There is no guarantee that scripts/extract-ikconfig can find anything,
or that proc/config.gz is present.

The safe, sure-to-work thing to do is create some strings or files or w=
hatever
based on CONFIG_* kconfig symbols during kernel build, then those hints=
 will
be available at kernel run-time.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***
