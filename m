From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 8/8] cifs: convert cifs_iovec_write to use async
 writes
Date: Fri, 23 Mar 2012 17:11:00 -0400
Message-ID: <20120323171100.606a7b5d@tlielax.poochiereds.net>
References: <1328279581-21889-1-git-send-email-jlayton@redhat.com>
	<1328279581-21889-9-git-send-email-jlayton@redhat.com>
	<CAKywueT3Cmw4ffuE1wvMzxZniWyUUCU=8rtrB4Eu7Zz3FMtecQ@mail.gmail.com>
	<20120221065455.4f4b3ec5@tlielax.poochiereds.net>
	<CAKywueRRCSttySt0AbkoANBYVgz=p-p+FbMEx9EfcdLP+v4OcQ@mail.gmail.com>
	<CAH2r5mvkMV7O8L+1yLg4v69YVSh8+xnvNHBK1_zm8EKAZA-MPQ@mail.gmail.com>
	<20120323170140.3cdd927f@tlielax.poochiereds.net>
	<CAH2r5mtKvQ5wjVwJJukn+JwNV1XuQg_78yq7KCvzQYkWG4g2TA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtKvQ5wjVwJJukn+JwNV1XuQg_78yq7KCvzQYkWG4g2TA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 23 Mar 2012 16:05:20 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Mar 23, 2012 at 4:01 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Fri, 23 Mar 2012 15:55:14 -0500
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> Jeff,
> >> We should cleanup compile warning - was planning to add a tiny pat=
ch
> >> to fix if no objection.
> >>
> >> Look correct?
> >>
> >> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> >> index daaaca8..460d87b 100644
> >> --- a/fs/cifs/file.c
> >> +++ b/fs/cifs/file.c
> >> @@ -2114,7 +2114,7 @@ cifs_uncached_marshal_iov(struct kvec *iov,
> >> struct cifs_writedata *wdata)
> >>
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* marshal up the pages into iov array=
 */
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < wdata->nr_pages; i++=
) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iov[i + 1].iov_=
len =3D min(bytes, PAGE_SIZE);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iov[i + 1].iov_=
len =3D min_t(size_t, bytes, PAGE_SIZE);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iov[i + 1]=
=2Eiov_base =3D kmap(wdata->pages[i]);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bytes -=3D=
 iov[i + 1].iov_len;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >>
> >
> > That patch looks harmless, but I don't seem to be able to reproduce=
 any
> > warnings. Can you elaborate on how you're getting a warning from th=
at?
>=20
> make modules C=3D1 M=3Dfs/cifs CF=3D-D__CHECK_ENDIAN__
>=20
> FC16
>=20
> [stevef@smf-gateway cifs-2.6]$ gcc --version
> gcc (GCC) 4.6.2 20111027 (Red Hat 4.6.2-1)
> Copyright (C) 2011 Free Software Foundation, Inc.
>=20
>=20

Hrm...I don't see it on my F16 box. Are you on 32 bit arch? If so, that
might be why. In any case, that patch is fine if it silences the
warning for you.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
