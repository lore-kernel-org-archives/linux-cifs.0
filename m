From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v3 3/3] cifs: convert printk(LEVEL...) to pr_<level>
Date: Mon, 12 May 2014 19:55:07 +0300
Message-ID: <1399913707-31262-4-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1399913707-31262-1-git-send-email-andriy.shevchenko@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>,
	Alexander Bokovoy <ab-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1399913707-31262-1-git-send-email-andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The useful macros embed message level in the name. Thus, it cleans up the code
a bit. In cases when it was plain printk() the conversion was done to info
level.

Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 fs/cifs/cifs_debug.c |  5 ++---
 fs/cifs/cifs_debug.h |  7 +++----
 fs/cifs/connect.c    | 51 ++++++++++++++++++---------------------------------
 fs/cifs/netmisc.c    |  2 +-
 fs/cifs/transport.c  |  4 ++--
 5 files changed, 26 insertions(+), 43 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index d15cae9..fbd1bea 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -34,8 +34,7 @@
 void
 cifs_dump_mem(char *label, void *data, int length)
 {
-	printk(KERN_DEBUG "%s: dump of %d bytes of data at 0x%p\n",
-		label, length, data);
+	pr_debug("%s: dump of %d bytes of data at 0x%p\n", label, length, data);
 	print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 4,
 		       data, length, true);
 }
@@ -51,7 +50,7 @@ void cifs_vfs_err(const char *fmt, ...)
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	printk(KERN_ERR "CIFS VFS: %pV", &vaf);
+	pr_err("CIFS VFS: %pV", &vaf);
 
 	va_end(args);
 }
diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
index c99b40f..f40fbac 100644
--- a/fs/cifs/cifs_debug.h
+++ b/fs/cifs/cifs_debug.h
@@ -53,13 +53,12 @@ __printf(1, 2) void cifs_vfs_err(const char *fmt, ...);
 do {									\
 	if (type == FYI) {						\
 		if (cifsFYI & CIFS_INFO) {				\
-			printk(KERN_DEBUG "%s: " fmt,			\
-			       __FILE__, ##__VA_ARGS__);		\
+			pr_debug("%s: " fmt, __FILE__, ##__VA_ARGS__);	\
 		}							\
 	} else if (type == VFS) {					\
 		cifs_vfs_err(fmt, ##__VA_ARGS__);			\
 	} else if (type == NOISY && type != 0) {			\
-		printk(KERN_DEBUG fmt, ##__VA_ARGS__);			\
+		pr_debug(fmt, ##__VA_ARGS__);				\
 	}								\
 } while (0)
 
@@ -71,7 +70,7 @@ do {									\
 #define cifs_dbg(type, fmt, ...)					\
 do {									\
 	if (0)								\
-		printk(KERN_DEBUG fmt, ##__VA_ARGS__);			\
+		pr_debug(fmt, ##__VA_ARGS__);				\
 } while (0)
 #endif
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8813ff7..4ddbf4d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1447,9 +1447,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			vol->seal = 1;
 			break;
 		case Opt_noac:
-			printk(KERN_WARNING "CIFS: Mount option noac not "
-				"supported. Instead set "
-				"/proc/fs/cifs/LookupCacheEnabled to 0\n");
+			pr_warn("CIFS: Mount option noac not supported. Instead set /proc/fs/cifs/LookupCacheEnabled to 0\n");
 			break;
 		case Opt_fsc:
 #ifndef CONFIG_CIFS_FSCACHE
@@ -1579,7 +1577,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 
 			if (strnlen(string, CIFS_MAX_USERNAME_LEN) >
 							CIFS_MAX_USERNAME_LEN) {
-				printk(KERN_WARNING "CIFS: username too long\n");
+				pr_warn("CIFS: username too long\n");
 				goto cifs_parse_mount_err;
 			}
 			vol->username = kstrdup(string, GFP_KERNEL);
@@ -1641,8 +1639,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			temp_len = strlen(value);
 			vol->password = kzalloc(temp_len+1, GFP_KERNEL);
 			if (vol->password == NULL) {
-				printk(KERN_WARNING "CIFS: no memory "
-						    "for password\n");
+				pr_warn("CIFS: no memory for password\n");
 				goto cifs_parse_mount_err;
 			}
 
@@ -1666,8 +1663,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 
 			if (!cifs_convert_address(dstaddr, string,
 					strlen(string))) {
-				printk(KERN_ERR "CIFS: bad ip= option (%s).\n",
-					string);
+				pr_err("CIFS: bad ip= option (%s).\n", string);
 				goto cifs_parse_mount_err;
 			}
 			got_ip = true;
@@ -1679,15 +1675,13 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 
 			if (strnlen(string, CIFS_MAX_DOMAINNAME_LEN)
 					== CIFS_MAX_DOMAINNAME_LEN) {
-				printk(KERN_WARNING "CIFS: domain name too"
-						    " long\n");
+				pr_warn("CIFS: domain name too long\n");
 				goto cifs_parse_mount_err;
 			}
 
 			vol->domainname = kstrdup(string, GFP_KERNEL);
 			if (!vol->domainname) {
-				printk(KERN_WARNING "CIFS: no memory "
-						    "for domainname\n");
+				pr_warn("CIFS: no memory for domainname\n");
 				goto cifs_parse_mount_err;
 			}
 			cifs_dbg(FYI, "Domain name set\n");
@@ -1700,8 +1694,8 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			if (!cifs_convert_address(
 					(struct sockaddr *)&vol->srcaddr,
 					string, strlen(string))) {
-				printk(KERN_WARNING "CIFS:  Could not parse"
-						    " srcaddr: %s\n", string);
+				pr_warn("CIFS: Could not parse srcaddr: %s\n",
+					string);
 				goto cifs_parse_mount_err;
 			}
 			break;
@@ -1711,8 +1705,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 				goto out_nomem;
 
 			if (strnlen(string, 1024) >= 65) {
-				printk(KERN_WARNING "CIFS: iocharset name "
-						    "too long.\n");
+				pr_warn("CIFS: iocharset name too long.\n");
 				goto cifs_parse_mount_err;
 			}
 
@@ -1720,8 +1713,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 				vol->iocharset = kstrdup(string,
 							 GFP_KERNEL);
 				if (!vol->iocharset) {
-					printk(KERN_WARNING "CIFS: no memory"
-							    "for charset\n");
+					pr_warn("CIFS: no memory for charset\n");
 					goto cifs_parse_mount_err;
 				}
 			}
@@ -1752,9 +1744,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			 * set at top of the function
 			 */
 			if (i == RFC1001_NAME_LEN && string[i] != 0)
-				printk(KERN_WARNING "CIFS: netbiosname"
-				       " longer than 15 truncated.\n");
-
+				pr_warn("CIFS: netbiosname longer than 15 truncated.\n");
 			break;
 		case Opt_servern:
 			/* servernetbiosname specified override *SMBSERVER */
@@ -1780,8 +1770,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			/* The string has 16th byte zero still from
 			   set at top of the function  */
 			if (i == RFC1001_NAME_LEN && string[i] != 0)
-				printk(KERN_WARNING "CIFS: server net"
-				       "biosname longer than 15 truncated.\n");
+				pr_warn("CIFS: server netbiosname longer than 15 truncated.\n");
 			break;
 		case Opt_ver:
 			string = match_strdup(args);
@@ -1793,8 +1782,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 				break;
 			}
 			/* For all other value, error */
-			printk(KERN_WARNING "CIFS: Invalid version"
-					    " specified\n");
+			pr_warn("CIFS: Invalid version specified\n");
 			goto cifs_parse_mount_err;
 		case Opt_vers:
 			string = match_strdup(args);
@@ -1835,7 +1823,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 	}
 
 	if (!sloppy && invalid) {
-		printk(KERN_ERR "CIFS: Unknown mount option \"%s\"\n", invalid);
+		pr_err("CIFS: Unknown mount option \"%s\"\n", invalid);
 		goto cifs_parse_mount_err;
 	}
 
@@ -1861,8 +1849,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 		/* No ip= option specified? Try to get it from UNC */
 		if (!cifs_convert_address(dstaddr, &vol->UNC[2],
 						strlen(&vol->UNC[2]))) {
-			printk(KERN_ERR "Unable to determine destination "
-					"address.\n");
+			pr_err("Unable to determine destination address.\n");
 			goto cifs_parse_mount_err;
 		}
 	}
@@ -1873,20 +1860,18 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 	if (uid_specified)
 		vol->override_uid = override_uid;
 	else if (override_uid == 1)
-		printk(KERN_NOTICE "CIFS: ignoring forceuid mount option "
-				   "specified with no uid= option.\n");
+		pr_notice("CIFS: ignoring forceuid mount option specified with no uid= option.\n");
 
 	if (gid_specified)
 		vol->override_gid = override_gid;
 	else if (override_gid == 1)
-		printk(KERN_NOTICE "CIFS: ignoring forcegid mount option "
-				   "specified with no gid= option.\n");
+		pr_notice("CIFS: ignoring forcegid mount option specified with no gid= option.\n");
 
 	kfree(mountdata_copy);
 	return 0;
 
 out_nomem:
-	printk(KERN_WARNING "Could not allocate temporary buffer\n");
+	pr_warn("Could not allocate temporary buffer\n");
 cifs_parse_mount_err:
 	kfree(string);
 	kfree(mountdata_copy);
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index 0498845..bc9597b 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -795,7 +795,7 @@ cifs_print_status(__u32 status_code)
 	while (nt_errs[idx].nt_errstr != NULL) {
 		if (((nt_errs[idx].nt_errcode) & 0xFFFFFF) ==
 		    (status_code & 0xFFFFFF)) {
-			printk(KERN_NOTICE "Status code returned 0x%08x %s\n",
+			pr_notice("Status code returned 0x%08x %s\n",
 				   status_code, nt_errs[idx].nt_errstr);
 		}
 		idx++;
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 18cd565..979f83e 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -99,9 +99,9 @@ DeleteMidQEntry(struct mid_q_entry *midEntry)
 	   something is wrong, unless it is quite a slow link or server */
 	if ((now - midEntry->when_alloc) > HZ) {
 		if ((cifsFYI & CIFS_TIMER) && (midEntry->command != command)) {
-			printk(KERN_DEBUG " CIFS slow rsp: cmd %d mid %llu",
+			pr_debug(" CIFS slow rsp: cmd %d mid %llu",
 			       midEntry->command, midEntry->mid);
-			printk(" A: 0x%lx S: 0x%lx R: 0x%lx\n",
+			pr_info(" A: 0x%lx S: 0x%lx R: 0x%lx\n",
 			       now - midEntry->when_alloc,
 			       now - midEntry->when_sent,
 			       now - midEntry->when_received);
-- 
2.0.0.rc2
