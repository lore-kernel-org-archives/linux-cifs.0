From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 4/4] cifs: add warning about change in default cache semantics in 3.7
Date: Wed, 16 May 2012 07:55:54 -0400
Message-ID: <1337169354-19045-5-git-send-email-jlayton@redhat.com>
References: <1337169354-19045-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337169354-19045-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Add a warning that will be displayed when there is no cache= option
specified. We want to ensure that users are aware of the change in
defaults coming in 3.7.

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 2bd867f..e79df39 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1243,6 +1243,8 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 	char *string = NULL;
 	char *tmp_end, *value;
 	char delim;
+	bool cache_specified = false;
+	static bool cache_warned = false;
 
 	separator[0] = ',';
 	separator[1] = 0;
@@ -1454,6 +1456,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			vol->seal = 1;
 			break;
 		case Opt_direct:
+			cache_specified = true;
 			vol->direct_io = true;
 			vol->strict_io = false;
 			cERROR(1, "The \"directio\" option will be removed in "
@@ -1461,6 +1464,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 				  "option.");
 			break;
 		case Opt_strictcache:
+			cache_specified = true;
 			vol->direct_io = false;
 			vol->strict_io = true;
 			cERROR(1, "The \"strictcache\" option will be removed "
@@ -1887,6 +1891,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 				goto cifs_parse_mount_err;
 			break;
 		case Opt_cache:
+			cache_specified = true;
 			string = match_strdup(args);
 			if (string == NULL)
 				goto out_nomem;
@@ -1937,6 +1942,14 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 		printk(KERN_NOTICE "CIFS: ignoring forcegid mount option "
 				   "specified with no gid= option.\n");
 
+	/* FIXME: remove this block in 3.7 */
+	if (!cache_specified && !cache_warned) {
+		cache_warned = true;
+		printk(KERN_NOTICE "CIFS: no cache= option specified, using "
+				   "\"cache=loose\". This default will change "
+				   "to \"cache=strict\" in 3.7.\n");
+	}
+
 	kfree(mountdata_copy);
 	return 0;
 
-- 
1.7.7.6
