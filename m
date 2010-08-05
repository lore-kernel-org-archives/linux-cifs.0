From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 4/7] cifs: implement CIFSFormatMFSymlink()
Date: Thu,  5 Aug 2010 21:50:18 +0200
Message-ID: <1281037821-11479-5-git-send-email-metze@samba.org>
References: <AANLkTimU=0P=qrPeu1KFTPriLfRLo94xHZ5Dy2x0JFrp@mail.gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimU=0P=qrPeu1KFTPriLfRLo94xHZ5Dy2x0JFrp-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/link.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index a8dcc27..500d912 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -92,6 +92,47 @@ CIFSParseMFSymlink(const u8 *buf,
 }
 
 static int
+CIFSFormatMFSymlink(u8 *buf, unsigned int buf_len, const char *link_str)
+{
+	unsigned int link_len;
+	unsigned int ofs;
+	struct MD5Context md5_ctx;
+	u8 md5_hash[16];
+
+	if (buf_len != CIFS_MF_SYMLINK_FILE_SIZE)
+		return -EINVAL;
+
+	link_len = strlen(link_str);
+
+	if (link_len > CIFS_MF_SYMLINK_LINK_MAXLEN)
+		return -ENAMETOOLONG;
+
+	cifs_MD5_init(&md5_ctx);
+	cifs_MD5_update(&md5_ctx, (const u8 *)link_str, link_len);
+	cifs_MD5_final(md5_hash, &md5_ctx);
+
+	snprintf(buf, buf_len,
+		 CIFS_MF_SYMLINK_LEN_FORMAT CIFS_MF_SYMLINK_MD5_FORMAT,
+		 link_len,
+		 CIFS_MF_SYMLINK_MD5_ARGS(md5_hash));
+
+	ofs = CIFS_MF_SYMLINK_LINK_OFFSET;
+	memcpy(buf + ofs, link_str, link_len);
+
+	ofs += link_len;
+	if (ofs < CIFS_MF_SYMLINK_FILE_SIZE) {
+		buf[ofs] = '\n';
+		ofs++;
+	}
+
+	while (ofs < CIFS_MF_SYMLINK_FILE_SIZE) {
+		buf[ofs] = ' ';
+		ofs++;
+	}
+
+	return 0;
+}
+
 CIFSQueryMFSymLink(const int xid, struct cifsTconInfo *tcon,
 		   const unsigned char *searchName, char **symlinkinfo,
 		   const struct nls_table *nls_codepage, int remap)
-- 
1.7.0.4
