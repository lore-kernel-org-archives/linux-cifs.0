From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [SMB3] Add parsing for resilienthandles mount parm
Date: Sat,  3 Oct 2015 19:29:33 -0500
Message-ID: <1443918573-44613-1-git-send-email-smfrench@gmail.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Since many servers (Windows clients, and non-clustered servers) do not
support persistent handles but do support resilient handles, allow
the user to specify a mount option "resilienthandles" in order
to get more reliable connections and less chance of data loss
(at least when SMB2.1 or later)

Signed-off-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>

Signed-off-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
---
 fs/cifs/cifsfs.c   |  2 ++
 fs/cifs/cifsglob.h |  2 ++
 fs/cifs/connect.c  | 24 +++++++++++++++++++++++-
 fs/cifs/smb2file.c |  6 ++++++
 4 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 13302e9..f578ef9 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -456,6 +456,8 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 		seq_puts(s, ",hard");
 	if (tcon->use_persistent)
 		seq_puts(s, ",persistenthandles");
+	else if (tcon->use_resilient)
+		seq_puts(s, ",resilienthandles");
 	if (tcon->unix_ext)
 		seq_puts(s, ",unix");
 	else
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index ec31a03..472daeb 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -496,6 +496,7 @@ struct smb_vol {
 	bool nosharesock:1;
 	bool persistent:1;
 	bool nopersistent:1;
+	bool resilient:1; /* noresilient not required since not fored for CA */
 	unsigned int rsize;
 	unsigned int wsize;
 	bool sockopt_tcp_nodelay:1;
@@ -901,6 +902,7 @@ struct cifs_tcon {
 	bool broken_posix_open; /* e.g. Samba server versions < 3.3.2, 3.2.9 */
 	bool broken_sparse_sup; /* if server or share does not support sparse */
 	bool need_reconnect:1; /* connection reset, tid now invalid */
+	bool use_resilient:1; /* use resilient instead of durable handles */
 	bool use_persistent:1; /* use persistent instead of durable handles */
 #ifdef CONFIG_CIFS_SMB2
 	bool print:1;		/* set if connection to printer share */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 9e44532..1e7840a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -88,6 +88,7 @@ enum {
 	Opt_fsc, Opt_mfsymlinks,
 	Opt_multiuser, Opt_sloppy, Opt_nosharesock,
 	Opt_persistent, Opt_nopersistent,
+	Opt_resilient, Opt_noresilient,
 
 	/* Mount options which take numeric value */
 	Opt_backupuid, Opt_backupgid, Opt_uid,
@@ -172,6 +173,8 @@ static const match_table_t cifs_mount_option_tokens = {
 	{ Opt_nosharesock, "nosharesock" },
 	{ Opt_persistent, "persistenthandles"},
 	{ Opt_nopersistent, "nopersistenthandles"},
+	{ Opt_resilient, "resilienthandles"},
+	{ Opt_noresilient, "noresilienthandles"},
 
 	{ Opt_backupuid, "backupuid=%s" },
 	{ Opt_backupgid, "backupgid=%s" },
@@ -1510,12 +1513,23 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			break;
 		case Opt_persistent:
 			vol->persistent = true;
-			if (vol->nopersistent) {
+			if ((vol->nopersistent) || (vol->resilient)) {
 				cifs_dbg(VFS,
 				  "persistenthandles mount options conflict\n");
 				goto cifs_parse_mount_err;
 			}
 			break;
+		case Opt_resilient:
+			vol->resilient = true;
+			if (vol->persistent) {
+				cifs_dbg(VFS,
+				  "persistenthandles mount options conflict\n");
+				goto cifs_parse_mount_err;
+			}
+			break;
+		case Opt_noresilient:
+			vol->resilient = false; /* this is already the default */
+			break;
 
 		/* Numeric Values */
 		case Opt_backupuid:
@@ -2695,6 +2709,14 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 	     && (volume_info->nopersistent == false)) {
 		cifs_dbg(FYI, "enabling persistent handles\n");
 		tcon->use_persistent = true;
+	} else if (volume_info->resilient) {
+		if (ses->server->vals->protocol_id == 0) {
+			cifs_dbg(VFS,
+			     "SMB2.1 or later required for resilient handles\n");
+			rc = -EOPNOTSUPP;
+			goto out_fail;
+		}
+		tcon->use_resilient = true;
 	}
 
 	/*
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 2ab297d..04f2af0 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -67,6 +67,12 @@ smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
 	if (rc)
 		goto out;
 
+	/*
+	 * FIXME: Add
+	 * 	if (tcon->use_resilient)
+	 *		SMB2_ioctl(xid, ... FSCTL_LMR_REQUEST_RESILIENCY, true);
+	 */
+
 	if (buf) {
 		/* open response does not have IndexNumber field - get it */
 		rc = SMB2_get_srv_num(xid, oparms->tcon, fid->persistent_fid,
-- 
1.9.1
