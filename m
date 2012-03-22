From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] cifs: use standard token parser for mount options
Date: Thu, 22 Mar 2012 15:26:47 +0000
Message-ID: <1332430007.1883.7.camel@localhost>
References: <1331307197.10670.2.camel@localhost>
	 <20120321133855.52901c60@redhat.com> <1332354787.2818.7.camel@localhost>
	 <20120321163051.0fa2c714@redhat.com>
	 <CAH2r5mt6NiZmF1JZPG2sZ7bwNFiWpxxQ9Q6OoJXC_st7+oUoZg@mail.gmail.com>
	 <20120321163818.0418fd2c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120321163818.0418fd2c-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Use the standard token parser instead of the long if condition to parse
cifs mount options.

This was first proposed by Scott Lovenberg
http://lists.samba.org/archive/linux-cifs-client/2010-May/006079.html

Mount options have been grouped together in terms of their input types.
Aliases for username, password, domain and credentials have been added.
The password parser has been modified to make it easier to read.

Since the patch was first proposed, the following bugs have been fixed
1) Allow blank 'pass' option to be passed by the cifs mount helper when
using sec=none.
2) Do not explicitly set vol->nullauth to 0. This causes a problem
when using sec=none while also using a username.

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c | 1338 ++++++++++++++++++++++++++++++++---------------------
 1 files changed, 814 insertions(+), 524 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5560e1d..06702d3 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -40,6 +40,8 @@
 #include <linux/module.h>
 #include <keys/user-type.h>
 #include <net/ipv6.h>
+#include <linux/parser.h>
+
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
@@ -63,6 +65,191 @@ extern mempool_t *cifs_req_poolp;
 #define TLINK_ERROR_EXPIRE	(1 * HZ)
 #define TLINK_IDLE_EXPIRE	(600 * HZ)
 
+enum {
+
+	/* Mount options that take no arguments */
+	Opt_user_xattr, Opt_nouser_xattr,
+	Opt_forceuid, Opt_noforceuid,
+	Opt_noblocksend, Opt_noautotune,
+	Opt_hard, Opt_soft, Opt_perm, Opt_noperm,
+	Opt_mapchars, Opt_nomapchars, Opt_sfu,
+	Opt_nosfu, Opt_nodfs, Opt_posixpaths,
+	Opt_noposixpaths, Opt_nounix,
+	Opt_nocase,
+	Opt_brl, Opt_nobrl,
+	Opt_forcemandatorylock, Opt_setuids,
+	Opt_nosetuids, Opt_dynperm, Opt_nodynperm,
+	Opt_nohard, Opt_nosoft,
+	Opt_nointr, Opt_intr,
+	Opt_nostrictsync, Opt_strictsync,
+	Opt_serverino, Opt_noserverino,
+	Opt_rwpidforward, Opt_cifsacl, Opt_nocifsacl,
+	Opt_acl, Opt_noacl, Opt_locallease,
+	Opt_sign, Opt_seal, Opt_direct,
+	Opt_strictcache, Opt_noac,
+	Opt_fsc, Opt_mfsymlinks,
+	Opt_multiuser,
+
+	/* Mount options which take numeric value */
+	Opt_backupuid, Opt_backupgid, Opt_uid,
+	Opt_cruid, Opt_gid, Opt_file_mode,
+	Opt_dirmode, Opt_port,
+	Opt_rsize, Opt_wsize, Opt_actimeo,
+
+	/* Mount options which take string value */
+	Opt_user, Opt_pass, Opt_ip,
+	Opt_unc, Opt_domain,
+	Opt_srcaddr, Opt_prefixpath,
+	Opt_iocharset, Opt_sockopt,
+	Opt_netbiosname, Opt_servern,
+	Opt_ver, Opt_sec,
+
+	/* Mount options to be ignored */
+	Opt_ignore,
+
+	/* Options which could be blank */
+	Opt_blank_pass,
+
+	Opt_err
+};
+
+static const match_table_t cifs_mount_option_tokens = {
+
+	{ Opt_user_xattr, "user_xattr" },
+	{ Opt_nouser_xattr, "nouser_xattr" },
+	{ Opt_forceuid, "forceuid" },
+	{ Opt_noforceuid, "noforceuid" },
+	{ Opt_noblocksend, "noblocksend" },
+	{ Opt_noautotune, "noautotune" },
+	{ Opt_hard, "hard" },
+	{ Opt_soft, "soft" },
+	{ Opt_perm, "perm" },
+	{ Opt_noperm, "noperm" },
+	{ Opt_mapchars, "mapchars" },
+	{ Opt_nomapchars, "nomapchars" },
+	{ Opt_sfu, "sfu" },
+	{ Opt_nosfu, "nosfu" },
+	{ Opt_nodfs, "nodfs" },
+	{ Opt_posixpaths, "posixpaths" },
+	{ Opt_noposixpaths, "noposixpaths" },
+	{ Opt_nounix, "nounix" },
+	{ Opt_nounix, "nolinux" },
+	{ Opt_nocase, "nocase" },
+	{ Opt_nocase, "ignorecase" },
+	{ Opt_brl, "brl" },
+	{ Opt_nobrl, "nobrl" },
+	{ Opt_nobrl, "nolock" },
+	{ Opt_forcemandatorylock, "forcemandatorylock" },
+	{ Opt_setuids, "setuids" },
+	{ Opt_nosetuids, "nosetuids" },
+	{ Opt_dynperm, "dynperm" },
+	{ Opt_nodynperm, "nodynperm" },
+	{ Opt_nohard, "nohard" },
+	{ Opt_nosoft, "nosoft" },
+	{ Opt_nointr, "nointr" },
+	{ Opt_intr, "intr" },
+	{ Opt_nostrictsync, "nostrictsync" },
+	{ Opt_strictsync, "strictsync" },
+	{ Opt_serverino, "serverino" },
+	{ Opt_noserverino, "noserverino" },
+	{ Opt_rwpidforward, "rwpidforward" },
+	{ Opt_cifsacl, "cifsacl" },
+	{ Opt_nocifsacl, "nocifsacl" },
+	{ Opt_acl, "acl" },
+	{ Opt_noacl, "noacl" },
+	{ Opt_locallease, "locallease" },
+	{ Opt_sign, "sign" },
+	{ Opt_seal, "seal" },
+	{ Opt_direct, "direct" },
+	{ Opt_direct, "forceddirectio" },
+	{ Opt_strictcache, "strictcache" },
+	{ Opt_noac, "noac" },
+	{ Opt_fsc, "fsc" },
+	{ Opt_mfsymlinks, "mfsymlinks" },
+	{ Opt_multiuser, "multiuser" },
+
+	{ Opt_backupuid, "backupuid=%s" },
+	{ Opt_backupgid, "backupgid=%s" },
+	{ Opt_uid, "uid=%s" },
+	{ Opt_cruid, "cruid=%s" },
+	{ Opt_gid, "gid=%s" },
+	{ Opt_file_mode, "file_mode=%s" },
+	{ Opt_dirmode, "dirmode=%s" },
+	{ Opt_dirmode, "dir_mode=%s" },
+	{ Opt_port, "port=%s" },
+	{ Opt_rsize, "rsize=%s" },
+	{ Opt_wsize, "wsize=%s" },
+	{ Opt_actimeo, "actimeo=%s" },
+
+	{ Opt_user, "user=%s" },
+	{ Opt_user, "username=%s" },
+	{ Opt_blank_pass, "pass=" },
+	{ Opt_pass, "pass=%s" },
+	{ Opt_pass, "password=%s" },
+	{ Opt_ip, "ip=%s" },
+	{ Opt_ip, "addr=%s" },
+	{ Opt_unc, "unc=%s" },
+	{ Opt_unc, "target=%s" },
+	{ Opt_unc, "path=%s" },
+	{ Opt_domain, "dom=%s" },
+	{ Opt_domain, "domain=%s" },
+	{ Opt_domain, "workgroup=%s" },
+	{ Opt_srcaddr, "srcaddr=%s" },
+	{ Opt_prefixpath, "prefixpath=%s" },
+	{ Opt_iocharset, "iocharset=%s" },
+	{ Opt_sockopt, "sockopt=%s" },
+	{ Opt_netbiosname, "netbiosname=%s" },
+	{ Opt_servern, "servern=%s" },
+	{ Opt_ver, "ver=%s" },
+	{ Opt_ver, "vers=%s" },
+	{ Opt_ver, "version=%s" },
+	{ Opt_sec, "sec=%s" },
+
+	{ Opt_ignore, "cred" },
+	{ Opt_ignore, "credentials" },
+	{ Opt_ignore, "guest" },
+	{ Opt_ignore, "rw" },
+	{ Opt_ignore, "ro" },
+	{ Opt_ignore, "suid" },
+	{ Opt_ignore, "nosuid" },
+	{ Opt_ignore, "exec" },
+	{ Opt_ignore, "noexec" },
+	{ Opt_ignore, "nodev" },
+	{ Opt_ignore, "noauto" },
+	{ Opt_ignore, "dev" },
+	{ Opt_ignore, "mand" },
+	{ Opt_ignore, "nomand" },
+	{ Opt_ignore, "_netdev" },
+
+	{ Opt_err, NULL }
+};
+
+enum {
+	Opt_sec_krb5, Opt_sec_krb5i, Opt_sec_krb5p,
+	Opt_sec_ntlmsspi, Opt_sec_ntlmssp,
+	Opt_ntlm, Opt_sec_ntlmi, Opt_sec_ntlmv2i,
+	Opt_sec_nontlm, Opt_sec_lanman,
+	Opt_sec_none,
+
+	Opt_sec_err
+};
+
+static const match_table_t cifs_secflavor_tokens = {
+	{ Opt_sec_krb5, "krb5" },
+	{ Opt_sec_krb5i, "krb5i" },
+	{ Opt_sec_krb5p, "krb5p" },
+	{ Opt_sec_ntlmsspi, "ntlmsspi" },
+	{ Opt_sec_ntlmssp, "ntlmssp" },
+	{ Opt_ntlm, "ntlm" },
+	{ Opt_sec_ntlmi, "ntlmi" },
+	{ Opt_sec_ntlmv2i, "ntlmv2i" },
+	{ Opt_sec_nontlm, "nontlm" },
+	{ Opt_sec_lanman, "lanman" },
+	{ Opt_sec_none, "none" },
+
+	{ Opt_sec_err, NULL }
+};
+
 static int ip_connect(struct TCP_Server_Info *server);
 static int generic_ip_connect(struct TCP_Server_Info *server);
 static void tlink_rb_insert(struct rb_root *root, struct tcon_link *new_tlink);
@@ -926,13 +1113,79 @@ extract_hostname(const char *unc)
 	return dst;
 }
 
+static int get_option_ul(substring_t args[], unsigned long *option)
+{
+	int rc;
+	char *string;
+
+	string = match_strdup(args);
+	if (string == NULL)
+		return -ENOMEM;
+	rc = kstrtoul(string, 10, option);
+	kfree(string);
+
+	return rc;
+}
+
+
+static int cifs_parse_security_flavors(char *value,
+				       struct smb_vol *vol)
+{
+
+	substring_t args[MAX_OPT_ARGS];
+
+	switch (match_token(value, cifs_secflavor_tokens, args)) {
+	case Opt_sec_krb5:
+		vol->secFlg |= CIFSSEC_MAY_KRB5;
+		break;
+	case Opt_sec_krb5i:
+		vol->secFlg |= CIFSSEC_MAY_KRB5 | CIFSSEC_MUST_SIGN;
+		break;
+	case Opt_sec_krb5p:
+		/* vol->secFlg |= CIFSSEC_MUST_SEAL | CIFSSEC_MAY_KRB5; */
+		cERROR(1, "Krb5 cifs privacy not supported");
+		break;
+	case Opt_sec_ntlmssp:
+		vol->secFlg |= CIFSSEC_MAY_NTLMSSP;
+		break;
+	case Opt_sec_ntlmsspi:
+		vol->secFlg |= CIFSSEC_MAY_NTLMSSP | CIFSSEC_MUST_SIGN;
+		break;
+	case Opt_ntlm:
+		/* ntlm is default so can be turned off too */
+		vol->secFlg |= CIFSSEC_MAY_NTLM;
+		break;
+	case Opt_sec_ntlmi:
+		vol->secFlg |= CIFSSEC_MAY_NTLM | CIFSSEC_MUST_SIGN;
+		break;
+	case Opt_sec_nontlm:
+		vol->secFlg |= CIFSSEC_MAY_NTLMV2;
+		break;
+	case Opt_sec_ntlmv2i:
+		vol->secFlg |= CIFSSEC_MAY_NTLMV2 | CIFSSEC_MUST_SIGN;
+		break;
+#ifdef CONFIG_CIFS_WEAK_PW_HASH
+	case Opt_sec_lanman:
+		vol->secFlg |= CIFSSEC_MAY_LANMAN;
+		break;
+#endif
+	case Opt_sec_none:
+		vol->nullauth = 1;
+		break;
+	default:
+		cERROR(1, "bad security option: %s", value);
+		return 1;
+	}
+
+	return 0;
+}
+
 static int
 cifs_parse_mount_options(const char *mountdata, const char *devname,
 			 struct smb_vol *vol)
 {
-	char *value, *data, *end;
+	char *data, *end;
 	char *mountdata_copy = NULL, *options;
-	int err;
 	unsigned int  temp_len, i, j;
 	char separator[2];
 	short int override_uid = -1;
@@ -940,9 +1193,13 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 	bool uid_specified = false;
 	bool gid_specified = false;
 	char *nodename = utsname()->nodename;
+	char *string = NULL;
+	char *tmp_end, *value;
+	char delim;
 
 	separator[0] = ',';
 	separator[1] = 0;
+	delim = separator[0];
 
 	/*
 	 * does not have to be perfect mapping since field is
@@ -981,6 +1238,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 
 	options = mountdata_copy;
 	end = options + strlen(options);
+
 	if (strncmp(options, "sep=", 4) == 0) {
 		if (options[4] != 0) {
 			separator[0] = options[4];
@@ -993,609 +1251,638 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 	vol->backupgid_specified = false; /* no backup intent for a group */
 
 	while ((data = strsep(&options, separator)) != NULL) {
+		substring_t args[MAX_OPT_ARGS];
+		unsigned long option;
+		int token;
+
 		if (!*data)
 			continue;
-		if ((value = strchr(data, '=')) != NULL)
-			*value++ = '\0';
 
-		/* Have to parse this before we parse for "user" */
-		if (strnicmp(data, "user_xattr", 10) == 0) {
+		token = match_token(data, cifs_mount_option_tokens, args);
+
+		switch (token) {
+
+		/* Ingnore the following */
+		case Opt_ignore:
+			break;
+
+		/* Boolean values */
+		case Opt_user_xattr:
 			vol->no_xattr = 0;
-		} else if (strnicmp(data, "nouser_xattr", 12) == 0) {
+			break;
+		case Opt_nouser_xattr:
 			vol->no_xattr = 1;
-		} else if (strnicmp(data, "user", 4) == 0) {
-			if (!value) {
-				printk(KERN_WARNING
-				       "CIFS: invalid or missing username\n");
-				goto cifs_parse_mount_err;
-			} else if (!*value) {
-				/* null user, ie anonymous, authentication */
-				vol->nullauth = 1;
-			}
-			if (strnlen(value, MAX_USERNAME_SIZE) <
-						MAX_USERNAME_SIZE) {
-				vol->username = kstrdup(value, GFP_KERNEL);
-				if (!vol->username) {
-					printk(KERN_WARNING "CIFS: no memory "
-							    "for username\n");
-					goto cifs_parse_mount_err;
-				}
-			} else {
-				printk(KERN_WARNING "CIFS: username too long\n");
-				goto cifs_parse_mount_err;
-			}
-		} else if (strnicmp(data, "pass", 4) == 0) {
-			if (!value) {
-				vol->password = NULL;
-				continue;
-			} else if (value[0] == 0) {
-				/* check if string begins with double comma
-				   since that would mean the password really
-				   does start with a comma, and would not
-				   indicate an empty string */
-				if (value[1] != separator[0]) {
-					vol->password = NULL;
-					continue;
-				}
-			}
-			temp_len = strlen(value);
-			/* removed password length check, NTLM passwords
-				can be arbitrarily long */
-
-			/* if comma in password, the string will be
-			prematurely null terminated.  Commas in password are
-			specified across the cifs mount interface by a double
-			comma ie ,, and a comma used as in other cases ie ','
-			as a parameter delimiter/separator is single and due
-			to the strsep above is temporarily zeroed. */
-
-			/* NB: password legally can have multiple commas and
-			the only illegal character in a password is null */
-
-			if ((value[temp_len] == 0) &&
-			    (value + temp_len < end) &&
-			    (value[temp_len+1] == separator[0])) {
-				/* reinsert comma */
-				value[temp_len] = separator[0];
-				temp_len += 2;  /* move after second comma */
-				while (value[temp_len] != 0)  {
-					if (value[temp_len] == separator[0]) {
-						if (value[temp_len+1] ==
-						     separator[0]) {
-						/* skip second comma */
-							temp_len++;
-						} else {
-						/* single comma indicating start
-							 of next parm */
-							break;
-						}
-					}
-					temp_len++;
-				}
-				if (value[temp_len] == 0) {
-					options = NULL;
-				} else {
-					value[temp_len] = 0;
-					/* point option to start of next parm */
-					options = value + temp_len + 1;
-				}
-				/* go from value to value + temp_len condensing
-				double commas to singles. Note that this ends up
-				allocating a few bytes too many, which is ok */
-				vol->password = kzalloc(temp_len, GFP_KERNEL);
-				if (vol->password == NULL) {
-					printk(KERN_WARNING "CIFS: no memory "
-							    "for password\n");
-					goto cifs_parse_mount_err;
-				}
-				for (i = 0, j = 0; i < temp_len; i++, j++) {
-					vol->password[j] = value[i];
-					if (value[i] == separator[0]
-						&& value[i+1] == separator[0]) {
-						/* skip second comma */
-						i++;
-					}
-				}
-				vol->password[j] = 0;
-			} else {
-				vol->password = kzalloc(temp_len+1, GFP_KERNEL);
-				if (vol->password == NULL) {
-					printk(KERN_WARNING "CIFS: no memory "
-							    "for password\n");
-					goto cifs_parse_mount_err;
-				}
-				strcpy(vol->password, value);
-			}
-		} else if (!strnicmp(data, "ip", 2) ||
-			   !strnicmp(data, "addr", 4)) {
-			if (!value || !*value) {
-				vol->UNCip = NULL;
-			} else if (strnlen(value, INET6_ADDRSTRLEN) <
-							INET6_ADDRSTRLEN) {
-				vol->UNCip = kstrdup(value, GFP_KERNEL);
-				if (!vol->UNCip) {
-					printk(KERN_WARNING "CIFS: no memory "
-							    "for UNC IP\n");
-					goto cifs_parse_mount_err;
-				}
-			} else {
-				printk(KERN_WARNING "CIFS: ip address "
-						    "too long\n");
-				goto cifs_parse_mount_err;
-			}
-		} else if (strnicmp(data, "sec", 3) == 0) {
-			if (!value || !*value) {
-				cERROR(1, "no security value specified");
-				continue;
-			} else if (strnicmp(value, "krb5i", 5) == 0) {
-				vol->secFlg |= CIFSSEC_MAY_KRB5 |
-					CIFSSEC_MUST_SIGN;
-			} else if (strnicmp(value, "krb5p", 5) == 0) {
-				/* vol->secFlg |= CIFSSEC_MUST_SEAL |
-					CIFSSEC_MAY_KRB5; */
-				cERROR(1, "Krb5 cifs privacy not supported");
-				goto cifs_parse_mount_err;
-			} else if (strnicmp(value, "krb5", 4) == 0) {
-				vol->secFlg |= CIFSSEC_MAY_KRB5;
-			} else if (strnicmp(value, "ntlmsspi", 8) == 0) {
-				vol->secFlg |= CIFSSEC_MAY_NTLMSSP |
-					CIFSSEC_MUST_SIGN;
-			} else if (strnicmp(value, "ntlmssp", 7) == 0) {
-				vol->secFlg |= CIFSSEC_MAY_NTLMSSP;
-			} else if (strnicmp(value, "ntlmv2i", 7) == 0) {
-				vol->secFlg |= CIFSSEC_MAY_NTLMV2 |
-					CIFSSEC_MUST_SIGN;
-			} else if (strnicmp(value, "ntlmv2", 6) == 0) {
-				vol->secFlg |= CIFSSEC_MAY_NTLMV2;
-			} else if (strnicmp(value, "ntlmi", 5) == 0) {
-				vol->secFlg |= CIFSSEC_MAY_NTLM |
-					CIFSSEC_MUST_SIGN;
-			} else if (strnicmp(value, "ntlm", 4) == 0) {
-				/* ntlm is default so can be turned off too */
-				vol->secFlg |= CIFSSEC_MAY_NTLM;
-			} else if (strnicmp(value, "nontlm", 6) == 0) {
-				/* BB is there a better way to do this? */
-				vol->secFlg |= CIFSSEC_MAY_NTLMV2;
-#ifdef CONFIG_CIFS_WEAK_PW_HASH
-			} else if (strnicmp(value, "lanman", 6) == 0) {
-				vol->secFlg |= CIFSSEC_MAY_LANMAN;
-#endif
-			} else if (strnicmp(value, "none", 4) == 0) {
-				vol->nullauth = 1;
-			} else {
-				cERROR(1, "bad security option: %s", value);
-				goto cifs_parse_mount_err;
-			}
-		} else if (strnicmp(data, "vers", 3) == 0) {
-			if (!value || !*value) {
-				cERROR(1, "no protocol version specified"
-					  " after vers= mount option");
-			} else if ((strnicmp(value, "cifs", 4) == 0) ||
-				   (strnicmp(value, "1", 1) == 0)) {
-				/* this is the default */
-				continue;
-			}
-		} else if ((strnicmp(data, "unc", 3) == 0)
-			   || (strnicmp(data, "target", 6) == 0)
-			   || (strnicmp(data, "path", 4) == 0)) {
-			if (!value || !*value) {
-				printk(KERN_WARNING "CIFS: invalid path to "
-						    "network resource\n");
-				goto cifs_parse_mount_err;
-			}
-			if ((temp_len = strnlen(value, 300)) < 300) {
-				vol->UNC = kmalloc(temp_len+1, GFP_KERNEL);
-				if (vol->UNC == NULL)
-					goto cifs_parse_mount_err;
-				strcpy(vol->UNC, value);
-				if (strncmp(vol->UNC, "//", 2) == 0) {
-					vol->UNC[0] = '\\';
-					vol->UNC[1] = '\\';
-				} else if (strncmp(vol->UNC, "\\\\", 2) != 0) {
-					printk(KERN_WARNING
-					       "CIFS: UNC Path does not begin "
-					       "with // or \\\\ \n");
-					goto cifs_parse_mount_err;
-				}
-			} else {
-				printk(KERN_WARNING "CIFS: UNC name too long\n");
-				goto cifs_parse_mount_err;
-			}
-		} else if ((strnicmp(data, "domain", 3) == 0)
-			   || (strnicmp(data, "workgroup", 5) == 0)) {
-			if (!value || !*value) {
-				printk(KERN_WARNING "CIFS: invalid domain name\n");
-				goto cifs_parse_mount_err;
-			}
-			/* BB are there cases in which a comma can be valid in
-			a domain name and need special handling? */
-			if (strnlen(value, 256) < 256) {
-				vol->domainname = kstrdup(value, GFP_KERNEL);
-				if (!vol->domainname) {
-					printk(KERN_WARNING "CIFS: no memory "
-							    "for domainname\n");
-					goto cifs_parse_mount_err;
-				}
-				cFYI(1, "Domain name set");
-			} else {
-				printk(KERN_WARNING "CIFS: domain name too "
-						    "long\n");
-				goto cifs_parse_mount_err;
-			}
-		} else if (strnicmp(data, "srcaddr", 7) == 0) {
-			vol->srcaddr.ss_family = AF_UNSPEC;
-
-			if (!value || !*value) {
-				printk(KERN_WARNING "CIFS: srcaddr value"
-				       " not specified.\n");
-				goto cifs_parse_mount_err;
-			}
-			i = cifs_convert_address((struct sockaddr *)&vol->srcaddr,
-						 value, strlen(value));
-			if (i == 0) {
-				printk(KERN_WARNING "CIFS:  Could not parse"
-				       " srcaddr: %s\n",
-				       value);
-				goto cifs_parse_mount_err;
-			}
-		} else if (strnicmp(data, "prefixpath", 10) == 0) {
-			if (!value || !*value) {
-				printk(KERN_WARNING
-					"CIFS: invalid path prefix\n");
-				goto cifs_parse_mount_err;
-			}
-			if ((temp_len = strnlen(value, 1024)) < 1024) {
-				if (value[0] != '/')
-					temp_len++;  /* missing leading slash */
-				vol->prepath = kmalloc(temp_len+1, GFP_KERNEL);
-				if (vol->prepath == NULL)
-					goto cifs_parse_mount_err;
-				if (value[0] != '/') {
-					vol->prepath[0] = '/';
-					strcpy(vol->prepath+1, value);
-				} else
-					strcpy(vol->prepath, value);
-				cFYI(1, "prefix path %s", vol->prepath);
-			} else {
-				printk(KERN_WARNING "CIFS: prefix too long\n");
-				goto cifs_parse_mount_err;
-			}
-		} else if (strnicmp(data, "iocharset", 9) == 0) {
-			if (!value || !*value) {
-				printk(KERN_WARNING "CIFS: invalid iocharset "
-						    "specified\n");
-				goto cifs_parse_mount_err;
-			}
-			if (strnlen(value, 65) < 65) {
-				if (strnicmp(value, "default", 7)) {
-					vol->iocharset = kstrdup(value,
-								 GFP_KERNEL);
-
-					if (!vol->iocharset) {
-						printk(KERN_WARNING "CIFS: no "
-								   "memory for"
-								   "charset\n");
-						goto cifs_parse_mount_err;
-					}
-				}
-				/* if iocharset not set then load_nls_default
-				   is used by caller */
-				cFYI(1, "iocharset set to %s", value);
-			} else {
-				printk(KERN_WARNING "CIFS: iocharset name "
-						    "too long.\n");
-				goto cifs_parse_mount_err;
-			}
-		} else if (!strnicmp(data, "uid", 3) && value && *value) {
-			vol->linux_uid = simple_strtoul(value, &value, 0);
-			uid_specified = true;
-		} else if (!strnicmp(data, "cruid", 5) && value && *value) {
-			vol->cred_uid = simple_strtoul(value, &value, 0);
-		} else if (!strnicmp(data, "forceuid", 8)) {
+			break;
+		case Opt_forceuid:
 			override_uid = 1;
-		} else if (!strnicmp(data, "noforceuid", 10)) {
+			break;
+		case Opt_noforceuid:
 			override_uid = 0;
-		} else if (!strnicmp(data, "gid", 3) && value && *value) {
-			vol->linux_gid = simple_strtoul(value, &value, 0);
-			gid_specified = true;
-		} else if (!strnicmp(data, "forcegid", 8)) {
-			override_gid = 1;
-		} else if (!strnicmp(data, "noforcegid", 10)) {
-			override_gid = 0;
-		} else if (strnicmp(data, "file_mode", 4) == 0) {
-			if (value && *value) {
-				vol->file_mode =
-					simple_strtoul(value, &value, 0);
-			}
-		} else if (strnicmp(data, "dir_mode", 4) == 0) {
-			if (value && *value) {
-				vol->dir_mode =
-					simple_strtoul(value, &value, 0);
-			}
-		} else if (strnicmp(data, "dirmode", 4) == 0) {
-			if (value && *value) {
-				vol->dir_mode =
-					simple_strtoul(value, &value, 0);
-			}
-		} else if (strnicmp(data, "port", 4) == 0) {
-			if (value && *value) {
-				vol->port =
-					simple_strtoul(value, &value, 0);
-			}
-		} else if (strnicmp(data, "rsize", 5) == 0) {
-			if (value && *value) {
-				vol->rsize =
-					simple_strtoul(value, &value, 0);
-			}
-		} else if (strnicmp(data, "wsize", 5) == 0) {
-			if (value && *value) {
-				vol->wsize =
-					simple_strtoul(value, &value, 0);
-			}
-		} else if (strnicmp(data, "sockopt", 5) == 0) {
-			if (!value || !*value) {
-				cERROR(1, "no socket option specified");
-				continue;
-			} else if (strnicmp(value, "TCP_NODELAY", 11) == 0) {
-				vol->sockopt_tcp_nodelay = 1;
-			}
-		} else if (strnicmp(data, "netbiosname", 4) == 0) {
-			if (!value || !*value || (*value == ' ')) {
-				cFYI(1, "invalid (empty) netbiosname");
-			} else {
-				memset(vol->source_rfc1001_name, 0x20,
-					RFC1001_NAME_LEN);
-				/*
-				 * FIXME: are there cases in which a comma can
-				 * be valid in workstation netbios name (and
-				 * need special handling)?
-				 */
-				for (i = 0; i < RFC1001_NAME_LEN; i++) {
-					/* don't ucase netbiosname for user */
-					if (value[i] == 0)
-						break;
-					vol->source_rfc1001_name[i] = value[i];
-				}
-				/* The string has 16th byte zero still from
-				set at top of the function  */
-				if (i == RFC1001_NAME_LEN && value[i] != 0)
-					printk(KERN_WARNING "CIFS: netbiosname"
-						" longer than 15 truncated.\n");
-			}
-		} else if (strnicmp(data, "servern", 7) == 0) {
-			/* servernetbiosname specified override *SMBSERVER */
-			if (!value || !*value || (*value == ' ')) {
-				cFYI(1, "empty server netbiosname specified");
-			} else {
-				/* last byte, type, is 0x20 for servr type */
-				memset(vol->target_rfc1001_name, 0x20,
-					RFC1001_NAME_LEN_WITH_NULL);
-
-				for (i = 0; i < 15; i++) {
-				/* BB are there cases in which a comma can be
-				   valid in this workstation netbios name
-				   (and need special handling)? */
-
-				/* user or mount helper must uppercase
-				   the netbiosname */
-					if (value[i] == 0)
-						break;
-					else
-						vol->target_rfc1001_name[i] =
-								value[i];
-				}
-				/* The string has 16th byte zero still from
-				   set at top of the function  */
-				if (i == RFC1001_NAME_LEN && value[i] != 0)
-					printk(KERN_WARNING "CIFS: server net"
-					"biosname longer than 15 truncated.\n");
-			}
-		} else if (strnicmp(data, "actimeo", 7) == 0) {
-			if (value && *value) {
-				vol->actimeo = HZ * simple_strtoul(value,
-								   &value, 0);
-				if (vol->actimeo > CIFS_MAX_ACTIMEO) {
-					cERROR(1, "CIFS: attribute cache"
-							"timeout too large");
-					goto cifs_parse_mount_err;
-				}
-			}
-		} else if (strnicmp(data, "credentials", 4) == 0) {
-			/* ignore */
-		} else if (strnicmp(data, "version", 3) == 0) {
-			/* ignore */
-		} else if (strnicmp(data, "guest", 5) == 0) {
-			/* ignore */
-		} else if (strnicmp(data, "rw", 2) == 0 && strlen(data) == 2) {
-			/* ignore */
-		} else if (strnicmp(data, "ro", 2) == 0) {
-			/* ignore */
-		} else if (strnicmp(data, "noblocksend", 11) == 0) {
+			break;
+		case Opt_noblocksend:
 			vol->noblocksnd = 1;
-		} else if (strnicmp(data, "noautotune", 10) == 0) {
+			break;
+		case Opt_noautotune:
 			vol->noautotune = 1;
-		} else if ((strnicmp(data, "suid", 4) == 0) ||
-				   (strnicmp(data, "nosuid", 6) == 0) ||
-				   (strnicmp(data, "exec", 4) == 0) ||
-				   (strnicmp(data, "noexec", 6) == 0) ||
-				   (strnicmp(data, "nodev", 5) == 0) ||
-				   (strnicmp(data, "noauto", 6) == 0) ||
-				   (strnicmp(data, "dev", 3) == 0)) {
-			/*  The mount tool or mount.cifs helper (if present)
-			    uses these opts to set flags, and the flags are read
-			    by the kernel vfs layer before we get here (ie
-			    before read super) so there is no point trying to
-			    parse these options again and set anything and it
-			    is ok to just ignore them */
-			continue;
-		} else if (strnicmp(data, "hard", 4) == 0) {
+			break;
+		case Opt_hard:
 			vol->retry = 1;
-		} else if (strnicmp(data, "soft", 4) == 0) {
+			break;
+		case Opt_soft:
 			vol->retry = 0;
-		} else if (strnicmp(data, "perm", 4) == 0) {
+			break;
+		case Opt_perm:
 			vol->noperm = 0;
-		} else if (strnicmp(data, "noperm", 6) == 0) {
+			break;
+		case Opt_noperm:
 			vol->noperm = 1;
-		} else if (strnicmp(data, "mapchars", 8) == 0) {
+			break;
+		case Opt_mapchars:
 			vol->remap = 1;
-		} else if (strnicmp(data, "nomapchars", 10) == 0) {
+			break;
+		case Opt_nomapchars:
 			vol->remap = 0;
-		} else if (strnicmp(data, "sfu", 3) == 0) {
+			break;
+		case Opt_sfu:
 			vol->sfu_emul = 1;
-		} else if (strnicmp(data, "nosfu", 5) == 0) {
+			break;
+		case Opt_nosfu:
 			vol->sfu_emul = 0;
-		} else if (strnicmp(data, "nodfs", 5) == 0) {
+			break;
+		case Opt_nodfs:
 			vol->nodfs = 1;
-		} else if (strnicmp(data, "posixpaths", 10) == 0) {
+			break;
+		case Opt_posixpaths:
 			vol->posix_paths = 1;
-		} else if (strnicmp(data, "noposixpaths", 12) == 0) {
+			break;
+		case Opt_noposixpaths:
 			vol->posix_paths = 0;
-		} else if (strnicmp(data, "nounix", 6) == 0) {
-			vol->no_linux_ext = 1;
-		} else if (strnicmp(data, "nolinux", 7) == 0) {
+			break;
+		case Opt_nounix:
 			vol->no_linux_ext = 1;
-		} else if ((strnicmp(data, "nocase", 6) == 0) ||
-			   (strnicmp(data, "ignorecase", 10)  == 0)) {
+			break;
+		case Opt_nocase:
 			vol->nocase = 1;
-		} else if (strnicmp(data, "mand", 4) == 0) {
-			/* ignore */
-		} else if (strnicmp(data, "nomand", 6) == 0) {
-			/* ignore */
-		} else if (strnicmp(data, "_netdev", 7) == 0) {
-			/* ignore */
-		} else if (strnicmp(data, "brl", 3) == 0) {
+			break;
+		case Opt_brl:
 			vol->nobrl =  0;
-		} else if ((strnicmp(data, "nobrl", 5) == 0) ||
-			   (strnicmp(data, "nolock", 6) == 0)) {
+			break;
+		case Opt_nobrl:
 			vol->nobrl =  1;
 			/* turn off mandatory locking in mode
-			if remote locking is turned off since the
-			local vfs will do advisory */
+			 * if remote locking is turned off since the
+			 * local vfs will do advisory */
 			if (vol->file_mode ==
 				(S_IALLUGO & ~(S_ISUID | S_IXGRP)))
 				vol->file_mode = S_IALLUGO;
-		} else if (strnicmp(data, "forcemandatorylock", 9) == 0) {
-			/* will take the shorter form "forcemand" as well */
-			/* This mount option will force use of mandatory
-			  (DOS/Windows style) byte range locks, instead of
-			  using posix advisory byte range locks, even if the
-			  Unix extensions are available and posix locks would
-			  be supported otherwise. If Unix extensions are not
-			  negotiated this has no effect since mandatory locks
-			  would be used (mandatory locks is all that those
-			  those servers support) */
+			break;
+		case Opt_forcemandatorylock:
 			vol->mand_lock = 1;
-		} else if (strnicmp(data, "setuids", 7) == 0) {
+			break;
+		case Opt_setuids:
 			vol->setuids = 1;
-		} else if (strnicmp(data, "nosetuids", 9) == 0) {
+			break;
+		case Opt_nosetuids:
 			vol->setuids = 0;
-		} else if (strnicmp(data, "dynperm", 7) == 0) {
+			break;
+		case Opt_dynperm:
 			vol->dynperm = true;
-		} else if (strnicmp(data, "nodynperm", 9) == 0) {
+			break;
+		case Opt_nodynperm:
 			vol->dynperm = false;
-		} else if (strnicmp(data, "nohard", 6) == 0) {
+			break;
+		case Opt_nohard:
 			vol->retry = 0;
-		} else if (strnicmp(data, "nosoft", 6) == 0) {
+			break;
+		case Opt_nosoft:
 			vol->retry = 1;
-		} else if (strnicmp(data, "nointr", 6) == 0) {
+			break;
+		case Opt_nointr:
 			vol->intr = 0;
-		} else if (strnicmp(data, "intr", 4) == 0) {
+			break;
+		case Opt_intr:
 			vol->intr = 1;
-		} else if (strnicmp(data, "nostrictsync", 12) == 0) {
+			break;
+		case Opt_nostrictsync:
 			vol->nostrictsync = 1;
-		} else if (strnicmp(data, "strictsync", 10) == 0) {
+			break;
+		case Opt_strictsync:
 			vol->nostrictsync = 0;
-		} else if (strnicmp(data, "serverino", 7) == 0) {
+			break;
+		case Opt_serverino:
 			vol->server_ino = 1;
-		} else if (strnicmp(data, "noserverino", 9) == 0) {
+			break;
+		case Opt_noserverino:
 			vol->server_ino = 0;
-		} else if (strnicmp(data, "rwpidforward", 12) == 0) {
+			break;
+		case Opt_rwpidforward:
 			vol->rwpidforward = 1;
-		} else if (strnicmp(data, "cifsacl", 7) == 0) {
+			break;
+		case Opt_cifsacl:
 			vol->cifs_acl = 1;
-		} else if (strnicmp(data, "nocifsacl", 9) == 0) {
+			break;
+		case Opt_nocifsacl:
 			vol->cifs_acl = 0;
-		} else if (strnicmp(data, "acl", 3) == 0) {
+			break;
+		case Opt_acl:
 			vol->no_psx_acl = 0;
-		} else if (strnicmp(data, "noacl", 5) == 0) {
+			break;
+		case Opt_noacl:
 			vol->no_psx_acl = 1;
-		} else if (strnicmp(data, "locallease", 6) == 0) {
+			break;
+		case Opt_locallease:
 			vol->local_lease = 1;
-		} else if (strnicmp(data, "sign", 4) == 0) {
+			break;
+		case Opt_sign:
 			vol->secFlg |= CIFSSEC_MUST_SIGN;
-		} else if (strnicmp(data, "seal", 4) == 0) {
+			break;
+		case Opt_seal:
 			/* we do not do the following in secFlags because seal
-			   is a per tree connection (mount) not a per socket
-			   or per-smb connection option in the protocol */
-			/* vol->secFlg |= CIFSSEC_MUST_SEAL; */
+			 * is a per tree connection (mount) not a per socket
+			 * or per-smb connection option in the protocol
+			 * vol->secFlg |= CIFSSEC_MUST_SEAL;
+			 */
 			vol->seal = 1;
-		} else if (strnicmp(data, "direct", 6) == 0) {
-			vol->direct_io = 1;
-		} else if (strnicmp(data, "forcedirectio", 13) == 0) {
+			break;
+		case Opt_direct:
 			vol->direct_io = 1;
-		} else if (strnicmp(data, "strictcache", 11) == 0) {
+			break;
+		case Opt_strictcache:
 			vol->strict_io = 1;
-		} else if (strnicmp(data, "noac", 4) == 0) {
+			break;
+		case Opt_noac:
 			printk(KERN_WARNING "CIFS: Mount option noac not "
 				"supported. Instead set "
 				"/proc/fs/cifs/LookupCacheEnabled to 0\n");
-		} else if (strnicmp(data, "fsc", 3) == 0) {
+			break;
+		case Opt_fsc:
 #ifndef CONFIG_CIFS_FSCACHE
 			cERROR(1, "FS-Cache support needs CONFIG_CIFS_FSCACHE "
 				  "kernel config option set");
 			goto cifs_parse_mount_err;
 #endif
 			vol->fsc = true;
-		} else if (strnicmp(data, "mfsymlinks", 10) == 0) {
+			break;
+		case Opt_mfsymlinks:
 			vol->mfsymlinks = true;
-		} else if (strnicmp(data, "multiuser", 8) == 0) {
+			break;
+		case Opt_multiuser:
 			vol->multiuser = true;
-		} else if (!strnicmp(data, "backupuid", 9) && value && *value) {
-			err = kstrtouint(value, 0, &vol->backupuid);
-			if (err < 0) {
+			break;
+
+		/* Numeric Values */
+		case Opt_backupuid:
+			if (get_option_ul(args, &option)) {
 				cERROR(1, "%s: Invalid backupuid value",
 					__func__);
 				goto cifs_parse_mount_err;
 			}
+			vol->backupuid = option;
 			vol->backupuid_specified = true;
-		} else if (!strnicmp(data, "backupgid", 9) && value && *value) {
-			err = kstrtouint(value, 0, &vol->backupgid);
-			if (err < 0) {
+			break;
+		case Opt_backupgid:
+			if (get_option_ul(args, &option)) {
 				cERROR(1, "%s: Invalid backupgid value",
 					__func__);
 				goto cifs_parse_mount_err;
 			}
+			vol->backupgid = option;
 			vol->backupgid_specified = true;
-		} else
-			printk(KERN_WARNING "CIFS: Unknown mount option %s\n",
-						data);
-	}
-	if (vol->UNC == NULL) {
-		if (devname == NULL) {
-			printk(KERN_WARNING "CIFS: Missing UNC name for mount "
-						"target\n");
-			goto cifs_parse_mount_err;
-		}
-		if ((temp_len = strnlen(devname, 300)) < 300) {
-			vol->UNC = kmalloc(temp_len+1, GFP_KERNEL);
-			if (vol->UNC == NULL)
+			break;
+		case Opt_uid:
+			if (get_option_ul(args, &option)) {
+				cERROR(1, "%s: Invalid uid value",
+					__func__);
+				goto cifs_parse_mount_err;
+			}
+			vol->linux_uid = option;
+			uid_specified = true;
+			break;
+		case Opt_cruid:
+			if (get_option_ul(args, &option)) {
+				cERROR(1, "%s: Invalid cruid value",
+					__func__);
+				goto cifs_parse_mount_err;
+			}
+			vol->cred_uid = option;
+			break;
+		case Opt_gid:
+			if (get_option_ul(args, &option)) {
+				cERROR(1, "%s: Invalid gid value",
+						__func__);
+				goto cifs_parse_mount_err;
+			}
+			vol->linux_gid = option;
+			gid_specified = true;
+			break;
+		case Opt_file_mode:
+			if (get_option_ul(args, &option)) {
+				cERROR(1, "%s: Invalid file_mode value",
+					__func__);
+				goto cifs_parse_mount_err;
+			}
+			vol->file_mode = option;
+			break;
+		case Opt_dirmode:
+			if (get_option_ul(args, &option)) {
+				cERROR(1, "%s: Invalid dir_mode value",
+					__func__);
+				goto cifs_parse_mount_err;
+			}
+			vol->dir_mode = option;
+			break;
+		case Opt_port:
+			if (get_option_ul(args, &option)) {
+				cERROR(1, "%s: Invalid port value",
+					__func__);
+				goto cifs_parse_mount_err;
+			}
+			vol->port = option;
+			break;
+		case Opt_rsize:
+			if (get_option_ul(args, &option)) {
+				cERROR(1, "%s: Invalid rsize value",
+					__func__);
+				goto cifs_parse_mount_err;
+			}
+			vol->rsize = option;
+			break;
+		case Opt_wsize:
+			if (get_option_ul(args, &option)) {
+				cERROR(1, "%s: Invalid wsize value",
+					__func__);
+				goto cifs_parse_mount_err;
+			}
+			vol->wsize = option;
+			break;
+		case Opt_actimeo:
+			if (get_option_ul(args, &option)) {
+				cERROR(1, "%s: Invalid actimeo value",
+					__func__);
+				goto cifs_parse_mount_err;
+			}
+			vol->actimeo = HZ * option;
+			if (vol->actimeo > CIFS_MAX_ACTIMEO) {
+				cERROR(1, "CIFS: attribute cache"
+					  "timeout too large");
+				goto cifs_parse_mount_err;
+			}
+			break;
+
+		/* String Arguments */
+
+		case Opt_user:
+			string = match_strdup(args);
+			if (string == NULL)
+				goto out_nomem;
+
+			if (!*string) {
+				/* null user, ie. anonymous authentication */
+				vol->nullauth = 1;
+			} else if (strnlen(string, MAX_USERNAME_SIZE) >
+							MAX_USERNAME_SIZE) {
+				printk(KERN_WARNING "CIFS: username too long\n");
+				goto cifs_parse_mount_err;
+			}
+			vol->username = kstrdup(string, GFP_KERNEL);
+			if (!vol->username) {
+				printk(KERN_WARNING "CIFS: no memory "
+						    "for username\n");
+				goto cifs_parse_mount_err;
+			}
+			break;
+		case Opt_blank_pass:
+			vol->password = NULL;
+			break;
+		case Opt_pass:
+			/* passwords have to be handled differently
+			 * to allow the character used for deliminator
+			 * to be passed within them
+			 */
+
+			/* Obtain the value string */
+			value = strchr(data, '=');
+			if (value != NULL)
+				*value++ = '\0';
+
+			/* Set tmp_end to end of the string */
+			tmp_end = (char *) value + strlen(value);
+
+			/* Check if following character is the deliminator
+			 * If yes, we have encountered a double deliminator
+			 * reset the NULL character to the deliminator
+			 */
+			if (tmp_end < end && tmp_end[1] == delim)
+				tmp_end[0] = delim;
+
+			/* Keep iterating until we get to a single deliminator
+			 * OR the end
+			 */
+			while ((tmp_end = strchr(tmp_end, delim)) != NULL &&
+			       (tmp_end[1] == delim)) {
+				tmp_end = (char *) &tmp_end[2];
+			}
+
+			/* Reset var options to point to next element */
+			if (tmp_end) {
+				tmp_end[0] = '\0';
+				options = (char *) &tmp_end[1];
+			} else
+				/* Reached the end of the mount option string */
+				options = end;
+
+			/* Now build new password string */
+			temp_len = strlen(value);
+			vol->password = kzalloc(temp_len+1, GFP_KERNEL);
+			if (vol->password == NULL) {
+				printk(KERN_WARNING "CIFS: no memory "
+						    "for password\n");
+				goto cifs_parse_mount_err;
+			}
+
+			for (i = 0, j = 0; i < temp_len; i++, j++) {
+				vol->password[j] = value[i];
+				if ((value[i] == delim) &&
+				     value[i+1] == delim)
+					/* skip the second deliminator */
+					i++;
+			}
+			vol->password[j] = '\0';
+			break;
+		case Opt_ip:
+			string = match_strdup(args);
+			if (string == NULL)
+				goto out_nomem;
+
+			if (!*string) {
+				vol->UNCip = NULL;
+			} else if (strnlen(string, INET6_ADDRSTRLEN) >
+						INET6_ADDRSTRLEN) {
+				printk(KERN_WARNING "CIFS: ip address "
+						    "too long\n");
+				goto cifs_parse_mount_err;
+			}
+			vol->UNCip = kstrdup(string, GFP_KERNEL);
+			if (!vol->UNCip) {
+				printk(KERN_WARNING "CIFS: no memory "
+						    "for UNC IP\n");
+				goto cifs_parse_mount_err;
+			}
+			break;
+		case Opt_unc:
+			string = match_strdup(args);
+			if (string == NULL)
+				goto out_nomem;
+
+			if (!*string) {
+				printk(KERN_WARNING "CIFS: invalid path to "
+						    "network resource\n");
+				goto cifs_parse_mount_err;
+			}
+
+			temp_len = strnlen(string, 300);
+			if (temp_len  == 300) {
+				printk(KERN_WARNING "CIFS: UNC name too long\n");
 				goto cifs_parse_mount_err;
-			strcpy(vol->UNC, devname);
-			if (strncmp(vol->UNC, "//", 2) == 0) {
+			}
+
+			if (strncmp(string, "//", 2) == 0) {
 				vol->UNC[0] = '\\';
 				vol->UNC[1] = '\\';
-			} else if (strncmp(vol->UNC, "\\\\", 2) != 0) {
+			} else if (strncmp(string, "\\\\", 2) != 0) {
 				printk(KERN_WARNING "CIFS: UNC Path does not "
-						    "begin with // or \\\\ \n");
+						    "begin with // or \\\\\n");
 				goto cifs_parse_mount_err;
 			}
-			value = strpbrk(vol->UNC+2, "/\\");
-			if (value)
-				*value = '\\';
-		} else {
-			printk(KERN_WARNING "CIFS: UNC name too long\n");
+
+			vol->UNC = kmalloc(temp_len+1, GFP_KERNEL);
+			if (vol->UNC == NULL) {
+				printk(KERN_WARNING "CIFS: no memory "
+						    "for UNC\n");
+				goto cifs_parse_mount_err;
+			}
+			strcpy(vol->UNC, string);
+			break;
+		case Opt_domain:
+			string = match_strdup(args);
+			if (string == NULL)
+				goto out_nomem;
+
+			if (!*string) {
+				printk(KERN_WARNING "CIFS: invalid domain"
+						    " name\n");
+				goto cifs_parse_mount_err;
+			} else if (strnlen(string, 256) == 256) {
+				printk(KERN_WARNING "CIFS: domain name too"
+						    " long\n");
+				goto cifs_parse_mount_err;
+			}
+
+			vol->domainname = kstrdup(string, GFP_KERNEL);
+			if (!vol->domainname) {
+				printk(KERN_WARNING "CIFS: no memory "
+						    "for domainname\n");
+				goto cifs_parse_mount_err;
+			}
+			cFYI(1, "Domain name set");
+			break;
+		case Opt_srcaddr:
+			string = match_strdup(args);
+			if (string == NULL)
+				goto out_nomem;
+
+			if (!*string) {
+				printk(KERN_WARNING "CIFS: srcaddr value not"
+						    " specified\n");
+				goto cifs_parse_mount_err;
+			} else if (!cifs_convert_address(
+					(struct sockaddr *)&vol->srcaddr,
+					string, strlen(string))) {
+				printk(KERN_WARNING "CIFS:  Could not parse"
+						    " srcaddr: %s\n", string);
+				goto cifs_parse_mount_err;
+			}
+			break;
+		case Opt_prefixpath:
+			string = match_strdup(args);
+			if (string == NULL)
+				goto out_nomem;
+
+			if (!*string) {
+				printk(KERN_WARNING "CIFS: Invalid path"
+						    " prefix\n");
+				goto cifs_parse_mount_err;
+			}
+			temp_len = strnlen(string, 1024);
+			if (string[0] != '/')
+				temp_len++; /* missing leading slash */
+			if (temp_len > 1024) {
+				printk(KERN_WARNING "CIFS: prefix too long\n");
+				goto cifs_parse_mount_err;
+			}
+
+			vol->prepath = kmalloc(temp_len+1, GFP_KERNEL);
+			if (vol->prepath == NULL) {
+				printk(KERN_WARNING "CIFS: no memory "
+						    "for path prefix\n");
+				goto cifs_parse_mount_err;
+			}
+
+			if (string[0] != '/') {
+				vol->prepath[0] = '/';
+				strcpy(vol->prepath+1, string);
+			} else
+				strcpy(vol->prepath, string);
+
+			break;
+		case Opt_iocharset:
+			string = match_strdup(args);
+			if (string == NULL)
+				goto out_nomem;
+
+			if (!*string) {
+				printk(KERN_WARNING "CIFS: Invalid iocharset"
+						    " specified\n");
+				goto cifs_parse_mount_err;
+			} else if (strnlen(string, 1024) >= 65) {
+				printk(KERN_WARNING "CIFS: iocharset name "
+						    "too long.\n");
+				goto cifs_parse_mount_err;
+			}
+
+			 if (strnicmp(string, "default", 7) != 0) {
+				vol->iocharset = kstrdup(string,
+							 GFP_KERNEL);
+				if (!vol->iocharset) {
+					printk(KERN_WARNING "CIFS: no memory"
+							    "for charset\n");
+					goto cifs_parse_mount_err;
+				}
+			}
+			/* if iocharset not set then load_nls_default
+			 * is used by caller
+			 */
+			cFYI(1, "iocharset set to %s", string);
+			break;
+		case Opt_sockopt:
+			string = match_strdup(args);
+			if (string == NULL)
+				goto out_nomem;
+
+			if (!*string) {
+				printk(KERN_WARNING "CIFS: No socket option"
+						    " specified\n");
+				goto cifs_parse_mount_err;
+			}
+			if (strnicmp(string, "TCP_NODELAY", 11) == 0)
+				vol->sockopt_tcp_nodelay = 1;
+			break;
+		case Opt_netbiosname:
+			string = match_strdup(args);
+			if (string == NULL)
+				goto out_nomem;
+
+			if (!*string) {
+				printk(KERN_WARNING "CIFS: Invalid (empty)"
+						    " netbiosname\n");
+				break;
+			}
+
+			memset(vol->source_rfc1001_name, 0x20,
+				RFC1001_NAME_LEN);
+			/*
+			 * FIXME: are there cases in which a comma can
+			 * be valid in workstation netbios name (and
+			 * need special handling)?
+			 */
+			for (i = 0; i < RFC1001_NAME_LEN; i++) {
+				/* don't ucase netbiosname for user */
+				if (string[i] == 0)
+					break;
+				vol->source_rfc1001_name[i] = string[i];
+			}
+			/* The string has 16th byte zero still from
+			 * set at top of the function
+			 */
+			if (i == RFC1001_NAME_LEN && string[i] != 0)
+				printk(KERN_WARNING "CIFS: netbiosname"
+				       " longer than 15 truncated.\n");
+
+			break;
+		case Opt_servern:
+			/* servernetbiosname specified override *SMBSERVER */
+			string = match_strdup(args);
+			if (string == NULL)
+				goto out_nomem;
+
+			if (!*string) {
+				printk(KERN_WARNING "CIFS: Empty server"
+					" netbiosname specified\n");
+				break;
+			}
+			/* last byte, type, is 0x20 for servr type */
+			memset(vol->target_rfc1001_name, 0x20,
+				RFC1001_NAME_LEN_WITH_NULL);
+
+			/* BB are there cases in which a comma can be
+			   valid in this workstation netbios name
+			   (and need special handling)? */
+
+			/* user or mount helper must uppercase the
+			   netbios name */
+			for (i = 0; i < 15; i++) {
+				if (string[i] == 0)
+					break;
+				vol->target_rfc1001_name[i] = string[i];
+			}
+			/* The string has 16th byte zero still from
+			   set at top of the function  */
+			if (i == RFC1001_NAME_LEN && string[i] != 0)
+				printk(KERN_WARNING "CIFS: server net"
+				       "biosname longer than 15 truncated.\n");
+			break;
+		case Opt_ver:
+			string = match_strdup(args);
+			if (string == NULL)
+				goto out_nomem;
+
+			if (!*string) {
+				cERROR(1, "no protocol version specified"
+					  " after vers= mount option");
+				goto cifs_parse_mount_err;
+			}
+
+			if (strnicmp(string, "cifs", 4) == 0 ||
+			    strnicmp(string, "1", 1) == 0) {
+				/* This is the default */
+				break;
+			}
+			/* For all other value, error */
+			printk(KERN_WARNING "CIFS: Invalid version"
+					    " specified\n");
 			goto cifs_parse_mount_err;
+		case Opt_sec:
+			string = match_strdup(args);
+			if (string == NULL)
+				goto out_nomem;
+
+			if (!*string) {
+				printk(KERN_WARNING "CIFS: no security flavor"
+						    " specified\n");
+				break;
+			}
+
+			if (cifs_parse_security_flavors(string, vol) != 0)
+				goto cifs_parse_mount_err;
+			break;
+		default:
+			printk(KERN_WARNING "CIFS: Unknown mount option %s\n",
+						data);
+			break;
 		}
+		/* Free up any allocated string */
+		kfree(string);
+		string = NULL;
 	}
 
 #ifndef CONFIG_KEYS
@@ -1625,7 +1912,10 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 	kfree(mountdata_copy);
 	return 0;
 
+out_nomem:
+	printk(KERN_WARNING "Could not allocate temporary buffer\n");
 cifs_parse_mount_err:
+	kfree(string);
 	kfree(mountdata_copy);
 	return 1;
 }
-- 
1.7.7.6
