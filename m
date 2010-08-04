From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 3/8] cifs: add CIFSCheckMFSymlink() as stub
Date: Wed,  4 Aug 2010 16:11:44 +0200
Message-ID: <1280931109-22380-4-git-send-email-metze@samba.org>
References: <AANLkTinJ1WRBT_Q3TqOZdMQExV66LSUAPG4c01yK-XRK@mail.gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinJ1WRBT_Q3TqOZdMQExV66LSUAPG4c01yK-XRK-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsproto.h |    3 +++
 fs/cifs/inode.c     |    7 +++++++
 fs/cifs/link.c      |    8 ++++++++
 3 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 2eaebbd..e94e095 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -409,4 +409,7 @@ extern int CIFSSMBSetPosixACL(const int xid, struct cifsTconInfo *tcon,
 extern int CIFSGetExtAttr(const int xid, struct cifsTconInfo *tcon,
 			const int netfid, __u64 *pExtAttrBits, __u64 *pMask);
 extern void cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb);
+extern int CIFSCheckMFSymlink(struct cifs_fattr *fattr,
+		const unsigned char *path,
+		struct cifs_sb_info *cifs_sb, int xid);
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index a15b3a9..c4121de 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -661,6 +661,13 @@ int cifs_get_inode_info(struct inode **pinode,
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL)
 		cifs_sfu_mode(&fattr, full_path, cifs_sb, xid);
 
+	/* query for SFU type info if supported and needed */
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
+		tmprc = CIFSCheckMFSymlink(&fattr, full_path, cifs_sb, xid);
+		if (tmprc)
+			cFYI(1, "CIFSCheckMFSymlink: %d", tmprc);
+	}
+
 	if (!*pinode) {
 		*pinode = cifs_iget(sb, &fattr);
 		if (!*pinode)
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 2358a5f..985373c 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -48,6 +48,14 @@ CIFSQueryMFSymLink(const int xid, struct cifsTconInfo *tcon,
 }
 
 int
+CIFSCheckMFSymlink(struct cifs_fattr *fattr,
+		   const unsigned char *path,
+		   struct cifs_sb_info *cifs_sb, int xid)
+{
+	return 0;
+}
+
+int
 cifs_hardlink(struct dentry *old_file, struct inode *inode,
 	      struct dentry *direntry)
 {
-- 
1.7.0.4
