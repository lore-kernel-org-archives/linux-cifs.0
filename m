From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 1/7] cifs: implement CIFSParseMFSymlink()
Date: Thu,  5 Aug 2010 21:50:15 +0200
Message-ID: <1281037821-11479-2-git-send-email-metze@samba.org>
References: <AANLkTimU=0P=qrPeu1KFTPriLfRLo94xHZ5Dy2x0JFrp@mail.gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimU=0P=qrPeu1KFTPriLfRLo94xHZ5Dy2x0JFrp-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/link.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 473ca80..12eb491 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -28,6 +28,68 @@
 #include "cifsproto.h"
 #include "cifs_debug.h"
 #include "cifs_fs_sb.h"
+#include "md5.h"
+
+#define CIFS_MF_SYMLINK_LEN_OFFSET (4+1)
+#define CIFS_MF_SYMLINK_MD5_OFFSET (CIFS_MF_SYMLINK_LEN_OFFSET+(4+1))
+#define CIFS_MF_SYMLINK_LINK_OFFSET (CIFS_MF_SYMLINK_MD5_OFFSET+(32+1))
+#define CIFS_MF_SYMLINK_LINK_MAXLEN (1024)
+#define CIFS_MF_SYMLINK_FILE_SIZE \
+	(CIFS_MF_SYMLINK_LINK_OFFSET + CIFS_MF_SYMLINK_LINK_MAXLEN)
+
+#define CIFS_MF_SYMLINK_LEN_FORMAT "XSym\n%04u\n"
+#define CIFS_MF_SYMLINK_MD5_FORMAT \
+	"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x\n"
+#define CIFS_MF_SYMLINK_MD5_ARGS(md5_hash) \
+	md5_hash[0],  md5_hash[1],  md5_hash[2],  md5_hash[3], \
+	md5_hash[4],  md5_hash[5],  md5_hash[6],  md5_hash[7], \
+	md5_hash[8],  md5_hash[9],  md5_hash[10], md5_hash[11],\
+	md5_hash[12], md5_hash[13], md5_hash[14], md5_hash[15]
+
+static int
+CIFSParseMFSymlink(const u8 *buf,
+		   unsigned int buf_len,
+		   unsigned int *_link_len,
+		   char **_link_str)
+{
+	int rc;
+	unsigned int link_len;
+	const char *md5_str1;
+	const char *link_str;
+	struct MD5Context md5_ctx;
+	u8 md5_hash[16];
+	char md5_str2[34];
+
+	if (buf_len != CIFS_MF_SYMLINK_FILE_SIZE)
+		return -EINVAL;
+
+	md5_str1 = (const char *)&buf[CIFS_MF_SYMLINK_MD5_OFFSET];
+	link_str = (const char *)&buf[CIFS_MF_SYMLINK_LINK_OFFSET];
+
+	rc = sscanf(buf, CIFS_MF_SYMLINK_LEN_FORMAT, &link_len);
+	if (rc != 1)
+		return -EINVAL;
+
+	cifs_MD5_init(&md5_ctx);
+	cifs_MD5_update(&md5_ctx, (const u8 *)link_str, link_len);
+	cifs_MD5_final(md5_hash, &md5_ctx);
+
+	snprintf(md5_str2, sizeof(md5_str2),
+		 CIFS_MF_SYMLINK_MD5_FORMAT,
+		 CIFS_MF_SYMLINK_MD5_ARGS(md5_hash));
+
+	if (strncmp(md5_str1, md5_str2, 17) != 0)
+		return -EINVAL;
+
+	if (_link_str) {
+		*_link_str = kstrndup(link_str, link_len, GFP_KERNEL);
+		if (!*_link_str)
+			return -ENOMEM;
+	}
+
+	*_link_len = link_len;
+	return 0;
+}
 
 int
 cifs_hardlink(struct dentry *old_file, struct inode *inode,
-- 
1.7.0.4
