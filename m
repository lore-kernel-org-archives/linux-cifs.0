From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 3/7] cifs: implement CIFSQueryMFSymLink()
Date: Thu,  5 Aug 2010 21:50:17 +0200
Message-ID: <1281037821-11479-4-git-send-email-metze@samba.org>
References: <AANLkTimU=0P=qrPeu1KFTPriLfRLo94xHZ5Dy2x0JFrp@mail.gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimU=0P=qrPeu1KFTPriLfRLo94xHZ5Dy2x0JFrp-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/link.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index c0aebdb..a8dcc27 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -91,6 +91,56 @@ CIFSParseMFSymlink(const u8 *buf,
 	return 0;
 }
 
+static int
+CIFSQueryMFSymLink(const int xid, struct cifsTconInfo *tcon,
+		   const unsigned char *searchName, char **symlinkinfo,
+		   const struct nls_table *nls_codepage, int remap)
+{
+	int rc;
+	int oplock = 0;
+	__u16 netfid = 0;
+	u8 *buf;
+	char *pbuf;
+	unsigned int bytes_read = 0;
+	int buf_type = CIFS_NO_BUFFER;
+	unsigned int link_len = 0;
+	FILE_ALL_INFO file_info;
+
+	rc = CIFSSMBOpen(xid, tcon, searchName, FILE_OPEN, GENERIC_READ,
+			 CREATE_NOT_DIR, &netfid, &oplock, &file_info,
+			 nls_codepage, remap);
+	if (rc != 0)
+		return rc;
+
+	if (file_info.EndOfFile != CIFS_MF_SYMLINK_FILE_SIZE) {
+		CIFSSMBClose(xid, tcon, netfid);
+		/* it's not a symlink */
+		return -EINVAL;
+	}
+
+	buf = kmalloc(CIFS_MF_SYMLINK_FILE_SIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	pbuf = buf;
+
+	rc = CIFSSMBRead(xid, tcon, netfid,
+			 CIFS_MF_SYMLINK_FILE_SIZE /* length */,
+			 0 /* offset */,
+			 &bytes_read, &pbuf, &buf_type);
+	CIFSSMBClose(xid, tcon, netfid);
+	if (rc != 0) {
+		kfree(buf);
+		return rc;
+	}
+
+	rc = CIFSParseMFSymlink(buf, bytes_read, &link_len, symlinkinfo);
+	kfree(buf);
+	if (rc != 0)
+		return rc;
+
+	return 0;
+}
+
 int
 CIFSCheckMFSymlink(struct cifs_fattr *fattr,
 		   const unsigned char *path,
-- 
1.7.0.4
