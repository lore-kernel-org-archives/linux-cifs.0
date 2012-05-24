From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: stat fails for directory in cifs that contains latin-1 accented
 character.
Date: Thu, 24 May 2012 06:51:52 -0400
Message-ID: <20120524065152.2e8ec480@tlielax.poochiereds.net>
References: <CANM685KZP6_=ymS0RA3Mwm1PiVTPb-WpmuvdVjmF0tehBf7+zQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "John P. Hartmann" <jphartmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANM685KZP6_=ymS0RA3Mwm1PiVTPb-WpmuvdVjmF0tehBf7+zQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 24 May 2012 11:30:35 +0200
"John P. Hartmann" <jphartmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Kernel is 2.6.34.9-69.fc13.i686.
>=20
> The server is configured with charset en_US.iso88591.  Mount options
> include iocharset=3Diso8859-1.
>=20
> ls shows the directory correctly, but  ls -l fails:
>=20
> ls: N=C3=B8digt, Men Dog Gerne: No such file or directory
> total 0
> drwxr-xr-x 2 john staff 0 Jun 12  2011 N=C3=B8digt, Men Dog Gerne
>=20
> strace shows that lstat fails with ENOENT:
>=20
> lstat64("N\370digt, Men Dog Gerne", 0x9ca6bb0) =3D -1 ENOENT (No such
> file or directory)
>=20
> The character is x'f8' as shown, which is the correct encoding of o-s=
lash.
>=20
> The same happens when I diropen() and then stat() the contents.
>=20
> What is the real problem here?

Sounds like the character isn't being converted correctly before
cifs.ko sends it over the wire. Does this server support unicode? You
may need to sniff traffic to figure out what's actually being sent in
either direction.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
