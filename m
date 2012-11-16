From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/6] cifs: fix up handling of prefixpath= option
Date: Fri, 16 Nov 2012 12:36:53 -0500
Message-ID: <1353087414-32152-6-git-send-email-jlayton@redhat.com>
References: <1353087414-32152-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org,
	almiller_1-/E1597aS9LT10XsdtD+oqA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1353087414-32152-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently the code takes care to ensure that the prefixpath has a
leading '/' delimiter. What if someone passes us a prefixpath with a
leading '\\' instead? The code doesn't properly handle that currently
AFAICS.

Let's just change the code to skip over any leading delimiter character
when copying the prepath. Then, fix up the users of the prepath option
to prefix it with the correct delimiter when they use it.

Also, there's no need to limit the length of the prefixpath to 1k. If
the server can handle it, why bother forbidding it?

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c | 34 +++++++++-------------------------
 fs/cifs/smb1ops.c |  5 +++--
 fs/cifs/smb2ops.c |  2 +-
 3 files changed, 13 insertions(+), 28 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 89f426f..b1f352a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1603,31 +1603,14 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			}
 			break;
 		case Opt_prefixpath:
-			string = match_strdup(args);
-			if (string == NULL)
-				goto out_nomem;
-
-			temp_len = strnlen(string, 1024);
-			if (string[0] != '/')
-				temp_len++; /* missing leading slash */
-			if (temp_len > 1024) {
-				printk(KERN_WARNING "CIFS: prefix too long\n");
-				goto cifs_parse_mount_err;
-			}
-
-			vol->prepath = kmalloc(temp_len+1, GFP_KERNEL);
-			if (vol->prepath == NULL) {
-				printk(KERN_WARNING "CIFS: no memory "
-						    "for path prefix\n");
-				goto cifs_parse_mount_err;
-			}
-
-			if (string[0] != '/') {
-				vol->prepath[0] = '/';
-				strcpy(vol->prepath+1, string);
-			} else
-				strcpy(vol->prepath, string);
+			/* skip over any leading delimiter */
+			if (*args[0].from == '/' || *args[0].from == '\\')
+				args[0].from++;
 
+			kfree(vol->prepath);
+			vol->prepath = match_strdup(args);
+			if (vol->prepath == NULL)
+				goto out_nomem;
 			break;
 		case Opt_iocharset:
 			string = match_strdup(args);
@@ -3238,7 +3221,7 @@ build_unc_path_to_root(const struct smb_vol *vol,
 		const struct cifs_sb_info *cifs_sb)
 {
 	char *full_path, *pos;
-	unsigned int pplen = vol->prepath ? strlen(vol->prepath) : 0;
+	unsigned int pplen = vol->prepath ? strlen(vol->prepath) + 1: 0;
 	unsigned int unc_len = strnlen(vol->UNC, MAX_TREE_SIZE + 1);
 
 	full_path = kmalloc(unc_len + pplen + 1, GFP_KERNEL);
@@ -3249,6 +3232,7 @@ build_unc_path_to_root(const struct smb_vol *vol,
 	pos = full_path + unc_len;
 
 	if (pplen) {
+		*pos++ = CIFS_DIR_SEP(cifs_sb);
 		strncpy(pos, vol->prepath, pplen);
 		pos += pplen;
 	}
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 56cc4be..50e9613 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -579,7 +579,7 @@ static char *
 cifs_build_path_to_root(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
 			struct cifs_tcon *tcon)
 {
-	int pplen = vol->prepath ? strlen(vol->prepath) : 0;
+	int pplen = vol->prepath ? strlen(vol->prepath) + 1 : 0;
 	int dfsplen;
 	char *full_path = NULL;
 
@@ -600,7 +600,8 @@ cifs_build_path_to_root(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
 
 	if (dfsplen)
 		strncpy(full_path, tcon->treeName, dfsplen);
-	strncpy(full_path + dfsplen, vol->prepath, pplen);
+	full_path[dfsplen] = CIFS_DIR_SEP(cifs_sb);
+	strncpy(full_path + dfsplen + 1, vol->prepath, pplen);
 	convert_delimiter(full_path, CIFS_DIR_SEP(cifs_sb));
 	full_path[dfsplen + pplen] = 0; /* add trailing null */
 	return full_path;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 4d9dbe0..1baa82d 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -266,7 +266,7 @@ static char *
 smb2_build_path_to_root(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
 			struct cifs_tcon *tcon)
 {
-	int pplen = vol->prepath ? strlen(vol->prepath) : 0;
+	int pplen = vol->prepath ? strlen(vol->prepath) + 1 : 0;
 	char *full_path = NULL;
 
 	/* if no prefix path, simply set path to the root of share to "" */
-- 
1.7.11.7
