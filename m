From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 2/3] cifs: add a smb_version_operations/values structures and a smb_version enum
Date: Wed, 16 May 2012 23:15:04 +0400
Message-ID: <1337195705-1381-3-git-send-email-piastry@etersoft.ru>
References: <1337195705-1381-1-git-send-email-piastry@etersoft.ru>
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337195705-1381-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

We need a way to dispatch different operations for different versions.
Behold the smb_version_operations/values structures. For now, those
structures just hold the version enum value and nothing uses them.
Eventually, we'll expand them to cover other operations/values as we
change the callers to dispatch from here.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/Makefile   |    2 +-
 fs/cifs/cifsfs.c   |    1 +
 fs/cifs/cifsglob.h |   19 +++++++++++++++++++
 fs/cifs/connect.c  |   42 +++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb1ops.c  |   27 +++++++++++++++++++++++++++
 5 files changed, 89 insertions(+), 2 deletions(-)
 create mode 100644 fs/cifs/smb1ops.c

diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index 005d524..0fe7025 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -6,7 +6,7 @@ obj-$(CONFIG_CIFS) += cifs.o
 cifs-y := cifsfs.o cifssmb.o cifs_debug.o connect.o dir.o file.o inode.o \
 	  link.o misc.o netmisc.o smbencrypt.o transport.o asn1.o \
 	  cifs_unicode.o nterr.o xattr.o cifsencrypt.o \
-	  readdir.o ioctl.o sess.o export.o
+	  readdir.o ioctl.o sess.o export.o smb1ops.o
 
 cifs-$(CONFIG_CIFS_ACL) += cifsacl.o
 
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index f718d57..8a6928c 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -354,6 +354,7 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 	struct sockaddr *srcaddr;
 	srcaddr = (struct sockaddr *)&tcon->ses->server->srcaddr;
 
+	seq_printf(s, ",vers=%s", tcon->ses->server->vals->version_string);
 	cifs_show_security(s, tcon->ses->server);
 	cifs_show_cache_flavor(s, cifs_sb);
 
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a867d99..812e22a 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -150,6 +150,17 @@ struct cifs_cred {
  *****************************************************************
  */
 
+enum smb_version {
+	Smb_1 = 1,
+};
+
+struct smb_version_operations {
+};
+
+struct smb_version_values {
+	char		*version_string;
+};
+
 struct smb_vol {
 	char *username;
 	char *password;
@@ -205,6 +216,8 @@ struct smb_vol {
 	bool sockopt_tcp_nodelay:1;
 	unsigned short int port;
 	unsigned long actimeo; /* attribute cache timeout (jiffies) */
+	struct smb_version_operations *ops;
+	struct smb_version_values *vals;
 	char *prepath;
 	struct sockaddr_storage srcaddr; /* allow binding to a local IP */
 	struct nls_table *local_nls;
@@ -242,6 +255,8 @@ struct TCP_Server_Info {
 	int srv_count; /* reference counter */
 	/* 15 character server name + 0x20 16th byte indicating type = srv */
 	char server_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
+	struct smb_version_operations	*ops;
+	struct smb_version_values	*vals;
 	enum statusEnum tcpStatus; /* what we think the status is */
 	char *hostname; /* hostname portion of UNC string */
 	struct socket *ssocket;
@@ -1069,4 +1084,8 @@ void cifs_oplock_break(struct work_struct *work);
 extern const struct slow_work_ops cifs_oplock_break_ops;
 extern struct workqueue_struct *cifsiod_wq;
 
+/* Operations for different SMB versions */
+#define SMB1_VERSION_STRING	"1.0"
+extern struct smb_version_operations smb1_operations;
+extern struct smb_version_values smb1_values;
 #endif	/* _CIFS_GLOB_H */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 0c82881..5fa0403 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -102,7 +102,7 @@ enum {
 	Opt_srcaddr, Opt_prefixpath,
 	Opt_iocharset, Opt_sockopt,
 	Opt_netbiosname, Opt_servern,
-	Opt_ver, Opt_sec, Opt_cache,
+	Opt_ver, Opt_vers, Opt_sec, Opt_cache,
 
 	/* Mount options to be ignored */
 	Opt_ignore,
@@ -209,6 +209,7 @@ static const match_table_t cifs_mount_option_tokens = {
 	{ Opt_netbiosname, "netbiosname=%s" },
 	{ Opt_servern, "servern=%s" },
 	{ Opt_ver, "ver=%s" },
+	{ Opt_vers, "vers=%s" },
 	{ Opt_sec, "sec=%s" },
 	{ Opt_cache, "cache=%s" },
 
@@ -274,6 +275,10 @@ static const match_table_t cifs_cacheflavor_tokens = {
 	{ Opt_cache_err, NULL }
 };
 
+static const match_table_t cifs_smb_version_tokens = {
+	{ Smb_1, SMB1_VERSION_STRING },
+};
+
 static int ip_connect(struct TCP_Server_Info *server);
 static int generic_ip_connect(struct TCP_Server_Info *server);
 static void tlink_rb_insert(struct rb_root *root, struct tcon_link *new_tlink);
@@ -1224,6 +1229,23 @@ cifs_parse_cache_flavor(char *value, struct smb_vol *vol)
 }
 
 static int
+cifs_parse_smb_version(char *value, struct smb_vol *vol)
+{
+	substring_t args[MAX_OPT_ARGS];
+
+	switch (match_token(value, cifs_smb_version_tokens, args)) {
+	case Smb_1:
+		vol->ops = &smb1_operations;
+		vol->vals = &smb1_values;
+		break;
+	default:
+		cERROR(1, "Unknown vers= option specified: %s", value);
+		return 1;
+	}
+	return 0;
+}
+
+static int
 cifs_parse_mount_options(const char *mountdata, const char *devname,
 			 struct smb_vol *vol)
 {
@@ -1276,6 +1298,10 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 
 	vol->actimeo = CIFS_DEF_ACTIMEO;
 
+	/* FIXME: add autonegotiation -- for now, SMB1 is default */
+	vol->ops = &smb1_operations;
+	vol->vals = &smb1_values;
+
 	if (!mountdata)
 		goto cifs_parse_mount_err;
 
@@ -1879,6 +1905,14 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			printk(KERN_WARNING "CIFS: Invalid version"
 					    " specified\n");
 			goto cifs_parse_mount_err;
+		case Opt_vers:
+			string = match_strdup(args);
+			if (string == NULL)
+				goto out_nomem;
+
+			if (cifs_parse_smb_version(string, vol) != 0)
+				goto cifs_parse_mount_err;
+			break;
 		case Opt_sec:
 			string = match_strdup(args);
 			if (string == NULL)
@@ -2107,6 +2141,9 @@ match_security(struct TCP_Server_Info *server, struct smb_vol *vol)
 static int match_server(struct TCP_Server_Info *server, struct sockaddr *addr,
 			 struct smb_vol *vol)
 {
+	if ((server->vals != vol->vals) || (server->ops != vol->ops))
+		return 0;
+
 	if (!net_eq(cifs_net_ns(server), current->nsproxy->net_ns))
 		return 0;
 
@@ -2229,6 +2266,8 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 		goto out_err;
 	}
 
+	tcp_ses->ops = volume_info->ops;
+	tcp_ses->vals = volume_info->vals;
 	cifs_set_net_ns(tcp_ses, get_net(current->nsproxy->net_ns));
 	tcp_ses->hostname = extract_hostname(volume_info->UNC);
 	if (IS_ERR(tcp_ses->hostname)) {
@@ -3635,6 +3674,7 @@ cifs_setup_volume_info(struct smb_vol *volume_info, char *mount_data,
 	if (cifs_parse_mount_options(mount_data, devname, volume_info))
 		return -EINVAL;
 
+
 	if (volume_info->nullauth) {
 		cFYI(1, "Anonymous login");
 		kfree(volume_info->username);
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
new file mode 100644
index 0000000..d2850d1
--- /dev/null
+++ b/fs/cifs/smb1ops.c
@@ -0,0 +1,27 @@
+/*
+ *  SMB1 (CIFS) version specific operations
+ *
+ *  Copyright (c) 2012, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
+ *
+ *  This library is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License v2 as published
+ *  by the Free Software Foundation.
+ *
+ *  This library is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *  the GNU Lesser General Public License for more details.
+ *
+ *  You should have received a copy of the GNU Lesser General Public License
+ *  along with this library; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#include "cifsglob.h"
+
+struct smb_version_operations smb1_operations = {
+};
+
+struct smb_version_values smb1_values = {
+	.version_string = SMB1_VERSION_STRING,
+};
-- 
1.7.1
