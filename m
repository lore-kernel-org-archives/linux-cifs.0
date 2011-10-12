From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/5] cifs: allow for larger rsize= options and change defaults
Date: Wed, 12 Oct 2011 16:22:25 +0400
Message-ID: <CAKywueRHKSrYLmebgSvcfOrrZ=jRC8ELL+Vt0j91orHMLtUVvw@mail.gmail.com>
References: <1318336527-13648-1-git-send-email-jlayton@redhat.com>
	<1318336527-13648-5-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1318336527-13648-5-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/11 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
=2E..
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Set default value...
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* HACK alert! Ancient servers have very small buffer=
s. Even though
> + =A0 =A0 =A0 =A0* MS-CIFS indicates that servers are only limited by=
 the client's
> + =A0 =A0 =A0 =A0* bufsize for reads, testing against win98se shows t=
hat it throws
> + =A0 =A0 =A0 =A0* INVALID_PARAMETER errors if you try to request too=
 large a read.
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* If the server advertises a MaxBufferSize of less t=
han one page,
> + =A0 =A0 =A0 =A0* assume that it also can't satisfy reads larger tha=
n that either.
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* FIXME: Is there a better heuristic for this?
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (tcon->unix_ext && (unix_cap & CIFS_UNIX_LARGE_READ_=
CAP))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 defsize =3D CIFS_DEFAULT_IOSIZE;
> + =A0 =A0 =A0 else if (server->capabilities & CAP_LARGE_READ_X)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 defsize =3D CIFS_DEFAULT_NON_POSIX_RSIZ=
E;
> + =A0 =A0 =A0 else if (server->maxBuf >=3D PAGE_CACHE_SIZE)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 defsize =3D CIFSMaxBufSize;
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 defsize =3D server->maxBuf - sizeof(REA=
D_RSP);
> +

So, if the max buffer size that the server supports is greater or
equal that PAGE_CACHE_SIZE than we set it to CIFSMaxBufSize. But if
maxBuf is less than CIFSMaxBufSize? I think the server refects such a
request.

--=20
Best regards,
Pavel Shilovsky.
