From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: CIFS is slooow, gvfs is fast
Date: Fri, 22 Oct 2010 16:14:46 +0530
Message-ID: <4CC16B1E.4060709@suse.de>
References: <20101022013544.0fdab0e0@werewolf.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: =?ISO-8859-15?Q?=22J=2EA=2E_Magall=F3n=22?= <jamagallon-sh/6fXdz2Rs@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101022013544.0fdab0e0-BIo4oXGMtDgJmsy6czSMtA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

(Cc linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)

On 10/22/2010 05:05 AM, J.A. Magall=F3n wrote:

> I have a very strange behaviour with windows networking.
> I have an HTPC, which I access from my Linux desktop. It runs Windows=
 7.
> Network is GigaBit, routed by a Linksys WRT320N running latest DD-WRT=
=2E
> I setup an automount path under /net/htpc with CIFS filesystem.
> I can also access the drives in HTPC via gvfs from Gnome DE.
>=20
> Problem: speed is _VERY_ different.
> R/W through the automount point (CIFS fs), is roughly 7-8 MB/s (ridic=
ulous
> for gigabit speeds).
> R/W through Gnome/gvfs (kind of fuse) goes around 35 - 40 MB/s (400 M=
bits/s),
> that look much better.

What is the kernel version In which you are seeing the problem? I'm not
seeing this on 2.6.36-rc4. Do you have a wired interface as well? Are
you sure that both are using the same network path?

> I have tried with different rsize/wsize in mount, but speed is the sa=
me
> (perhaps I did not get the right values...).

Does the changes reflect in /proc/mounts?


--=20
Suresh Jayaraman
