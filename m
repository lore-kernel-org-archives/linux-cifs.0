From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Zero size and zero blocks mountpoint.
Date: Sun, 19 Sep 2010 15:04:27 -0700
Message-ID: <20100919150427.16ab30d9@corrin.poochiereds.net>
References: <AANLkTi=GPOoF5bOdySz2izWTEEBShZ8LG=SWPKZVHCU8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=GPOoF5bOdySz2izWTEEBShZ8LG=SWPKZVHCU8-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 19 Sep 2010 21:28:41 +0200
Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hello,
>=20
> whe mounting a smb filesystem using cifs, the mountpoint gets zero
> size and zero blocks:
>=20
>=20
> ls -al
> total 12
> drwxr-xr-x =A0 2 root root =A0 =A0 4096 2010-09-19 16:53 .
> drwxr-xr-x =A0 3 root root =A0 =A0 4096 2010-09-19 16:53 ..
> drwxr-xr-x =A0 6 root root =A0 =A0 =A0 =A00 2010-09-03 23:41 bononlin=
e
> -rw-r--r-- =A0 1 root root =A0 =A0 =A0 40 2010-09-19 16:53 .directory
> drwxr-xr-x 673 gast netgroup =A0 =A00 2010-09-12 23:40 ftp
> drwxrwxr-x =A010 gast netgroup =A0 =A00 2010-08-06 23:28 public
> drwxr-xr-x =A034 sbon netgroup =A0 =A00 2010-09-19 16:03 sbon
> drwxr-xr-x =A010 root root =A0 =A0 =A0 =A00 2010-08-06 23:26 video
>=20
> The directories bononline, ftp, public, sbon adn video are all
> mountpoints of smb shares.
>=20
> It's causing some unwanted behaviour.
> How can I change that, or is this not changeable?
> Stef

I think it's just a matter of setting the inode->i_size on the
directory. I *think* that when you do a QPathInfo call to a directory
via cifs the size comes back 0. Setting this to something else probably
means an extra call to the server to get the "real" size (whatever that
means). The question is, what should this be set to?

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
