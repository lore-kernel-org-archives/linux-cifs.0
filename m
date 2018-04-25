From: Long Li <longli@linuxonhyperv.com>
Subject: [PATCH rebased] cifs: smbd: Enable signing with smbdirect
Date: Wed, 25 Apr 2018 11:30:05 -0700
Message-ID: <20180425183005.9347-2-longli@linuxonhyperv.com>
References: <20180425183005.9347-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180425183005.9347-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Now signing is supported with RDMA transport.

Remove the code that disabled it.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/connect.c | 8 --------
 fs/cifs/smb2pdu.c | 5 -----
 2 files changed, 13 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index e8830f0..deef270 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1977,14 +1977,6 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 		goto cifs_parse_mount_err;
 	}
 
-#ifdef CONFIG_CIFS_SMB_DIRECT
-	if (vol->rdma && vol->sign) {
-		cifs_dbg(VFS, "Currently SMB direct doesn't support signing."
-			" This is being fixed\n");
-		goto cifs_parse_mount_err;
-	}
-#endif
-
 #ifndef CONFIG_KEYS
 	/* Muliuser mounts require CONFIG_KEYS support */
 	if (vol->multiuser) {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 8472f32..b16f953 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -737,11 +737,6 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 
 	cifs_dbg(FYI, "validate negotiate\n");
 
-#ifdef CONFIG_CIFS_SMB_DIRECT
-	if (tcon->ses->server->rdma)
-		return 0;
-#endif
-
 	/* In SMB3.11 preauth integrity supersedes validate negotiate */
 	if (tcon->ses->server->dialect == SMB311_PROT_ID)
 		return 0;
-- 
2.7.4
