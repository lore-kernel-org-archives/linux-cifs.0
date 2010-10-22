From: "J.A. =?ISO-8859-1?B?TWFnYWxs824=?=" <jamagallon@ono.com>
Subject: Re: CIFS is slooow, gvfs is fast
Date: Sat, 23 Oct 2010 00:46:36 +0200
Message-ID: <20101023004636.1acdd81c@werewolf.home>
References: <20101022013544.0fdab0e0@werewolf.home>
 <4CC16B1E.4060709@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-cifs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4CC16B1E.4060709@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, 22 Oct 2010 16:14:46 +0530, Suresh Jayaraman <sjayaraman@suse.d=
e> wrote:

> (Cc linux-cifs@vger.kernel.org)
>=20
> On 10/22/2010 05:05 AM, J.A. Magall=F3n wrote:
>=20
> > I have a very strange behaviour with windows networking.
> > I have an HTPC, which I access from my Linux desktop. It runs Windo=
ws 7.
> > Network is GigaBit, routed by a Linksys WRT320N running latest DD-W=
RT.
> > I setup an automount path under /net/htpc with CIFS filesystem.
> > I can also access the drives in HTPC via gvfs from Gnome DE.
> >=20
> > Problem: speed is _VERY_ different.
> > R/W through the automount point (CIFS fs), is roughly 7-8 MB/s (rid=
iculous
> > for gigabit speeds).
> > R/W through Gnome/gvfs (kind of fuse) goes around 35 - 40 MB/s (400=
 Mbits/s),
> > that look much better.
>=20
> What is the kernel version In which you are seeing the problem? I'm n=
ot

Its just new 2.6.36 final, mandriva distro kernel.

> seeing this on 2.6.36-rc4. Do you have a wired interface as well? Are

Yes, boxes are all wired to the 320N router, at gigabit speeds.
Just to double check, I also probed with my netbook with 100Mb ehternet=
=2E
The effect is less obvious, but writing to the Win7 box through the
cifs automount path goes at 3.5-4.0 Mb/s, and with gvfs it reaches
7.5 Mb/s.

> you sure that both are using the same network path?
>=20

If you mean hardware network path (cabling, router), yes.
=46or file paths, CIFS fs is under /net/htpc/media, and gvfs uses a mou=
nt
point on '~/.gvfs/media on htpc'.

And here comes the weird part. To rule out the desktop environment fact=
or,
I tried a dd in both paths. On /net, I get 16.6 MB/s, and on
~/.gvfs/xxx, I just get 5.5 MB/s. I really don't understand anything...
things get reversed depending if you use a gui or commandline.

Weird, really weird...

--=20
J.A. Magallon <jamagallon()ono!com>     \               Software is lik=
e sex:
                                         \         It's better when it'=
s free
