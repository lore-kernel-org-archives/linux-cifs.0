From: =?iso-8859-1?Q?Bj=F6rn?= JACKE <bj-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org>
Subject: Re: [PATCH] cifs: lower default wsize when unix extensions are not
 used
Date: Wed, 23 Nov 2011 19:34:05 +0100
Message-ID: <E1RTHe2-004p4M-7T@intern.SerNet.DE>
References: <1320863843-29406-1-git-send-email-jlayton@redhat.com>
 <20111109134140.2105ed9e@corrin.poochiereds.net>
 <CAH2r5mtmboSEMHbj6ixh6UGSgiTFz1Mn=ZU6fkQaCSu7n6h=EQ@mail.gmail.com>
 <20111109160408.44947815@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	phireph0x-/E1597aS9LQAvxtiuMwx3w@public.gmane.org, piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111109160408.44947815-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 2011-11-09 at 16:04 -0500 Jeff Layton sent off:
> On Wed, 9 Nov 2011 14:55:36 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>=20
> > How much of a performance hit does this make?  I would expect that
> > dropping the writesize by more than 50% to most non-Samba servers t=
o
> > work around a bug in Solaris seems extreme.  If this hurts our
> > performance measurably, it may be more pragmatic to limit the wsize
> > change to a subset of these (e.g. based on server type) - seems mor=
e
> > fair to not punish other servers for a Solaris bug.
> >=20
>=20
> I'm not sure how big a hit it will be, but it won't be 0. As always, =
it
> depends on workload. The problem is, I'm not sure we can reliably
> detect when the server can't handle larger writes like this.

I've seen a performance drop from 60MB/s to 50MB/s on a 1GB switched ne=
twork
when unix extensions were disabled just because the rsize was limited f=
rom 128k
to 64k. That was tested with Darwin's smbfs but the dropdown in perform=
ance of
cifs vfs will be similar. If this can be seen as a server bug I'd also =
like to
see Oracle fix their server and keep cifs vfs be able to use 128k.

Bj=F6rn
