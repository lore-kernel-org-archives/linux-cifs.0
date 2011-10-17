From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: mention the required kernel version to make
 cifs.idmap work
Date: Mon, 17 Oct 2011 13:06:54 -0400
Message-ID: <20111017130654.53fd42c4@corrin.poochiereds.net>
References: <4E9C19A3.8010009@suse.de>
	<20111017081139.564089db@tlielax.poochiereds.net>
	<CAH2r5msxArv-Hdy6sBVGbNtLcjhwk0EUwGj07H85iOT4KHqiRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sjayaraman-l3A5Bk7waGM@public.gmane.org, linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msxArv-Hdy6sBVGbNtLcjhwk0EUwGj07H85iOT4KHqiRg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 17 Oct 2011 11:59:20 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Mon, Oct 17, 2011 at 7:11 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Mon, 17 Oct 2011 17:33:47 +0530
> > Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
> >
> >> .. properly in the "NOTES" section.
> >>
> >> Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> >> ---
> >> =C2=A0cifs.idmap.8.in | =C2=A0 =C2=A03 +++
> >> =C2=A01 files changed, 3 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/cifs.idmap.8.in b/cifs.idmap.8.in
> >> index f2fa3b2..7adfdc6 100644
> >> --- a/cifs.idmap.8.in
> >> +++ b/cifs.idmap.8.in
> >> @@ -76,6 +76,9 @@ create =C2=A0 =C2=A0 =C2=A0cifs\&.idmap =C2=A0 =C2=
=A0 * * @sbindir@/cifs\&.idmap %k
> >> =C2=A0See
> >> =C2=A0\fBrequest-key.conf\fR(5)
> >> =C2=A0for more info on each field\&.
> >> +.SH "NOTES"
> >> +.PP
> >> +For cifs.idmap to work properly you would need a kernel version 3=
=2E0 or above.
> >> =C2=A0.SH "SEE ALSO"
> >> =C2=A0.PP
> >>
> >
> > This looks reasonable, but I'm always a bit leery of calling out
> > specific versions like this. Some distros (e.g. Red Hat's and Novel=
l's)
> > will backport features from later kernels, so saying you need a 3.0
> > kernel might be confusing.
> >
> > We might want to rephrase this with something like "Support for upc=
alls
> > to cifs.idmap was initially introduced in the 3.0 kernel." It's a
> > little more weaselly but it isn't false if someone is working with =
a
> > kernel that has backported this code.
> >
> > Sound reasonable?
>=20
> Yes - also to supplement this data can use the cifs version (displaye=
d
> by modinfo) - presumably with wholesale backport of cifs code the
> version number could be updated as well.
>=20

Except that often, distros pick and choose what new features to
backport. FWIW, I typically I don't bother bumping the version number
in the kmod in RHEL since it's more or less meaningless...

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
