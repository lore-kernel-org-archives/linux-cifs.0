From: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Subject: [Patch v2 01/19] CIFS: Add RDMA mount option
Date: Sun, 20 Aug 2017 12:04:25 -0700
Message-ID: <1503255883-3041-2-git-send-email-longli@exchange.microsoft.com>
References: <1503255883-3041-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1503255883-3041-1-git-send-email-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

Add "rdma" to CIFS mount option, which tells CIFS this is for connecting to a SMB server over SMBDirect. Add checks to validate this feature is only used on SMB 3.X dialects.

To connect to SMBDirect, use "mount.cifs -o rdma,vers=3.x".

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/cifs_debug.c |  2 ++
 fs/cifs/cifsfs.c     |  2 ++
 fs/cifs/cifsglob.h   |  3 +++
 fs/cifs/connect.c    | 25 ++++++++++++++++++++++++-
 4 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 9727e1d..ba0870d 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -171,6 +171,8 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 				ses->ses_count, ses->serverOS, ses->serverNOS,
 				ses->capabilities, ses->status);
 			}
+			if (server->rdma)
+				seq_printf(m, "RDMA\n\t");
 			seq_printf(m, "TCP status: %d\n\tLocal Users To "
 				   "Server: %d SecMode: 0x%x Req On Wire: %d",
 				   server->tcpStatus, server->srv_count,
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index fe0c8dc..a628800 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -330,6 +330,8 @@ cifs_show_address(struct seq_file *s, struct TCP_Server_Info *server)
 	default:
 		seq_puts(s, "(unknown)");
 	}
+	if (server->rdma)
+		seq_puts(s, ",rdma");
 }
 
 static void
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 8289f95..703c2fb 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -531,6 +531,7 @@ struct smb_vol {
 	bool nopersistent:1;
 	bool resilient:1; /* noresilient not required since not fored for CA */
 	bool domainauto:1;
+	bool rdma:1;
 	unsigned int rsize;
 	unsigned int wsize;
 	bool sockopt_tcp_nodelay:1;
@@ -649,6 +650,8 @@ struct TCP_Server_Info {
 	bool	sec_kerberos;		/* supports plain Kerberos */
 	bool	sec_mskerberos;		/* supports legacy MS Kerberos */
 	bool	large_buf;		/* is current buffer large? */
+	/* use SMBD connection instead of socket */
+	bool	rdma;
 	struct delayed_work	echo; /* echo ping workqueue job */
 	char	*smallbuf;	/* pointer to current "small" buffer */
 	char	*bigbuf;	/* pointer to current "big" buffer */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 2eeaac6..d5d0ecd 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -94,7 +94,7 @@ enum {
 	Opt_multiuser, Opt_sloppy, Opt_nosharesock,
 	Opt_persistent, Opt_nopersistent,
 	Opt_resilient, Opt_noresilient,
-	Opt_domainauto,
+	Opt_domainauto, Opt_rdma,
 
 	/* Mount options which take numeric value */
 	Opt_backupuid, Opt_backupgid, Opt_uid,
@@ -185,6 +185,7 @@ static const match_table_t cifs_mount_option_tokens = {
 	{ Opt_resilient, "resilienthandles"},
 	{ Opt_noresilient, "noresilienthandles"},
 	{ Opt_domainauto, "domainauto"},
+	{ Opt_rdma, "rdma"},
 
 	{ Opt_backupuid, "backupuid=%s" },
 	{ Opt_backupgid, "backupgid=%s" },
@@ -1541,6 +1542,9 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 		case Opt_domainauto:
 			vol->domainauto = true;
 			break;
+		case Opt_rdma:
+			vol->rdma = true;
+			break;
 
 		/* Numeric Values */
 		case Opt_backupuid:
@@ -1931,6 +1935,21 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 		goto cifs_parse_mount_err;
 	}
 
+	if (vol->rdma) {
+		switch (vol->vals->protocol_id) {
+		case SMB30_PROT_ID:
+		case SMB302_PROT_ID:
+		case SMB311_PROT_ID:
+			break;
+		default:
+			cifs_dbg(
+				VFS,
+				"SMBDirect requires Version "
+				"3.0, 3.02 or 3.1.1\n");
+			goto cifs_parse_mount_err;
+		}
+	}
+
 #ifndef CONFIG_KEYS
 	/* Muliuser mounts require CONFIG_KEYS support */
 	if (vol->multiuser) {
@@ -2134,6 +2153,9 @@ static int match_server(struct TCP_Server_Info *server, struct smb_vol *vol)
 	if (server->echo_interval != vol->echo_interval * HZ)
 		return 0;
 
+	if (server->rdma != vol->rdma)
+		return 0;
+
 	return 1;
 }
 
@@ -2234,6 +2256,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	tcp_ses->noblocksnd = volume_info->noblocksnd;
 	tcp_ses->noautotune = volume_info->noautotune;
 	tcp_ses->tcp_nodelay = volume_info->sockopt_tcp_nodelay;
+	tcp_ses->rdma = volume_info->rdma;
 	tcp_ses->in_flight = 0;
 	tcp_ses->credits = 1;
 	init_waitqueue_head(&tcp_ses->response_q);
-- 
2.7.4
