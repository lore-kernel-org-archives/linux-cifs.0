From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] cifs: fix composing of mount options for DFS referrals
Date: Thu, 23 May 2013 14:47:44 -0400
Message-ID: <1369334864-21105-1-git-send-email-jlayton@redhat.com>
References: <1369270472-16408-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369270472-16408-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

With the change to ignore the unc= and prefixpath= mount options, there
is no longer any need to add them to the options string when mounting.
By the same token, we now need to build a device name that includes the
prefixpath when mounting.

To make things neater, the delimiters on the devicename are changed
to '/' since that's preferred when mounting anyway.

While we're at it, fix a potential buffer overrun when building the
mount options string, if the new ip= option is much longer than the
original one.

v2: fix some comments and don't bother looking at whether there is
    a prepath in the ref->node_name when deciding whether to pass
    a prepath to cifs_build_devname.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_dfs_ref.c | 141 +++++++++++++++++++++++++------------------------
 fs/cifs/dns_resolve.c  |   4 +-
 2 files changed, 74 insertions(+), 71 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 8e33ec6..43feb8d 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/vfs.h>
 #include <linux/fs.h>
+#include <linux/inet.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifsfs.h"
@@ -48,58 +49,74 @@ void cifs_dfs_release_automount_timer(void)
 }
 
 /**
- * cifs_get_share_name	-	extracts share name from UNC
- * @node_name:	pointer to UNC string
+ * cifs_build_devname - build a devicename from a UNC and optional prepath
+ * @nodename:	pointer to UNC string
+ * @prepath:	pointer to prefixpath (or NULL if there isn't one)
  *
- * Extracts sharename form full UNC.
- * i.e. strips from UNC trailing path that is not part of share
- * name and fixup missing '\' in the beginning of DFS node refferal
- * if necessary.
- * Returns pointer to share name on success or ERR_PTR on error.
- * Caller is responsible for freeing returned string.
+ * Build a new cifs devicename after chasing a DFS referral. Allocate a buffer
+ * big enough to hold the final thing. Copy the UNC from the nodename, and
+ * concatenate the prepath onto the end of it if there is one.
+ *
+ * Returns pointer to the built string, or a ERR_PTR. Caller is responsible
+ * for freeing the returned string.
  */
-static char *cifs_get_share_name(const char *node_name)
+static char *
+cifs_build_devname(char *nodename, const char *prepath)
 {
-	int len;
-	char *UNC;
-	char *pSep;
-
-	len = strlen(node_name);
-	UNC = kmalloc(len+2 /*for term null and additional \ if it's missed */,
-			 GFP_KERNEL);
-	if (!UNC)
-		return ERR_PTR(-ENOMEM);
+	size_t pplen;
+	size_t unclen;
+	char *dev;
+	char *pos;
+
+	/* skip over any preceding delimiters */
+	nodename += strspn(nodename, "\\");
+	if (!*nodename)
+		return ERR_PTR(-EINVAL);
 
-	/* get share name and server name */
-	if (node_name[1] != '\\') {
-		UNC[0] = '\\';
-		strncpy(UNC+1, node_name, len);
-		len++;
-		UNC[len] = 0;
-	} else {
-		strncpy(UNC, node_name, len);
-		UNC[len] = 0;
-	}
+	/* get length of UNC and set pos to last char */
+	unclen = strlen(nodename);
+	pos = nodename + unclen - 1;
 
-	/* find server name end */
-	pSep = memchr(UNC+2, '\\', len-2);
-	if (!pSep) {
-		cifs_dbg(VFS, "%s: no server name end in node name: %s\n",
-			 __func__, node_name);
-		kfree(UNC);
-		return ERR_PTR(-EINVAL);
+	/* trim off any trailing delimiters */
+	while(*pos == '\\') {
+		--pos;
+		--unclen;
 	}
 
-	/* find sharename end */
-	pSep++;
-	pSep = memchr(UNC+(pSep-UNC), '\\', len-(pSep-UNC));
-	if (pSep) {
-		/* trim path up to sharename end
-		 * now we have share name in UNC */
-		*pSep = 0;
+	/* allocate a buffer:
+	 * +2 for preceding "//"
+	 * +1 for delimiter between UNC and prepath
+	 * +1 for trailing NULL
+	 */
+	pplen = prepath ? strlen(prepath) : 0;
+	dev = kmalloc(2 + unclen + 1 + pplen + 1, GFP_KERNEL);
+	if (!dev)
+		return ERR_PTR(-ENOMEM);
+
+	pos = dev;
+	/* add the initial "//" */
+	*pos = '/';
+	++pos;
+	*pos = '/';
+	++pos;
+
+	/* copy in the UNC portion from referral */
+	memcpy(pos, nodename, unclen);
+	pos += unclen;
+
+	/* copy the prefixpath remainder (if there is one) */
+	if (pplen) {
+		*pos = '/';
+		++pos;
+		memcpy(pos, prepath, pplen);
+		pos += pplen;
 	}
 
-	return UNC;
+	/* NULL terminator */
+	*pos = '\0';
+
+	convert_delimiter(dev, '/');
+	return dev;
 }
 
 
@@ -123,6 +140,7 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 {
 	int rc;
 	char *mountdata = NULL;
+	const char *prepath = NULL;
 	int md_len;
 	char *tkn_e;
 	char *srvIP = NULL;
@@ -132,7 +150,10 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 	if (sb_mountdata == NULL)
 		return ERR_PTR(-EINVAL);
 
-	*devname = cifs_get_share_name(ref->node_name);
+	if (strlen(fullpath) - ref->path_consumed)
+		prepath = fullpath + ref->path_consumed;
+
+	*devname = cifs_build_devname(ref->node_name, prepath);
 	if (IS_ERR(*devname)) {
 		rc = PTR_ERR(*devname);
 		*devname = NULL;
@@ -146,12 +167,14 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 		goto compose_mount_options_err;
 	}
 
-	/* md_len = strlen(...) + 12 for 'sep+prefixpath='
-	 * assuming that we have 'unc=' and 'ip=' in
-	 * the original sb_mountdata
+	/*
+	 * In most cases, we'll be building a shorter string than the original,
+	 * but we do have to assume that the address in the ip= option may be
+	 * much longer than the original. Add the max length of an address
+	 * string to the length of the original string to allow for worst case.
 	 */
-	md_len = strlen(sb_mountdata) + rc + strlen(ref->node_name) + 12;
-	mountdata = kzalloc(md_len+1, GFP_KERNEL);
+	md_len = strlen(sb_mountdata) + INET6_ADDRSTRLEN;
+	mountdata = kzalloc(md_len + 1, GFP_KERNEL);
 	if (mountdata == NULL) {
 		rc = -ENOMEM;
 		goto compose_mount_options_err;
@@ -195,26 +218,6 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 		strncat(mountdata, &sep, 1);
 	strcat(mountdata, "ip=");
 	strcat(mountdata, srvIP);
-	strncat(mountdata, &sep, 1);
-	strcat(mountdata, "unc=");
-	strcat(mountdata, *devname);
-
-	/* find & copy prefixpath */
-	tkn_e = strchr(ref->node_name + 2, '\\');
-	if (tkn_e == NULL) {
-		/* invalid unc, missing share name*/
-		rc = -EINVAL;
-		goto compose_mount_options_err;
-	}
-
-	tkn_e = strchr(tkn_e + 1, '\\');
-	if (tkn_e || (strlen(fullpath) - ref->path_consumed)) {
-		strncat(mountdata, &sep, 1);
-		strcat(mountdata, "prefixpath=");
-		if (tkn_e)
-			strcat(mountdata, tkn_e + 1);
-		strcat(mountdata, fullpath + ref->path_consumed);
-	}
 
 	/*cifs_dbg(FYI, "%s: parent mountdata: %s\n", __func__, sb_mountdata);*/
 	/*cifs_dbg(FYI, "%s: submount mountdata: %s\n", __func__, mountdata );*/
diff --git a/fs/cifs/dns_resolve.c b/fs/cifs/dns_resolve.c
index e7512e4..7ede730 100644
--- a/fs/cifs/dns_resolve.c
+++ b/fs/cifs/dns_resolve.c
@@ -34,7 +34,7 @@
 
 /**
  * dns_resolve_server_name_to_ip - Resolve UNC server name to ip address.
- * @unc: UNC path specifying the server
+ * @unc: UNC path specifying the server (with '/' as delimiter)
  * @ip_addr: Where to return the IP address.
  *
  * The IP address will be returned in string form, and the caller is
@@ -64,7 +64,7 @@ dns_resolve_server_name_to_ip(const char *unc, char **ip_addr)
 	hostname = unc + 2;
 
 	/* Search for server name delimiter */
-	sep = memchr(hostname, '\\', len);
+	sep = memchr(hostname, '/', len);
 	if (sep)
 		len = sep - hostname;
 	else
-- 
1.8.1.4
