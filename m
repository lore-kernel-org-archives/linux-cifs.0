From: Jan Klos <honza.klos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cifs: Fix inability to write files >2GB to SMB2/3 shares (FIXED)
Date: Sun, 06 Oct 2013 20:37:56 +0200
Message-ID: <5251AE04.4030206@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	Jan Klos <honza.klos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When connecting to SMB2/3 shares, maximum file size is set to non-LFS maximum in superblock. This is due to cap_large_files bit being different for 
SMB1 and SMB2/3 (where it is just an internal flag that is not negotiated and the SMB1 one corresponds to multichannel capability) while capabilities 
are checked always for the SMB1 bit in cifs_read_super().

The patch fixes this by checking for the correct bit according to the protocol version.

Sorry for the repost, GMail messed up my previous mail (and I even confirmed it on the mailing list!), sorry!


Signed-off-by: Jan Klos <honza.klos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

---

diff -uprN a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c	2013-10-05 16:18:07.000000000 +0200
+++ b/fs/cifs/cifsfs.c	2013-10-06 16:18:13.488378000 +0200
@@ -120,14 +120,16 @@ cifs_read_super(struct super_block *sb)
  {
  	struct inode *inode;
  	struct cifs_sb_info *cifs_sb;
+	struct cifs_tcon *tcon;
  	int rc = 0;

  	cifs_sb = CIFS_SB(sb);
+	tcon = cifs_sb_master_tcon(cifs_sb);

  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIXACL)
  		sb->s_flags |= MS_POSIXACL;

-	if (cifs_sb_master_tcon(cifs_sb)->ses->capabilities & CAP_LARGE_FILES)
+	if (tcon->ses->capabilities & tcon->ses->server->vals->cap_large_files)
  		sb->s_maxbytes = MAX_LFS_FILESIZE;
  	else
  		sb->s_maxbytes = MAX_NON_LFS;
@@ -147,7 +149,7 @@ cifs_read_super(struct super_block *sb)
  		goto out_no_root;
  	}

-	if (cifs_sb_master_tcon(cifs_sb)->nocase)
+	if (tcon->nocase)
  		sb->s_d_op = &cifs_ci_dentry_ops;
  	else
  		sb->s_d_op = &cifs_dentry_ops;
