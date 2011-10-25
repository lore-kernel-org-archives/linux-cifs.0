From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 48/53] CIFS: Process signing for SMB2_logoff
Date: Tue, 25 Oct 2011 10:12:21 +0400
Message-ID: <1319523146-2859-49-git-send-email-piastry@etersoft.ru>
References: <1319523146-2859-1-git-send-email-piastry@etersoft.ru>
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319523146-2859-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/smb2pdu.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 7f546ac..6f025b4 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1035,6 +1035,8 @@ SMB2_logoff(const int xid, struct cifs_ses *ses)
 
 	 /* since no tcon, smb2_init can not do this, so do here */
 	pSMB2->hdr.SessionId = ses->Suid;
+	if (server->sec_mode & SECMODE_SIGN_REQUIRED)
+		pSMB2->hdr.Flags |= SMB2_FLAGS_SIGNED;
 
 	rc = smb2_sendrcv_norsp(xid, ses, &pSMB2->hdr,
 				CIFS_STD_OP | CIFS_LOG_ERROR);
-- 
1.7.1
