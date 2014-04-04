From: =?iso-8859-1?Q?Tobias_Doerffel?= <tobias.doerffel-2LT3hlbiLj/X2ID+q72mRQ@public.gmane.org>
Subject: =?iso-8859-1?Q?DFS_with_unix_extensions_or_mfsymlinks/SFU?=
Date: Fri, 4 Apr 2014 12:44:28 +0200
Message-ID: <zarafa.533e8d0c.67da.7d1f165a029de750@zarafa.ed-chemnitz.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: =?iso-8859-1?Q?linux-cifs=40vger=2Ekernel=2Eorg?=
	<linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

we recently deployed a DFS setup based on Samba 4. Things are working w=
ell on Windows computers while we have some troubles with our Linux ter=
minal servers.

Our company's DFS tree is mounted at /dfs using sec=3Dkrb and the multi=
user option. As soon as there are DFS links we get the famous

ls: cannot read symbolic link FOOBAR: Object is remote

message. However we can chdir into the directory (and display its conte=
nts) even though it sometimes doesn't work immediately. When I however =
disable unix extensions (-o nounix) I don't have these issues and DFS r=
eferrals get resolved/mounted immediately, that's why we currently use =
this option. However disabling unix extensions is not an option long te=
rm as our users need software which creates e.g. pipes/FIFOs, does file=
 locking etc. and worked well before (with OpenAFS). This could be achi=
eved by using the =ABsfu=BB option. But if I enable SFU support, I can =
neither create symlinks nor use the mfsymlinks mount option. So whateve=
r approach I chose, there's always something not working properly.

Do you have any advice? Is there any reason why SFU does not work in co=
njunction with MFSymLinks?

More information:

Mount options used:
- mostly working DFS setup without unix extensions: sec=3Dkrb5,nounix,m=
ultiuser,mfsymlinks,dir_mode=3D0700,file_mode=3D0700,noserverino,cache=3D=
strict,mapchars,rsize=3D16777216,wsize=3D16777216,nobrl

- Simple test setup with unix extensions:
sec=3Dkrb5,multiuser,cache=3Dstrict

System: Ubuntu 12.04.4 LTS x86_64
Kernel version: 3.13.6 (current  Ubuntu 14.04 kernel)
CIFS utils: 6.3
Keyutils: 1.5.9

# grep CIFS /boot/config-3.13.0-21-generic=20
CONFIG_CIFS=3Dm
CONFIG_CIFS_STATS=3Dy
# CONFIG_CIFS_STATS2 is not set
CONFIG_CIFS_WEAK_PW_HASH=3Dy
CONFIG_CIFS_UPCALL=3Dy
CONFIG_CIFS_XATTR=3Dy
CONFIG_CIFS_POSIX=3Dy
CONFIG_CIFS_ACL=3Dy
CONFIG_CIFS_DEBUG=3Dy
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_DFS_UPCALL=3Dy
CONFIG_CIFS_SMB2=3Dy
CONFIG_CIFS_FSCACHE=3Dy


Thank you in advance and best regards

Tobias Doerffel


--
Dipl.-Inf. Tobias Doerffel

-----------------------------------------------
EDC Electronic Design Chemnitz GmbH
Technologie-Campus 4, 09126 Chemnitz

Gesch=E4ftsf=FChrer: Dr.-Ing. Steffen Heinz
                 Dipl.-Ing. Andr=E9 Lange
Tel.:            +49 371 52 45 90
=46ax.:            +49 371 52 45 910
E-Mail:          info-2LT3hlbiLj/X2ID+q72mRQ@public.gmane.org

Sitz der Gesellschaft: Chemnitz
HRB 23986, Amtsgericht Chemnitz
USTID: DE258181725
-----------------------------------------------
