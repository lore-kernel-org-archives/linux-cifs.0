From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Problems with CVS on CIFS since kernel 2.6.30
Date: Mon, 02 Aug 2010 20:23:17 +0530
Message-ID: <4C56DBDD.4070501@suse.de>
References: <AANLkTingdjU-KKW3=KboAnR0pNeiE7aEje0nXhM6bYbe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jon Bramley <brammers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTingdjU-KKW3=KboAnR0pNeiE7aEje0nXhM6bYbe-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 08/02/2010 07:28 PM, Jon Bramley wrote:
> Hi all,
> I'm experiencing a problem with the linux CIFS client which is
> preventing me from using any kernel past 2.6.29, I've been=EF=BF=BDba=
nging=EF=BF=BDmy
> head against this one for some months now, so thought it about time t=
o
> ask some experts. I'm running Gentoo linux on a 32 bit machine.
>=20
> When connecting to our cifs share on any kernel I've tried since
> 2.6.29 (30, 31, 32, 33 and 34) I cannot use CVS on the share, as I ge=
t
> the following error:
>=20
> 515 14:41 $ cvs update
> cvs [update aborted]: cannot get working directory: No such file or d=
irectory
>=20
> Here is the bottom part of=EF=BF=BDan strace of the above command:
> http://paste.org/pastebin/view/21095
>=20
> dmesg always seems to report the following, upon mount, on all kernel=
s
> past 2.6.29, which I'm guessing is related:
>=20
> =EF=BF=BDCIFS VFS: server 10.194.0.106 of type Samba 3.0.28a returned
> unexpected error on SMB posix open, disabling posix open support.
> Check if server update available.
> =EF=BF=BDCIFS VFS: Autodisabling the use of server inode numbers on
> \\shared.orbis\shared. This server doesn't seem to support them
> properly. Hardlinks will not be recognized on this mount. Consider
> mounting with the "noserverino" option to silence this message.
>=20
> I've tried mounting the share using the noserverino option, which

See options serverino, noserverino and section inode numbers in 'man
mount.cifs' for additional information regarding this error.

Is there a hardlink involved?

> indeed does get rid of the second of those lines in dmesg, but doesn'=
t
> fix the problem. Updating the server is not really an option (unless =
I
> can prove very good reason) since this is my work server. One slightl=
y

The samba version you are using seem to be quite old.. Does better POSI=
X
support/conformance sound like a good enough reason..?

> strange thing, is that some of my colleagues run Ubuntu 10.04, which
> uses the 2.6.32 kernel, and they can use the share without problem.

What is the server version in this case?


Thanks,

--=20
Suresh Jayaraman
