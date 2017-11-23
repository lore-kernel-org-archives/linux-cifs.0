From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v8 16/16] CIFS: SMBD: Disable signing on SMB direct transport
Date: Wed, 22 Nov 2017 17:38:49 -0700
Message-ID: <20171123003849.17093-17-longli@exchange.microsoft.com>
References: <20171123003849.17093-1-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171123003849.17093-1-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Currently the CIFS SMB Direct implementation (experimental) doesn't properly
support signing. Disable it when SMB Direct is in use for transport.

Signing will be enabled in future after it is implemented.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/connect.c | 8 ++++++++
 fs/cifs/smb2pdu.c | 5 +++++
 2 files changed, 13 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 1677401..b18eae1 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1968,6 +1968,14 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 		goto cifs_parse_mount_err;
 	}
 
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	if (vol->rdma && vol->sign) {
+		cifs_dbg(VFS, "Currently SMB direct doesn't support signing."
+			" This is being fixed\n");
+		goto cifs_parse_mount_err;
+	}
+#endif
+
 #ifndef CONFIG_KEYS
 	/* Muliuser mounts require CONFIG_KEYS support */
 	if (vol->multiuser) {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index bee0871d..a3e67be 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -616,6 +616,11 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 
 	cifs_dbg(FYI, "validate negotiate\n");
 
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	if (tcon->ses->server->rdma)
+		return 0;
+#endif
+
 	/*
 	 * validation ioctl must be signed, so no point sending this if we
 	 * can not sign it (ie are not known user).  Even if signing is not
-- 
2.7.4
