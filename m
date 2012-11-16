From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 6/6] cifs: parse the device name into UNC and prepath
Date: Fri, 16 Nov 2012 12:36:54 -0500
Message-ID: <1353087414-32152-7-git-send-email-jlayton@redhat.com>
References: <1353087414-32152-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org,
	almiller_1-/E1597aS9LT10XsdtD+oqA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1353087414-32152-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This should fix a regression that was introduced when the new mount
option parser went in. Also, when the unc= and prefixpath= options
are provided, check their values against the ones we parsed from
the device string. If they differ, then throw a warning that tells
the user that we're using the values from the unc= option for now,
but that that will change in 3.10.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 88 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b1f352a..b9f3dd7 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1090,6 +1090,52 @@ cifs_parse_smb_version(char *value, struct smb_vol *vol)
 	return 0;
 }
 
+/*
+ * Parse a devname into substrings and populate the vol->UNC and vol->prepath
+ * fields with the result. Returns 0 on success and an error otherwise.
+ */
+static int
+cifs_parse_devname(const char *devname, struct smb_vol *vol)
+{
+	char *pos;
+	const char *delims = "/\\";
+	size_t len;
+
+	/* make sure we have a valid UNC double delimiter prefix */
+	len = strspn(devname, delims);
+	if (len != 2)
+		return -EINVAL;
+
+	/* find delimiter between host and sharename */
+	pos = strpbrk(devname + 2, delims);
+	if (!pos)
+		return -EINVAL;
+
+	/* skip past delimiter */
+	++pos;
+
+	/* now go until next delimiter or end of string */
+	len = strcspn(pos, delims);
+
+	/* move "pos" up to delimiter or NULL */
+	pos += len;
+	vol->UNC = kstrndup(devname, pos - devname, GFP_KERNEL);
+	if (!vol->UNC)
+		return -ENOMEM;
+
+	convert_delimiter(vol->UNC, '\\');
+
+	/* If pos is NULL, or is a bogus trailing delimiter then no prepath */
+	if (!*pos++ || !*pos)
+		return 0;
+
+	vol->prepath = kstrdup(pos, GFP_KERNEL);
+	if (!vol->prepath)
+		return -ENOMEM;
+
+	return 0;
+}
+
 static int
 cifs_parse_mount_options(const char *mountdata, const char *devname,
 			 struct smb_vol *vol)
@@ -1172,6 +1218,16 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 	vol->backupuid_specified = false; /* no backup intent for a user */
 	vol->backupgid_specified = false; /* no backup intent for a group */
 
+	/*
+	 * For now, we ignore -EINVAL errors under the assumption that the
+	 * unc= and prefixpath= options will be usable.
+	 */
+	if (cifs_parse_devname(devname, vol) == -ENOMEM) {
+		printk(KERN_ERR "CIFS: Unable to allocate memory to parse "
+				"device string.\n");
+		goto out_nomem;
+	}
+
 	while ((data = strsep(&options, separator)) != NULL) {
 		substring_t args[MAX_OPT_ARGS];
 		unsigned long option;
@@ -1557,18 +1613,31 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			got_ip = true;
 			break;
 		case Opt_unc:
-			kfree(vol->UNC);
+			string = vol->UNC;
 			vol->UNC = match_strdup(args);
-			if (vol->UNC == NULL)
+			if (vol->UNC == NULL) {
+				kfree(string);
 				goto out_nomem;
+			}
 
 			convert_delimiter(vol->UNC, '\\');
 			if (vol->UNC[0] != '\\' || vol->UNC[1] != '\\') {
-				printk(KERN_WARNING "CIFS: UNC Path does not "
+				kfree(string);
+				printk(KERN_ERR "CIFS: UNC Path does not "
 						"begin with // or \\\\\n");
 				goto cifs_parse_mount_err;
 			}
 
+			/* Compare old unc= option to new one */
+			if (!string || strcmp(string, vol->UNC))
+				printk(KERN_WARNING "CIFS: the value of the "
+					"unc= mount option does not match the "
+					"device string. Using the unc= option "
+					"for now. In 3.10, that option will "
+					"be ignored and the contents of the "
+					"device string will be used "
+					"instead. (%s != %s)\n", string,
+					vol->UNC);
 			break;
 		case Opt_domain:
 			string = match_strdup(args);
@@ -1607,10 +1676,22 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			if (*args[0].from == '/' || *args[0].from == '\\')
 				args[0].from++;
 
-			kfree(vol->prepath);
+			string = vol->prepath;
 			vol->prepath = match_strdup(args);
-			if (vol->prepath == NULL)
+			if (vol->prepath == NULL) {
+				kfree(string);
 				goto out_nomem;
+			}
+			/* Compare old prefixpath= option to new one */
+			if (!string || strcmp(string, vol->prepath))
+				printk(KERN_WARNING "CIFS: the value of the "
+					"prefixpath= mount option does not "
+					"match the device string. Using the "
+					"prefixpath= option for now. In 3.10, "
+					"that option will be ignored and the "
+					"contents of the device string will be "
+					"used instead.(%s != %s)\n", string,
+					vol->prepath);
 			break;
 		case Opt_iocharset:
 			string = match_strdup(args);
@@ -1768,8 +1849,8 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 	}
 #endif
 	if (!vol->UNC) {
-		cERROR(1, "CIFS mount error: No UNC path (e.g. -o "
-			"unc=\\\\192.168.1.100\\public) specified");
+		cERROR(1, "CIFS mount error: No usable UNC path provided in "
+			  "device string or in unc= option!");
 		goto cifs_parse_mount_err;
 	}
 
-- 
1.7.11.7
