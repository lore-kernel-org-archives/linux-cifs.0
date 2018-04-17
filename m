From: Long Li <longli@linuxonhyperv.com>
Subject: [Patch v2 5/6] cifs: smbd: Enable signing with smbdirect
Date: Tue, 17 Apr 2018 12:17:09 -0700
Message-ID: <20180417191710.14855-5-longli@linuxonhyperv.com>
References: <20180417191710.14855-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>, stable@vger.kernel.org
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180417191710.14855-1-longli@linuxonhyperv.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Now signing is supported with RDMA transport.

Remove the code that disabled it.

Signed-off-by: Long Li <longli@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/cifs/connect.c | 8 --------
 fs/cifs/smb2pdu.c | 4 ----
 2 files changed, 12 deletions(-)

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
index 33f612f..3e052a0 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -737,10 +737,6 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 
 	cifs_dbg(FYI, "validate negotiate\n");
 
-#ifdef CONFIG_CIFS_SMB_DIRECT
-	if (tcon->ses->server->rdma)
-		return 0;
-#endif
 	pneg_inbuf = kmalloc(sizeof(*pneg_inbuf), GFP_KERNEL);
 	if (!pneg_inbuf)
 		return -ENOMEM;
-- 
2.7.4
