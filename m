From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: don't compare uniqueids in cifs_prime_dcache unless server inode numbers are in use
Date: Tue, 18 Dec 2012 06:46:22 -0500
Message-ID: <1355831182-21555-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oliver.Moessinger-Lx0bRpaNhpazQB+pC5nmwQ@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Oliver reported that commit cd60042c caused his cifs mounts to
continually thrash through new inodes on readdir. His servers are not
sending inode numbers (or he's not using them), and the new test in
that function doesn't account for that sort of setup correctly.

If we're not using server inode numbers, then assume that the inode
attached to the dentry hasn't changed. Go ahead and update the
attributes in place, but keep the same inode number.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v3.5+
Reported-and-Tested-by: Oliver M=C3=B6ssinger <Oliver.Moessinger@ichaus=
=2Ede>
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
