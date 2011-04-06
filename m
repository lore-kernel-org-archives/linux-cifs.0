From: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Subject: [PATCH v4 3/6] cifs: cifs_parse_mount_options: do not tokenize mount options in-place
Date: Wed, 6 Apr 2011 16:26:42 +0200
Message-ID: <1302100005-1848-3-git-send-email-seanius@seanius.net>
References: <1302100005-1848-1-git-send-email-seanius@seanius.net>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1302100005-1848-1-git-send-email-seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

To keep strings passed to cifs_parse_mount_options re-usable (which is
needed to clean up the DFS referral handling), tokenize a copy of the
mount options instead.  If values are needed from this tokenized string,
they too must be duplicated (previously, some options were copied and
others duplicated).

Since we are not on the critical path and any cleanup is relatively easy,
the extra memory usage shouldn't be a problem (and it is a bit simpler
than trying to implement something smarter).

Signed-off-by: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
---
 fs/cifs/connect.c |  109 ++++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 74 insertions(+), 35 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 4873bac..259fc64 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -807,11 +807,12 @@ extract_hostname(const char *unc)
 }
 
 static int
-cifs_parse_mount_options(char *options, const char *devname,
+cifs_parse_mount_options(const char *mountdata, const char *devname,
 			 struct smb_vol *vol)
 {
 	char *value;
 	char *data;
+	char *mountdata_copy, *options;
 	unsigned int  temp_len, i, j;
 	char separator[2];
 	short int override_uid = -1;
@@ -851,9 +852,14 @@ cifs_parse_mount_options(char *options, const char *devname,
 
 	vol->actimeo = CIFS_DEF_ACTIMEO;
 
-	if (!options)
-		return 1;
+	if (!mountdata)
+		goto cifs_parse_mount_err;
+
+	mountdata_copy = kstrndup(mountdata, PAGE_CACHE_SIZE, GFP_KERNEL);
+	if (!mountdata_copy)
+		goto cifs_parse_mount_err;
 
+	options = mountdata_copy;
 	if (strncmp(options, "sep=", 4) == 0) {
 		if (options[4] != 0) {
 			separator[0] = options[4];
@@ -878,17 +884,22 @@ cifs_parse_mount_options(char *options, const char *devname,
 			if (!value) {
 				printk(KERN_WARNING
 				       "CIFS: invalid or missing username\n");
-				return 1;	/* needs_arg; */
+				goto cifs_parse_mount_err;
 			} else if (!*value) {
 				/* null user, ie anonymous, authentication */
 				vol->nullauth = 1;
 			}
 			if (strnlen(value, MAX_USERNAME_SIZE) <
 						MAX_USERNAME_SIZE) {
-				vol->username = value;
+				vol->username = kstrdup(value, GFP_KERNEL);
+				if (!vol->username) {
+					printk(KERN_WARNING "CIFS: no memory "
+							    "for username\n");
+					goto cifs_parse_mount_err;
+				}
 			} else {
 				printk(KERN_WARNING "CIFS: username too long\n");
-				return 1;
+				goto cifs_parse_mount_err;
 			}
 		} else if (strnicmp(data, "pass", 4) == 0) {
 			if (!value) {
@@ -951,7 +962,7 @@ cifs_parse_mount_options(char *options, const char *devname,
 				if (vol->password == NULL) {
 					printk(KERN_WARNING "CIFS: no memory "
 							    "for password\n");
-					return 1;
+					goto cifs_parse_mount_err;
 				}
 				for (i = 0, j = 0; i < temp_len; i++, j++) {
 					vol->password[j] = value[i];
@@ -967,7 +978,7 @@ cifs_parse_mount_options(char *options, const char *devname,
 				if (vol->password == NULL) {
 					printk(KERN_WARNING "CIFS: no memory "
 							    "for password\n");
-					return 1;
+					goto cifs_parse_mount_err;
 				}
 				strcpy(vol->password, value);
 			}
@@ -977,11 +988,16 @@ cifs_parse_mount_options(char *options, const char *devname,
 				vol->UNCip = NULL;
 			} else if (strnlen(value, INET6_ADDRSTRLEN) <
 							INET6_ADDRSTRLEN) {
-				vol->UNCip = value;
+				vol->UNCip = kstrdup(value, GFP_KERNEL);
+				if (!vol->UNCip) {
+					printk(KERN_WARNING "CIFS: no memory "
+							    "for UNC IP\n");
+					goto cifs_parse_mount_err;
+				}
 			} else {
 				printk(KERN_WARNING "CIFS: ip address "
 						    "too long\n");
-				return 1;
+				goto cifs_parse_mount_err;
 			}
 		} else if (strnicmp(data, "sec", 3) == 0) {
 			if (!value || !*value) {
@@ -994,7 +1010,7 @@ cifs_parse_mount_options(char *options, const char *devname,
 				/* vol->secFlg |= CIFSSEC_MUST_SEAL |
 					CIFSSEC_MAY_KRB5; */
 				cERROR(1, "Krb5 cifs privacy not supported");
-				return 1;
+				goto cifs_parse_mount_err;
 			} else if (strnicmp(value, "krb5", 4) == 0) {
 				vol->secFlg |= CIFSSEC_MAY_KRB5;
 			} else if (strnicmp(value, "ntlmsspi", 8) == 0) {
@@ -1024,7 +1040,7 @@ cifs_parse_mount_options(char *options, const char *devname,
 				vol->nullauth = 1;
 			} else {
 				cERROR(1, "bad security option: %s", value);
-				return 1;
+				goto cifs_parse_mount_err;
 			}
 		} else if (strnicmp(data, "vers", 3) == 0) {
 			if (!value || !*value) {
@@ -1048,12 +1064,12 @@ cifs_parse_mount_options(char *options, const char *devname,
 			if (!value || !*value) {
 				printk(KERN_WARNING "CIFS: invalid path to "
 						    "network resource\n");
-				return 1;	/* needs_arg; */
+				goto cifs_parse_mount_err;
 			}
 			if ((temp_len = strnlen(value, 300)) < 300) {
 				vol->UNC = kmalloc(temp_len+1, GFP_KERNEL);
 				if (vol->UNC == NULL)
-					return 1;
+					goto cifs_parse_mount_err;
 				strcpy(vol->UNC, value);
 				if (strncmp(vol->UNC, "//", 2) == 0) {
 					vol->UNC[0] = '\\';
@@ -1062,27 +1078,32 @@ cifs_parse_mount_options(char *options, const char *devname,
 					printk(KERN_WARNING
 					       "CIFS: UNC Path does not begin "
 					       "with // or \\\\ \n");
-					return 1;
+					goto cifs_parse_mount_err;
 				}
 			} else {
 				printk(KERN_WARNING "CIFS: UNC name too long\n");
-				return 1;
+				goto cifs_parse_mount_err;
 			}
 		} else if ((strnicmp(data, "domain", 3) == 0)
 			   || (strnicmp(data, "workgroup", 5) == 0)) {
 			if (!value || !*value) {
 				printk(KERN_WARNING "CIFS: invalid domain name\n");
-				return 1;	/* needs_arg; */
+				goto cifs_parse_mount_err;
 			}
 			/* BB are there cases in which a comma can be valid in
 			a domain name and need special handling? */
 			if (strnlen(value, 256) < 256) {
-				vol->domainname = value;
+				vol->domainname = kstrdup(value, GFP_KERNEL);
+				if (!vol->domainname) {
+					printk(KERN_WARNING "CIFS: no memory "
+							    "for domainname\n");
+					goto cifs_parse_mount_err;
+				}
 				cFYI(1, "Domain name set");
 			} else {
 				printk(KERN_WARNING "CIFS: domain name too "
 						    "long\n");
-				return 1;
+				goto cifs_parse_mount_err;
 			}
 		} else if (strnicmp(data, "srcaddr", 7) == 0) {
 			vol->srcaddr.ss_family = AF_UNSPEC;
@@ -1090,7 +1111,7 @@ cifs_parse_mount_options(char *options, const char *devname,
 			if (!value || !*value) {
 				printk(KERN_WARNING "CIFS: srcaddr value"
 				       " not specified.\n");
-				return 1;	/* needs_arg; */
+				goto cifs_parse_mount_err;
 			}
 			i = cifs_convert_address((struct sockaddr *)&vol->srcaddr,
 						 value, strlen(value));
@@ -1098,20 +1119,20 @@ cifs_parse_mount_options(char *options, const char *devname,
 				printk(KERN_WARNING "CIFS:  Could not parse"
 				       " srcaddr: %s\n",
 				       value);
-				return 1;
+				goto cifs_parse_mount_err;
 			}
 		} else if (strnicmp(data, "prefixpath", 10) == 0) {
 			if (!value || !*value) {
 				printk(KERN_WARNING
 					"CIFS: invalid path prefix\n");
-				return 1;       /* needs_argument */
+				goto cifs_parse_mount_err;
 			}
 			if ((temp_len = strnlen(value, 1024)) < 1024) {
 				if (value[0] != '/')
 					temp_len++;  /* missing leading slash */
 				vol->prepath = kmalloc(temp_len+1, GFP_KERNEL);
 				if (vol->prepath == NULL)
-					return 1;
+					goto cifs_parse_mount_err;
 				if (value[0] != '/') {
 					vol->prepath[0] = '/';
 					strcpy(vol->prepath+1, value);
@@ -1120,24 +1141,33 @@ cifs_parse_mount_options(char *options, const char *devname,
 				cFYI(1, "prefix path %s", vol->prepath);
 			} else {
 				printk(KERN_WARNING "CIFS: prefix too long\n");
-				return 1;
+				goto cifs_parse_mount_err;
 			}
 		} else if (strnicmp(data, "iocharset", 9) == 0) {
 			if (!value || !*value) {
 				printk(KERN_WARNING "CIFS: invalid iocharset "
 						    "specified\n");
-				return 1;	/* needs_arg; */
+				goto cifs_parse_mount_err;
 			}
 			if (strnlen(value, 65) < 65) {
-				if (strnicmp(value, "default", 7))
-					vol->iocharset = value;
+				if (strnicmp(value, "default", 7)) {
+					vol->iocharset = kstrdup(value,
+								 GFP_KERNEL);
+
+					if (!vol->iocharset) {
+						printk(KERN_WARNING "CIFS: no "
+								   "memory for"
+								   "charset\n");
+						goto cifs_parse_mount_err;
+					}
+				}
 				/* if iocharset not set then load_nls_default
 				   is used by caller */
 				cFYI(1, "iocharset set to %s", value);
 			} else {
 				printk(KERN_WARNING "CIFS: iocharset name "
 						    "too long.\n");
-				return 1;
+				goto cifs_parse_mount_err;
 			}
 		} else if (!strnicmp(data, "uid", 3) && value && *value) {
 			vol->linux_uid = simple_strtoul(value, &value, 0);
@@ -1250,7 +1280,7 @@ cifs_parse_mount_options(char *options, const char *devname,
 				if (vol->actimeo > CIFS_MAX_ACTIMEO) {
 					cERROR(1, "CIFS: attribute cache"
 							"timeout too large");
-					return 1;
+					goto cifs_parse_mount_err;
 				}
 			}
 		} else if (strnicmp(data, "credentials", 4) == 0) {
@@ -1394,7 +1424,7 @@ cifs_parse_mount_options(char *options, const char *devname,
 #ifndef CONFIG_CIFS_FSCACHE
 			cERROR(1, "FS-Cache support needs CONFIG_CIFS_FSCACHE"
 				  "kernel config option set");
-			return 1;
+			goto cifs_parse_mount_err;
 #endif
 			vol->fsc = true;
 		} else if (strnicmp(data, "mfsymlinks", 10) == 0) {
@@ -1409,12 +1439,12 @@ cifs_parse_mount_options(char *options, const char *devname,
 		if (devname == NULL) {
 			printk(KERN_WARNING "CIFS: Missing UNC name for mount "
 						"target\n");
-			return 1;
+			goto cifs_parse_mount_err;
 		}
 		if ((temp_len = strnlen(devname, 300)) < 300) {
 			vol->UNC = kmalloc(temp_len+1, GFP_KERNEL);
 			if (vol->UNC == NULL)
-				return 1;
+				goto cifs_parse_mount_err;
 			strcpy(vol->UNC, devname);
 			if (strncmp(vol->UNC, "//", 2) == 0) {
 				vol->UNC[0] = '\\';
@@ -1422,21 +1452,21 @@ cifs_parse_mount_options(char *options, const char *devname,
 			} else if (strncmp(vol->UNC, "\\\\", 2) != 0) {
 				printk(KERN_WARNING "CIFS: UNC Path does not "
 						    "begin with // or \\\\ \n");
-				return 1;
+				goto cifs_parse_mount_err;
 			}
 			value = strpbrk(vol->UNC+2, "/\\");
 			if (value)
 				*value = '\\';
 		} else {
 			printk(KERN_WARNING "CIFS: UNC name too long\n");
-			return 1;
+			goto cifs_parse_mount_err;
 		}
 	}
 
 	if (vol->multiuser && !(vol->secFlg & CIFSSEC_MAY_KRB5)) {
 		cERROR(1, "Multiuser mounts currently require krb5 "
 			  "authentication!");
-		return 1;
+		goto cifs_parse_mount_err;
 	}
 
 	if (vol->UNCip == NULL)
@@ -1454,7 +1484,12 @@ cifs_parse_mount_options(char *options, const char *devname,
 		printk(KERN_NOTICE "CIFS: ignoring forcegid mount option "
 				   "specified with no gid= option.\n");
 
+	kfree(mountdata_copy);
 	return 0;
+
+cifs_parse_mount_err:
+	kfree(mountdata_copy);
+	return 1;
 }
 
 /** Returns true if srcaddr isn't specified and rhs isn't
@@ -2704,8 +2739,12 @@ cleanup_volume_info(struct smb_vol **pvolume_info)
 		return;
 
 	volume_info = *pvolume_info;
+	kfree(volume_info->username);
 	kzfree(volume_info->password);
 	kfree(volume_info->UNC);
+	kfree(volume_info->UNCip);
+	kfree(volume_info->domainname);
+	kfree(volume_info->iocharset);
 	kfree(volume_info->prepath);
 	kfree(volume_info);
 	*pvolume_info = NULL;
-- 
1.7.4.1
