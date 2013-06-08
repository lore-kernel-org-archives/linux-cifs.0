From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: How to automatically umount a "broken" CIFS mount?
Date: Sat, 8 Jun 2013 09:18:45 -0400
Message-ID: <20130608091845.61c69f8f@tlielax.poochiereds.net>
References: <CANh5envke45j_91cZHNDjL=r7pn489_NJ-454euD6O1bRbfjAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Valdemar =?ISO-8859-1?B?TfhyY2g=?= <peter-Fsal10Ed6HEAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANh5envke45j_91cZHNDjL=r7pn489_NJ-454euD6O1bRbfjAw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 8 Jun 2013 13:39:33 +0200
Peter Valdemar M=F8rch <peter-Fsal10Ed6HEAvxtiuMwx3w@public.gmane.org> wrote:

> Hi,
>=20
> Is there some way to detect if the mount no longer "works"? There
> could be many reasons for this: network error, Windows server has bee=
n
> shut down, etc.
>=20
> I can of course periodically do this:
>=20
> > time ls -l /mnt/cifs/
> ls: cannot access /mnt/cifs/: Host is down
>=20

EHOSTDOWN is not really a legit error to most syscalls. The fact that
it leaks out into userland is a bug. I wouldn't rely on that.

> real    0m10.000s
> user    0m0.000s
> sys    0m0.000s
>=20
> And use that error to umount, which is what I'll do if I don't have
> any other options.
>=20
> But I'm hoping for some timeout / auto-umount mechanism or some way t=
o
> query if the mount is still "good", that doesn't take 10 seconds pr.
> mountpoint...
>=20

Given the nature of how networks and the SMB protocol work, there is
little choice other than to send a call to the server and wait. That
wait is necessarily long (minutes even) since there's no way to know if
the client really isn't responding or is just taking a long time to
process the request.

If you really don't care about the mount and you have no dirty data on
it, then you should be able to do a lazy umount (umount -l) which will
detach it from the mount tree and eventually clean it up when there are
no more references to it. If you have this problem frequently, then
consider using something like autofs to mount it as needed and unmount
it when you're done.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
