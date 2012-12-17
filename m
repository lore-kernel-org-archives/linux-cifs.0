From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: your patch 1165211 on pachwork.kernel.org
Date: Mon, 17 Dec 2012 09:12:25 -0500
Message-ID: <20121217091225.5efa8f65@tlielax.poochiereds.net>
References: <104938ABBE1D0049BEB4AC72072B72512DDC47E9@MAILSRV2.ic-haus.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "=?ISO-8859-1?B?TfZzc2luZ2VyLA==?= Oliver"
	<Oliver.Moessinger-Lx0bRpaNhpazQB+pC5nmwQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <104938ABBE1D0049BEB4AC72072B72512DDC47E9-p8sJbJtQAZFnt6g797hzN/4CVqVLow9K@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 17 Dec 2012 09:43:08 +0000
"M=F6ssinger, Oliver" <Oliver.Moessinger-Lx0bRpaNhpazQB+pC5nmwQ@public.gmane.org> wrote:

> Hi Jeff,
>=20
> we are using cifs in our company to access NetApp and Windows exports=
=2E With our old installation (kernel version 2.6.37.6) we don't have p=
roblems. But with the new installation (kernel version 3.4.11) we found=
 an issue. Have a look at this:
>=20
> net ms@cluster1:~> cat /proc/version
> Linux version 2.6.37.6-0.20-desktop (geeko@buildhost) (gcc version 4.=
5.1 20101208 [gcc-4_5-branch revision 167585] (SUSE Linux) ) #1 SMP PRE=
EMPT 2011-12-19 23:39:38 +0100
> net ms@cluster1:~> ls -i /smb/lw_t/
> 16136 A1 Fehler Start.bmp  16140 CHIPLAB.SRC  16144 hlkt-kram    1614=
8 PROD  16152 Software   16156 User
> 16137 Assy                 16141 CHIPLABW     16145 IC           1614=
9 Qual  16153 tent       16157 vslick
> 16138 Band                 16142 Debug        16146 Mess         1615=
0 REF   16154 Thumbs.db  16158 WP ROOT. SF
> 16139 BURNIN               16143 expunged     16147 OS2-Treiber  1615=
1 SOFT  16155 TOOLS
> net ms@cluster1:~> ls -i /smb/lw_t/
> 16136 A1 Fehler Start.bmp  16140 CHIPLAB.SRC  16144 hlkt-kram    1614=
8 PROD  16152 Software   16156 User
> 16137 Assy                 16141 CHIPLABW     16145 IC           1614=
9 Qual  16153 tent       16157 vslick
> 16138 Band                 16142 Debug        16146 Mess         1615=
0 REF   16154 Thumbs.db  16158 WP ROOT. SF
> 16139 BURNIN               16143 expunged     16147 OS2-Treiber  1615=
1 SOFT  16155 TOOLS
>=20
>=20
> local ms@itms2:~> cat /proc/version
> Linux version 3.4.11-2.16-desktop (geeko@buildhost) (gcc version 4.7.=
1 20120723 [gcc-4_7-branch revision 189773] (SUSE Linux) ) #1 SMP PREEM=
PT Wed Sep 26 17:05:00 UTC 2012 (259fc87)
> local ms@itms2:~> ls -i /smb/lw_t/
> 1684245 A1 Fehler Start.bmp  1684250 CHIPLABW   1684255 Mess         =
1684260 SOFT       1684265 User
> 1684246 Assy                 1684251 Debug      1684256 OS2-Treiber  =
1684261 Software   1684266 vslick
> 1684247 Band                 1684252 expunged   1684257 PROD         =
1684262 tent       1684267 WP ROOT. SF
> 1684248 BURNIN               1684253 hlkt-kram  1684258 Qual         =
1684263 Thumbs.db
> 1684249 CHIPLAB.SRC          1684254 IC         1684259 REF          =
1684264 TOOLS
> local ms@itms2:~> ls -i /smb/lw_t/
> 1684268 A1 Fehler Start.bmp  1684273 CHIPLABW   1684278 Mess         =
1684283 SOFT       1684288 User
> 1684269 Assy                 1684274 Debug      1684279 OS2-Treiber  =
1684284 Software   1684289 vslick
> 1684270 Band                 1684275 expunged   1684280 PROD         =
1684285 tent       1684290 WP ROOT. SF
> 1684271 BURNIN               1684276 hlkt-kram  1684281 Qual         =
1684286 Thumbs.db
> 1684272 CHIPLAB.SRC          1684277 IC         1684282 REF          =
1684287 TOOLS
>=20
>=20
> You see on itms2 the inods are not the same on the second ls command.=
 This causes in some strange problems with programs that expect the sam=
e inode for folder. For example the bash command line give an error mes=
sage:
>=20
> local ms@itms2:/smb/lw_t/BURNIN> ls
> bi         BITEST  -BURNIN.CFG  prj   Protokolle                    T=
L_LIFET
> birel.cmd  burn_3  DOC          PROG  temperatur_schrank_programme  w=
as steht wo.txt
> local ms@itms2:/smb/lw_t/BURNIN>
>=20
> # now 'ls -i /smb/lw_t' on a different shell
>=20
> local ms@itms2:/smb/lw_t/BURNIN>
> shell-init: error retrieving current directory: getcwd: cannot access=
 parent directories: No such file or directory
> pwd: error retrieving current directory: getcwd: cannot access parent=
 directories: No such file or directory
> local ms@itms2:/smb/lw_t/BURNIN> ls
> -BURNIN.CFG  DOC   Protokolle  bi         burn_3  temperatur_schrank_=
programme
> BITEST       PROG  TL_LIFET    birel.cmd  prj     was steht wo.txt
> shell-init: error retrieving current directory: getcwd: cannot access=
 parent directories: No such file or directory
> pwd: error retrieving current directory: getcwd: cannot access parent=
 directories: No such file or directory
>=20
>=20
> After some research i found your patch:
>=20
> https://patchwork.kernel.org/patch/1165211/
>=20
> I reverted it completely and compiled it. The problem is gone.
>=20
> Do you know this bug? Do you have a fix for it?
>=20

You're the first to have reported it, AFAIK. Does something like this
patch help? This one is against mainline kernels, so you may need to
backport it for something 3.4-ish.

---------------------[snip]-----------------

[PATCH] cifs: don't compare uniqueids in cifs_prime_dcache unless serve=
r inode numbers are in use

Oliver reported that commit cd60042c caused his cifs mounts to
continually thrash through new inodes on readdir. His servers are not
sending inode numbers (or he's not using them), and the new test in
that function doesn't account for that sort of setup correctly.

If we're not using server inode numbers, then assume that the inode
attached to the dentry hasn't changed. Go ahead and update the
attributes in place, but keep the same inode number.

Reported-by: M=F6ssinger, Oliver <Oliver.Moessinger-Lx0bRpaNhpazQB+pC5nmwQ@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/readdir.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 6002fdc..cdd6ff4 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -78,6 +78,7 @@ cifs_prime_dcache(struct dentry *parent, struct qstr =
*name,
 	struct dentry *dentry, *alias;
 	struct inode *inode;
 	struct super_block *sb =3D parent->d_inode->i_sb;
+	struct cifs_sb_info *cifs_sb =3D CIFS_SB(sb);
=20
 	cFYI(1, "%s: for %s", __func__, name->name);
=20
@@ -91,10 +92,20 @@ cifs_prime_dcache(struct dentry *parent, struct qst=
r *name,
 		int err;
=20
 		inode =3D dentry->d_inode;
-		/* update inode in place if i_ino didn't change */
-		if (inode && CIFS_I(inode)->uniqueid =3D=3D fattr->cf_uniqueid) {
-			cifs_fattr_to_inode(inode, fattr);
-			goto out;
+		if (inode) {
+			/*
+			 * If we're generating inode numbers, then we don't
+			 * want to clobber the existing one with the one that
+			 * the readdir code created.
+			 */
+			if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM))
+				fattr->cf_uniqueid =3D CIFS_I(inode)->uniqueid;
+
+			/* update inode in place if i_ino didn't change */
+			if (CIFS_I(inode)->uniqueid =3D=3D fattr->cf_uniqueid) {
+				cifs_fattr_to_inode(inode, fattr);
+				goto out;
+			}
 		}
 		err =3D d_invalidate(dentry);
 		dput(dentry);
--=20
1.7.11.7
