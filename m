From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 5/7] cifs: implement CIFSCreateMFSymLink()
Date: Mon,  9 Aug 2010 19:07:13 +0200
Message-ID: <1281373635-16202-6-git-send-email-metze@samba.org>
References: <1281373635-16202-1-git-send-email-metze@samba.org>
 <1281373635-16202-2-git-send-email-metze@samba.org>
 <1281373635-16202-3-git-send-email-metze@samba.org>
 <1281373635-16202-4-git-send-email-metze@samba.org>
 <1281373635-16202-5-git-send-email-metze@samba.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1281373635-16202-5-git-send-email-metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/link.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 0473a86..1b2a8c9 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -133,6 +133,51 @@ CIFSFormatMFSymlink(u8 *buf, unsigned int buf_len, const char *link_str)
 	return 0;
 }
 
+static int
+CIFSCreateMFSymLink(const int xid, struct cifsTconInfo *tcon,
+		    const char *fromName, const char *toName,
+		    const struct nls_table *nls_codepage, int remap)
+{
+	int rc;
+	int oplock = 0;
+	__u16 netfid = 0;
+	u8 *buf;
+	unsigned int bytes_written = 0;
+
+	buf = kmalloc(CIFS_MF_SYMLINK_FILE_SIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	rc = CIFSFormatMFSymlink(buf, CIFS_MF_SYMLINK_FILE_SIZE, toName);
+	if (rc != 0) {
+		kfree(buf);
+		return rc;
+	}
+
+	rc = CIFSSMBOpen(xid, tcon, fromName, FILE_CREATE, GENERIC_WRITE,
+			 CREATE_NOT_DIR, &netfid, &oplock, NULL,
+			 nls_codepage, remap);
+	if (rc != 0) {
+		kfree(buf);
+		return rc;
+	}
+
+	rc = CIFSSMBWrite(xid, tcon, netfid,
+			  CIFS_MF_SYMLINK_FILE_SIZE /* length */,
+			  0 /* offset */,
+			  &bytes_written, buf, NULL, 0);
+	CIFSSMBClose(xid, tcon, netfid);
+	kfree(buf);
+	if (rc != 0)
+		return rc;
+
+	if (bytes_written != CIFS_MF_SYMLINK_FILE_SIZE)
+		return -EIO;
+
+	return 0;
+}
+
+static int
 CIFSQueryMFSymLink(const int xid, struct cifsTconInfo *tcon,
 		   const unsigned char *searchName, char **symlinkinfo,
 		   const struct nls_table *nls_codepage, int remap)
-- 
1.7.0.4
