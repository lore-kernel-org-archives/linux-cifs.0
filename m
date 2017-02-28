From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v3 5/7] CIFS: set signing flag in SMB2+ TreeConnect if needed
Date: Tue, 28 Feb 2017 19:40:32 +0100
Message-ID: <20170228184034.18771-6-aaptel@suse.com>
References: <20170228184034.18771-1-aaptel@suse.com>
Cc: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170228184034.18771-1-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

cifs_enable_signing() already sets server->sign according to what the
server requires/offers and what mount options allows/forbids, so use
that.

this is required for IPC tcon that connects to signing-required servers.

Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 8c4532d..2fd93ee 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1168,8 +1168,8 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 
 		/* since no tcon, smb2_init can not do this, so do here */
 		req->hdr.sync_hdr.SessionId = ses->Suid;
-		/* if (ses->server->sec_mode & SECMODE_SIGN_REQUIRED)
-			req->hdr.Flags |= SMB2_FLAGS_SIGNED; */
+		if (ses->server->sign)
+			req->hdr.sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
 	} else if (encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-- 
2.10.2
