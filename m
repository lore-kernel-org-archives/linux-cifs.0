From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: store the real expected sequence number in the mid
Date: Wed,  3 Apr 2013 14:07:56 -0400
Message-ID: <1365012476-6885-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently, the signing routines take a pointer to a place to store the
expected sequence number for the mid response. It then stores a value
that's one below what that sequence number should be, and then adds one
to it when verifying the signature on the response.

Increment the sequence number before storing the value in the mid, and
eliminate the "+1" when checking the signature.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsencrypt.c | 4 ++--
 fs/cifs/cifssmb.c     | 2 +-
 fs/cifs/transport.c   | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 2cbbec6..71436d1 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -135,8 +135,8 @@ int cifs_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 				cpu_to_le32(server->sequence_number);
 	cifs_pdu->Signature.Sequence.Reserved = 0;
 
-	*pexpected_response_sequence_number = server->sequence_number++;
-	server->sequence_number++;
+	*pexpected_response_sequence_number = ++server->sequence_number;
+	++server->sequence_number;
 
 	rc = cifs_calc_signature(rqst, server, smb_signature);
 	if (rc)
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 076d7ed..4060c45 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1545,7 +1545,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
 			int rc = 0;
 
 			rc = cifs_verify_signature(&rqst, server,
-						  mid->sequence_number + 1);
+						  mid->sequence_number);
 			if (rc)
 				cifs_dbg(VFS, "SMB signature verification returned error = %d\n",
 					 rc);
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 293d2c8..bfbf470 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -622,7 +622,7 @@ cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		iov.iov_len = len;
 		/* FIXME: add code to kill session */
 		rc = cifs_verify_signature(&rqst, server,
-					   mid->sequence_number + 1);
+					   mid->sequence_number);
 		if (rc)
 			cifs_dbg(VFS, "SMB signature verification returned error = %d\n",
 				 rc);
-- 
1.7.11.7
