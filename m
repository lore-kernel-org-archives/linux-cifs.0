From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: DFS with unix extensions or mfsymlinks/SFU
Date: Wed, 07 May 2014 13:08:07 +0100
Message-ID: <1399464487.2621.8.camel@sachin-laptop>
References: <zarafa.533e8d0c.67da.7d1f165a029de750@zarafa.ed-chemnitz.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Tobias Doerffel <tobias.doerffel-2LT3hlbiLj/X2ID+q72mRQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <zarafa.533e8d0c.67da.7d1f165a029de750-Re+uX9gtWIdJ209wn1+v+yQaj01YtLkH@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2014-04-04 at 12:44 +0200, Tobias Doerffel wrote:
> Hi,
>=20
> we recently deployed a DFS setup based on Samba 4. Things are working=
 well on Windows computers while we have some troubles with our Linux t=
erminal servers.
>=20
> Our company's DFS tree is mounted at /dfs using sec=3Dkrb and the mul=
tiuser option. As soon as there are DFS links we get the famous
>=20
> ls: cannot read symbolic link FOOBAR: Object is remote
>=20
> message. However we can chdir into the directory (and display its con=
tents) even though it sometimes doesn't work immediately. When I howeve=
r disable unix extensions (-o nounix) I don't have these issues and DFS=
 referrals get resolved/mounted immediately, that's why we currently us=
e this option. However disabling unix extensions is not an option long =
term as our users need software which creates e.g. pipes/FIFOs, does fi=
le locking etc. and worked well before (with OpenAFS). This could be ac=
hieved by using the =C2=ABsfu=C2=BB option. But if I enable SFU support=
, I can neither create symlinks nor use the mfsymlinks mount option. So=
 whatever approach I chose, there's always something not working proper=
ly.
>=20
> Do you have any advice? Is there any reason why SFU does not work in =
conjunction with MFSymLinks?
>=20

Hello Tobais,

The following patch should help you.
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D924e3fa48c627ad45d3be9412a93df34ab0fb482

This is probably not yet included in the kernel you are using. Maybe yo=
u
can try recompiling your kernel with this patch included and see if it
helps you.

Regards
Sachin Prabhu

> More information:
>=20
> Mount options used:
> - mostly working DFS setup without unix extensions: sec=3Dkrb5,nounix=
,multiuser,mfsymlinks,dir_mode=3D0700,file_mode=3D0700,noserverino,cach=
e=3Dstrict,mapchars,rsize=3D16777216,wsize=3D16777216,nobrl
>=20
> - Simple test setup with unix extensions:
> sec=3Dkrb5,multiuser,cache=3Dstrict
>=20
> System: Ubuntu 12.04.4 LTS x86_64
> Kernel version: 3.13.6 (current  Ubuntu 14.04 kernel)
> CIFS utils: 6.3
> Keyutils: 1.5.9
>=20
> # grep CIFS /boot/config-3.13.0-21-generic=20
> CONFIG_CIFS=3Dm
> CONFIG_CIFS_STATS=3Dy
> # CONFIG_CIFS_STATS2 is not set
> CONFIG_CIFS_WEAK_PW_HASH=3Dy
> CONFIG_CIFS_UPCALL=3Dy
> CONFIG_CIFS_XATTR=3Dy
> CONFIG_CIFS_POSIX=3Dy
> CONFIG_CIFS_ACL=3Dy
> CONFIG_CIFS_DEBUG=3Dy
> # CONFIG_CIFS_DEBUG2 is not set
> CONFIG_CIFS_DFS_UPCALL=3Dy
> CONFIG_CIFS_SMB2=3Dy
> CONFIG_CIFS_FSCACHE=3Dy
>=20
>=20
> Thank you in advance and best regards
>=20
> Tobias Doerffel
>=20
>=20
> --
> Dipl.-Inf. Tobias Doerffel
>=20
> -----------------------------------------------
> EDC Electronic Design Chemnitz GmbH
> Technologie-Campus 4, 09126 Chemnitz
>=20
> Gesch=C3=A4ftsf=C3=BChrer: Dr.-Ing. Steffen Heinz
>                  Dipl.-Ing. Andr=C3=A9 Lange
> Tel.:            +49 371 52 45 90
> Fax.:            +49 371 52 45 910
> E-Mail:          info-2LT3hlbiLj/X2ID+q72mRQ@public.gmane.org
>=20
> Sitz der Gesellschaft: Chemnitz
> HRB 23986, Amtsgericht Chemnitz
> USTID: DE258181725
> -----------------------------------------------
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
