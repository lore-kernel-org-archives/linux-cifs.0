From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: shrinking set of cifs fixes to merge for 2.6.39 to small set
Date: Tue, 12 Apr 2011 09:16:57 -0400
Message-ID: <20110412091657.0a2ed527@corrin.poochiereds.net>
References: <BANLkTi=72h+nv9BfB+1e69tW4Hb_u5U_TA@mail.gmail.com>
	<20110412075144.53180566@corrin.poochiereds.net>
	<BANLkTin627FFHH_mt1Lu7TMVMAb5y-DKgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTin627FFHH_mt1Lu7TMVMAb5y-DKgg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 12 Apr 2011 07:30:14 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Apr 12, 2011 at 6:51 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Mon, 11 Apr 2011 20:33:42 -0500
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> Since it is already past the merge window (was waiting to discuss =
some
> >> fixes with others at the fs summit last week before merge), =C2=A0=
I shrunk
> >> the list of cifs patches waiting for merge (in cifs-2.6.git) to a =
much
> >> smaller set of more critical ones. See below. (I moved the others
> >> temporarily to a for-2.6.40 branch in cifs-2.6.git). =C2=A0We (Jef=
f,
> >> Shirish, I etc.) need to build/test more with this set before send=
ing
> >> though.
> >>
> >> Jeff Layton (8):
> >> =C2=A0 =C2=A0 =C2=A0 cifs: check for private_data before trying to=
 put it
> >> =C2=A0 =C2=A0 =C2=A0 cifs: replace /proc/fs/cifs/Experimental with=
 a module parm
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0I think we should also put in the patch =
that adds the
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0page_mkwrite handler.
>=20
> I agree but it had more merge conflicts.
>=20

Ok, I just resent the patch with the merge conflicts fixed.

I've also given the set you're proposing + the page_mkwrite patch a
quick smoke test run with connectathon and it seems to be ok.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
