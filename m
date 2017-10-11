From: Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH] CIFS: Fix NULL pointer deref on SMB2_tcon() failure
Date: Wed, 11 Oct 2017 13:23:36 +0200
Message-ID: <20171011112336.11263-1-aaptel@suse.com>
References: <20171010230138.31832-1-lsahlber@redhat.com>
Cc: lsahlber@redhat.com, smfrench@gmail.com,
        Aurelien Aptel <aaptel@suse.com>, stable@vger.kernel.org
To: linux-cifs@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171010230138.31832-1-lsahlber@redhat.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

If SendReceive2() fails rsp is set to NULL but is dereferenced in the
error handling code.

Cc: stable@vger.kernel.org
Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 7aa67206f6da..eb658b641ded 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1168,7 +1168,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	struct smb2_tree_connect_req *req;
 	struct smb2_tree_connect_rsp *rsp = NULL;
 	struct kvec iov[2];
-	struct kvec rsp_iov;
+	struct kvec rsp_iov = { NULL, 0 };
 	int rc = 0;
 	int resp_buftype;
 	int unc_path_len;
@@ -1285,7 +1285,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	return rc;
 
 tcon_error_exit:
-	if (rsp->hdr.sync_hdr.Status == STATUS_BAD_NETWORK_NAME) {
+	if (rsp && rsp->hdr.sync_hdr.Status == STATUS_BAD_NETWORK_NAME) {
 		cifs_dbg(VFS, "BAD_NETWORK_NAME: %s\n", tree);
 	}
 	goto tcon_exit;
-- 
2.12.3
