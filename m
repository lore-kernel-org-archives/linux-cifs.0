From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: add attribute cache timeout (actimeo) tunable
Date: Wed, 17 Nov 2010 16:11:05 -0500
Message-ID: <20101117161105.21492ff8@tlielax.poochiereds.net>
References: <1290018214-9415-1-git-send-email-sjayaraman@suse.de>
	<20101117133919.07f9f0db@tlielax.poochiereds.net>
	<4CE429F8.6070105@suse.de>
	<AANLkTikN44ayabuHkYWz1Cd6WYVdyO25Tv0E_fKv7=Fi@mail.gmail.com>
	<AANLkTinHdTudRWzHz-wf7bhiwn-2S8A-PM0YA3m_XLks@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinHdTudRWzHz-wf7bhiwn-2S8A-PM0YA3m_XLks-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 17 Nov 2010 13:43:52 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Nov 17, 2010 at 1:40 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wr=
ote:
> > On Wed, Nov 17, 2010 at 1:16 PM, Suresh Jayaraman <sjayaraman@suse.=
de> wrote:
> >> On 11/18/2010 12:09 AM, Jeff Layton wrote:
> >>> On Wed, 17 Nov 2010 23:53:34 +0530
> >>> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
> >>>
> >>>> Currently, the attribute cache timeout for CIFS is hardcoded to =
1 second. This
> >>>> means that the client might have to issue a QPATHINFO/QFILEINFO =
call every 1
> >>>> second to verify if something has changes, which seems too expen=
sive. On the
> >>>> other hand, if the timeout is hardcoded to a higher value, workl=
oads that
> >>>> expect strict cache coherency might see unexpected results.
> >>>>
> >>>> Making attribute cache timeout as a tunable will allow us to mak=
e a tradeoff
> >>>> between performance and cache metadata correctness depending on =
the
> >>>> application/workload needs.
> >>>>
> >>>> Add 'actimeo' tunable that can be used to tune the attribute cac=
he timeout.
> >>>> The default timeout is set to 1 second.
> >>>>
> >>>> Also, display actimeo option value in /proc/mounts.
> >>> =A0 =A0 =A0 You actually do need to impose a limit here. I sugges=
t looking
> >>> =A0 =A0 =A0 very closely at time_before/time_after macros. It'll =
also be
> >>> =A0 =A0 =A0 easier to deal storing actimeo in terms of jiffies in=
stead of
> >>> =A0 =A0 =A0 seconds.
> >>
> >>> =A0 =A0 =A0 Finally, this value needs to be displayed in /proc/mo=
unts.
> >>>
> >>
> >> Did you mean displaying values in jiffies in /proc/mounts? Wouldn'=
t it
> >> be confusing for users to see such a higher numbers (usually) when=
 they
> >> had used a simple 2 digit number for e.g. during mount?
> >
> > That is a good question - seems like we ought to allow setting more=
 granular
> > timeouts (ie jiffies) but nfs actimeo assumes the value is in secon=
ds
> > by default.
> > I am fine with allowing actimeo to be specified more than one way (=
seconds vs
> > milliseconds or seconds vs. jiffies) with suffix or prefix or keywo=
rd variant.
>=20
> This assumes there are apps that might someday need stricter
> guarantees (sub 1 second - e.g. 15 per second) but not disable metada=
ta caching.
> If we don't think that would ever happen - then I am fine with second=
s
> everywhere
> (actimeo only in seconds, /proc display only in seconds).
>=20

I don't see any real need for that level of granularity. 1s should be
enough for anyone. :)

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
