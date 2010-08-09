From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 2/7] cifs: implement CIFSCouldBeMFSymlink() and CIFSCheckMFSymlink()
Date: Mon,  9 Aug 2010 19:07:10 +0200
Message-ID: <1281373635-16202-3-git-send-email-metze@samba.org>
References: <1281373635-16202-1-git-send-email-metze@samba.org>
 <1281373635-16202-2-git-send-email-metze@samba.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1281373635-16202-2-git-send-email-metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsproto.h |    4 ++
 fs/cifs/link.c      |   79 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 1f54508..2d97650 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -409,4 +409,8 @@ extern int CIFSSMBSetPosixACL(const int xid, struct cifsTconInfo *tcon,
 extern int CIFSGetExtAttr(const int xid, struct cifsTconInfo *tcon,
 			const int netfid, __u64 *pExtAttrBits, __u64 *pMask);
 extern void cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb);
+extern bool CIFSCouldBeMFSymlink(const struct cifs_fattr *fattr);
+extern int CIFSCheckMFSymlink(struct cifs_fattr *fattr,
+		const unsigned char *path,
+		struct cifs_sb_info *cifs_sb, int xid);
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 12eb491..bec212b 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -91,6 +91,85 @@ CIFSParseMFSymlink(const u8 *buf,
 	return 0;
 }
 
+bool
+CIFSCouldBeMFSymlink(const struct cifs_fattr *fattr)
+{
+	if (!(fattr->cf_mode & S_IFREG))
+		/* it's not a symlink */
+		return false;
+
+	if (fattr->cf_eof != CIFS_MF_SYMLINK_FILE_SIZE)
+		/* it's not a symlink */
+		return false;
+
+	return true;
+}
+
+int
+CIFSCheckMFSymlink(struct cifs_fattr *fattr,
+		   const unsigned char *path,
+		   struct cifs_sb_info *cifs_sb, int xid)
+{
+	int rc;
+	int oplock = 0;
+	__u16 netfid = 0;
+	struct cifsTconInfo *pTcon = cifs_sb->tcon;
+	u8 *buf;
+	char *pbuf;
+	unsigned int bytes_read = 0;
+	int buf_type = CIFS_NO_BUFFER;
+	unsigned int link_len = 0;
+	FILE_ALL_INFO file_info;
+
+	if (!CIFSCouldBeMFSymlink(fattr))
+		/* it's not a symlink */
+		return 0;
+
+	rc = CIFSSMBOpen(xid, pTcon, path, FILE_OPEN, GENERIC_READ,
+			 CREATE_NOT_DIR, &netfid, &oplock, &file_info,
+			 cifs_sb->local_nls,
+			 cifs_sb->mnt_cifs_flags &
+				CIFS_MOUNT_MAP_SPECIAL_CHR);
+	if (rc != 0)
+		return rc;
+
+	if (file_info.EndOfFile != CIFS_MF_SYMLINK_FILE_SIZE) {
+		CIFSSMBClose(xid, pTcon, netfid);
+		/* it's not a symlink */
+		return 0;
+	}
+
+	buf = kmalloc(CIFS_MF_SYMLINK_FILE_SIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	pbuf = buf;
+
+	rc = CIFSSMBRead(xid, pTcon, netfid,
+			 CIFS_MF_SYMLINK_FILE_SIZE /* length */,
+			 0 /* offset */,
+			 &bytes_read, &pbuf, &buf_type);
+	CIFSSMBClose(xid, pTcon, netfid);
+	if (rc != 0) {
+		kfree(buf);
+		return rc;
+	}
+
+	rc = CIFSParseMFSymlink(buf, bytes_read, &link_len, NULL);
+	kfree(buf);
+	if (rc == -EINVAL)
+		/* it's not a symlink */
+		return 0;
+	if (rc != 0)
+		return rc;
+
+	/* it is a symlink */
+	fattr->cf_eof = link_len;
+	fattr->cf_mode &= ~S_IFMT;
+	fattr->cf_mode |= S_IFLNK | S_IRWXU | S_IRWXG | S_IRWXO;
+	fattr->cf_dtype = DT_LNK;
+	return 0;
+}
+
 int
 cifs_hardlink(struct dentry *old_file, struct inode *inode,
 	      struct dentry *direntry)
-- 
1.7.0.4
