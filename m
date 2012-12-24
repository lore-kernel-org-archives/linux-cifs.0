From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: CIFS mount fails if I ctrl-c a long-running find process (Linux
 mounting Windows share)
Date: Mon, 24 Dec 2012 09:14:21 -0500
Message-ID: <20121224091421.63d0df23@tlielax.poochiereds.net>
References: <1355872616.69791.YahooMailNeo@web160302.mail.bf1.yahoo.com>
	<20121219090322.3999f995@tlielax.poochiereds.net>
	<1355944553.61735.YahooMailNeo@web160303.mail.bf1.yahoo.com>
	<1355945432.81847.YahooMailNeo@web160302.mail.bf1.yahoo.com>
	<20121220093806.537c2496@corrin.poochiereds.net>
	<20121223091034.5e313ee1@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Tim Perry <tim.perry-kUnrLEE8I/oKpCjwLQ55aZ9NZdITTVap@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121223091034.5e313ee1-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 23 Dec 2012 09:10:34 -0500
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Thu, 20 Dec 2012 09:38:06 -0500
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>=20
> > On Wed, 19 Dec 2012 11:30:32 -0800 (PST)
> > Tim Perry <tim.perry-kUnrLEE8I/oKpCjwLQ55aZ9NZdITTVap@public.gmane.org> wrote:
> >=20
> > > Dear Jeff, et. al.,
> > >=20
> > >=20
> > > I can reproduce the problem by starting "find . -name \*.ext"and =
killing it when connected to either of our two Windows 2003 Servers. I =
can *not* reproduce it doing the same thing connected to a windows 7 bo=
x.
> > >=20
> > > $ uname -a
> > > Linux servername 3.2.0-34-generic #53-Ubuntu SMP Thu Nov 15 10:49=
:02 UTC 2012 i686 i686 i386 GNU/Linux
> > > $ cat /proc/version
> > >=20
> > > Linux version 3.2.0-34-generic (buildd@roseapple) (gcc version 4.=
6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #53-Ubuntu SMP Thu Nov 15 10:49:02=
 UTC 2012
> > > $ lsb_release -a
> > > No LSB modules are available.
> > > Distributor ID: Ubuntu
> > > Description: =A0 =A0Ubuntu 12.04.1 LTS
> > > Release: =A0 =A0 =A0 =A012.04
> > > Codename: =A0 =A0 =A0 precise
> > >=20
> > >=20
> > > I tried using strace but hitting ctrl-c killed strace (obviously,=
 oops), but interestingly, this did *not* hang the file system. I will =
try and kill the find command (kill -9 perhaps?) and see if I can recre=
ate the error that way.
> > >=20
> > > CONTINUING HERE:
> > > I don't think strace on the find command will help because it isn=
't making the network connections. CIFS is making the network connectio=
ns. Maybe I can cause the mount to happen with an strace version of CIF=
S? =A0How would I do that?
> > >=20
> > > Anyhow, I opened two terminal windows and proceeded as follows:
> > >=20
> > > In terminal 1:
> > >=20
> > > $ strace find . -name \*adzzz >& ~/straceFind.txt
> > >=20
> > >=20
> > > In terminal 2:
> > > $ ps aux | grep find | grep -v strace
> > > perry =A0 =A0 2583 12.6 =A00.0 =A0 4792 =A01088 pts/5 =A0 =A0R+ =A0=
 11:27 =A0 0:00 find . -name *adzzz
> > > perry =A0 =A0 2585 =A00.0 =A00.0 =A0 4388 =A0 828 pts/2 =A0 =A0S+=
 =A0 11:27 =A0 0:00 grep find
> > > $ kill -9 2583
> > >=20
> > > File system dies.
> > >=20
> > > I've attaced the straceFind.txt, but it just shows find walking t=
he filesystem tree:
> > > statat64(AT_FDCWD, "0010", {st_mode=3DS_IFDIR|0777, st_size=3D0, =
=2E..}, AT_SYMLINK_NOFOLLOW) =3D 0
> > > openat(AT_FDCWD, "0010", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECT=
ORY|O_CLOEXEC) =3D 5
> > > fchdir(5) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =3D 0
> > > getdents64(5, /* 14 entries */, 32768) =A0=3D 448
> > > getdents64(5, /* 0 entries */, 32768) =A0 =3D 0
> > > close(5) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0=3D 0
> > > fstatat64(AT_FDCWD, "_vti_cnf", {st_mode=3DS_IFDIR|0777, st_size=3D=
0, ...}, AT_SYMLINK_NOFOLLOW) =3D 0
> > > openat(AT_FDCWD, "_vti_cnf", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DI=
RECTORY|O_CLOEXEC) =3D 5
> > > fchdir(5) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =3D 0
> > > getdents64(5, /* 13 entries */, 32768) =A0=3D 416
> > > getdents64(5, /* 0 entries */, 32768) =A0 =3D 0
> > > close(5) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0=3D 0
> > > open("..", O_RDONLY|O_NOCTTY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O=
_NOFOLLOW) =3D 5
> > > fstat64(5, {st_mode=3DS_IFDIR|0777, st_size=3D0, ...}) =3D 0
> > > fchdir(
> > >=20
> > >=20
> > > Ideas?
> > >=20
> >=20
> > That kernel is pretty old, so you may want to try a more recent one=
=2E
> >=20
> > You may first want to start by tracing with wireshark -- see what's
> > happening on the wire before and after the signal is delivered.
> >=20
> > If it works against win7 then it's likely that win7 disconnects the
> > socket when the signatures are wrong. With that, we'd reestablish t=
he
> > connection and things would start working again. I suspect that win=
2k8
> > just starts returning an error that we map to -EACCES.
> >=20
> > It's possible that we should disconnect the client when the signatu=
res
> > start looking wrong, but I think we need to understand why signals =
are
> > causing this issue in the first place.
> >=20
> > There are some places where we do interruptible sleeps (vs. killabl=
e
> > ones). It's possible that SIGINT (which is what ^c generally delive=
rs)
> > is causing havok there.
> >=20
>=20
> I had a look at the code today and suspect that I know what the probl=
em
> is. When the kernel goes to send a request, it first signs it and the=
n
> bumps the sequence numbers that it tracks. If the request doesn't
> actually make it out onto the wire, like when the task catches a
> signal, those sequence numbers remain high even though the request
> didn't go out.
>=20
> Here's an untested patch that might help tell whether this is the
> case. You may want to try it and see if it does. Note that this fix i=
s
> a bit of a kludge and is not suitable for merging!
>=20
> A better fix would involve changing when the sequence number gets
> bumped in the first place. If this patch seems to help things, then
> I'll look at coding up that up.
>=20
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 76d974c..4520234 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -334,10 +334,14 @@ uncork:
>  		server->tcpStatus =3D CifsNeedReconnect;
>  	}
> =20
> -	if (rc < 0 && rc !=3D -EINTR)
> -		cERROR(1, "Error %d sending data on socket to server", rc);
> -	else
> +	if (rc < 0) {
> +		if (rc =3D=3D -EINTR)
> +			server->sequence_number -=3D 2;
> +		else
> +			cERROR(1, "Error %d sending data on socket to server", rc);
> +	} else {
>  		rc =3D 0;
> +	}
> =20
>  	return rc;
>  }
>=20
>=20

I was able to reproduce this, and I don't think the above patch will
fix it (at least not completely). The problem seems to be that the NT
cancel command is screwing up the sequence numbers. We'll have to do
some research to figure out why that's occurring.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
