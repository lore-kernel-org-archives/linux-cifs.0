From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 1/2] CIFS: Fix memory leak in SMB2 oplock break code
Date: Wed, 15 Aug 2012 15:24:22 +0400
Message-ID: <1345029863-6731-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

SendReceive2 doesn't free a response buffer but SendReceiveNoRsp does.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2pdu.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index b183420..88ac69c 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1943,9 +1943,8 @@ SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 		  const u64 persistent_fid, const u64 volatile_fid,
 		  __u8 oplock_level)
 {
-	int rc = 0, buf_type;
+	int rc;
 	struct smb2_oplock_break *req = NULL;
-	struct kvec iov[1];
 
 	cFYI(1, "SMB2_oplock_break");
 	rc = small_smb2_init(SMB2_OPLOCK_BREAK, tcon, (void **) &req);
@@ -1958,11 +1957,7 @@ SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 	req->OplockLevel = oplock_level;
 	req->hdr.CreditRequest = cpu_to_le16(1);
 
-	iov->iov_base = (char *)req;
-	/* 4 for rfc1002 length */
-	iov->iov_len = get_rfc1002_length(req) + 4;
-
-	rc = SendReceive2(xid, tcon->ses, iov, 1, &buf_type, CIFS_OBREAK_OP);
+	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) req, CIFS_OBREAK_OP);
 	/* SMB2 buffer freed by function above */
 
 	if (rc) {
-- 
1.7.1
