From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5] cifs: allow for larger rsize= options and change
 defaults
Date: Wed, 12 Oct 2011 08:31:13 -0400
Message-ID: <20111012083113.2130445d@tlielax.poochiereds.net>
References: <1318336527-13648-1-git-send-email-jlayton@redhat.com>
	<1318336527-13648-5-git-send-email-jlayton@redhat.com>
	<CAKywueRHKSrYLmebgSvcfOrrZ=jRC8ELL+Vt0j91orHMLtUVvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRHKSrYLmebgSvcfOrrZ=jRC8ELL+Vt0j91orHMLtUVvw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 12 Oct 2011 16:22:25 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2011/10/11 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> ...
> > +
> > + =C2=A0 =C2=A0 =C2=A0 /*
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* Set default value...
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0*
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* HACK alert! Ancient servers have ver=
y small buffers. Even though
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* MS-CIFS indicates that servers are o=
nly limited by the client's
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* bufsize for reads, testing against w=
in98se shows that it throws
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* INVALID_PARAMETER errors if you try =
to request too large a read.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0*
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* If the server advertises a MaxBuffer=
Size of less than one page,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* assume that it also can't satisfy re=
ads larger than that either.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0*
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* FIXME: Is there a better heuristic f=
or this?
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> > + =C2=A0 =C2=A0 =C2=A0 if (tcon->unix_ext && (unix_cap & CIFS_UNIX_=
LARGE_READ_CAP))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 defsize =3D CIFS=
_DEFAULT_IOSIZE;
> > + =C2=A0 =C2=A0 =C2=A0 else if (server->capabilities & CAP_LARGE_RE=
AD_X)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 defsize =3D CIFS=
_DEFAULT_NON_POSIX_RSIZE;
> > + =C2=A0 =C2=A0 =C2=A0 else if (server->maxBuf >=3D PAGE_CACHE_SIZE=
)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 defsize =3D CIFS=
MaxBufSize;
> > + =C2=A0 =C2=A0 =C2=A0 else
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 defsize =3D serv=
er->maxBuf - sizeof(READ_RSP);
> > +
>=20
> So, if the max buffer size that the server supports is greater or
> equal that PAGE_CACHE_SIZE than we set it to CIFSMaxBufSize. But if
> maxBuf is less than CIFSMaxBufSize? I think the server refects such a
> request.
>=20

I guess you mean "rejects" ?

In principle, the server's maxBuf should have no bearing at all on the
size of a read that it can satisfy.

In practice though, it seems like much older servers (such as win9x
era) *do* have such a limitation. We have no clear way to identify such
servers though, so I came up with this one (maxBuf less than
PAGE_CACHE_SIZE).

I'm open to suggestions for a better heuristic here if you have one.
Note too that this is just the default setting, and the user can
override it if they wish.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
