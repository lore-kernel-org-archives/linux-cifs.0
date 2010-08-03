From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 5/8] cifs: implement CIFSCheckMFSymlink()
Date: Tue,  3 Aug 2010 17:05:57 +0200
Message-ID: <1280847960-16371-6-git-send-email-metze@samba.org>
References: <1280847960-16371-1-git-send-email-metze@samba.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280847960-16371-1-git-send-email-metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/link.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 33307b1..f7636f9 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -113,6 +113,66 @@ CIFSCheckMFSymlink(struct cifs_fattr *fattr,
 		   const unsigned char *path,
 		   struct cifs_sb_info *cifs_sb, int xid)
 {
+	int rc;
+	int oplock = 0;
+	__u16 netfid = 0;
+	struct cifsTconInfo *pTcon = cifs_sb->tcon;
+	u8 buf[CIFS_MF_SYMLINK_FILE_SIZE];
+	char *pbuf = buf;
+	unsigned int bytes_read = 0;
+	int buf_type = CIFS_NO_BUFFER;
+	unsigned int link_len = 0;
+	FILE_ALL_INFO file_info;
+
+	if (!(fattr->cf_mode & S_IFREG)) {
+		/* it's not a symlink */
+		return 0;
+	}
+
+	if (fattr->cf_eof != CIFS_MF_SYMLINK_FILE_SIZE) {
+		/* it's not a symlink */
+		return 0;
+	}
+
+	rc = CIFSSMBOpen(xid, pTcon, path, FILE_OPEN, GENERIC_READ,
+			 CREATE_NOT_DIR, &netfid, &oplock, &file_info,
+			 cifs_sb->local_nls,
+			 cifs_sb->mnt_cifs_flags &
+				CIFS_MOUNT_MAP_SPECIAL_CHR);
+	if (rc != 0) {
+		return rc;
+	}
+
+	if (file_info.EndOfFile != CIFS_MF_SYMLINK_FILE_SIZE) {
+		CIFSSMBClose(xid, pTcon, netfid);
+		/* it's not a symlink */
+		return 0;
+	}
+
+	/* Read header */
+	rc = CIFSSMBRead(xid, pTcon, netfid,
+			 CIFS_MF_SYMLINK_FILE_SIZE /* length */,
+			 0 /* offset */,
+			 &bytes_read, &pbuf, &buf_type);
+	CIFSSMBClose(xid, pTcon, netfid);
+	if (rc != 0) {
+		return rc;
+	}
+
+	rc = CIFSParseMFSymlink(buf, bytes_read, &link_len, NULL);
+	if (rc == EINVAL) {
+		/* it's not a symlink */
+		return 0;
+	}
+	if (rc != 0) {
+		return rc;
+	}
+
+	/* it is a symlink */
+	fattr->cf_eof = link_len;
+	fattr->cf_mode &= ~S_IFMT;
+	fattr->cf_mode |= S_IFLNK;
+	fattr->cf_dtype = DT_LNK;
 	return 0;
 }
 
-- 
1.7.0.4
