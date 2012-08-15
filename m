From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 2/2] CIFS: Fix wrong setting of open requested oplock parm
Date: Wed, 15 Aug 2012 15:24:23 +0400
Message-ID: <1345029863-6731-2-git-send-email-pshilovsky@samba.org>
References: <1345029863-6731-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1345029863-6731-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Use oplock argument rather than BATCH value.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2pdu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 88ac69c..cee8f4d 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -896,7 +896,7 @@ SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
 		return rc;
 
 	if (server->oplocks)
-		req->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_BATCH;
+		req->RequestedOplockLevel = *oplock;
 	else
 		req->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_NONE;
 	req->ImpersonationLevel = IL_IMPERSONATION;
-- 
1.7.1
