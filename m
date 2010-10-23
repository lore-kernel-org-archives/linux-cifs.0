From: "J.A. =?ISO-8859-1?B?TWFnYWxs824=?=" <jamagallon-sh/6fXdz2Rs@public.gmane.org>
Subject: Re: CIFS is slooow, gvfs is fast
Date: Sun, 24 Oct 2010 01:30:38 +0200
Message-ID: <20101024013038.057442c0@werewolf.home>
References: <20101022013544.0fdab0e0@werewolf.home>
	<4CC16B1E.4060709@suse.de>
	<20101023004636.1acdd81c@werewolf.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101023004636.1acdd81c-BIo4oXGMtDgJmsy6czSMtA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 23 Oct 2010 00:46:36 +0200, "J.A. Magall=F3n" <jamagallon@ono.c=
om> wrote:

> On Fri, 22 Oct 2010 16:14:46 +0530, Suresh Jayaraman <sjayaraman@suse=
=2Ede> wrote:
>=20
> > (Cc linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
> >=20
> > On 10/22/2010 05:05 AM, J.A. Magall=F3n wrote:
> >=20
> > > I have a very strange behaviour with windows networking.
> > > I have an HTPC, which I access from my Linux desktop. It runs Win=
dows 7.
> > > Network is GigaBit, routed by a Linksys WRT320N running latest DD=
-WRT.
> > > I setup an automount path under /net/htpc with CIFS filesystem.
> > > I can also access the drives in HTPC via gvfs from Gnome DE.
> > >=20
> > > Problem: speed is _VERY_ different.
> > > R/W through the automount point (CIFS fs), is roughly 7-8 MB/s (r=
idiculous
> > > for gigabit speeds).
> > > R/W through Gnome/gvfs (kind of fuse) goes around 35 - 40 MB/s (4=
00 Mbits/s),
> > > that look much better.
> >=20
> > What is the kernel version In which you are seeing the problem? I'm=
 not
>=20
> Its just new 2.6.36 final, mandriva distro kernel.
>=20
> > seeing this on 2.6.36-rc4. Do you have a wired interface as well? A=
re
>=20
> Yes, boxes are all wired to the 320N router, at gigabit speeds.
> Just to double check, I also probed with my netbook with 100Mb ehtern=
et.
> The effect is less obvious, but writing to the Win7 box through the
> cifs automount path goes at 3.5-4.0 Mb/s, and with gvfs it reaches
> 7.5 Mb/s.
>=20
> > you sure that both are using the same network path?
> >=20
>=20
> If you mean hardware network path (cabling, router), yes.
> For file paths, CIFS fs is under /net/htpc/media, and gvfs uses a mou=
nt
> point on '~/.gvfs/media on htpc'.
>=20
> And here comes the weird part. To rule out the desktop environment fa=
ctor,
> I tried a dd in both paths. On /net, I get 16.6 MB/s, and on
> ~/.gvfs/xxx, I just get 5.5 MB/s. I really don't understand anything.=
=2E.
> things get reversed depending if you use a gui or commandline.
>=20
> Weird, really weird...
>=20

Well, to sort things out, I did some more tests (this does not mean thi=
ngs
get any closer to be clear for me at least...).

Network card state in linux side:

werewolf:/etc/autofs# ethtool eth0
Settings for eth0:
    Supported ports: [ TP ]
    Supported link modes:   10baseT/Half 10baseT/Full
                            100baseT/Half 100baseT/Full
                            1000baseT/Full
    Supports auto-negotiation: Yes
    Advertised link modes:  10baseT/Half 10baseT/Full
                            100baseT/Half 100baseT/Full
                            1000baseT/Full
    Advertised auto-negotiation: Yes
    Speed: 1000Mb/s
    Duplex: Full
    Port: Twisted Pair
    PHYAD: 0
    Transceiver: internal
    Auto-negotiation: on
    Supports Wake-on: pg
    Wake-on: d
    Current message level: 0x00000000 (0)
    Link detected: yes
   =20
Raw iperf behaviour:

lnx -> win: [  3]  0.0-10.0 sec    988 MBytes    828 Mbits/sec
win -> lnx: [  4]  0.0-10.0 sec    333 MBytes    279 Mbits/sec

Don't know why the difference, but anyways worst speed is 280 Mb/s.

auto.master:
	/net/htpc   file:/etc/autofs/auto.htpc
auto.htpc:
	media -fstype=3Dcifs,credentials=3D/etc/autofs/credentials/htpc,iochar=
set=3Dutf8,uid=3D3001,gid=3D3000 ://htpc/media

Times for gnome-ui-copy are approximate, speed is what the copy window =
says.

Case A: automount via cifs.
/proc/mounts:
	/etc/autofs/auto.htpc /net/htpc autofs rw,relatime,fd=3D6,pgrp=3D14361=
,timeout=3D300,minproto=3D5,maxproto=3D5,indirect 0 0
	//htpc/media/ /net/htpc/media cifs rw,relatime,unc=3D\\htpc\media,user=
name=3Dmedia,uid=3D0,noforceuid,gid=3D0,noforcegid,addr=3D192.168.1.20,=
file_mode=3D0755,dir_mode=3D0755,serverino,rsize=3D130048,wsize=3D57344=
 0 0

- dd if=3D~/file of=3Dfile.dd bs=3D1M
  292538368 bytes (293 MB) copied, 8.44771 s, 34.6 MB/s
- time cp ~/file file.cp: real    0m7.429s
- gnome UI copy: 39s, 7.8 MB/s

Case B: network mount via nautilus.
/proc/mounts:
	/etc/autofs/auto.htpc /net/htpc autofs rw,relatime,fd=3D6,pgrp=3D14361=
,timeout=3D300,minproto=3D5,maxproto=3D5,indirect 0 0
	gvfs-fuse-daemon /home/magallon/.gvfs fuse.gvfs-fuse-daemon rw,nosuid,=
nodev,relatime,user_id=3D3001,group_id=3D3000 0 0

- dd if=3D~/file of=3Dfile.dd bs=3D1M
  292538368 bytes (293 MB) copied, 50.4364 s, 5.8 MB/s
- time cp ~/file file.cp: real    0m50.151s
- gnome UI copy: 8s, 33.2 MB/s

And the best of all:

werewolf:~> time smbclient -U media%XXXXX //htpc/media -c 'put file'
Domain=3D[HOME] OS=3D[Windows 7 Enterprise 7600] Server=3D[Windows 7 En=
terprise 6.1]
putting file file as \file (66345.1 kb/s) (average 66345.1 kb/s)

real    0m4.318s
user    0m0.466s
sys 0m0.553s

Can anybody tell me whats going here...??
It looks just like gui tools behave just in reverse of cli, and that a =
plain
smbclient is faster that cifs. I'm really confused...

--=20
J.A. Magallon <jamagallon()ono!com>     \               Software is lik=
e sex:
                                         \         It's better when it'=
s free
