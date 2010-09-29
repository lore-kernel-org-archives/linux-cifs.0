From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] CIFS: Invaldate remote inode on the last close
Date: Wed, 29 Sep 2010 09:38:10 +0400
Message-ID: <AANLkTimj4RB2ZJrRtHnndSrPR7a4VodLHrH8Nv_GufmN@mail.gmail.com>
References: <AANLkTikGiHe3JeryfV8V2PH+yAObqpd5PwGAkvZFidF9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikGiHe3JeryfV8V2PH+yAObqpd5PwGAkvZFidF9-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The little fix of the previous version.

When we close the last file handle of the inode we should invalidate it
to prevent data coherency problem when we open it again but it has been
modified by other clients.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
=A0fs/cifs/file.c | =A0 21 ++++++++++++++++++---
=A01 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index de046e1..68e1789 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -153,9 +153,16 @@ psx_client_can_cache:
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pCifsInode->clientCanCacheAll =3D true;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pCifsInode->clientCanCacheRead =3D true;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Exclusive Oplock granted on ino=
de %p",
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0file->f_path.dentry->d=
_inode);
- =A0 =A0 =A0 } else if ((oplock & 0xF) =3D=3D OPLOCK_READ)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0file->f_path.dentry->d_inode);
+ =A0 =A0 =A0 } else if ((oplock & 0xF) =3D=3D OPLOCK_READ) {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheAll =3D false;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pCifsInode->clientCanCacheRead =3D true;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Level II Oplock granted on inode=
 %p",
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0file->f_path.dentry->d_inode);
+ =A0 =A0 =A0 } else {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheAll =3D false;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheRead =3D false;
+ =A0 =A0 =A0 }

=A0 =A0 =A0 =A0/* will have to change the unlock if we reenable the
=A0 =A0 =A0 =A0 =A0 filemap_fdatawrite (which does not seem necessary *=
/
@@ -211,8 +218,14 @@ client_can_cache:
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pCifsInode->clientCanCacheAll =3D true;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pCifsInode->clientCanCacheRead =3D true;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Exclusive Oplock granted on ino=
de %p", inode);
- =A0 =A0 =A0 } else if ((oplock & 0xF) =3D=3D OPLOCK_READ)
+ =A0 =A0 =A0 } else if ((oplock & 0xF) =3D=3D OPLOCK_READ) {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheAll =3D false;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pCifsInode->clientCanCacheRead =3D true;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Level II Oplock granted on inode=
 %p", inode);
+ =A0 =A0 =A0 } else {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheAll =3D false;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheRead =3D false;
+ =A0 =A0 =A0 }

=A0 =A0 =A0 =A0return rc;
=A0}
@@ -633,6 +646,8 @@ int cifs_close(struct inode *inode, struct file *fi=
le)
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 on this inode, much less write behi=
nd and read ahead */
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_I(inode)->clientCanCacheRead =3D fa=
lse;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_I(inode)->clientCanCacheAll =A0=3D =
false;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_=
STRICT_IO)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 invalidate_remote_inode(i=
node);
=A0 =A0 =A0 =A0}
=A0 =A0 =A0 =A0read_unlock(&GlobalSMBSeslock);
=A0 =A0 =A0 =A0if ((rc =3D=3D 0) && CIFS_I(inode)->write_behind_rc)
--
1.7.2.1
