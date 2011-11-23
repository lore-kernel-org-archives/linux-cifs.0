From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: lower default wsize when unix extensions are not
 used
Date: Wed, 23 Nov 2011 15:04:27 -0500
Message-ID: <20111123150427.57a63195@tlielax.poochiereds.net>
References: <1320863843-29406-1-git-send-email-jlayton@redhat.com>
	<20111109134140.2105ed9e@corrin.poochiereds.net>
	<CAH2r5mtmboSEMHbj6ixh6UGSgiTFz1Mn=ZU6fkQaCSu7n6h=EQ@mail.gmail.com>
	<20111109160408.44947815@corrin.poochiereds.net>
	<E1RTHe2-004p4M-7T@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	phireph0x-/E1597aS9LQAvxtiuMwx3w@public.gmane.org, piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org
To: =?UTF-8?B?QmrDtnJu?= JACKE <bj-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E1RTHe2-004p4M-7T-dqLtpHMqGvUyWpdLl23E4A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 23 Nov 2011 19:34:05 +0100
Bj=C3=B6rn JACKE <bj-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org> wrote:

> On 2011-11-09 at 16:04 -0500 Jeff Layton sent off:
> > On Wed, 9 Nov 2011 14:55:36 -0600
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >=20
> > > How much of a performance hit does this make?  I would expect tha=
t
> > > dropping the writesize by more than 50% to most non-Samba servers=
 to
> > > work around a bug in Solaris seems extreme.  If this hurts our
> > > performance measurably, it may be more pragmatic to limit the wsi=
ze
> > > change to a subset of these (e.g. based on server type) - seems m=
ore
> > > fair to not punish other servers for a Solaris bug.
> > >=20
> >=20
> > I'm not sure how big a hit it will be, but it won't be 0. As always=
, it
> > depends on workload. The problem is, I'm not sure we can reliably
> > detect when the server can't handle larger writes like this.
>=20
> I've seen a performance drop from 60MB/s to 50MB/s on a 1GB switched =
network
> when unix extensions were disabled just because the rsize was limited=
 from 128k
> to 64k. That was tested with Darwin's smbfs but the dropdown in perfo=
rmance of
> cifs vfs will be similar. If this can be seen as a server bug I'd als=
o like to
> see Oracle fix their server and keep cifs vfs be able to use 128k.
>=20

That 64k is just a default. There's nothing that stops you from setting
the rsize or wsize higher in this situation. You can go up to ~128k for
the rsize too if you know your server can handle it.

The Solaris/Illumos problem is apparently a kernel bug, and Gordon Ross
has apparently fixed it for Illumos. My concern though is that we don't
know if there are other servers with similar limitations out there in
the field. Windows never sends anything larger than 64k. There are
potentially a lot of servers out there that can't handle a larger wsize=
=2E

Even if it's *just* Solaris kernels that are broken this way, there are
still a number of those servers in the field. By defaulting larger
we're putting those users' data at risk.

Ultimately, this is Steve's call, even if I think his logic is flawed.
I would however appreciate a clear NAK on this patch if he's not going
to take it as I have to decide what to do for RHEL and Fedora.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
